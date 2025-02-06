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
// Helper for Parameter Attributes
// --------------------------------------------------------------------------

// paramAttr implements the ir.ParamAttribute interface.
type paramAttr string

func (a paramAttr) String() string           { return string(a) }
func (a paramAttr) IsParamAttribute()          {} // no-op
const Nocapture paramAttr = "nocapture"

// --------------------------------------------------------------------------
// CodeGenerator Structure
// --------------------------------------------------------------------------

type CodeGenerator struct {
	module       *ir.Module                // The LLVM IR module being built.
	currentFunc  *ir.Func                  // The current function.
	currentBlock *ir.Block                 // The current basic block.
	variableEnv  map[string]*ir.InstAlloca // Map from variable name to alloca.

	printfFunc   *ir.Func // External function: printf.
	scanf        *ir.Func // External function: scanf.

	// Global format strings for printing.
	// (Note: "%s\n" and "%d\n" are 4-byte constants including the null terminator.)
	fmtString *ir.Global // For strings: e.g. "%s\n"
	fmtInt    *ir.Global // For integers: e.g. "%d\n"

	// Cache for string constants.
	stringConsts map[string]*ir.Global
}

// uniqueGlobalName returns a unique name using the given prefix.
func (cg *CodeGenerator) uniqueGlobalName(prefix string) string {
	return fmt.Sprintf("%s_%d", prefix, len(cg.module.Globals))
}

// --------------------------------------------------------------------------
// Entry Point: CodegenProgram
// --------------------------------------------------------------------------

func CodegenProgram(prog *parser.Program) *ir.Module {
	cg := &CodeGenerator{
		module:       ir.NewModule(),
		variableEnv:  make(map[string]*ir.InstAlloca),
		stringConsts: make(map[string]*ir.Global),
	}

	// Declare external I/O functions.
	cg.declareExternalIO()

	// Create globals for our format strings.
	// "%s\n" as a [4 x i8] constant.
	cg.fmtString = cg.module.NewGlobalDef(cg.uniqueGlobalName("fmt_str"), constant.NewCharArrayFromString("%s\n\x00"))
	cg.fmtString.Immutable = true
	// "%d\n" as a [4 x i8] constant.
	cg.fmtInt = cg.module.NewGlobalDef(cg.uniqueGlobalName("fmt_int"), constant.NewCharArrayFromString("%d\n\x00"))
	cg.fmtInt.Immutable = true

	// Create the main entry function.
	mainFn := cg.module.NewFunc("main", types.I32)
	cg.currentFunc = mainFn
	cg.currentBlock = mainFn.NewBlock("entry")

	// Generate IR for each class.
	for _, classNode := range prog.Classes {
		cg.genClass(classNode)
	}

	// Look for an entry method ("Main_main" or "<ClassName>_main").
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
		// Call the entry method.
		_ = cg.currentBlock.NewCall(entryFn)
		cg.currentBlock.NewRet(constant.NewInt(types.I32, 0))
	} else {
		cg.currentBlock.NewRet(constant.NewInt(types.I32, 0))
	}

	return cg.module
}

// findFuncByName returns the function from the module whose name matches.
func findFuncByName(mod *ir.Module, name string) *ir.Func {
	for _, fn := range mod.Funcs {
		if fn.Name() == name {
			return fn
		}
	}
	return nil
}

// --------------------------------------------------------------------------
// External I/O Declarations
// --------------------------------------------------------------------------

func (cg *CodeGenerator) declareExternalIO() {
	// Declare printf: i32 @printf(i8* nocapture, ...).
	printfParam := ir.NewParam("fmt", types.NewPointer(types.I8))
	printfParam.Attrs = append(printfParam.Attrs, Nocapture)
	printfFn := cg.module.NewFunc("printf", types.I32, printfParam)
	printfFn.Sig.Variadic = true
	cg.printfFunc = printfFn

	// Declare scanf similarly.
	scanfParam := ir.NewParam("fmt", types.NewPointer(types.I8))
	scanfParam.Attrs = append(scanfParam.Attrs, Nocapture)
	scanfFn := cg.module.NewFunc("scanf", types.I32, scanfParam)
	scanfFn.Sig.Variadic = true
	cg.scanf = scanfFn
}

// --------------------------------------------------------------------------
// Class, Method, and Expression Generation
// --------------------------------------------------------------------------

func (cg *CodeGenerator) genClass(classNode *parser.Class) {
	for _, feat := range classNode.Features {
		switch f := feat.(type) {
		case *parser.Method:
			cg.genMethod(classNode.Name, f)
		case *parser.Attribute:
			// Attributes not implemented in this minimal codegen.
		default:
			fmt.Printf("Unknown feature type %T in class %s\n", f, classNode.Name)
		}
	}
}

