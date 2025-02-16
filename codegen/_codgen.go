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

// e.g. used for "nocapture".
const Nocapture paramAttr = "nocapture"

// --------------------------------------------------------------------------
// DispatchEntry is used to compute dispatch table layouts.
type DispatchEntry struct {
    Class  string
    Method string
}

// --------------------------------------------------------------------------
// CodeGenerator accumulates all structures, methods, vtables, etc.
type CodeGenerator struct {
    module          *ir.Module
    currentFunc     *ir.Func
    currentBlock    *ir.Block
    variableEnv     map[string]*ir.InstAlloca // var name -> alloca
    variableTypeEnv map[string]string         // var name -> COOL type

    printfFunc *ir.Func
    scanfFunc  *ir.Func

    // Format strings for output and input.
    fmtString   *ir.Global
    fmtInt      *ir.Global
    fmtStringIn *ir.Global
    fmtIntIn    *ir.Global

    stringCounter int // to produce unique global string names

    // Current COOL class name we are inside of (for attributes, self, etc.).
    currentClass string

    // attributeIndices["Class.attr"] = index in the LLVM struct
    attributeIndices map[string]int

    // classTypes["ClassName"] = the LLVM struct type for that class
    classTypes map[string]types.Type

    // attributeTypeEnv["Class.attr"] = COOL type of that attribute
    attributeTypeEnv map[string]string

    // For uniqueness in block names etc.
    counter int

    // Canonical pointer types for each COOL class, e.g. %X_struct*
    classPtrTypes map[string]types.Type

    // The internal LLVM struct for built-in classes:
    stringStruct *types.StructType
    intStruct    *types.StructType
    boolStruct   *types.StructType
    objectStruct *types.StructType
    ioStruct     *types.StructType

    // Because we treat "String" as a pointer to `stringStruct`
    stringType types.Type

    // For dynamic dispatch: vtables
    dispatchTableLayouts map[string][]DispatchEntry
    dispatchTables       map[string]*ir.Global
    methodIndices        map[string]int
}

// uniqueGlobalName produces a unique global name.
func (cg *CodeGenerator) uniqueGlobalName(prefix string) string {
    return fmt.Sprintf("%s_%d", prefix, len(cg.module.Globals))
}

// isBuiltIn checks if className is one of the five COOL built-ins.
func isBuiltIn(className string) bool {
    return className == "Object" ||
        className == "Int" ||
        className == "String" ||
        className == "Bool" ||
        className == "IO"
}

// --------------------------------------------------------------------------
// Boxing/unboxing Int and Bool
// --------------------------------------------------------------------------
func (cg *CodeGenerator) boxInt(val value.Value) value.Value {
    size := constant.NewInt(types.I64, cg.typeSize(cg.intStruct))
    mallocFn := findFuncByName(cg.module, "malloc")
    rawPtr := cg.currentBlock.NewCall(mallocFn, size)
    intObj := cg.currentBlock.NewBitCast(rawPtr, cg.getClassPtrType("Int"))
    fieldPtr := cg.currentBlock.NewGetElementPtr(
        cg.intStruct, intObj,
        constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 1),
    )
    cg.currentBlock.NewStore(val, fieldPtr)
    return intObj
}

func (cg *CodeGenerator) boxBool(val value.Value) value.Value {
    size := constant.NewInt(types.I64, cg.typeSize(cg.boolStruct))
    mallocFn := findFuncByName(cg.module, "malloc")
    rawPtr := cg.currentBlock.NewCall(mallocFn, size)
    boolObj := cg.currentBlock.NewBitCast(rawPtr, cg.getClassPtrType("Bool"))
    fieldPtr := cg.currentBlock.NewGetElementPtr(
        cg.boolStruct, boolObj,
        constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 1),
    )
    cg.currentBlock.NewStore(val, fieldPtr)
    return boolObj
}

func (cg *CodeGenerator) unboxInt(obj value.Value) value.Value {
    if _, ok := obj.Type().(*types.PointerType); !ok {
        obj = cg.currentBlock.NewBitCast(obj, cg.getClassPtrType("Int"))
    }
    ptrType := cg.getClassPtrType("Int").(*types.PointerType)
    fieldPtr := cg.currentBlock.NewGetElementPtr(ptrType.ElemType, obj,
        constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 1))
    return cg.currentBlock.NewLoad(types.I32, fieldPtr)
}

func (cg *CodeGenerator) unboxBool(obj value.Value) value.Value {
    if _, ok := obj.Type().(*types.PointerType); !ok {
        obj = cg.currentBlock.NewBitCast(obj, cg.getClassPtrType("Bool"))
    }
    ptrType := cg.getClassPtrType("Bool").(*types.PointerType)
    fieldPtr := cg.currentBlock.NewGetElementPtr(ptrType.ElemType, obj,
        constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 1))
    return cg.currentBlock.NewLoad(types.I1, fieldPtr)
}

// --------------------------------------------------------------------------
// typeSize returns a crude size (in bytes) for a given LLVM type.
func (cg *CodeGenerator) typeSize(t types.Type) int64 {
    switch tt := t.(type) {
    case *types.StructType:
        // Very rough. Each field ~8 bytes
        return int64(len(tt.Fields)) * 8
    case *types.PointerType:
        return 8
    case *types.IntType:
        return 4
    default:
        return 8
    }
}

func (cg *CodeGenerator) getClassPtrType(className string) types.Type {
    if ptr, ok := cg.classPtrTypes[className]; ok {
        return ptr
    }
    if st, ok := cg.classTypes[className]; ok {
        ptr := types.NewPointer(st)
        cg.classPtrTypes[className] = ptr
        return ptr
    }
    return types.NewPointer(types.I8)
}

