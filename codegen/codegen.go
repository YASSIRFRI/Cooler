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

type paramAttr string

func (a paramAttr) String() string    { return string(a) }
func (a paramAttr) IsParamAttribute() {}

const Nocapture paramAttr = "nocapture"

type CodeGenerator struct {
	module           *ir.Module
	currentFunc      *ir.Func
	currentBlock     *ir.Block
	variableEnv      map[string]*ir.InstAlloca // variable name -> alloca

	printfFunc *ir.Func
	scanfFunc  *ir.Func

	// Format strings for output and input.
	// (Note: Removed the extra newline characters for out_string and out_int.)
	fmtString   *ir.Global // e.g. "%s"
	fmtInt      *ir.Global // e.g. "%d"
	fmtStringIn *ir.Global // e.g. "%1023s\x00"
	fmtIntIn    *ir.Global // e.g. "%d\x00"

	// Cache for string constants is no longer used for merging.
	// We now always generate a new global so that each string gets a unique name.
	stringConsts     map[string]*ir.Global
	stringCounter    int

	currentClass     string
	attributeGlobals map[string]*ir.Global

	counter int
}

func (cg *CodeGenerator) uniqueGlobalName(prefix string) string {
	return fmt.Sprintf("%s_%d", prefix, len(cg.module.Globals))
}

// --------------------------------------------------------------------------
// Entry Point: CodegenProgram
// --------------------------------------------------------------------------

