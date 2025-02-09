// package codegen
package codegen

import (
	"fmt"
	"strings"

	"cooler/parser"

	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/enum"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
)

// --------------------------------------------------------------------------
// Helper type for parameter attributes.
type paramAttr string

func (a paramAttr) String() string    { return string(a) }
func (a paramAttr) IsParamAttribute() {}

// For example, used for "nocapture".
const Nocapture paramAttr = "nocapture"

// --------------------------------------------------------------------------
// DispatchEntry is used to compute dispatch table layouts.
type DispatchEntry struct {
	Class  string
	Method string
}

// --------------------------------------------------------------------------
// CodeGenerator carries extra maps to track COOL type names, object layout,
// canonical pointer types, and (NEW) dispatch table information.
//
// IMPORTANT: User‐defined classes now have a “vtable pointer” as their first field.
// Built‐in classes (Int, String, Bool, IO) are represented as objects with boxed values.
type CodeGenerator struct {
	module           *ir.Module
	currentFunc      *ir.Func
	currentBlock     *ir.Block
	variableEnv      map[string]*ir.InstAlloca // variable name -> alloca
	variableTypeEnv  map[string]string         // variable name -> COOL type

	printfFunc *ir.Func
	scanfFunc  *ir.Func

	// Format strings for output and input.
	fmtString   *ir.Global // e.g. "%s\x00"
	fmtInt      *ir.Global // e.g. "%d\x00"
	fmtStringIn *ir.Global // e.g. "%1023s\x00"
	fmtIntIn    *ir.Global // e.g. "%d\x00"

	// String constants.
	stringConsts  map[string]*ir.Global
	stringCounter int

	// When inside a class we set currentClass to that class name.
	currentClass string

	// Maps attribute names (as "Class.Attribute") to their field index.
	attributeIndices map[string]int
	// Maps class names to their LLVM struct types.
	classTypes map[string]types.Type

	// (Optional) Record the COOL type for each attribute.
	attributeTypeEnv map[string]string

	counter int

	// Canonical pointer types:
	//
	// Instead of representing String as just a pointer to i8 (a C string),
	// we now represent a String object as a pointer to a struct that holds one field:
	// the actual C string pointer. (That struct prints as { i8* } in LLVM–IR.)
	stringStruct *types.StructType   // e.g. struct { i8* }
	stringType   types.Type           // canonical pointer type for String objects (= pointer to stringStruct)
	//
	// For built–in Int and Bool we box the primitive value.
	// Int is represented as struct { i32 } and Bool as struct { i1 }.
	//
	// Other canonical types (for classes) remain.
	classPtrTypes map[string]types.Type // canonical pointer types for classes (keyed by class name)

	// NEW: Fields for dynamic dispatch.
	// For each user-defined class we compute:
	// - dispatchTableLayouts: the ordered list of methods (including inherited ones,
	//   with overriding) for that class.
	// - dispatchTables: a global vtable (constant array of function pointers) for that class.
	// - methodIndices: a map from "Class.Method" (where Class is a static type)
	//   to the index in the dispatch table.
	dispatchTableLayouts map[string][]DispatchEntry
	dispatchTables       map[string]*ir.Global
	methodIndices        map[string]int
}

// uniqueGlobalName produces a unique name using the module’s current globals.
func (cg *CodeGenerator) uniqueGlobalName(prefix string) string {
	return fmt.Sprintf("%s_%d", prefix, len(cg.module.Globals))
}

// typeSize returns a crude size (in bytes) for a given LLVM type.
// For structs we assume each field is 4 bytes.
func (cg *CodeGenerator) typeSize(t types.Type) int64 {
	switch tt := t.(type) {
	case *types.StructType:
		return int64(len(tt.Fields)) * 4
	case *types.PointerType:
		// Assume pointer size is 4 bytes.
		return 4
	case *types.IntType:
		// Assume i32 is 4 bytes.
		return 4
	case *types.VoidType:
		return 0
	default:
		return 4
	}
}

// getClassPtrType returns the canonical pointer type for a given class name.
func (cg *CodeGenerator) getClassPtrType(className string) types.Type {
	if ptr, ok := cg.classPtrTypes[className]; ok {
		return ptr
	}
	if structType, ok := cg.classTypes[className]; ok {
		ptr := types.NewPointer(structType)
		cg.classPtrTypes[className] = ptr
		return ptr
	}
	// Fallback.
	return types.I32
}

// isBuiltIn returns true if className is one of the built-in types.
func isBuiltIn(className string) bool {
	return className == "Int" || className == "String" || className == "Bool" || className == "IO"
}

// contains is a helper to check whether a string is in a slice.
func contains(slice []string, s string) bool {
	for _, a := range slice {
		if a == s {
			return true
		}
	}
	return false
}