// CodegenProgram is the entry point that generates LLVM IR for the entire COOL program.
func CodegenProgram(prog *parser.Program) *ir.Module {
    cg := &CodeGenerator{
        module:               ir.NewModule(),
        variableEnv:          make(map[string]*ir.InstAlloca),
        variableTypeEnv:      make(map[string]string),
        attributeIndices:     make(map[string]int),
        classTypes:           make(map[string]types.Type),
        attributeTypeEnv:     make(map[string]string),
        classPtrTypes:        make(map[string]types.Type),
        dispatchTableLayouts: make(map[string][]DispatchEntry),
        dispatchTables:       make(map[string]*ir.Global),
        methodIndices:        make(map[string]int),
    }

    // Builtin object struct: only a vtable pointer
    cg.objectStruct = types.NewStruct(types.NewPointer(types.I8))
    cg.objectStruct.SetName("ObjectStruct")
    cg.module.NewTypeDef("ObjectStruct", cg.objectStruct)

    // Builtin Int: vtable pointer + i32
    cg.intStruct = types.NewStruct(
        types.NewPointer(types.I8),
        types.I32,
    )
    cg.intStruct.SetName("IntStruct")
    cg.module.NewTypeDef("IntStruct", cg.intStruct)

    // Builtin Bool: vtable pointer + i1
    cg.boolStruct = types.NewStruct(
        types.NewPointer(types.I8),
        types.I1,
    )
    cg.boolStruct.SetName("BoolStruct")
    cg.module.NewTypeDef("BoolStruct", cg.boolStruct)

    // Builtin String: vtable pointer + i8* data
    cg.stringStruct = types.NewStruct(
        types.NewPointer(types.I8),
        types.NewPointer(types.I8),
    )
    cg.stringStruct.SetName("StringStruct")
    cg.module.NewTypeDef("StringStruct", cg.stringStruct)

    // Builtin IO: vtable pointer only
    cg.ioStruct = types.NewStruct(types.NewPointer(types.I8))
    cg.ioStruct.SetName("IOStruct")
    cg.module.NewTypeDef("IOStruct", cg.ioStruct)

    // Register builtin class -> struct
    cg.classTypes["Object"] = cg.objectStruct
    cg.classTypes["Int"]    = cg.intStruct
    cg.classTypes["Bool"]   = cg.boolStruct
    cg.classTypes["String"] = cg.stringStruct
    cg.classTypes["IO"]     = cg.ioStruct

    // The canonical pointer form of "String"
    cg.classPtrTypes["StringStruct"] = types.NewPointer(cg.stringStruct)
    cg.stringType = types.NewPointer(cg.stringStruct)

    cg.declareExternalIO()
    cg.declareMalloc()
    cg.defineStringLength()
    cg.defineStringConcat()
    cg.defineStringSubstr()

    // Create a "main" function that calls Main_main or whichever is found
    mainFn := cg.module.NewFunc("main", types.I32)
    cg.currentFunc = mainFn
    cg.currentBlock = mainFn.NewBlock("entry")

    // Build a quick map of className => parser.Class
    classMap := make(map[string]*parser.Class)
    for _, classNode := range prog.Classes {
        classMap[classNode.Name] = classNode
    }

    // 1) Create each class type (struct) with attributes
    for _, classNode := range prog.Classes {
        cg.createClassType(classNode, classMap)
    }

    // 2) Declare methods
    for _, classNode := range prog.Classes {
        for _, feat := range classNode.Features {
            if method, ok := feat.(*parser.Method); ok {
                cg.declareMethod(classNode.Name, method)
            }
        }
    }

    // 3) Build dispatch tables
    cg.buildDispatchTableForBuiltins()
    for _, classNode := range prog.Classes {
        cg.buildDispatchTable(classNode, classMap)
    }

    // 4) Generate method bodies
    for _, classNode := range prog.Classes {
        cg.generateMethodBodies(classNode)
    }

    // Finally, call "Main_main" if it exists, else any X_main if found
    var entryFn *ir.Func
    if fn := findFuncByName(cg.module, "Main_main"); fn != nil {
        entryFn = fn
    } else {
        for _, cls := range prog.Classes {
            tryName := fmt.Sprintf("%s_main", cls.Name)
            if fn := findFuncByName(cg.module, tryName); fn != nil {
                entryFn = fn
                break
            }
        }
    }

    if entryFn != nil {
        cg.currentBlock.NewCall(entryFn)
    }
    cg.currentBlock.NewRet(constant.NewInt(types.I32, 0))

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
// Create minimal vtables for built-ins
// --------------------------------------------------------------------------
func (cg *CodeGenerator) buildDispatchTableForBuiltins() {
    cg.createVTableGlobal("Object", []DispatchEntry{})
    cg.createVTableGlobal("Int",    []DispatchEntry{})
    cg.createVTableGlobal("String", []DispatchEntry{})
    cg.createVTableGlobal("Bool",   []DispatchEntry{})
    cg.createVTableGlobal("IO",     []DispatchEntry{})
}

func (cg *CodeGenerator) createVTableGlobal(className string, layout []DispatchEntry) {
    commonMethodPtrType := types.NewPointer(types.NewFunc(
        cg.getClassPtrType("Object"),
        cg.getClassPtrType("Object"),
    ))
    arrType := types.NewArray(uint64(len(layout)), commonMethodPtrType)
    elems := make([]constant.Constant, len(layout))
    for i, entry := range layout {
        fnName := fmt.Sprintf("%s_%s", entry.Class, entry.Method)
        fn := findFuncByName(cg.module, fnName)
        if fn != nil {
            casted := constant.NewBitCast(fn, commonMethodPtrType)
            elems[i] = casted
        } else {
            elems[i] = constant.NewNull(commonMethodPtrType)
        }
    }
    vtableGlobal := cg.module.NewGlobalDef(
        fmt.Sprintf("vtable_%s", className),
        constant.NewArray(arrType, elems...),
    )
    cg.dispatchTables[className] = vtableGlobal
}

// --------------------------------------------------------------------------
// External IO declarations
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

    // Format strings
    cg.fmtString = cg.module.NewGlobalDef(
        cg.uniqueGlobalName("fmt_str"),
        constant.NewCharArrayFromString("%s\x00"),
    )
    cg.fmtString.Immutable = true

    cg.fmtInt = cg.module.NewGlobalDef(
        cg.uniqueGlobalName("fmt_int"),
        constant.NewCharArrayFromString("%d\x00"),
    )
    cg.fmtInt.Immutable = true

    cg.fmtStringIn = cg.module.NewGlobalDef(
        cg.uniqueGlobalName("fmt_str_in"),
        constant.NewCharArrayFromString("%1023s\x00"),
    )
    cg.fmtStringIn.Immutable = true

    cg.fmtIntIn = cg.module.NewGlobalDef(
        cg.uniqueGlobalName("fmt_int_in"),
        constant.NewCharArrayFromString("%d\x00"),
    )
    cg.fmtIntIn.Immutable = true
}

func (cg *CodeGenerator) declareMalloc() {
    cg.module.NewFunc("malloc", types.NewPointer(types.I8), ir.NewParam("size", types.I64))
}