func CodegenProgram(prog *parser.Program) *ir.Module {
	cg := &CodeGenerator{
		module:           ir.NewModule(),
		variableEnv:      make(map[string]*ir.InstAlloca),
		stringConsts:     make(map[string]*ir.Global),
		attributeGlobals: make(map[string]*ir.Global),
	}

	// Declare external I/O functions.
	cg.declareExternalIO()
	// Declare external malloc (used by our string functions).
	cg.declareMalloc()
	// Define our built-in string methods.
	cg.defineStringLength()
	cg.defineStringConcat()
	cg.defineStringSubstr()

	mainFn := cg.module.NewFunc("main", types.I32)
	cg.currentFunc = mainFn
	cg.currentBlock = mainFn.NewBlock("entry")

	// Generate IR for each COOL class.
	for _, classNode := range prog.Classes {
		cg.genClass(classNode)
	}

	// Attempt to find "Main_main" or "<ClassName>_main" as the entry method.
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

	// If found, call it and return its value. Otherwise just return 0.
	if entryFn != nil {
		retVal := cg.currentBlock.NewCall(entryFn)
		cg.currentBlock.NewRet(retVal)
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
	// 1) printf
	// i32 @printf(i8* nocapture, ...)
	printfParam := ir.NewParam("fmt", types.NewPointer(types.I8))
	printfParam.Attrs = append(printfParam.Attrs, Nocapture)
	cg.printfFunc = cg.module.NewFunc("printf", types.I32, printfParam)
	cg.printfFunc.Sig.Variadic = true

	// 2) scanf
	// i32 @scanf(i8* nocapture, ...)
	scanfParam := ir.NewParam("fmt", types.NewPointer(types.I8))
	scanfParam.Attrs = append(scanfParam.Attrs, Nocapture)
	cg.scanfFunc = cg.module.NewFunc("scanf", types.I32, scanfParam)
	cg.scanfFunc.Sig.Variadic = true

	// Create global format strings for printing:
	//   "%s" and "%d"
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

	// Create global format strings for reading:
	//   "%1023s\x00" and "%d\x00"
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
// Built-in String Methods Definitions
// --------------------------------------------------------------------------

// defineStringLength implements:
//    i32 @String_length(i8* %str)
func (cg *CodeGenerator) defineStringLength() {
	// Function signature.
	param := ir.NewParam("str", types.NewPointer(types.I8))
	fn := cg.module.NewFunc("String_length", types.I32, param)
	entry := fn.NewBlock("entry")
	// Allocate counter.
	counterAlloca := entry.NewAlloca(types.I32)
	entry.NewStore(constant.NewInt(types.I32, 0), counterAlloca)
	// Branch to loop.
	loop := fn.NewBlock("loop")
	entry.NewBr(loop)
	// Loop block.
	counter := loop.NewLoad(types.I32, counterAlloca)
	// Get pointer to current character.
	charPtr := loop.NewGetElementPtr(types.I8, fn.Params[0], counter)
	ch := loop.NewLoad(types.I8, charPtr)
	// Compare with null terminator.
	cmp := loop.NewICmp(enum.IPredEQ, ch, constant.NewInt(types.I8, 0))
	incBlock := fn.NewBlock("inc")
	exit := fn.NewBlock("exit")
	loop.NewCondBr(cmp, exit, incBlock)
	// Increment block.
	counterNext := incBlock.NewAdd(counter, constant.NewInt(types.I32, 1))
	incBlock.NewStore(counterNext, counterAlloca)
	incBlock.NewBr(loop)
	// Exit: return counter.
	retVal := exit.NewLoad(types.I32, counterAlloca)
	exit.NewRet(retVal)
}

// defineStringConcat implements:
//    i8* @String_concat(i8* %str, i8* %other)
func (cg *CodeGenerator) defineStringConcat() {
	// Function signature.
	param1 := ir.NewParam("str", types.NewPointer(types.I8))
	param2 := ir.NewParam("other", types.NewPointer(types.I8))
	fn := cg.module.NewFunc("String_concat", types.NewPointer(types.I8), param1, param2)
	entry := fn.NewBlock("entry")
	// Call String_length on both parameters.
	len1 := entry.NewCall(findFuncByName(cg.module, "String_length"), fn.Params[0])
	len2 := entry.NewCall(findFuncByName(cg.module, "String_length"), fn.Params[1])
	total := entry.NewAdd(len1, len2)
	totalPlus := entry.NewAdd(total, constant.NewInt(types.I32, 1))
	totalLL := entry.NewSExt(totalPlus, types.I64)
	// Call malloc to allocate new string.
	mallocFn := findFuncByName(cg.module, "malloc")
	newStr := entry.NewCall(mallocFn, totalLL)
	// Use llvm.memcpy to copy the two strings.
	// Declare (if not already declared) the memcpy intrinsic.
	memcpyName := "llvm.memcpy.p0i8.p0i8.i64"
	memcpyFn := findFuncByName(cg.module, memcpyName)
	if memcpyFn == nil {
		// Signature: void (i8*, i8*, i64, i32, i1)
		memcpyFn = cg.module.NewFunc(memcpyName, types.Void,
			ir.NewParam("dest", types.NewPointer(types.I8)),
			ir.NewParam("src", types.NewPointer(types.I8)),
			ir.NewParam("size", types.I64),
			ir.NewParam("align", types.I32),
			ir.NewParam("isvolatile", types.I1))
		memcpyFn.Sig.Variadic = false
	}
	// Copy first string.
	size1 := entry.NewSExt(len1, types.I64)
	entry.NewCall(memcpyFn, newStr, fn.Params[0], size1, constant.NewInt(types.I32, 1), constant.NewInt(types.I1, 0))
	// Copy second string.
	dest2 := entry.NewGetElementPtr(types.I8, newStr, len1)
	size2 := entry.NewSExt(len2, types.I64)
	entry.NewCall(memcpyFn, dest2, fn.Params[1], size2, constant.NewInt(types.I32, 1), constant.NewInt(types.I1, 0))
	// Write null terminator at the end.
	nullPtr := entry.NewGetElementPtr(types.I8, newStr, total)
	entry.NewStore(constant.NewInt(types.I8, 0), nullPtr)
	entry.NewRet(newStr)
}

// defineStringSubstr implements:
//    i8* @String_substr(i8* %str, i32 %start, i32 %len)
func (cg *CodeGenerator) defineStringSubstr() {
	// Function signature.
	param1 := ir.NewParam("str", types.NewPointer(types.I8))
	param2 := ir.NewParam("start", types.I32)
	param3 := ir.NewParam("len", types.I32)
	fn := cg.module.NewFunc("String_substr", types.NewPointer(types.I8), param1, param2, param3)
	entry := fn.NewBlock("entry")
	// For simplicity, we ignore bounds checking.
	// Allocate new string: (len + 1) bytes.
	lenPlus := entry.NewAdd(fn.Params[2], constant.NewInt(types.I32, 1))
	lenPlusLL := entry.NewSExt(lenPlus, types.I64)
	mallocFn := findFuncByName(cg.module, "malloc")
	newStr := entry.NewCall(mallocFn, lenPlusLL)
	// Allocate a local index variable.
	idxAlloca := entry.NewAlloca(types.I32)
	entry.NewStore(constant.NewInt(types.I32, 0), idxAlloca)
	// Branch to loop.
	loop := fn.NewBlock("loop")
	entry.NewBr(loop)
	// In loop: if idx < len then copy character; else branch to finish.
	idx := loop.NewLoad(types.I32, idxAlloca)
	cond := loop.NewICmp(enum.IPredSLT, idx, fn.Params[2])
	body := fn.NewBlock("body")
	finish := fn.NewBlock("finish")
	loop.NewCondBr(cond, body, finish)
	// In body: compute source pointer = str + (start + idx)
	sum := body.NewAdd(fn.Params[1], idx)
	srcPtr := body.NewGetElementPtr(types.I8, fn.Params[0], sum)
	ch := body.NewLoad(types.I8, srcPtr)
	// Destination pointer = newStr + idx
	dstPtr := body.NewGetElementPtr(types.I8, newStr, idx)
	body.NewStore(ch, dstPtr)
	// Increment idx.
	idxNext := body.NewAdd(idx, constant.NewInt(types.I32, 1))
	body.NewStore(idxNext, idxAlloca)
	body.NewBr(loop)
	// In finish: store null terminator at newStr + len.
	dstTerm := finish.NewGetElementPtr(types.I8, newStr, fn.Params[2])
	finish.NewStore(constant.NewInt(types.I8, 0), dstTerm)
	finish.NewRet(newStr)
}

// --------------------------------------------------------------------------
// Class, Method, and Expression Generation
// --------------------------------------------------------------------------

func (cg *CodeGenerator) genClass(classNode *parser.Class) {
	var methods []*parser.Method
	// First pass: declare methods and process attributes.
	for _, feat := range classNode.Features {
		switch f := feat.(type) {
		case *parser.Method:
			methods = append(methods, f)
			cg.declareMethod(classNode.Name, f)
		case *parser.Attribute:
			cg.genAttribute(classNode.Name, f)
		default:
			fmt.Printf("Unknown feature type %T in class %s\n", f, classNode.Name)
		}
	}
	// Second pass: generate method bodies.
	for _, m := range methods {
		fnName := fmt.Sprintf("%s_%s", classNode.Name, m.Ident)
		fn := findFuncByName(cg.module, fnName)
		if fn == nil {
			fmt.Printf("Error: function %s not declared\n", fnName)
		} else {
			cg.generateMethodBody(classNode.Name, m, fn)
		}
	}
}

// declareMethod creates the function signature (without a body) for a method.
func (cg *CodeGenerator) declareMethod(className string, method *parser.Method) {
	// Determine the return type based on the method declaration.
	var retType types.Type
	switch method.Type {
	case "Int":
		retType = types.I32
	case "String":
		retType = types.NewPointer(types.I8)
	case "Bool":
		retType = types.I32
	default:
		retType = types.I32
	}

	// Note: In a full OO implementation an implicit "self" parameter would be added.
	var params []*ir.Param
	for _, fm := range method.Formals {
		var paramType types.Type
		switch fm.Type {
		case "Int":
			paramType = types.I32
		case "String":
			paramType = types.NewPointer(types.I8)
		default:
			paramType = types.I32
		}
		params = append(params, ir.NewParam(fm.Ident, paramType))
	}
	fnName := fmt.Sprintf("%s_%s", className, method.Ident)
	cg.module.NewFunc(fnName, retType, params...)
}

// generateMethodBody fills in the body of a previously declared function.
func (cg *CodeGenerator) generateMethodBody(className string, method *parser.Method, fn *ir.Func) {
	oldFunc := cg.currentFunc
	oldBlock := cg.currentBlock
	oldEnv := cg.variableEnv
	oldClass := cg.currentClass

	cg.currentFunc = fn
	cg.currentBlock = fn.NewBlock("entry")
	cg.variableEnv = make(map[string]*ir.InstAlloca)
	cg.currentClass = className // Set current class for attribute resolution

	// Allocate parameters and store them in the environment.
	for _, p := range fn.Params {
		alloca := cg.currentBlock.NewAlloca(p.Type())
		cg.currentBlock.NewStore(p, alloca)
		cg.variableEnv[p.LocalName] = alloca
	}

	retVal := cg.genExpr(method.Body)
	fmt.Println("From Codegen retVal: ", retVal)
	cg.currentBlock.NewRet(retVal)

	cg.currentFunc = oldFunc
	cg.currentBlock = oldBlock
	cg.variableEnv = oldEnv
	cg.currentClass = oldClass
}

func (cg *CodeGenerator) genAttribute(className string, attr *parser.Attribute) {
	var initVal value.Value
	switch attr.Type {
	case "Int":
		initVal = constant.NewInt(types.I32, 0)
		if attr.Init != nil {
			if intConst, ok := attr.Init.(*parser.IntConst); ok {
				initVal = constant.NewInt(types.I32, int64(intConst.Value))
			} else {
				fmt.Printf("Non-integer initializer for attribute %s.%s, defaulting to 0\n", className, attr.Ident)
			}
		}
	case "String":
		var strVal string
		if attr.Init != nil {
			if strConst, ok := attr.Init.(*parser.StringConst); ok {
				strVal = strConst.Value
			} else {
				fmt.Printf("Non-string initializer for attribute %s.%s, defaulting to empty string\n", className, attr.Ident)
				strVal = ""
			}
		} else {
			strVal = ""
		}
		gStr := cg.getOrCreateGlobalString(strVal)
		zero := constant.NewInt(types.I32, 0)
		initVal = constant.NewGetElementPtr(gStr.ContentType, gStr, zero, zero)
	default:
		initVal = constant.NewInt(types.I32, 0)
	}
	globalName := fmt.Sprintf("%s_%s", className, attr.Ident)
	var global *ir.Global
	switch attr.Type {
	case "Int":
		global = cg.module.NewGlobalDef(globalName, initVal.(*constant.Int))
	case "String":
		global = cg.module.NewGlobalDef(globalName, initVal.(*constant.ExprGetElementPtr))
	default:
		global = cg.module.NewGlobalDef(globalName, constant.NewInt(types.I32, 0))
	}
	cg.attributeGlobals[globalName] = global
}

// Dispatch expression types.
func (cg *CodeGenerator) genExpr(node parser.Node) value.Value {
	switch n := node.(type) {
	case *parser.IntConst:
		return constant.NewInt(types.I32, int64(n.Value))
	case *parser.BoolConst:
		if n.Value {
			return constant.NewInt(types.I32, 1)
		}
		return constant.NewInt(types.I32, 0)
	case *parser.StringConst:
		return cg.genStringConstantPtr(n.Value)
	case *parser.Self:
		// For a self expression we return a pointer to self.
		// (This is a placeholder – a full object model would need proper self handling.)
		return constant.NewInt(types.I32, 0)
	case *parser.Ident:
		if alloca, ok := cg.variableEnv[n.Name]; ok {
			fmt.Printf("IDENT %s found, loading from alloca %v\n", n.Name, alloca)
			return cg.currentBlock.NewLoad(alloca.ElemType, alloca)
		}
		if cg.currentClass != "" {
			globalName := fmt.Sprintf("%s_%s", cg.currentClass, n.Name)
			if global, ok := cg.attributeGlobals[globalName]; ok {
				return cg.currentBlock.NewLoad(global.ContentType, global)
			}
		}
		fmt.Printf("IDENT %s not found, defaulting to 0.\n", n.Name)
		return constant.NewInt(types.I32, 0)
	case *parser.Assignment:
		val := cg.genExpr(n.Expr)
		alloca, ok := cg.variableEnv[n.Ident.Name]
		if !ok {
			alloca = cg.currentBlock.NewAlloca(val.Type())
			cg.variableEnv[n.Ident.Name] = alloca
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
		return cg.genIf(n)
	case *parser.While:
		return cg.genWhile(n)
	case *parser.BinaryOperation:
		return cg.genBinaryOp(n)
	case *parser.UnaryOperation:
		return cg.genUnaryOp(n)
	case *parser.New:
		// In a robust implementation this would allocate a new object.
		return constant.NewInt(types.I32, 0)
	case *parser.Let:
		return cg.genLet(n)
	case *parser.Case:
		return cg.genCase(n)
	case *parser.MethodCall:
		return cg.genMethodCall(n)
	case *parser.FunctionCall:
		return cg.genFunctionCall(n)
	default:
		fmt.Printf("Unhandled expr type %T, returning 0.\n", n)
		return constant.NewInt(types.I32, 0)
	}
}

// --------------------------------------------------------------------------
// String Helpers
// --------------------------------------------------------------------------

// genStringConstantPtr always creates a new global string constant with a unique name.
func (cg *CodeGenerator) genStringConstantPtr(strVal string) value.Value {
	// Replace literal "\n" with an actual newline.
	strVal = strings.ReplaceAll(strVal, "\\n", "\n")
	g := cg.getOrCreateGlobalString(strVal)
	zero := constant.NewInt(types.I32, 0)
	return cg.currentBlock.NewGetElementPtr(g.ContentType, g, zero, zero)
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
	// (We do not cache here so that each occurrence is unique.)
	return g
}

// --------------------------------------------------------------------------
// Control Structures
// --------------------------------------------------------------------------

func (cg *CodeGenerator) genIf(i *parser.If) value.Value {
	condVal := cg.genExpr(i.Condition)
	isTrue := cg.currentBlock.NewICmp(enum.IPredNE, condVal, constant.NewInt(types.I32, 0))
	thenBlock := cg.currentFunc.NewBlock(cg.newUniqueName("if_then"))
	elseBlock := cg.currentFunc.NewBlock(cg.newUniqueName("if_else"))
	mergeBlock := cg.currentFunc.NewBlock(cg.newUniqueName("if_end"))
	cg.currentBlock.NewCondBr(isTrue, thenBlock, elseBlock)
	// Then branch.
	cg.currentBlock = thenBlock
	thenVal := cg.genExpr(i.True)
	cg.currentBlock.NewBr(mergeBlock)
	// Else branch.
	cg.currentBlock = elseBlock
	elseVal := cg.genExpr(i.False)
	cg.currentBlock.NewBr(mergeBlock)
	// Merge.
	cg.currentBlock = mergeBlock
	phi := mergeBlock.NewPhi(
		ir.NewIncoming(thenVal, thenBlock),
		ir.NewIncoming(elseVal, elseBlock),
	)
	return phi
}

func (cg *CodeGenerator) genWhile(w *parser.While) value.Value {
	condBlock := cg.currentFunc.NewBlock("while_cond")
	bodyBlock := cg.currentFunc.NewBlock("while_body")
	endBlock := cg.currentFunc.NewBlock("while_end")
	cg.currentBlock.NewBr(condBlock)
	cg.currentBlock = condBlock
	condVal := cg.genExpr(w.Condition)
	isTrue := condBlock.NewICmp(enum.IPredNE, condVal, constant.NewInt(types.I32, 0))
	condBlock.NewCondBr(isTrue, bodyBlock, endBlock)
	cg.currentBlock = bodyBlock
	cg.genExpr(w.Body)
	cg.currentBlock.NewBr(condBlock)
	cg.currentBlock = endBlock
	return constant.NewInt(types.I32, 0)
}

func (cg *CodeGenerator) genBinaryOp(bin *parser.BinaryOperation) value.Value {
	left := cg.genExpr(bin.Left)
	right := cg.genExpr(bin.Right)
	switch bin.Operator {
	case "+":
		return cg.currentBlock.NewAdd(left, right)
	case "-":
		return cg.currentBlock.NewSub(left, right)
	case "*":
		return cg.currentBlock.NewMul(left, right)
	case "/":
		return cg.currentBlock.NewSDiv(left, right)
	case "<":
		icmp := cg.currentBlock.NewICmp(enum.IPredSLT, left, right)
		return cg.currentBlock.NewZExt(icmp, types.I32)
	case "<=":
		icmp := cg.currentBlock.NewICmp(enum.IPredSLE, left, right)
		return cg.currentBlock.NewZExt(icmp, types.I32)
	case "=":
		icmp := cg.currentBlock.NewICmp(enum.IPredEQ, left, right)
		return cg.currentBlock.NewZExt(icmp, types.I32)
	default:
		fmt.Printf("Unknown binop %q\n", bin.Operator)
		return constant.NewInt(types.I32, 0)
	}
}

func (cg *CodeGenerator) genUnaryOp(u *parser.UnaryOperation) value.Value {
	right := cg.genExpr(u.Right)
	switch u.Operator {
	case "~":
		zero := constant.NewInt(types.I32, 0)
		return cg.currentBlock.NewSub(zero, right)
	case "not":
		icmp := cg.currentBlock.NewICmp(enum.IPredEQ, right, constant.NewInt(types.I32, 0))
		return cg.currentBlock.NewZExt(icmp, types.I32)
	case "isvoid":
		// A proper implementation would test for null.
		return constant.NewInt(types.I32, 0)
	default:
		fmt.Printf("Unknown unary operator %q\n", u.Operator)
		return constant.NewInt(types.I32, 0)
	}
}

func (cg *CodeGenerator) genLet(l *parser.Let) value.Value {
	oldEnv := cg.variableEnv
	cg.variableEnv = make(map[string]*ir.InstAlloca)
	for k, v := range oldEnv {
		cg.variableEnv[k] = v
	}
	for _, assignment := range l.Assignments {
		fmt.Printf("Let assignment: %s : %s\n", assignment.Ident, assignment.Type)
		var varType types.Type
		switch assignment.Type {
		case "Int":
			varType = types.I32
		case "String":
			varType = types.NewPointer(types.I8)
		default:
			varType = types.I32
		}
		alloca := cg.currentBlock.NewAlloca(varType)
		cg.variableEnv[assignment.Ident] = alloca
		var initVal value.Value
		if assignment.Init != nil {
			initVal = cg.genExpr(assignment.Init)
		} else {
			if varType.Equal(types.I32) {
				initVal = constant.NewInt(types.I32, 0)
			} else if varType.Equal(types.NewPointer(types.I8)) {
				initVal = constant.NewNull(types.NewPointer(types.I8))
			} else {
				initVal = constant.NewInt(types.I32, 0)
			}
		}
		cg.currentBlock.NewStore(initVal, alloca)
	}
	result := cg.genExpr(l.Body)
	cg.variableEnv = oldEnv
	return result
}

func (cg *CodeGenerator) genCase(c *parser.Case) value.Value {
	// Minimal: pick the first branch.
	_ = cg.genExpr(c.Expr) // discard
	if len(c.TypeActions) == 0 {
		fmt.Println("Case with no branches => returning 0.")
		return constant.NewInt(types.I32, 0)
	}
	firstAction := c.TypeActions[0]
	fmt.Printf("CASE picking first branch: %s:%s => expr.\n", firstAction.Ident, firstAction.Type)
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
}

// --------------------------------------------------------------------------
// I/O Helpers (printing)
// --------------------------------------------------------------------------

func (cg *CodeGenerator) genCallPrintString(strPtr value.Value) value.Value {
	zero := constant.NewInt(types.I32, 0)
	fmtPtr := cg.currentBlock.NewGetElementPtr(cg.fmtString.ContentType, cg.fmtString, zero, zero)
	return cg.currentBlock.NewCall(cg.printfFunc, fmtPtr, strPtr)
}

func (cg *CodeGenerator) genCallPrintInt(intVal value.Value) value.Value {
	zero := constant.NewInt(types.I32, 0)
	fmtPtr := cg.currentBlock.NewGetElementPtr(cg.fmtInt.ContentType, cg.fmtInt, zero, zero)
	return cg.currentBlock.NewCall(cg.printfFunc, fmtPtr, intVal)
}

// --------------------------------------------------------------------------
// I/O Helpers (reading)
// --------------------------------------------------------------------------

func (cg *CodeGenerator) genCallInString() value.Value {
	// Allocate [1024 x i8] on the stack.
	bufAlloca := cg.currentBlock.NewAlloca(types.NewArray(1024, types.I8))
	zero := constant.NewInt(types.I32, 0)
	ptr := cg.currentBlock.NewGetElementPtr(bufAlloca.ElemType, bufAlloca, zero, zero)
	fmtPtr := cg.currentBlock.NewGetElementPtr(cg.fmtStringIn.ContentType, cg.fmtStringIn, zero, zero)
	cg.currentBlock.NewCall(cg.scanfFunc, fmtPtr, ptr)
	// Convert pointer to i32.
	ptrAsInt := cg.currentBlock.NewPtrToInt(ptr, types.I32)
	return ptrAsInt
}

func (cg *CodeGenerator) genCallInInt() value.Value {
	allocaI32 := cg.currentBlock.NewAlloca(types.I32)
	zero := constant.NewInt(types.I32, 0)
	fmtPtr := cg.currentBlock.NewGetElementPtr(cg.fmtIntIn.ContentType, cg.fmtIntIn, zero, zero)
	cg.currentBlock.NewCall(cg.scanfFunc, fmtPtr, allocaI32)
	loadedVal := cg.currentBlock.NewLoad(types.I32, allocaI32)
	return loadedVal
}

// --------------------------------------------------------------------------
// MethodCall and FunctionCall
// --------------------------------------------------------------------------

// genMethodCall:
//  - Evaluates the receiver and passes it as the first argument.
//  - For built-in String methods (length, concat, substr), uses our defined functions.
func (cg *CodeGenerator) genMethodCall(mc *parser.MethodCall) value.Value {
	// Evaluate the receiver.
	var receiver value.Value
	if mc.Object != nil {
		receiver = cg.genExpr(mc.Object)
	} else {
		// If no receiver is provided, default to "self" (not fully implemented).
		receiver = constant.NewInt(types.I32, 0)
	}
	// Evaluate method arguments.
	var args []value.Value
	// Pass the receiver as the first (implicit) parameter.
	args = append(args, receiver)
	for _, p := range mc.Method.Params {
		args = append(args, cg.genExpr(p))
	}
	name := mc.Method.Ident
	var calleeName string
	// For built-in String methods, force the callee name.
	if name == "length" || name == "concat" || name == "substr" {
		calleeName = "String_" + name
	} else {
		// For other methods, if not already qualified, prefix with current class.
		if cg.currentClass != "" && !strings.Contains(name, "_") {
			calleeName = fmt.Sprintf("%s_%s", cg.currentClass, name)
		} else {
			calleeName = name
		}
	}
	fmt.Println("calleeName: ", calleeName)
	callee := findFuncByName(cg.module, calleeName)
	if callee == nil {
		fmt.Printf("Error: method %s not found\n", calleeName)
		return constant.NewInt(types.I32, 0)
	}
	return cg.currentBlock.NewCall(callee, args...)
}

// genFunctionCall:
// In COOL a bare call like out_int(...) is shorthand for self.out_int(...).
func (cg *CodeGenerator) genFunctionCall(fc *parser.FunctionCall) value.Value {
	// Check for built-in I/O functions.
	switch fc.Ident {
	case "out_string":
		if len(fc.Params) < 1 {
			fmt.Println("Warning: out_string with no params!")
			return constant.NewInt(types.I32, 0)
		}
		return cg.genCallPrintString(cg.genExpr(fc.Params[0]))
	case "out_int":
		if len(fc.Params) < 1 {
			fmt.Println("Warning: out_int with no params!")
			return constant.NewInt(types.I32, 0)
		}
		return cg.genCallPrintInt(cg.genExpr(fc.Params[0]))
	case "in_string":
		return cg.genCallInString()
	case "in_int":
		return cg.genCallInInt()
	}
	var args []value.Value
	for _, p := range fc.Params {
		args = append(args, cg.genExpr(p))
	}
	// If inside a class, prefix the function name with currentClass unless already qualified.
	calleeName := fc.Ident
	if cg.currentClass != "" && !strings.HasPrefix(fc.Ident, cg.currentClass+"_") {
		calleeName = fmt.Sprintf("%s_%s", cg.currentClass, fc.Ident)
	}
	callee := findFuncByName(cg.module, calleeName)
	if callee == nil {
		fmt.Println("calleeName: ", calleeName)
		fmt.Printf("Error: function %s not found\n", calleeName)
		return constant.NewInt(types.I32, 0)
	}
	return cg.currentBlock.NewCall(callee, args...)
}

func (cg *CodeGenerator) newUniqueName(prefix string) string {
	name := fmt.Sprintf("%s_%d", prefix, cg.counter)
	cg.counter++
	return name
}