// genMethod generates a function named "<ClassName>_<MethodName>".
// For I/O methods, we expect the body to include calls to out_string or out_int.
func (cg *CodeGenerator) genMethod(className string, method *parser.Method) {
	// For simplicity, every method returns an i32.
	var params []*ir.Param
	for _, fm := range method.Formals {
		param := ir.NewParam(fm.Ident, types.I32)
		params = append(params, param)
	}
	fnName := fmt.Sprintf("%s_%s", className, method.Ident)
	fn := cg.module.NewFunc(fnName, types.I32, params...)

	// Save old state.
	oldFunc := cg.currentFunc
	oldBlock := cg.currentBlock
	oldEnv := cg.variableEnv

	cg.currentFunc = fn
	cg.currentBlock = fn.NewBlock("entry")
	cg.variableEnv = make(map[string]*ir.InstAlloca)

	// Allocate each formal parameter.
	for _, p := range fn.Params {
		alloca := cg.currentBlock.NewAlloca(types.I32)
		cg.currentBlock.NewStore(p, alloca)
		cg.variableEnv[p.LocalName] = alloca
	}

	// Generate code for the method body.
	// (For a method such as MyIO_main, the body should contain an out_string call.)
	_ = cg.genExpr(method.Body)

	// IMPORTANT: For I/O methods we want to generate a call to printf.
	// For example, if the body was "out_string("Hello World\n");", then
	// genExpr will generate a method call that produces:
	//    %str_ptr = getelementptr [13 x i8], [13 x i8]* @str_0, i32 0, i32 0
	//    %fmt_ptr = getelementptr [4 x i8], [4 x i8]* @fmt_str_0, i32 0, i32 0
	//    %res = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i8* %str_ptr)
	// We then ignore %res and simply return 0.
	cg.currentBlock.NewRet(constant.NewInt(types.I32, 0))

	// Restore old state.
	cg.currentFunc = oldFunc
	cg.currentBlock = oldBlock
	cg.variableEnv = oldEnv
}