// --------------------------------------------------------------------------
// Built‐in String Methods
// --------------------------------------------------------------------------
func (cg *CodeGenerator) defineStringLength() {
    param := ir.NewParam("str", cg.stringType)
    fn := cg.module.NewFunc("String_length", types.I32, param)
    entry := fn.NewBlock("entry")

    charPtrPtr := entry.NewGetElementPtr(
        cg.stringStruct, fn.Params[0],
        constant.NewInt(types.I32, 0),
        constant.NewInt(types.I32, 1),
    )
    charPtr := entry.NewLoad(types.NewPointer(types.I8), charPtrPtr)

    counterAlloca := entry.NewAlloca(types.I32)
    entry.NewStore(constant.NewInt(types.I32, 0), counterAlloca)

    loopBlock := fn.NewBlock("loop")
    entry.NewBr(loopBlock)

    counter := loopBlock.NewLoad(types.I32, counterAlloca)
    charPtrIndexed := loopBlock.NewGetElementPtr(types.I8, charPtr, counter)
    ch := loopBlock.NewLoad(types.I8, charPtrIndexed)
    cmp := loopBlock.NewICmp(enum.IPredEQ, ch, constant.NewInt(types.I8, 0))

    incBlock := fn.NewBlock("inc")
    exitBlock := fn.NewBlock("exit")
    loopBlock.NewCondBr(cmp, exitBlock, incBlock)

    counterNext := incBlock.NewAdd(counter, constant.NewInt(types.I32, 1))
    incBlock.NewStore(counterNext, counterAlloca)
    incBlock.NewBr(loopBlock)

    retVal := exitBlock.NewLoad(types.I32, counterAlloca)
    exitBlock.NewRet(retVal)
}

func (cg *CodeGenerator) defineStringConcat() {
    s1 := ir.NewParam("str", cg.stringType)
    s2 := ir.NewParam("other", cg.stringType)
    fn := cg.module.NewFunc("String_concat", cg.stringType, s1, s2)
    entry := fn.NewBlock("entry")

    // Load the i8* from both string objects
    charPtrPtr1 := entry.NewGetElementPtr(
        cg.stringStruct, fn.Params[0],
        constant.NewInt(types.I32, 0),
        constant.NewInt(types.I32, 1),
    )
    charPtr1 := entry.NewLoad(types.NewPointer(types.I8), charPtrPtr1)

    charPtrPtr2 := entry.NewGetElementPtr(
        cg.stringStruct, fn.Params[1],
        constant.NewInt(types.I32, 0),
        constant.NewInt(types.I32, 1),
    )
    charPtr2 := entry.NewLoad(types.NewPointer(types.I8), charPtrPtr2)

    len1 := entry.NewCall(findFuncByName(cg.module, "String_length"), fn.Params[0])
    len2 := entry.NewCall(findFuncByName(cg.module, "String_length"), fn.Params[1])
    total := entry.NewAdd(len1, len2)
    totalPlus := entry.NewAdd(total, constant.NewInt(types.I32, 1))
    totalLL := entry.NewSExt(totalPlus, types.I64)

    mallocFn := findFuncByName(cg.module, "malloc")
    newCharPtr := entry.NewCall(mallocFn, totalLL)

    // Setup llvm.memcpy
    memcpyName := "llvm.memcpy.p0i8.p0i8.i64"
    memcpyFn := findFuncByName(cg.module, memcpyName)
    if memcpyFn == nil {
        memcpyFn = cg.module.NewFunc(
            memcpyName, types.Void,
            ir.NewParam("dest", types.NewPointer(types.I8)),
            ir.NewParam("src", types.NewPointer(types.I8)),
            ir.NewParam("size", types.I64),
            ir.NewParam("align", types.I32),
            ir.NewParam("isvolatile", types.I1),
        )
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

    // Store newCharPtr into the single field
    charFieldPtr := entry.NewGetElementPtr(
        cg.stringStruct, newStringObj,
        constant.NewInt(types.I32, 0),
        constant.NewInt(types.I32, 1),
    )
    entry.NewStore(newCharPtr, charFieldPtr)

    entry.NewRet(newStringObj)
}

func (cg *CodeGenerator) defineStringSubstr() {
    s := ir.NewParam("str", cg.stringType)
    start := ir.NewParam("start", types.I32)
    length := ir.NewParam("len", types.I32)
    fn := cg.module.NewFunc("String_substr", cg.stringType, s, start, length)
    entry := fn.NewBlock("entry")

    charPtrPtr := entry.NewGetElementPtr(
        cg.stringStruct, fn.Params[0],
        constant.NewInt(types.I32, 0),
        constant.NewInt(types.I32, 1),
    )
    charPtr := entry.NewLoad(types.NewPointer(types.I8), charPtrPtr)

    lenPlus := entry.NewAdd(fn.Params[2], constant.NewInt(types.I32, 1))
    lenPlusLL := entry.NewSExt(lenPlus, types.I64)
    mallocFn := findFuncByName(cg.module, "malloc")
    newCharPtr := entry.NewCall(mallocFn, lenPlusLL)

    idxAlloca := entry.NewAlloca(types.I32)
    entry.NewStore(constant.NewInt(types.I32, 0), idxAlloca)

    loopBlock := fn.NewBlock("loop")
    entry.NewBr(loopBlock)

    idx := loopBlock.NewLoad(types.I32, idxAlloca)
    cond := loopBlock.NewICmp(enum.IPredSLT, idx, fn.Params[2])
    bodyBlock := fn.NewBlock("body")
    finishBlock := fn.NewBlock("finish")
    loopBlock.NewCondBr(cond, bodyBlock, finishBlock)

    sum := bodyBlock.NewAdd(fn.Params[1], idx)
    srcPtr := bodyBlock.NewGetElementPtr(types.I8, charPtr, sum)
    ch := bodyBlock.NewLoad(types.I8, srcPtr)
    dstPtr := bodyBlock.NewGetElementPtr(types.I8, newCharPtr, idx)
    bodyBlock.NewStore(ch, dstPtr)
    idxNext := bodyBlock.NewAdd(idx, constant.NewInt(types.I32, 1))
    bodyBlock.NewStore(idxNext, idxAlloca)
    bodyBlock.NewBr(loopBlock)

    dstTerm := finishBlock.NewGetElementPtr(types.I8, newCharPtr, fn.Params[2])
    finishBlock.NewStore(constant.NewInt(types.I8, 0), dstTerm)

    sizeStringObj := constant.NewInt(types.I64, cg.typeSize(cg.stringStruct))
    newStringObjRaw := finishBlock.NewCall(mallocFn, sizeStringObj)
    newStringObj := finishBlock.NewBitCast(newStringObjRaw, cg.stringType)

    charFieldPtr := finishBlock.NewGetElementPtr(
        cg.stringStruct, newStringObj,
        constant.NewInt(types.I32, 0),
        constant.NewInt(types.I32, 1),
    )
    finishBlock.NewStore(newCharPtr, charFieldPtr)
    finishBlock.NewRet(newStringObj)
}

// --------------------------------------------------------------------------
// Create class struct type (with inheritance) in LLVM
// --------------------------------------------------------------------------
func (cg *CodeGenerator) createClassType(classNode *parser.Class, classMap map[string]*parser.Class) types.Type {
    // If it's built-in, we already have it
    if isBuiltIn(classNode.Name) {
        return cg.classTypes[classNode.Name]
    }

    // Start with [0] => i8* for vtable
    var fieldTypes []types.Type
    fieldTypes = append(fieldTypes, types.NewPointer(types.I8)) // vtable pointer
    index := 1

    // If inherits from another user class, get parent's fields
    if classNode.Inherits != "" && !isBuiltIn(classNode.Inherits) {
        parentNode := classMap[classNode.Inherits]
        if parentNode != nil {
            cg.createClassType(parentNode, classMap)
        }
        if parentStruct, ok := cg.classTypes[classNode.Inherits].(*types.StructType); ok {
            // Copy parent's fields (except vtable)
            if len(parentStruct.Fields) > 1 {
                for i := 1; i < len(parentStruct.Fields); i++ {
                    fieldTypes = append(fieldTypes, parentStruct.Fields[i])
                }
                index = len(fieldTypes)
            }
            // Copy parent's attribute indices
            for key, idxVal := range cg.attributeIndices {
                if strings.HasPrefix(key, classNode.Inherits+".") {
                    attrName := key[len(classNode.Inherits)+1:]
                    newKey := fmt.Sprintf("%s.%s", classNode.Name, attrName)
                    cg.attributeIndices[newKey] = idxVal
                    cg.attributeTypeEnv[newKey] = cg.attributeTypeEnv[key]
                }
            }
        }
    }

    // Add this class's own attributes
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
                    // fallback
                    attrType = cg.getClassPtrType("Object")
                }
            }
            key := fmt.Sprintf("%s.%s", classNode.Name, attr.Ident)
            if _, exists := cg.attributeIndices[key]; !exists {
                cg.attributeIndices[key] = index
                cg.attributeTypeEnv[key] = attr.Type
                fieldTypes = append(fieldTypes, attrType)
                index++
            } else {
                // If it existed (inherited?), override if needed
                fieldTypes[cg.attributeIndices[key]] = attrType
            }
        }
    }

    userStruct, ok := cg.classTypes[classNode.Name].(*types.StructType)
    if !ok {
        userStruct = types.NewStruct(fieldTypes...)
        userStruct.SetName(classNode.Name + "_struct")
        cg.module.NewTypeDef(userStruct.Name(), userStruct)
        cg.classTypes[classNode.Name] = userStruct
    } else {
        userStruct.Fields = fieldTypes
        userStruct.SetName(classNode.Name + "_struct")
    }
    return userStruct
}