// --------------------------------------------------------------------------
// Helper functions for boxing/unboxing Int and Bool
// --------------------------------------------------------------------------
func (cg *CodeGenerator) boxInt(val value.Value) value.Value {
	size := constant.NewInt(types.I64, cg.typeSize(cg.classTypes["Int"]))
	mallocFn := findFuncByName(cg.module, "malloc")
	rawPtr := cg.currentBlock.NewCall(mallocFn, size)
	intObj := cg.currentBlock.NewBitCast(rawPtr, cg.getClassPtrType("Int"))
	fieldPtr := cg.currentBlock.NewGetElementPtr(cg.classTypes["Int"], intObj,
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	cg.currentBlock.NewStore(val, fieldPtr)
	return intObj
}

func (cg *CodeGenerator) unboxInt(obj value.Value) value.Value {
	fieldPtr := cg.currentBlock.NewGetElementPtr(cg.classTypes["Int"], obj,
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	return cg.currentBlock.NewLoad(types.I32, fieldPtr)
}

func (cg *CodeGenerator) boxBool(val value.Value) value.Value {
	size := constant.NewInt(types.I64, cg.typeSize(cg.classTypes["Bool"]))
	mallocFn := findFuncByName(cg.module, "malloc")
	rawPtr := cg.currentBlock.NewCall(mallocFn, size)
	boolObj := cg.currentBlock.NewBitCast(rawPtr, cg.getClassPtrType("Bool"))
	fieldPtr := cg.currentBlock.NewGetElementPtr(cg.classTypes["Bool"], boolObj,
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	cg.currentBlock.NewStore(val, fieldPtr)
	return boolObj
}

func (cg *CodeGenerator) unboxBool(obj value.Value) value.Value {
	fieldPtr := cg.currentBlock.NewGetElementPtr(cg.classTypes["Bool"], obj,
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	return cg.currentBlock.NewLoad(types.I1, fieldPtr)
}

// --------------------------------------------------------------------------
// Entry Point: CodegenProgram
// --------------------------------------------------------------------------
func CodegenProgram(prog *parser.Program) *ir.Module {
	cg := &CodeGenerator{
		module:               ir.NewModule(),
		variableEnv:          make(map[string]*ir.InstAlloca),
		variableTypeEnv:      make(map[string]string),
		stringConsts:         make(map[string]*ir.Global),
		attributeIndices:     make(map[string]int),
		classTypes:           make(map[string]types.Type),
		attributeTypeEnv:     make(map[string]string),
		dispatchTableLayouts: make(map[string][]DispatchEntry),
		dispatchTables:       make(map[string]*ir.Global),
		methodIndices:        make(map[string]int),
	}
	// Set up canonical pointer types.
	cg.stringStruct = types.NewStruct(types.NewPointer(types.I8))
	cg.stringType = types.NewPointer(cg.stringStruct)
	cg.classPtrTypes = make(map[string]types.Type)

	// Predeclare built-in classes.
	// Represent Int as { i32 } and Bool as { i1 }.
	builtIns := []string{"Object", "Int", "Bool", "String", "IO"}
	for _, cname := range builtIns {
		switch cname {
		case "String":
			cg.classTypes[cname] = cg.stringStruct
		case "Int":
			cg.classTypes[cname] = types.NewStruct(types.I32)
		case "Bool":
			cg.classTypes[cname] = types.NewStruct(types.I1)
		default:
			cg.classTypes[cname] = types.NewStruct()
		}
	}

	// For each user–defined class, initially create an opaque struct.
	for _, classNode := range prog.Classes {
		if !contains(builtIns, classNode.Name) {
			opaqStruct := types.StructType{Opaque: true}
			cg.classTypes[classNode.Name] = &opaqStruct
		}
	}

	cg.declareExternalIO()
	cg.declareMalloc()
	cg.defineStringLength()
	cg.defineStringConcat()
	cg.defineStringSubstr()

	mainFn := cg.module.NewFunc("main", types.I32)
	cg.currentFunc = mainFn
	cg.currentBlock = mainFn.NewBlock("entry")

	// 1. Build a map from class names to AST nodes.
	classMap := make(map[string]*parser.Class)
	for _, classNode := range prog.Classes {
		classMap[classNode.Name] = classNode
	}
	// 2. Create class types (filling in inherited attributes as needed).
	for _, classNode := range prog.Classes {
		cg.createClassType(classNode, classMap)
	}
	// 3. Declare all methods (but do not generate bodies yet).
	for _, classNode := range prog.Classes {
		for _, feat := range classNode.Features {
			if method, ok := feat.(*parser.Method); ok {
				cg.declareMethod(classNode.Name, method)
			}
		}
	}
	// 4. Build dispatch tables.
	for _, classNode := range prog.Classes {
		cg.buildDispatchTable(classNode, classMap)
	}
	// 5. Generate method bodies.
	for _, classNode := range prog.Classes {
		cg.generateMethodBodies(classNode)
	}

	// Look for an entry method.
	var entryFn *ir.Func
	if fn := findFuncByName(cg.module, "Main_main"); fn != nil {
		entryFn = fn
	} else {
		for _, cls := range prog.Classes {
			try := fmt.Sprintf("%s_main", cls.Name)
			if fn := findFuncByName(cg.module, try); fn != nil {
				entryFn = fn
				break
			}
		}
	}
	if entryFn != nil {
		cg.currentBlock.NewCall(entryFn)
		cg.currentBlock.NewRet(constant.NewInt(types.I32, 0))
	} else {
		cg.currentBlock.NewRet(constant.NewInt(types.I32, 0))
	}

	return cg.module
}

func findFuncByName(mod *ir.Module, name string) *ir.Func {
	for _, fn := range mod.Funcs {
		if fn.Name() == name {
			return fn
		}
	}
	return nil
}

// --------------------------------------------------------------------------
// External Declarations
// --------------------------------------------------------------------------
func (cg *CodeGenerator) declareExternalIO() {
	printfParam := ir.NewParam("fmt", types.NewPointer(types.I8))
	printfParam.Attrs = append(printfParam.Attrs, Nocapture)
	cg.printfFunc = cg.module.NewFunc("printf", types.I32, printfParam)
	cg.printfFunc.Sig.Variadic = true

	scanfParam := ir.NewParam("fmt", types.NewPointer(types.I8))
	scanfParam.Attrs = append(scanfParam.Attrs, Nocapture)
	cg.scanfFunc = cg.module.NewFunc("scanf", types.I32, scanfParam)
	cg.scanfFunc.Sig.Variadic = true

	cg.fmtString = cg.module.NewGlobalDef(cg.uniqueGlobalName("fmt_str"), constant.NewCharArrayFromString("%s\x00"))
	cg.fmtString.Immutable = true

	cg.fmtInt = cg.module.NewGlobalDef(cg.uniqueGlobalName("fmt_int"), constant.NewCharArrayFromString("%d\x00"))
	cg.fmtInt.Immutable = true

	cg.fmtStringIn = cg.module.NewGlobalDef(cg.uniqueGlobalName("fmt_str_in"), constant.NewCharArrayFromString("%1023s\x00"))
	cg.fmtStringIn.Immutable = true

	cg.fmtIntIn = cg.module.NewGlobalDef(cg.uniqueGlobalName("fmt_int_in"), constant.NewCharArrayFromString("%d\x00"))
	cg.fmtIntIn.Immutable = true
}

func (cg *CodeGenerator) declareMalloc() {
	cg.module.NewFunc("malloc", types.NewPointer(types.I8), ir.NewParam("size", types.I64))
}

// --------------------------------------------------------------------------
// Built‐in String Methods Definitions
// --------------------------------------------------------------------------
func (cg *CodeGenerator) defineStringLength() {
	param := ir.NewParam("str", cg.stringType)
	fn := cg.module.NewFunc("String_length", types.I32, param)
	entry := fn.NewBlock("entry")
	charPtrPtr := entry.NewGetElementPtr(cg.stringStruct, fn.Params[0],
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	charPtr := entry.NewLoad(types.NewPointer(types.I8), charPtrPtr)
	counterAlloca := entry.NewAlloca(types.I32)
	entry.NewStore(constant.NewInt(types.I32, 0), counterAlloca)
	brLoop := fn.NewBlock("loop")
	entry.NewBr(brLoop)
	counter := brLoop.NewLoad(types.I32, counterAlloca)
	charPtrIndexed := brLoop.NewGetElementPtr(types.I8, charPtr, counter)
	ch := brLoop.NewLoad(types.I8, charPtrIndexed)
	cmp := brLoop.NewICmp(enum.IPredEQ, ch, constant.NewInt(types.I8, 0))
	incBlock := fn.NewBlock("inc")
	exit := fn.NewBlock("exit")
	brLoop.NewCondBr(cmp, exit, incBlock)
	counterNext := incBlock.NewAdd(counter, constant.NewInt(types.I32, 1))
	incBlock.NewStore(counterNext, counterAlloca)
	incBlock.NewBr(brLoop)
	retVal := exit.NewLoad(types.I32, counterAlloca)
	exit.NewRet(retVal)
}

func (cg *CodeGenerator) defineStringConcat() {
	param1 := ir.NewParam("str", cg.stringType)
	param2 := ir.NewParam("other", cg.stringType)
	fn := cg.module.NewFunc("String_concat", cg.stringType, param1, param2)
	entry := fn.NewBlock("entry")
	charPtrPtr1 := entry.NewGetElementPtr(cg.stringStruct, fn.Params[0],
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	charPtr1 := entry.NewLoad(types.NewPointer(types.I8), charPtrPtr1)
	charPtrPtr2 := entry.NewGetElementPtr(cg.stringStruct, fn.Params[1],
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	charPtr2 := entry.NewLoad(types.NewPointer(types.I8), charPtrPtr2)
	len1 := entry.NewCall(findFuncByName(cg.module, "String_length"), fn.Params[0])
	len2 := entry.NewCall(findFuncByName(cg.module, "String_length"), fn.Params[1])
	total := entry.NewAdd(len1, len2)
	totalPlus := entry.NewAdd(total, constant.NewInt(types.I32, 1))
	totalLL := entry.NewSExt(totalPlus, types.I64)
	mallocFn := findFuncByName(cg.module, "malloc")
	newCharPtr := entry.NewCall(mallocFn, totalLL)
	memcpyName := "llvm.memcpy.p0i8.p0i8.i64"
	memcpyFn := findFuncByName(cg.module, memcpyName)
	if memcpyFn == nil {
		memcpyFn = cg.module.NewFunc(memcpyName, types.Void,
			ir.NewParam("dest", types.NewPointer(types.I8)),
			ir.NewParam("src", types.NewPointer(types.I8)),
			ir.NewParam("size", types.I64),
			ir.NewParam("align", types.I32),
			ir.NewParam("isvolatile", types.I1))
		memcpyFn.Sig.Variadic = false
	}
	size1 := entry.NewSExt(len1, types.I64)
	entry.NewCall(memcpyFn, newCharPtr, charPtr1, size1,
		constant.NewInt(types.I32, 1), constant.NewInt(types.I1, 0))
	dest2 := entry.NewGetElementPtr(types.I8, newCharPtr, len1)
	size2 := entry.NewSExt(len2, types.I64)
	entry.NewCall(memcpyFn, dest2, charPtr2, size2,
		constant.NewInt(types.I32, 1), constant.NewInt(types.I1, 0))
	nullPtr := entry.NewGetElementPtr(types.I8, newCharPtr, total)
	entry.NewStore(constant.NewInt(types.I8, 0), nullPtr)
	sizeStringObj := constant.NewInt(types.I64, cg.typeSize(cg.stringStruct))
	newStringObjRaw := entry.NewCall(mallocFn, sizeStringObj)
	newStringObj := entry.NewBitCast(newStringObjRaw, cg.stringType)
	charFieldPtr := entry.NewGetElementPtr(cg.stringStruct, newStringObj,
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	entry.NewStore(newCharPtr, charFieldPtr)
	entry.NewRet(newStringObj)
}

func (cg *CodeGenerator) defineStringSubstr() {
	param1 := ir.NewParam("str", cg.stringType)
	param2 := ir.NewParam("start", types.I32)
	param3 := ir.NewParam("len", types.I32)
	fn := cg.module.NewFunc("String_substr", cg.stringType, param1, param2, param3)
	entry := fn.NewBlock("entry")
	charPtrPtr := entry.NewGetElementPtr(cg.stringStruct, fn.Params[0],
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	charPtr := entry.NewLoad(types.NewPointer(types.I8), charPtrPtr)
	lenPlus := entry.NewAdd(fn.Params[2], constant.NewInt(types.I32, 1))
	lenPlusLL := entry.NewSExt(lenPlus, types.I64)
	mallocFn := findFuncByName(cg.module, "malloc")
	newCharPtr := entry.NewCall(mallocFn, lenPlusLL)
	idxAlloca := entry.NewAlloca(types.I32)
	entry.NewStore(constant.NewInt(types.I32, 0), idxAlloca)
	loop := fn.NewBlock("loop")
	entry.NewBr(loop)
	idx := loop.NewLoad(types.I32, idxAlloca)
	cond := loop.NewICmp(enum.IPredSLT, idx, fn.Params[2])
	body := fn.NewBlock("body")
	finish := fn.NewBlock("finish")
	loop.NewCondBr(cond, body, finish)
	sum := body.NewAdd(fn.Params[1], idx)
	srcPtr := body.NewGetElementPtr(types.I8, charPtr, sum)
	ch := body.NewLoad(types.I8, srcPtr)
	dstPtr := body.NewGetElementPtr(types.I8, newCharPtr, idx)
	body.NewStore(ch, dstPtr)
	idxNext := body.NewAdd(idx, constant.NewInt(types.I32, 1))
	body.NewStore(idxNext, idxAlloca)
	body.NewBr(loop)
	dstTerm := finish.NewGetElementPtr(types.I8, newCharPtr, fn.Params[2])
	finish.NewStore(constant.NewInt(types.I8, 0), dstTerm)
	sizeStringObj := constant.NewInt(types.I64, cg.typeSize(cg.stringStruct))
	newStringObjRaw := finish.NewCall(mallocFn, sizeStringObj)
	newStringObj := finish.NewBitCast(newStringObjRaw, cg.stringType)
	charFieldPtr := finish.NewGetElementPtr(cg.stringStruct, newStringObj,
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	finish.NewStore(newCharPtr, charFieldPtr)
	finish.NewRet(newStringObj)
}

// --------------------------------------------------------------------------
// Class, Method, and Expression Generation
// --------------------------------------------------------------------------

// createClassType builds the LLVM struct type for a class.
// For built–in classes we simply generate a struct from the class’s own features.
// For user–defined classes we merge inherited attributes (if any) and then
// mark the type as non-opaque so that it has a known size.
func (cg *CodeGenerator) createClassType(classNode *parser.Class, classMap map[string]*parser.Class) types.Type {
	if isBuiltIn(classNode.Name) {
		var fieldTypes []types.Type
		index := 0
		for _, feat := range classNode.Features {
			if attr, ok := feat.(*parser.Attribute); ok {
				var attrType types.Type
				switch attr.Type {
				case "Int":
					attrType = cg.getClassPtrType("Int")
				case "String":
					attrType = cg.stringType
				case "Bool":
					attrType = cg.getClassPtrType("Bool")
				default:
					if _, exists := cg.classTypes[attr.Type]; exists {
						attrType = cg.getClassPtrType(attr.Type)
					} else {
						fmt.Printf("Error: class type %s not found for attribute %s\n", attr.Type, attr.Ident)
						attrType = cg.getClassPtrType("Object")
					}
				}
				fieldTypes = append(fieldTypes, attrType)
				key := fmt.Sprintf("%s.%s", classNode.Name, attr.Ident)
				cg.attributeIndices[key] = index
				cg.attributeTypeEnv[key] = attr.Type
				index++
			}
		}
		structType := types.NewStruct(fieldTypes...)
		cg.classTypes[classNode.Name] = structType
		return structType
	} else {
		var fieldTypes []types.Type
		var index int
		// The first field of every user–defined object is the vtable pointer.
		commonSelfType := cg.getClassPtrType("Object")
		commonMethodFuncType := types.NewFunc(commonSelfType, commonSelfType)
		commonMethodFuncType.Variadic = true
		vtableType := types.NewPointer(commonMethodFuncType)
		if classNode.Inherits != "" {
			if parentClass, found := classMap[classNode.Inherits]; found {
				cg.createClassType(parentClass, classMap)
			}
			if parentStruct, ok := cg.classTypes[classNode.Inherits]; ok {
				if ps, ok := parentStruct.(*types.StructType); ok {
					if len(ps.Fields) == 0 {
						fieldTypes = []types.Type{vtableType}
						index = 1
					} else {
						fieldTypes = append([]types.Type{}, ps.Fields...)
						index = len(ps.Fields)
					}
					for key, idxVal := range cg.attributeIndices {
						if strings.HasPrefix(key, classNode.Inherits+".") {
							attrName := key[len(classNode.Inherits)+1:]
							childKey := fmt.Sprintf("%s.%s", classNode.Name, attrName)
							cg.attributeIndices[childKey] = idxVal
							cg.attributeTypeEnv[childKey] = cg.attributeTypeEnv[key]
						}
					}
				} else {
					fieldTypes = []types.Type{vtableType}
					index = 1
				}
			} else {
				fieldTypes = []types.Type{vtableType}
				index = 1
			}
		} else {
			fieldTypes = []types.Type{vtableType}
			index = 1
		}
		for _, feat := range classNode.Features {
			if attr, ok := feat.(*parser.Attribute); ok {
				var attrType types.Type
				switch attr.Type {
				case "Int":
					attrType = cg.getClassPtrType("Int")
				case "String":
					attrType = cg.stringType
				case "Bool":
					attrType = cg.getClassPtrType("Bool")
				default:
					if _, exists := cg.classTypes[attr.Type]; exists {
						attrType = cg.getClassPtrType(attr.Type)
					} else {
						fmt.Printf("Error: class type %s not found for attribute %s\n", attr.Type, attr.Ident)
						attrType = cg.getClassPtrType("Object")
					}
				}
				childKey := fmt.Sprintf("%s.%s", classNode.Name, attr.Ident)
				if inheritedIndex, exists := cg.attributeIndices[childKey]; exists {
					fieldTypes[inheritedIndex] = attrType
					cg.attributeTypeEnv[childKey] = attr.Type
				} else {
					fieldTypes = append(fieldTypes, attrType)
					cg.attributeIndices[childKey] = index
					cg.attributeTypeEnv[childKey] = attr.Type
					index++
				}
			}
		}
		st, ok := cg.classTypes[classNode.Name].(*types.StructType)
		if !ok {
			st = types.NewStruct(fieldTypes...)
			cg.classTypes[classNode.Name] = st
		} else {
			st.Fields = fieldTypes
			st.Opaque = false
		}
		return st
	}
}

// declareMethod creates a method with a uniform signature.
// All methods (except "init") are declared with self parameter of type Object*
// and all formal parameters and the return type are object pointers.
func (cg *CodeGenerator) declareMethod(className string, method *parser.Method) {
	var retType types.Type
	if method.Ident == "init" {
		retType = cg.getClassPtrType(className)
	} else {
		switch method.Type {
		case "Int":
			retType = cg.getClassPtrType("Int")
		case "String":
			retType = cg.stringType
		case "Bool":
			retType = cg.getClassPtrType("Bool")
		case "SELF_TYPE":
			retType = cg.getClassPtrType("Object")
		default:
			if _, exists := cg.classTypes[method.Type]; exists {
				retType = cg.getClassPtrType(method.Type)
			} else {
				fmt.Printf("Unknown return type %q in method %q\n", method.Type, method.Ident)
				retType = cg.getClassPtrType("Object")
			}
		}
	}
	var params []*ir.Param
	selfType := cg.getClassPtrType("Object")
	selfParam := ir.NewParam("self", selfType)
	params = append(params, selfParam)
	for _, fm := range method.Formals {
		var paramType types.Type
		switch fm.Type {
		case "Int":
			paramType = cg.getClassPtrType("Int")
		case "String":
			paramType = cg.stringType
		case "Bool":
			paramType = cg.getClassPtrType("Bool")
		case "SELF_TYPE":
			paramType = cg.getClassPtrType("Object")
		default:
			if _, exists := cg.classTypes[fm.Type]; exists {
				paramType = cg.getClassPtrType(fm.Type)
			} else {
				paramType = cg.getClassPtrType("Object")
			}
		}
		params = append(params, ir.NewParam(fm.Ident, paramType))
	}
	fnName := fmt.Sprintf("%s_%s", className, method.Ident)
	cg.module.NewFunc(fnName, retType, params...)
}

// generateMethodBody generates the body of a method.
// We leave the self parameter in its universal type and perform bitcasts on–the–fly.
func (cg *CodeGenerator) generateMethodBody(className string, method *parser.Method, fn *ir.Func) {
	oldFunc := cg.currentFunc
	oldBlock := cg.currentBlock
	oldEnv := cg.variableEnv
	oldTypeEnv := cg.variableTypeEnv
	oldClass := cg.currentClass

	cg.currentFunc = fn
	cg.currentBlock = fn.NewBlock("entry")
	cg.variableEnv = make(map[string]*ir.InstAlloca)
	cg.variableTypeEnv = make(map[string]string)
	cg.variableTypeEnv["self"] = className

	for i, p := range fn.Params {
		alloca := cg.currentBlock.NewAlloca(p.Type())
		cg.currentBlock.NewStore(p, alloca)
		cg.variableEnv[p.LocalName] = alloca
		if i > 0 && i-1 < len(method.Formals) {
			cg.variableTypeEnv[p.LocalName] = method.Formals[i-1].Type
		}
	}

	retVal := cg.genExpr(method.Body)
	if retVal.Type() != fn.Sig.RetType {
		retVal = cg.currentBlock.NewBitCast(retVal, fn.Sig.RetType)
	}
	cg.currentBlock.NewRet(retVal)
	cg.currentFunc = oldFunc
	cg.currentBlock = oldBlock
	cg.variableEnv = oldEnv
	cg.variableTypeEnv = oldTypeEnv
	cg.currentClass = oldClass
}

func (cg *CodeGenerator) generateMethodBodies(classNode *parser.Class) {
	for _, feat := range classNode.Features {
		if method, ok := feat.(*parser.Method); ok {
			fnName := fmt.Sprintf("%s_%s", classNode.Name, method.Ident)
			fn := findFuncByName(cg.module, fnName)
			if fn == nil {
				fmt.Printf("Error: function %s not declared\n", fnName)
			} else {
				oldClass := cg.currentClass
				cg.currentClass = classNode.Name
				cg.generateMethodBody(classNode.Name, method, fn)
				cg.currentClass = oldClass
			}
		}
	}
}

// --------------------------------------------------------------------------
// buildDispatchTable constructs the dynamic dispatch (vtable) for a given class.
func (cg *CodeGenerator) buildDispatchTable(classNode *parser.Class, classMap map[string]*parser.Class) {
	if isBuiltIn(classNode.Name) {
		return
	}
	if _, exists := cg.dispatchTables[classNode.Name]; exists {
		return
	}
	var layout []DispatchEntry
	if classNode.Inherits != "" && !isBuiltIn(classNode.Inherits) {
		fmt.Printf("Building dispatch table for class %s inherited from %s\n", classNode.Name, classNode.Inherits)
		parentNode, found := classMap[classNode.Inherits]
		if found {
			cg.buildDispatchTable(parentNode, classMap)
			parentLayout := cg.dispatchTableLayouts[classNode.Inherits]
			layout = make([]DispatchEntry, len(parentLayout))
			copy(layout, parentLayout)
		}
	}
	for _, feat := range classNode.Features {
		if m, ok := feat.(*parser.Method); ok {
			found := false
			for i, entry := range layout {
				if entry.Method == m.Ident {
					layout[i] = DispatchEntry{Class: classNode.Name, Method: m.Ident}
					found = true
					break
				}
			}
			if !found {
				layout = append(layout, DispatchEntry{Class: classNode.Name, Method: m.Ident})
			}
		}
	}
	cg.dispatchTableLayouts[classNode.Name] = layout
	for i, entry := range layout {
		key := fmt.Sprintf("%s.%s", classNode.Name, entry.Method)
		cg.methodIndices[key] = i
	}
	methodCount := len(layout)
	commonSelfType := cg.getClassPtrType("Object")
	commonMethodFuncType := types.NewFunc(commonSelfType, commonSelfType)
	commonMethodFuncType.Variadic = true
	commonMethodType := types.NewPointer(commonMethodFuncType)

	elems := make([]constant.Constant, methodCount)
	for i, entry := range layout {
		funcName := fmt.Sprintf("%s_%s", entry.Class, entry.Method)
		fn := findFuncByName(cg.module, funcName)
		if fn == nil {
			fmt.Printf("Error: function %s not found for dispatch table of class %s\n", funcName, classNode.Name)
			elems[i] = constant.NewNull(commonMethodType)
		} else {
			casted := constant.NewBitCast(fn, commonMethodType)
			elems[i] = casted
		}
	}
	arrayType := types.NewArray(uint64(methodCount), commonMethodType)
	arrayConst := constant.NewArray(arrayType, elems...)
	globalName := fmt.Sprintf("vtable_%s", classNode.Name)
	vtableGlobal := cg.module.NewGlobalDef(globalName, arrayConst)
	vtableGlobal.Immutable = true
	cg.dispatchTables[classNode.Name] = vtableGlobal
}

// --------------------------------------------------------------------------
// Expression Generation
// --------------------------------------------------------------------------
func (cg *CodeGenerator) genExpr(node parser.Node) value.Value {
	switch n := node.(type) {
	case *parser.IntConst:
		// Box the integer constant.
		return cg.boxInt(constant.NewInt(types.I32, int64(n.Value)))
	case *parser.BoolConst:
		var b int64
		if n.Value {
			b = 1
		} else {
			b = 0
		}
		return cg.boxBool(constant.NewInt(types.I1, b))
	case *parser.StringConst:
		return cg.genStringConstantPtr(n.Value)
	case *parser.Self:
		if alloca, ok := cg.variableEnv["self"]; ok {
			return cg.currentBlock.NewLoad(alloca.ElemType, alloca)
		}
		return constant.NewNull(types.NewPointer(cg.getClassPtrType(cg.currentClass)))
	case *parser.Ident:
		if alloca, ok := cg.variableEnv[n.Name]; ok {
			return cg.currentBlock.NewLoad(alloca.ElemType, alloca)
		}
		if cg.currentClass != "" {
			key := fmt.Sprintf("%s.%s", cg.currentClass, n.Name)
			if index, found := cg.attributeIndices[key]; found {
				selfAlloca, ok := cg.variableEnv["self"]
				if !ok {
					fmt.Printf("Error: self not found in variableEnv\n")
					return constant.NewNull(types.NewPointer(types.I32))
				}
				selfVal := cg.currentBlock.NewLoad(cg.getClassPtrType("Object"), selfAlloca)
				specificSelf := cg.currentBlock.NewBitCast(selfVal, cg.getClassPtrType(cg.currentClass))
				indexVal := constant.NewInt(types.I32, int64(index))
				fieldPtr := cg.currentBlock.NewGetElementPtr(cg.classTypes[cg.currentClass], specificSelf,
					constant.NewInt(types.I32, 0), indexVal)
				return cg.currentBlock.NewLoad(fieldPtr.ElemType, fieldPtr)
			}
		}
		fmt.Printf("IDENT %s not found, defaulting to null.\n", n.Name)
		return constant.NewNull(types.NewPointer(types.I32))
	case *parser.Assignment:
		val := cg.genExpr(n.Expr)
		alloca, ok := cg.variableEnv[n.Ident.Name]
		if !ok {
			if cg.currentClass != "" {
				key := fmt.Sprintf("%s.%s", cg.currentClass, n.Ident.Name)
				if index, found := cg.attributeIndices[key]; found {
					selfAlloca, ok := cg.variableEnv["self"]
					if !ok {
						fmt.Printf("Error: self not found for assignment\n")
						return val
					}
					selfVal := cg.currentBlock.NewLoad(cg.getClassPtrType("Object"), selfAlloca)
					specificSelf := cg.currentBlock.NewBitCast(selfVal, cg.getClassPtrType(cg.currentClass))
					indexVal := constant.NewInt(types.I32, int64(index))
					fieldPtr := cg.currentBlock.NewGetElementPtr(cg.classTypes[cg.currentClass], specificSelf,
						constant.NewInt(types.I32, 0), indexVal)
					cg.currentBlock.NewStore(val, fieldPtr)
					return val
				}
			}
			alloca = cg.currentBlock.NewAlloca(val.Type())
			cg.variableEnv[n.Ident.Name] = alloca
		}
		if !val.Type().Equal(alloca.ElemType) {
			val = cg.currentBlock.NewBitCast(val, alloca.ElemType)
		}
		cg.currentBlock.NewStore(val, alloca)
		return val
	case *parser.Block:
		var last value.Value = constant.NewInt(types.I32, 0)
		for _, expr := range n.Exprs {
			last = cg.genExpr(expr)
		}
		return last
	case *parser.If:
		condVal := cg.genExpr(n.Condition)
		// If condition is a Bool object, unbox it.
		var cmpVal value.Value
		if condVal.Type().Equal(cg.getClassPtrType("Bool")) {
			cmpVal = cg.unboxBool(condVal)
		} else if condVal.Type().Equal(types.I32) || condVal.Type().Equal(types.I1) {
			cmpVal = condVal
		} else if condVal.Type().(*types.PointerType) != nil {
			cmpVal = condVal
		} else {
			cmpVal = condVal
		}
		// Determine a proper "zero" constant.
		var zero value.Value
		switch cmpVal.Type().(type) {
		case *types.IntType:
			zero = constant.NewInt(cmpVal.Type().(*types.IntType), 0)
		default:
			zero = constant.NewNull(types.NewPointer(cmpVal.Type()))
		}
		isTrue := cg.currentBlock.NewICmp(enum.IPredNE, cmpVal, zero)
		thenBlock := cg.currentFunc.NewBlock(cg.newUniqueName("if_then"))
		elseBlock := cg.currentFunc.NewBlock(cg.newUniqueName("if_else"))
		mergeBlock := cg.currentFunc.NewBlock(cg.newUniqueName("if_end"))
		cg.currentBlock.NewCondBr(isTrue, thenBlock, elseBlock)
		cg.currentBlock = thenBlock
		thenVal := cg.genExpr(n.True)
		cg.currentBlock.NewBr(mergeBlock)
		cg.currentBlock = elseBlock
		elseVal := cg.genExpr(n.False)
		cg.currentBlock.NewBr(mergeBlock)
		cg.currentBlock = mergeBlock
		phi := mergeBlock.NewPhi(
			ir.NewIncoming(thenVal, thenBlock),
			ir.NewIncoming(elseVal, elseBlock),
		)
		return phi
	case *parser.While:
		condBlock := cg.currentFunc.NewBlock("while_cond")
		bodyBlock := cg.currentFunc.NewBlock("while_body")
		endBlock := cg.currentFunc.NewBlock("while_end")
		cg.currentBlock.NewBr(condBlock)
		cg.currentBlock = condBlock
		condVal := cg.genExpr(n.Condition)
		var cmpVal value.Value
		if condVal.Type().Equal(cg.getClassPtrType("Bool")) {
			cmpVal = cg.unboxBool(condVal)
		} else {
			cmpVal = condVal
		}
		var zero value.Value
		switch cmpVal.Type().(type) {
		case *types.IntType:
			zero = constant.NewInt(cmpVal.Type().(*types.IntType), 0)
		default:
			zero = constant.NewNull(types.NewPointer(cmpVal.Type()))
		}
		isTrue := condBlock.NewICmp(enum.IPredNE, cmpVal, zero)
		condBlock.NewCondBr(isTrue, bodyBlock, endBlock)
		cg.currentBlock = bodyBlock
		cg.genExpr(n.Body)
		cg.currentBlock.NewBr(condBlock)
		cg.currentBlock = endBlock
		return constant.NewInt(types.I32, 0)
	case *parser.BinaryOperation:
		left := cg.genExpr(n.Left)
		right := cg.genExpr(n.Right)
		switch n.Operator {
		case "+":
			// Unbox ints, add, then box the result.
			leftVal := cg.unboxInt(left)
			rightVal := cg.unboxInt(right)
			sum := cg.currentBlock.NewAdd(leftVal, rightVal)
			return cg.boxInt(sum)
		case "-":
			leftVal := cg.unboxInt(left)
			rightVal := cg.unboxInt(right)
			diff := cg.currentBlock.NewSub(leftVal, rightVal)
			return cg.boxInt(diff)
		case "*":
			leftVal := cg.unboxInt(left)
			rightVal := cg.unboxInt(right)
			prod := cg.currentBlock.NewMul(leftVal, rightVal)
			return cg.boxInt(prod)
		case "/":
			leftVal := cg.unboxInt(left)
			rightVal := cg.unboxInt(right)
			quot := cg.currentBlock.NewSDiv(leftVal, rightVal)
			return cg.boxInt(quot)
		case "<":
			leftVal := cg.unboxInt(left)
			rightVal := cg.unboxInt(right)
			cmp := cg.currentBlock.NewICmp(enum.IPredSLT, leftVal, rightVal)
			return cg.boxBool(cmp)
		case "<=":
			leftVal := cg.unboxInt(left)
			rightVal := cg.unboxInt(right)
			cmp := cg.currentBlock.NewICmp(enum.IPredSLE, leftVal, rightVal)
			return cg.boxBool(cmp)
		case "=":
			// For Int objects.
			if left.Type().Equal(cg.getClassPtrType("Int")) && right.Type().Equal(cg.getClassPtrType("Int")) {
				leftVal := cg.unboxInt(left)
				rightVal := cg.unboxInt(right)
				cmp := cg.currentBlock.NewICmp(enum.IPredEQ, leftVal, rightVal)
				return cg.boxBool(cmp)
			}
			// For Bool objects.
			if left.Type().Equal(cg.getClassPtrType("Bool")) && right.Type().Equal(cg.getClassPtrType("Bool")) {
				leftVal := cg.unboxBool(left)
				rightVal := cg.unboxBool(right)
				cmp := cg.currentBlock.NewICmp(enum.IPredEQ, leftVal, rightVal)
				return cg.boxBool(cmp)
			}
			// For String objects.
			if left.Type().Equal(cg.stringType) && right.Type().Equal(cg.stringType) {
				leftCharPtrPtr := cg.currentBlock.NewGetElementPtr(cg.stringStruct, left,
					constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
				leftChar := cg.currentBlock.NewLoad(types.NewPointer(types.I8), leftCharPtrPtr)
				rightCharPtrPtr := cg.currentBlock.NewGetElementPtr(cg.stringStruct, right,
					constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
				rightChar := cg.currentBlock.NewLoad(types.NewPointer(types.I8), rightCharPtrPtr)
				cmp := cg.currentBlock.NewICmp(enum.IPredEQ, leftChar, rightChar)
				return cg.boxBool(cmp)
			}
			// Otherwise, compare pointers.
			cmp := cg.currentBlock.NewICmp(enum.IPredEQ, left, right)
			return cg.boxBool(cmp)
		default:
			fmt.Printf("Unknown binop %q\n", n.Operator)
			return constant.NewNull(types.NewPointer(types.I32))
		}
	case *parser.UnaryOperation:
		right := cg.genExpr(n.Right)
		switch n.Operator {
		case "~":
			// For int negation.
			val := cg.unboxInt(right)
			neg := cg.currentBlock.NewSub(constant.NewInt(types.I32, 0), val)
			return cg.boxInt(neg)
		case "not":
			// For boolean not.
			val := cg.unboxBool(right)
			notVal := cg.currentBlock.NewXor(val, constant.NewInt(types.I1, 1))
			return cg.boxBool(notVal)
		case "isvoid":
			// isvoid returns a Bool; if value is null, then true.
			var cmp value.Value
			if right.Type().(*types.PointerType) != nil {
				cmp = cg.currentBlock.NewICmp(enum.IPredEQ, right, constant.NewNull(types.NewPointer(right.Type())))
			} else {
				cmp = constant.NewInt(types.I1, 0)
			}
			return cg.boxBool(cmp)
		default:
			fmt.Printf("Unknown unary operator %q\n", n.Operator)
			return constant.NewNull(types.NewPointer(types.I32))
		}
	case *parser.New:
		className := n.Type
		classType, ok := cg.classTypes[className]
		if !ok {
			fmt.Printf("Error: unknown class %s in new expression\n", className)
			return constant.NewNull(types.NewPointer(types.I32))
		}
		mallocFn := findFuncByName(cg.module, "malloc")
		sizeConst := constant.NewInt(types.I64, cg.typeSize(classType))
		rawPtr := cg.currentBlock.NewCall(mallocFn, sizeConst)
		objPtr := cg.currentBlock.NewBitCast(rawPtr, cg.getClassPtrType(className))
		if !isBuiltIn(className) {
			vtableGlobal, exists := cg.dispatchTables[className]
			if !exists {
				fmt.Printf("Error: dispatch table for class %s not found\n", className)
			} else {
				vtablePtr := cg.currentBlock.NewBitCast(vtableGlobal, types.NewPointer(vtableGlobal.Init.Type()))
				vtableGEP := cg.currentBlock.NewGetElementPtr(vtableGlobal.Init.Type(), vtablePtr,
					constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
				vtableFieldType := cg.classTypes[className].(*types.StructType).Fields[0]
				vtableGEPCast := cg.currentBlock.NewBitCast(vtableGEP, vtableFieldType)
				vtableFieldPtr := cg.currentBlock.NewGetElementPtr(cg.classTypes[className], objPtr,
					constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
				cg.currentBlock.NewStore(vtableGEPCast, vtableFieldPtr)
			}
		}
		return objPtr
	case *parser.Let:
		oldEnv := cg.variableEnv
		cg.variableEnv = make(map[string]*ir.InstAlloca)
		for k, v := range oldEnv {
			cg.variableEnv[k] = v
		}
		if cg.variableTypeEnv == nil {
			cg.variableTypeEnv = make(map[string]string)
		}
		for _, assignment := range n.Assignments {
			var varType types.Type
			switch assignment.Type {
			case "Int":
				varType = cg.getClassPtrType("Int")
			case "String":
				varType = cg.stringType
			case "Bool":
				varType = cg.getClassPtrType("Bool")
			default:
				if _, exists := cg.classTypes[assignment.Type]; exists {
					varType = cg.getClassPtrType(assignment.Type)
				} else {
					varType = cg.getClassPtrType("Object")
				}
			}
			alloca := cg.currentBlock.NewAlloca(varType)
			cg.variableEnv[assignment.Ident] = alloca
			cg.variableTypeEnv[assignment.Ident] = assignment.Type
			var initVal value.Value
			if assignment.Init != nil {
				initVal = cg.genExpr(assignment.Init)
			} else {
				if assignment.Type == "String" {
					initVal = cg.genStringConstantPtr("")
				} else {
					initVal = constant.NewNull(varType.(*types.PointerType))
				}
			}
			cg.currentBlock.NewStore(initVal, alloca)
		}
		result := cg.genExpr(n.Body)
		cg.variableEnv = oldEnv
		return result
	case *parser.Case:
		_ = cg.genExpr(n.Expr)
		if len(n.TypeActions) == 0 {
			fmt.Println("Case with no branches => returning null.")
			return constant.NewNull(types.NewPointer(types.I32))
		}
		firstAction := n.TypeActions[0]
		oldEnv := cg.variableEnv
		cg.variableEnv = make(map[string]*ir.InstAlloca)
		for k, v := range oldEnv {
			cg.variableEnv[k] = v
		}
		dummy := cg.currentBlock.NewAlloca(types.I32)
		cg.variableEnv[firstAction.Ident] = dummy
		result := cg.genExpr(firstAction.Expr)
		cg.variableEnv = oldEnv
		return result
	case *parser.MethodCall:
		var receiver value.Value
		var receiverType string
		if n.Object != nil {
			receiver = cg.genExpr(n.Object)
			if newExpr, ok := n.Object.(*parser.New); ok {
				receiverType = newExpr.Type
			} else if ident, ok := n.Object.(*parser.Ident); ok {
				if t, found := cg.variableTypeEnv[ident.Name]; found {
					receiverType = t
				} else {
					key := fmt.Sprintf("%s.%s", cg.currentClass, ident.Name)
					if typ, found := cg.attributeTypeEnv[key]; found {
						receiverType = typ
					} else {
						receiverType = cg.currentClass
					}
				}
			}
			if receiverType == "" {
				receiverType = cg.currentClass
			}
		} else {
			receiver = constant.NewNull(types.NewPointer(types.I32))
			receiverType = cg.currentClass
		}
		var args []value.Value
		args = append(args, receiver)
		for _, p := range n.Method.Params {
			args = append(args, cg.genExpr(p))
		}
		if isBuiltIn(receiverType) {
			var calleeName string
			if n.Method.Ident == "length" || n.Method.Ident == "concat" || n.Method.Ident == "substr" {
				calleeName = "String_" + n.Method.Ident
			} else {
				calleeName = fmt.Sprintf("%s_%s", receiverType, n.Method.Ident)
			}
			callee := findFuncByName(cg.module, calleeName)
			if callee == nil {
				fmt.Printf("Error: method %s not found\n", calleeName)
				return constant.NewNull(types.NewPointer(types.I32))
			}
			return cg.currentBlock.NewCall(callee, args...)
		} else {
			key := fmt.Sprintf("%s.%s", receiverType, n.Method.Ident)
			idx, found := cg.methodIndices[key]
			if !found {
				fmt.Printf("Error: method %s not found in dispatch table for %s\n", n.Method.Ident, receiverType)
				return constant.NewNull(types.NewPointer(types.I32))
			}
			vtablePtr := cg.currentBlock.NewGetElementPtr(cg.classTypes[receiverType], receiver,
				constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
			vtableFieldType := cg.classTypes[receiverType].(*types.StructType).Fields[0]
			vtableVal := cg.currentBlock.NewLoad(vtableFieldType, vtablePtr)
			methodPtrPtr := cg.currentBlock.NewGetElementPtr(vtableFieldType, vtableVal,
				constant.NewInt(types.I32, int64(idx)))
			methodPtr := cg.currentBlock.NewLoad(methodPtrPtr.ElemType, methodPtrPtr)
			staticName := fmt.Sprintf("%s_%s", receiverType, n.Method.Ident)
			staticFn := findFuncByName(cg.module, staticName)
			if staticFn == nil {
				fmt.Printf("Error: static method %s not found\n", staticName)
				return constant.NewNull(types.NewPointer(types.I32))
			}
			commonSelfType := cg.getClassPtrType("Object")
			args[0] = cg.currentBlock.NewBitCast(receiver, commonSelfType)
			castedMethodPtr := cg.currentBlock.NewBitCast(methodPtr, staticFn.Type())
			return cg.currentBlock.NewCall(castedMethodPtr, args...)
		}
	case *parser.FunctionCall:
		switch n.Ident {
		case "out_string":
			if len(n.Params) < 1 {
				fmt.Println("Warning: out_string with no params!")
				return constant.NewNull(types.NewPointer(types.I32))
			}
			return cg.genCallPrintString(cg.genExpr(n.Params[0]))
		case "out_int":
			if len(n.Params) < 1 {
				fmt.Println("Warning: out_int with no params!")
				return constant.NewNull(types.NewPointer(types.I32))
			}
			return cg.genCallPrintInt(cg.genExpr(n.Params[0]))
		case "in_string":
			return cg.genCallInString()
		case "in_int":
			return cg.genCallInInt()
		}
		var args []value.Value
		if cg.currentClass != "" {
			if selfAlloca, ok := cg.variableEnv["self"]; ok {
				selfVal := cg.currentBlock.NewLoad(selfAlloca.ElemType, selfAlloca)
				args = append(args, selfVal)
			} else {
				args = append(args, constant.NewNull(types.NewPointer(cg.getClassPtrType(cg.currentClass))))
			}
		}
		for _, p := range n.Params {
			args = append(args, cg.genExpr(p))
		}
		calleeName := n.Ident
		if cg.currentClass != "" && !strings.HasPrefix(n.Ident, cg.currentClass+"_") {
			calleeName = fmt.Sprintf("%s_%s", cg.currentClass, n.Ident)
		}
		callee := findFuncByName(cg.module, calleeName)
		if callee == nil {
			fmt.Printf("Error: function %s not found\n", calleeName)
			return constant.NewNull(types.NewPointer(types.I32))
		}
		return cg.currentBlock.NewCall(callee, args...)
	default:
		fmt.Printf("Unhandled expr type %T, returning null.\n", n)
		return constant.NewNull(types.NewPointer(types.I32))
	}
}

// --------------------------------------------------------------------------
// String Helpers
// --------------------------------------------------------------------------
func (cg *CodeGenerator) genStringConstantPtr(strVal string) value.Value {
	strVal = strings.ReplaceAll(strVal, "\\n", "\n")
	g := cg.getOrCreateGlobalString(strVal)
	charPtr := constant.NewGetElementPtr(g.Init.Type(), g,
		constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	strObjConst := constant.NewStruct(cg.stringStruct, charPtr)
	globalStrObj := cg.module.NewGlobalDef(cg.uniqueGlobalName("str_obj"), strObjConst)
	globalStrObj.Immutable = true
	return constant.NewBitCast(globalStrObj, cg.stringType)
}

func (cg *CodeGenerator) getOrCreateGlobalString(strVal string) *ir.Global {
	if !strings.HasSuffix(strVal, "\x00") {
		strVal += "\x00"
	}
	globalName := fmt.Sprintf("str_%d", cg.stringCounter)
	cg.stringCounter++
	arr := constant.NewCharArrayFromString(strVal)
	g := cg.module.NewGlobalDef(globalName, arr)
	g.Immutable = true
	return g
}

// --------------------------------------------------------------------------
// Control Structures
// --------------------------------------------------------------------------
func (cg *CodeGenerator) genCallPrintString(strObj value.Value) value.Value {
	zero := constant.NewInt(types.I32, 0)
	charPtrPtr := cg.currentBlock.NewGetElementPtr(cg.stringStruct, strObj, zero, zero)
	charPtr := cg.currentBlock.NewLoad(types.NewPointer(types.I8), charPtrPtr)
	fmtPtr := cg.currentBlock.NewGetElementPtr(cg.fmtString.Type().(*types.PointerType).ElemType, cg.fmtString, zero, zero)
	cg.currentBlock.NewCall(cg.printfFunc, fmtPtr, charPtr)
	if selfAlloca, ok := cg.variableEnv["self"]; ok {
		return cg.currentBlock.NewLoad(selfAlloca.ElemType, selfAlloca)
	}
	return constant.NewNull(types.NewPointer(cg.stringType))
}

func (cg *CodeGenerator) genCallPrintInt(intObj value.Value) value.Value {
	// Unbox int.
	val := cg.unboxInt(intObj)
	zero := constant.NewInt(types.I32, 0)
	fmtPtr := cg.currentBlock.NewGetElementPtr(cg.fmtInt.Type().(*types.PointerType).ElemType, cg.fmtInt, zero, zero)
	cg.currentBlock.NewCall(cg.printfFunc, fmtPtr, val)
	if selfAlloca, ok := cg.variableEnv["self"]; ok {
		return cg.currentBlock.NewLoad(selfAlloca.ElemType, selfAlloca)
	}
	return constant.NewNull(types.NewPointer(cg.getClassPtrType("Int")))
}

func (cg *CodeGenerator) genCallInString() value.Value {
	bufAlloca := cg.currentBlock.NewAlloca(types.NewArray(1024, types.I8))
	zero := constant.NewInt(types.I32, 0)
	ptr := cg.currentBlock.NewGetElementPtr(bufAlloca.ElemType, bufAlloca, zero, zero)
	fmtPtr := cg.currentBlock.NewGetElementPtr(cg.fmtStringIn.Type().(*types.PointerType).ElemType, cg.fmtStringIn, zero, zero)
	cg.currentBlock.NewCall(cg.scanfFunc, fmtPtr, ptr)
	mallocFn := findFuncByName(cg.module, "malloc")
	sizeStringObj := constant.NewInt(types.I64, cg.typeSize(cg.stringStruct))
	newStringObjRaw := cg.currentBlock.NewCall(mallocFn, sizeStringObj)
	newStringObj := cg.currentBlock.NewBitCast(newStringObjRaw, cg.stringType)
	charFieldPtr := cg.currentBlock.NewGetElementPtr(cg.stringStruct, newStringObj, zero, zero)
	cg.currentBlock.NewStore(ptr, charFieldPtr)
	return newStringObj
}

func (cg *CodeGenerator) genCallInInt() value.Value {
	allocaI32 := cg.currentBlock.NewAlloca(types.I32)
	zero := constant.NewInt(types.I32, 0)
	fmtPtr := cg.currentBlock.NewGetElementPtr(cg.fmtIntIn.Type().(*types.PointerType).ElemType, cg.fmtIntIn, zero, zero)
	cg.currentBlock.NewCall(cg.scanfFunc, fmtPtr, allocaI32)
	loadedVal := cg.currentBlock.NewLoad(types.I32, allocaI32)
	return cg.boxInt(loadedVal)
}

func (cg *CodeGenerator) newUniqueName(prefix string) string {
	name := fmt.Sprintf("%s_%d", prefix, cg.counter)
	cg.counter++
	return name
}