// genExpr dispatches code generation based on AST node type.
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
		// Return an i8* pointer to a global string.
		return cg.genStringConstantPtr(n.Value)
	case *parser.Self:
		return constant.NewInt(types.I32, 0)
	case *parser.Ident:
		if alloca, ok := cg.variableEnv[n.Name]; ok {
			return cg.currentBlock.NewLoad(types.I32, alloca)
		}
		return constant.NewInt(types.I32, 0)
	case *parser.Assignment:
		val := cg.genExpr(n.Expr)
		alloca, ok := cg.variableEnv[n.Ident.Name]
		if !ok {
			alloca = cg.currentBlock.NewAlloca(types.I32)
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
		fmt.Printf("NEW %s => placeholder 0.\n", n.Type)
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

// genStringConstantPtr returns an i8* pointer to a global string constant.
func (cg *CodeGenerator) genStringConstantPtr(strVal string) value.Value {
	g := cg.getOrCreateGlobalString(strVal)
	zero := constant.NewInt(types.I32, 0)
	return cg.currentBlock.NewGetElementPtr(g.ContentType, g, zero, zero)
}

func (cg *CodeGenerator) getOrCreateGlobalString(strVal string) *ir.Global {
	// Replace escape sequences (e.g. "\n") with actual newlines.
	strVal = strings.ReplaceAll(strVal, "\\n", "\n")
	if g, ok := cg.stringConsts[strVal]; ok {
		return g
	}
	if !strings.HasSuffix(strVal, "\x00") {
		strVal += "\x00"
	}
	arr := constant.NewCharArrayFromString(strVal)
	globalName := fmt.Sprintf("str_%d", len(cg.stringConsts))
	g := cg.module.NewGlobalDef(globalName, arr)
	g.Immutable = true
	cg.stringConsts[strVal] = g
	return g
}

// --------------------------------------------------------------------------
// Control Structures (if, while, binary, unary, let, case)
// (Omitted for brevity; assume these remain unchanged.)
// --------------------------------------------------------------------------

func (cg *CodeGenerator) genIf(i *parser.If) value.Value {
	condVal := cg.genExpr(i.Condition)
	isTrue := cg.currentBlock.NewICmp(enum.IPredNE, condVal, constant.NewInt(types.I32, 0))
	thenBlock := cg.currentFunc.NewBlock("if_then")
	elseBlock := cg.currentFunc.NewBlock("if_else")
	endBlock := cg.currentFunc.NewBlock("if_end")
	cg.currentBlock.NewCondBr(isTrue, thenBlock, elseBlock)
	cg.currentBlock = thenBlock
	thenVal := cg.genExpr(i.True)
	thenBlock.NewBr(endBlock)
	cg.currentBlock = elseBlock
	elseVal := cg.genExpr(i.False)
	elseBlock.NewBr(endBlock)
	cg.currentBlock = endBlock
	return endBlock.NewPhi(ir.NewIncoming(thenVal, thenBlock), ir.NewIncoming(elseVal, elseBlock))
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
	bodyBlock.NewBr(condBlock)
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
	for _, attr := range l.Assignments {
		alloca := cg.currentBlock.NewAlloca(types.I32)
		cg.variableEnv[attr.Ident] = alloca
		var initVal value.Value = constant.NewInt(types.I32, 0)
		if attr.Init != nil {
    		initVal = cg.genExpr(attr.Init)
		}
		cg.currentBlock.NewStore(initVal, alloca)
	}
	result := cg.genExpr(l.Body)
	cg.variableEnv = oldEnv
	return result
}

func (cg *CodeGenerator) genCase(c *parser.Case) value.Value {
	exprVal := cg.genExpr(c.Expr)
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
	alloca := cg.currentBlock.NewAlloca(types.I32)
	cg.currentBlock.NewStore(exprVal, alloca)
	cg.variableEnv[firstAction.Ident] = alloca
	result := cg.genExpr(firstAction.Expr)
	cg.variableEnv = oldEnv
	return result
}

// --------------------------------------------------------------------------
// I/O Call Implementations
// --------------------------------------------------------------------------

// genCallPrintString generates the IR to print a string.
// It computes the pointer to the global format string (e.g. "%s\n")
// using getelementptr and then calls printf with that pointer and the
// provided string pointer.
func (cg *CodeGenerator) genCallPrintString(strPtr value.Value) value.Value {
	zero := constant.NewInt(types.I32, 0)
	// Compute: %fmt_ptr = getelementptr [4 x i8], [4 x i8]* @fmt_str_0, i32 0, i32 0
	fmtPtr := cg.currentBlock.NewGetElementPtr(cg.fmtString.ContentType, cg.fmtString, zero, zero)
	// Now call printf: %res = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i8* %str_ptr)
	callInst := cg.currentBlock.NewCall(cg.printfFunc, fmtPtr, strPtr)
	return callInst
}

// genCallPrintInt is analogous for integers.
func (cg *CodeGenerator) genCallPrintInt(intVal value.Value) value.Value {
	zero := constant.NewInt(types.I32, 0)
	fmtPtr := cg.currentBlock.NewGetElementPtr(cg.fmtInt.ContentType, cg.fmtInt, zero, zero)
	callInst := cg.currentBlock.NewCall(cg.printfFunc, fmtPtr, intVal)
	return callInst
}

// --------------------------------------------------------------------------
// MethodCall and FunctionCall Dispatch
// --------------------------------------------------------------------------

func (cg *CodeGenerator) genMethodCall(mc *parser.MethodCall) value.Value {
	// Evaluate the object (ignored in this minimal implementation).
	_ = cg.genExpr(mc.Object)
	name := mc.Method.Ident
	params := mc.Method.Params

	switch name {
	case "out_string":
		if len(params) < 1 {
			fmt.Println("Warning: out_string with no params!")
			return constant.NewInt(types.I32, 0)
		}
		// Compute the string pointer.
		strVal := cg.genExpr(params[0])
		// **This is the key call:** generate:
		// %fmt_ptr = getelementptr ... and %res = call i32 @printf(...)
		return cg.genCallPrintString(strVal)
	case "out_int":
		if len(params) < 1 {
			fmt.Println("Warning: out_int with no params!")
			return constant.NewInt(types.I32, 0)
		}
		intVal := cg.genExpr(params[0])
		return cg.genCallPrintInt(intVal)
	case "in_string":
		fmt.Println("in_string not implemented; returning 0")
		return constant.NewInt(types.I32, 0)
	case "in_int":
		fmt.Println("in_int not implemented; returning 0")
		return constant.NewInt(types.I32, 0)
	}

	fmt.Printf("MethodCall %s => placeholder\n", name)
	for _, p := range params {
		_ = cg.genExpr(p)
	}
	return constant.NewInt(types.I32, 0)
}

func (cg *CodeGenerator) genFunctionCall(fc *parser.FunctionCall) value.Value {
	fmt.Printf("FunctionCall %s => placeholder\n", fc.Ident)
	for _, p := range fc.Params {
		_ = cg.genExpr(p)
	}
	return constant.NewInt(types.I32, 0)
}