func (cg *CodeGenerator) declareMethod(className string, method *parser.Method) {
    var retType types.Type
    switch method.Type {
    case "Int":
        retType = cg.getClassPtrType("Int")
    case "String":
        retType = cg.stringType
    case "Bool":
        retType = cg.getClassPtrType("Bool")
    case "SELF_TYPE":
        retType = cg.getClassPtrType(className)
    default:
        if _, exists := cg.classTypes[method.Type]; exists {
            retType = cg.getClassPtrType(method.Type)
        } else {
            retType = cg.getClassPtrType("Object")
        }
    }

    selfParam := ir.NewParam("self", cg.getClassPtrType("Object"))
    params := []*ir.Param{selfParam}
    for _, f := range method.Formals {
        var ptype types.Type
        switch f.Type {
        case "Int":
            ptype = cg.getClassPtrType("Int")
        case "String":
            ptype = cg.stringType
        case "Bool":
            ptype = cg.getClassPtrType("Bool")
        case "SELF_TYPE":
            ptype = cg.getClassPtrType(className)
        default:
            if _, ok := cg.classTypes[f.Type]; ok {
                ptype = cg.getClassPtrType(f.Type)
            } else {
                ptype = cg.getClassPtrType("Object")
            }
        }
        params = append(params, ir.NewParam(f.Ident, ptype))
    }

    fnName := fmt.Sprintf("%s_%s", className, method.Ident)
    cg.module.NewFunc(fnName, retType, params...)
}

func (cg *CodeGenerator) generateMethodBodies(classNode *parser.Class) {
    for _, feat := range classNode.Features {
        if method, ok := feat.(*parser.Method); ok {
            fnName := fmt.Sprintf("%s_%s", classNode.Name, method.Ident)
            fn := findFuncByName(cg.module, fnName)
            if fn == nil {
                fmt.Printf("Error: function %s not declared\n", fnName)
                continue
            }
            oldFunc := cg.currentFunc
            oldBlock := cg.currentBlock
            oldEnv := cg.variableEnv
            oldTypeEnv := cg.variableTypeEnv
            oldClass := cg.currentClass

            cg.currentFunc = fn
            cg.currentBlock = fn.NewBlock("entry")
            cg.variableEnv = make(map[string]*ir.InstAlloca)
            cg.variableTypeEnv = make(map[string]string)
            cg.currentClass = classNode.Name

            // Store parameters in alloca
            for i, param := range fn.Params {
                alloca := cg.currentBlock.NewAlloca(param.Type())
                cg.currentBlock.NewStore(param, alloca)
                cg.variableEnv[param.LocalName] = alloca

                // param #0 = self
                if i == 0 {
                    // re-cast self to the actual user-defined pointer
                    selfVal := cg.currentBlock.NewLoad(alloca.ElemType, alloca)
                    castedSelf := cg.currentBlock.NewBitCast(selfVal, cg.getClassPtrType(classNode.Name))
                    newAlloca := cg.currentBlock.NewAlloca(castedSelf.Type())
                    cg.currentBlock.NewStore(castedSelf, newAlloca)
                    cg.variableEnv["self"] = newAlloca
                    cg.variableTypeEnv["self"] = classNode.Name
                } else {
                    // Normal formal param
                    if i-1 < len(method.Formals) {
                        cg.variableTypeEnv[param.LocalName] = method.Formals[i-1].Type
                    }
                }
            }

            retVal := cg.genExpr(method.Body)

            // Ensure we return the correct type if we must box or cast
            if !retVal.Type().Equal(fn.Sig.RetType) {
                if fn.Sig.RetType.Equal(cg.getClassPtrType("Int")) &&
                    retVal.Type().Equal(types.I32) {
                    retVal = cg.boxInt(retVal)
                } else if fn.Sig.RetType.Equal(cg.getClassPtrType("Bool")) &&
                    retVal.Type().Equal(types.I1) {
                    retVal = cg.boxBool(retVal)
                } else {
                    retVal = cg.currentBlock.NewBitCast(retVal, fn.Sig.RetType)
                }
            }
            cg.currentBlock.NewRet(retVal)

            cg.currentFunc = oldFunc
            cg.currentBlock = oldBlock
            cg.variableEnv = oldEnv
            cg.variableTypeEnv = oldTypeEnv
            cg.currentClass = oldClass
        }
    }
}

// --------------------------------------------------------------------------
// Build a vtable (array of function pointers) for each class
// --------------------------------------------------------------------------
func (cg *CodeGenerator) buildDispatchTable(classNode *parser.Class, classMap map[string]*parser.Class) {
    if isBuiltIn(classNode.Name) {
        return
    }
    if _, ok := cg.dispatchTables[classNode.Name]; ok {
        return
    }

    var layout []DispatchEntry
    if classNode.Inherits != "" && !isBuiltIn(classNode.Inherits) {
        cg.buildDispatchTable(classMap[classNode.Inherits], classMap)
        parentLayout := cg.dispatchTableLayouts[classNode.Inherits]
        layout = append(layout, parentLayout...)
    }

    // Add/override this class's methods
    for _, feat := range classNode.Features {
        if m, ok := feat.(*parser.Method); ok {
            found := false
            for i, entry := range layout {
                if entry.Method == m.Ident {
                    // override
                    layout[i] = DispatchEntry{classNode.Name, m.Ident}
                    found = true
                    break
                }
            }
            if !found {
                layout = append(layout, DispatchEntry{classNode.Name, m.Ident})
            }
        }
    }
    cg.dispatchTableLayouts[classNode.Name] = layout

    for i, entry := range layout {
        key := fmt.Sprintf("%s.%s", classNode.Name, entry.Method)
        cg.methodIndices[key] = i
    }

    // Build the actual global array
    commonSelfType := cg.getClassPtrType("Object")
    commonMethodFnType := types.NewFunc(commonSelfType, commonSelfType)
    commonMethodPtrType := types.NewPointer(commonMethodFnType)
    arrType := types.NewArray(uint64(len(layout)), commonMethodPtrType)

    elems := make([]constant.Constant, len(layout))
    for i, entry := range layout {
        fnName := fmt.Sprintf("%s_%s", entry.Class, entry.Method)
        fn := findFuncByName(cg.module, fnName)
        if fn == nil {
            elems[i] = constant.NewNull(commonMethodPtrType)
        } else {
            ptr := constant.NewBitCast(fn, types.NewPointer(types.I8))
            casted := constant.NewBitCast(ptr, commonMethodPtrType)
            elems[i] = casted
        }
    }

    arrConst := constant.NewArray(arrType, elems...)
    vtableName := fmt.Sprintf("vtable_%s", classNode.Name)
    vtableGlobal := cg.module.NewGlobalDef(vtableName, arrConst)
    vtableGlobal.Immutable = true
    cg.dispatchTables[classNode.Name] = vtableGlobal
}

// --------------------------------------------------------------------------
// genExpr
// --------------------------------------------------------------------------
func (cg *CodeGenerator) genExpr(node parser.Node) value.Value {
    switch n := node.(type) {

    // Simple constants
    case *parser.IntConst:
        return cg.boxInt(constant.NewInt(types.I32, int64(n.Value)))

    case *parser.BoolConst:
        val := int64(0)
        if n.Value {
            val = 1
        }
        return cg.boxBool(constant.NewInt(types.I1, val))

    case *parser.StringConst:
        return cg.genStringConstantPtr(n.Value)

    case *parser.Self:
        if alloca, ok := cg.variableEnv["self"]; ok {
            return cg.currentBlock.NewLoad(alloca.ElemType, alloca)
        }
        return constant.NewNull(types.NewPointer(types.I8))

    // *** FIX *** If it’s a local variable, use local. If attribute, GEP from self.
    case *parser.Ident:
        if alloca, ok := cg.variableEnv[n.Name]; ok {
            return cg.currentBlock.NewLoad(alloca.ElemType, alloca)
        }
        if cg.currentClass != "" {
            key := fmt.Sprintf("%s.%s", cg.currentClass, n.Name)
            if idx, found := cg.attributeIndices[key]; found {
                selfAlloca, ok2 := cg.variableEnv["self"]
                if !ok2 {
                    return constant.NewNull(types.NewPointer(types.I8))
                }
                selfVal := cg.currentBlock.NewLoad(selfAlloca.ElemType, selfAlloca)
                casted := cg.currentBlock.NewBitCast(selfVal, cg.getClassPtrType(cg.currentClass))
                ptr := cg.currentBlock.NewGetElementPtr(
                    cg.classTypes[cg.currentClass],
                    casted,
                    constant.NewInt(types.I32, 0),
                    constant.NewInt(types.I32, int64(idx)),
                )
                return cg.currentBlock.NewLoad(ptr.ElemType, ptr)
            }
        }
        // fallback
        return constant.NewNull(types.NewPointer(types.I8))

    // *** FIX *** Check local vs. attribute. If not found, new local var
    case *parser.Assignment:
        val := cg.genExpr(n.Expr)
        lhsName := n.Ident.Name
        if alloca, ok := cg.variableEnv[lhsName]; ok {
            cg.currentBlock.NewStore(val, alloca)
            return val
        }
        if cg.currentClass != "" {
            key := fmt.Sprintf("%s.%s", cg.currentClass, lhsName)
            if idx, found := cg.attributeIndices[key]; found {
                selfAlloca := cg.variableEnv["self"]
                selfVal := cg.currentBlock.NewLoad(selfAlloca.ElemType, selfAlloca)
                fieldPtr := cg.currentBlock.NewGetElementPtr(
                    val.Type(),
                    selfVal,
                    constant.NewInt(types.I32, int64(idx)),
                )
                cg.currentBlock.NewStore(val, fieldPtr)
                return val
            }
        }

        alloca := cg.currentBlock.NewAlloca(val.Type())
        cg.variableEnv[lhsName] = alloca
        cg.currentBlock.NewStore(val, alloca)
        return val

    case *parser.Block:
        var last value.Value = constant.NewNull(types.NewPointer(types.I8))
        for _, expr := range n.Exprs {
            last = cg.genExpr(expr)
        }
        return last

    case *parser.If:
        condVal := cg.genExpr(n.Condition)
        if condVal.Type().Equal(cg.getClassPtrType("Bool")) {
            condVal = cg.unboxBool(condVal)
        }
        zero := constant.NewInt(types.I1, 0)
        isTrue := cg.currentBlock.NewICmp(enum.IPredNE, condVal, zero)

        thenBlock := cg.currentFunc.NewBlock(cg.newUniqueName("if_then"))
        elseBlock := cg.currentFunc.NewBlock(cg.newUniqueName("if_else"))
        endBlock := cg.currentFunc.NewBlock(cg.newUniqueName("if_end"))
        cg.currentBlock.NewCondBr(isTrue, thenBlock, elseBlock)

        cg.currentBlock = thenBlock
        thenVal := cg.genExpr(n.True)
        cg.currentBlock.NewBr(endBlock)

        cg.currentBlock = elseBlock
        elseVal := cg.genExpr(n.False)
        cg.currentBlock.NewBr(endBlock)

        cg.currentBlock = endBlock
        phi := endBlock.NewPhi(
            ir.NewIncoming(thenVal, thenBlock),
            ir.NewIncoming(elseVal, elseBlock),
        )
        return phi

    case *parser.While:
        condBlock := cg.currentFunc.NewBlock(cg.newUniqueName("while_cond"))
        bodyBlock := cg.currentFunc.NewBlock(cg.newUniqueName("while_body"))
        endBlock := cg.currentFunc.NewBlock(cg.newUniqueName("while_end"))

        cg.currentBlock.NewBr(condBlock)
        cg.currentBlock = condBlock
        condVal := cg.genExpr(n.Condition)
        if condVal.Type().Equal(cg.getClassPtrType("Bool")) {
            condVal = cg.unboxBool(condVal)
        }
        zero := constant.NewInt(types.I1, 0)
        isTrue := condBlock.NewICmp(enum.IPredNE, condVal, zero)
        condBlock.NewCondBr(isTrue, bodyBlock, endBlock)

        cg.currentBlock = bodyBlock
        cg.genExpr(n.Body)
        cg.currentBlock.NewBr(condBlock)

        cg.currentBlock = endBlock
        return constant.NewNull(types.NewPointer(types.I8))

    case *parser.BinaryOperation:
        left := cg.genExpr(n.Left)
        right := cg.genExpr(n.Right)
        switch n.Operator {
        case "+":
            sum := cg.currentBlock.NewAdd(cg.unboxInt(left), cg.unboxInt(right))
            return cg.boxInt(sum)
        case "-":
            diff := cg.currentBlock.NewSub(cg.unboxInt(left), cg.unboxInt(right))
            return cg.boxInt(diff)
        case "*":
            prod := cg.currentBlock.NewMul(cg.unboxInt(left), cg.unboxInt(right))
            return cg.boxInt(prod)
        case "/":
            quot := cg.currentBlock.NewSDiv(cg.unboxInt(left), cg.unboxInt(right))
            return cg.boxInt(quot)
        case "<":
            cmp := cg.currentBlock.NewICmp(enum.IPredSLT, cg.unboxInt(left), cg.unboxInt(right))
            return cg.boxBool(cmp)
        case "<=":
            cmp := cg.currentBlock.NewICmp(enum.IPredSLE, cg.unboxInt(left), cg.unboxInt(right))
            return cg.boxBool(cmp)
        case "=":
            // If both sides are Int, compare unboxed
            if left.Type().Equal(cg.getClassPtrType("Int")) &&
                right.Type().Equal(cg.getClassPtrType("Int")) {
                eq := cg.currentBlock.NewICmp(enum.IPredEQ, cg.unboxInt(left), cg.unboxInt(right))
                return cg.boxBool(eq)
            }
            // If both sides are Bool, compare unboxed
            if left.Type().Equal(cg.getClassPtrType("Bool")) &&
                right.Type().Equal(cg.getClassPtrType("Bool")) {
                eq := cg.currentBlock.NewICmp(enum.IPredEQ, cg.unboxBool(left), cg.unboxBool(right))
                return cg.boxBool(eq)
            }
            // If both sides are strings, compare i8* data
            if left.Type().Equal(cg.stringType) && right.Type().Equal(cg.stringType) {
                lPtrPtr := cg.currentBlock.NewGetElementPtr(
                    cg.stringStruct, left,
                    constant.NewInt(types.I32, 0),
                    constant.NewInt(types.I32, 1),
                )
                lPtr := cg.currentBlock.NewLoad(types.NewPointer(types.I8), lPtrPtr)

                rPtrPtr := cg.currentBlock.NewGetElementPtr(
                    cg.stringStruct, right,
                    constant.NewInt(types.I32, 0),
                    constant.NewInt(types.I32, 1),
                )
                rPtr := cg.currentBlock.NewLoad(types.NewPointer(types.I8), rPtrPtr)

                eq := cg.currentBlock.NewICmp(enum.IPredEQ, lPtr, rPtr)
                return cg.boxBool(eq)
            }
            // else do pointer compare
            eq := cg.currentBlock.NewICmp(enum.IPredEQ, left, right)
            return cg.boxBool(eq)
        default:
            return constant.NewNull(types.NewPointer(types.I8))
        }

    case *parser.UnaryOperation:
        right := cg.genExpr(n.Right)
        switch n.Operator {
        case "~":
            neg := cg.currentBlock.NewSub(constant.NewInt(types.I32, 0), cg.unboxInt(right))
            return cg.boxInt(neg)
        case "not":
            bVal := cg.unboxBool(right)
            x := cg.currentBlock.NewXor(bVal, constant.NewInt(types.I1, 1))
            return cg.boxBool(x)
        case "isvoid":
            if pt, ok := right.Type().(*types.PointerType); ok {
                cmp := cg.currentBlock.NewICmp(enum.IPredEQ, right, constant.NewNull(pt))
                return cg.boxBool(cmp)
            }
            return cg.boxBool(constant.NewInt(types.I1, 0))
        default:
            return constant.NewNull(types.NewPointer(types.I8))
        }

    case *parser.New:
        className := n.Type
        if _, ok := cg.classTypes[className]; !ok {
            return constant.NewNull(types.NewPointer(types.I8))
        }
        mallocFn := findFuncByName(cg.module, "malloc")
        st := cg.classTypes[className]
        sizeConst := constant.NewInt(types.I64, cg.typeSize(st))
        rawPtr := cg.currentBlock.NewCall(mallocFn, sizeConst)
        objPtr := cg.currentBlock.NewBitCast(rawPtr, cg.getClassPtrType(className))

        vtGlobal, ok := cg.dispatchTables[className]
        if ok {
            // Convert the vtable global to i8*
            var vtableAsI8Ptr constant.Constant
            arrType, isArr := vtGlobal.Init.Type().(*types.ArrayType)
            if isArr {
                vtPtr := constant.NewBitCast(vtGlobal, types.NewPointer(arrType))
                vtableAsI8Ptr = constant.NewBitCast(vtPtr, types.NewPointer(types.I8))
            } else {
                vtableAsI8Ptr = constant.NewBitCast(vtGlobal, types.NewPointer(types.I8))
            }
            field0 := cg.currentBlock.NewGetElementPtr(
                st, objPtr,
                constant.NewInt(types.I32, 0),
                constant.NewInt(types.I32, 0),
            )
            cg.currentBlock.NewStore(vtableAsI8Ptr, field0)
        }
        return objPtr

    case *parser.Let:
        // Shadow variableEnv
        oldEnv := cg.variableEnv
        newEnv := make(map[string]*ir.InstAlloca)
        for k, v := range oldEnv {
            newEnv[k] = v
        }
        cg.variableEnv = newEnv

        // Shadow variableTypeEnv
        oldTypeEnv := cg.variableTypeEnv
        newTypeEnv := make(map[string]string)
        for k, v := range oldTypeEnv {
            newTypeEnv[k] = v
        }
        cg.variableTypeEnv = newTypeEnv

        // Create each let-bound variable
        for _, binding := range n.Assignments {
            var t types.Type
            switch binding.Type {
            case "Int":
                t = cg.getClassPtrType("Int")
            case "String":
                t = cg.stringType
            case "Bool":
                t = cg.getClassPtrType("Bool")
            default:
                if _, ok := cg.classTypes[binding.Type]; ok {
                    t = cg.getClassPtrType(binding.Type)
                } else {
                    t = cg.getClassPtrType("Object")
                }
            }
            alloca := cg.currentBlock.NewAlloca(t)
            cg.variableEnv[binding.Ident] = alloca
            cg.variableTypeEnv[binding.Ident] = binding.Type

            var initVal value.Value
            if binding.Init != nil {
                initVal = cg.genExpr(binding.Init)
            } else {
                if binding.Type == "String" {
                    initVal = cg.genStringConstantPtr("")
                } else {
                    initVal = constant.NewNull(types.NewPointer(t))
                }
            }
            if !initVal.Type().Equal(t) {
                initVal = cg.currentBlock.NewBitCast(initVal, t)
            }
            cg.currentBlock.NewStore(initVal, alloca)
        }
        // Body
        result := cg.genExpr(n.Body)

        // Restore
        cg.variableEnv = oldEnv
        cg.variableTypeEnv = oldTypeEnv
        return result

    case *parser.Case:
        // Minimal placeholder (not fully implemented).
        _ = cg.genExpr(n.Expr)
        if len(n.TypeActions) == 0 {
            return constant.NewNull(types.NewPointer(types.I8))
        }
        first := n.TypeActions[0]
        oldEnv := cg.variableEnv
        newEnv := make(map[string]*ir.InstAlloca)
        for k, v := range oldEnv {
            newEnv[k] = v
        }
        cg.variableEnv = newEnv
        dummy := cg.currentBlock.NewAlloca(types.I32)
        cg.variableEnv[first.Ident] = dummy
        res := cg.genExpr(first.Expr)
        cg.variableEnv = oldEnv
        return res

    case *parser.MethodCall:
        receiverVal := cg.genExpr(n.Object)

        var staticType string
        if objIdent, ok := n.Object.(*parser.Ident); ok {
            if t, found := cg.variableTypeEnv[objIdent.Name]; found {
                staticType = t
            } else {
                // Check if it's an attribute
                key := fmt.Sprintf("%s.%s", cg.currentClass, objIdent.Name)
                if attrType, foundAttr := cg.attributeTypeEnv[key]; foundAttr {
                    staticType = attrType
                } else {
                    staticType = "Object"
                }
            }
        } else if newExpr, ok := n.Object.(*parser.New); ok {
            staticType = newExpr.Type
        } else {
            // fallback
            staticType = "Object"
        }

        // Build the argument list: first param is the receiver as i8*, then method's formals
        args := []value.Value{}
        castedReceiver := cg.currentBlock.NewBitCast(receiverVal, cg.getClassPtrType("Object"))
        args = append(args, castedReceiver)

        for _, paramExpr := range n.Method.Params {
            argVal := cg.genExpr(paramExpr)
            args = append(args, argVal)
        }

        if isBuiltIn(staticType) {
            if staticType == "String" {
                switch n.Method.Ident {
                case "length":
                    lengthFn := findFuncByName(cg.module, "String_length")
                    if lengthFn == nil {
                        return constant.NewNull(types.NewPointer(types.I8))
                    }
                    i32val := cg.currentBlock.NewCall(lengthFn, receiverVal)
                    return cg.boxInt(i32val)
                case "concat":
                    concatFn := findFuncByName(cg.module, "String_concat")
                    if concatFn == nil {
                        return constant.NewNull(types.NewPointer(types.I8))
                    }
                    // The second param is args[1]
                    return cg.currentBlock.NewCall(concatFn, receiverVal, args[1])
                case "substr":
                    substrFn := findFuncByName(cg.module, "String_substr")
                    if substrFn == nil {
                        return constant.NewNull(types.NewPointer(types.I8))
                    }
                    // The second and third params are args[1], args[2]
                    return cg.currentBlock.NewCall(substrFn, receiverVal, args[1], args[2])
                }
            }
            fnName := fmt.Sprintf("%s_%s", staticType, n.Method.Ident)
            builtinFn := findFuncByName(cg.module, fnName)
            if builtinFn == nil {
                // Possibly handle known string methods

                // no known built-in
                return constant.NewNull(types.NewPointer(types.I8))
            }
            // Otherwise, call the built-in function
            return cg.currentBlock.NewCall(builtinFn, args...)
        }

        // Normal dynamic dispatch for user classes
        key := fmt.Sprintf("%s.%s", staticType, n.Method.Ident)
        idx, found := cg.methodIndices[key]
        if !found {
            return constant.NewNull(types.NewPointer(types.I8))
        }

        // load vtable from field 0
        realReceiver := cg.currentBlock.NewBitCast(receiverVal, cg.getClassPtrType(staticType))
        vtPtr := cg.currentBlock.NewGetElementPtr(
            cg.classTypes[staticType],
            realReceiver,
            constant.NewInt(types.I32, 0),
            constant.NewInt(types.I32, 0),
        )
        vtField := cg.currentBlock.NewLoad(types.NewPointer(types.I8), vtPtr)

        // bitcast i8* => [N x fn ptr]* so we can do a GEP
        layout := cg.dispatchTableLayouts[staticType]
        commonSelfType := cg.getClassPtrType("Object")
        commonMethodFnType := types.NewFunc(commonSelfType, commonSelfType)
        commonMethodPtrType := types.NewPointer(commonMethodFnType)
        arrType := types.NewArray(uint64(len(layout)), commonMethodPtrType)

        vtablePtr := cg.currentBlock.NewBitCast(vtField, types.NewPointer(arrType))
        methodPtrPtr := cg.currentBlock.NewGetElementPtr(
            arrType,
            vtablePtr,
            constant.NewInt(types.I32, 0),
            constant.NewInt(types.I32, int64(idx)),
        )
        methodPtr := cg.currentBlock.NewLoad(commonMethodPtrType, methodPtrPtr)

        // bitcast to the actual function type
        fnName := fmt.Sprintf("%s_%s", staticType, n.Method.Ident)
        realFn := findFuncByName(cg.module, fnName)
        if realFn == nil {
            return constant.NewNull(types.NewPointer(types.I8))
        }
        castedFn := cg.currentBlock.NewBitCast(methodPtr, realFn.Type())
        return cg.currentBlock.NewCall(castedFn, args...)

    case *parser.FunctionCall:
        // Typically for "out_string", "in_int", etc., or same-class calls
        switch n.Ident {
        case "out_string":
            if len(n.Params) < 1 {
                return constant.NewNull(types.NewPointer(types.I8))
            }
            return cg.genCallPrintString(cg.genExpr(n.Params[0]))

        case "out_int":
            if len(n.Params) < 1 {
                return constant.NewNull(types.NewPointer(types.I8))
            }
            return cg.genCallPrintInt(cg.genExpr(n.Params[0]))

        case "in_string":
            return cg.genCallInString()

        case "in_int":
            return cg.genCallInInt()
        }

        // Otherwise, we treat it as "self.<method>"
        var args []value.Value
        if cg.currentClass != "" {
            if selfAlloca, ok := cg.variableEnv["self"]; ok {
                selfVal := cg.currentBlock.NewLoad(selfAlloca.ElemType, selfAlloca)
                args = append(args, selfVal)
            } else {
                args = append(args, constant.NewNull(types.NewPointer(types.I8)))
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
            return constant.NewNull(types.NewPointer(types.I8))
        }
        return cg.currentBlock.NewCall(callee, args...)
    }

    // default fallback
    return constant.NewNull(types.NewPointer(types.I8))
}

// genStringConstantPtr inserts a string literal in the global area and returns a pointer to it.
func (cg *CodeGenerator) genStringConstantPtr(strVal string) value.Value {
    // Replace literal "\n" with real newlines, etc.
    strVal = strings.ReplaceAll(strVal, "\\n", "\n")
    if !strings.HasSuffix(strVal, "\x00") {
        strVal += "\x00"
    }
    arr := constant.NewCharArrayFromString(strVal)

    arrayName := fmt.Sprintf("str_%d", cg.stringCounter*2)
    g := cg.module.NewGlobalDef(arrayName, arr)
    gep := constant.NewGetElementPtr(g.Init.Type(), g)
    gep.InBounds = true
    strStruct := types.NewStruct(types.NewPointer(types.I8))
    init := constant.NewStruct(strStruct, gep)
    objName := fmt.Sprintf("str_obj_%d", cg.stringCounter*2+1)
    globStrObj := cg.module.NewGlobalDef(objName, init)
    globStrObj.Immutable = true
    ptr := constant.NewBitCast(globStrObj, cg.stringType)
    cg.stringCounter++

    return ptr
}

func (cg *CodeGenerator) genCallPrintString(strObj value.Value) value.Value {
    zero := constant.NewInt(types.I32, 0)
    charPtrPtr := cg.currentBlock.NewGetElementPtr(
        cg.stringStruct, strObj, zero, constant.NewInt(types.I32, 1),
    )
    charPtr := cg.currentBlock.NewLoad(types.NewPointer(types.I8), charPtrPtr)

    fmtPtr := cg.currentBlock.NewGetElementPtr(
        cg.fmtString.Type().(*types.PointerType).ElemType,
        cg.fmtString, zero, zero,
    )
    cg.currentBlock.NewCall(cg.printfFunc, fmtPtr, charPtr)

    // Return self if we're inside a method, else null
    if selfAlloca, ok := cg.variableEnv["self"]; ok {
        return cg.currentBlock.NewLoad(selfAlloca.ElemType, selfAlloca)
    }
    return constant.NewNull(types.NewPointer(types.I8))
}

func (cg *CodeGenerator) genCallPrintInt(intObj value.Value) value.Value {
    i32val := cg.unboxInt(intObj)
    zero := constant.NewInt(types.I32, 0)
    fmtPtr := cg.currentBlock.NewGetElementPtr(
        cg.fmtInt.Type().(*types.PointerType).ElemType,
        cg.fmtInt, zero, zero,
    )
    cg.currentBlock.NewCall(cg.printfFunc, fmtPtr, i32val)

    if selfAlloca, ok := cg.variableEnv["self"]; ok {
        return cg.currentBlock.NewLoad(selfAlloca.ElemType, selfAlloca)
    }
    return constant.NewNull(types.NewPointer(types.I8))
}

func (cg *CodeGenerator) genCallInString() value.Value {
    // stack-allocate a local [1024 x i8]
    bufAlloca := cg.currentBlock.NewAlloca(types.NewArray(1024, types.I8))
    zero := constant.NewInt(types.I32, 0)
    ptr := cg.currentBlock.NewGetElementPtr(bufAlloca.ElemType, bufAlloca, zero, zero)

    fmtPtr := cg.currentBlock.NewGetElementPtr(
        cg.fmtStringIn.Type().(*types.PointerType).ElemType,
        cg.fmtStringIn, zero, zero,
    )
    cg.currentBlock.NewCall(cg.scanfFunc, fmtPtr, ptr)

    mallocFn := findFuncByName(cg.module, "malloc")
    sizeStringObj := constant.NewInt(types.I64, cg.typeSize(cg.stringStruct))
    newStringObjRaw := cg.currentBlock.NewCall(mallocFn, sizeStringObj)
    newStringObj := cg.currentBlock.NewBitCast(newStringObjRaw, cg.stringType)

    charFieldPtr := cg.currentBlock.NewGetElementPtr(
        cg.stringStruct, newStringObj,
        zero, constant.NewInt(types.I32, 1),
    )
    cg.currentBlock.NewStore(ptr, charFieldPtr)
    return newStringObj
}

func (cg *CodeGenerator) genCallInInt() value.Value {
    allocaI32 := cg.currentBlock.NewAlloca(types.I32)
    zero := constant.NewInt(types.I32, 0)
    fmtPtr := cg.currentBlock.NewGetElementPtr(
        cg.fmtIntIn.Type().(*types.PointerType).ElemType,
        cg.fmtIntIn, zero, zero,
    )
    cg.currentBlock.NewCall(cg.scanfFunc, fmtPtr, allocaI32)
    loadedVal := cg.currentBlock.NewLoad(types.I32, allocaI32)
    return cg.boxInt(loadedVal)
}

func (cg *CodeGenerator) newUniqueName(prefix string) string {
    name := fmt.Sprintf("%s_%d", prefix, cg.counter)
    cg.counter++
    return name
}
