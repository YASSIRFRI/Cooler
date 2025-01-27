package main

import (
	"fmt"
	"os"
	"path/filepath"
	"cooler/lexer"
	"cooler/parser"
)

func main() {
	// Ensure input directory exists
	inputDir := "./input"
	if _, err := os.Stat(inputDir); os.IsNotExist(err) {
		if err := os.MkdirAll(inputDir, 0755); err != nil {
			fmt.Fprintf(os.Stderr, "Failed to create input directory: %v\n", err)
			os.Exit(1)
		}
	}

	// Read input file
	inputPath := filepath.Join(inputDir, "sampl2.cl")
	input, err := os.ReadFile(inputPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to read input file: %v\n", err)
		os.Exit(1)
	}

	lx := lexer.NewLexer(string(input))
	var tokens []*lexer.Token
	for {
		tok := lx.NextToken()
		if tok == nil {
			break
		}
		tokens = append(tokens, tok)
	}

	p := parser.NewParser(tokens)
	prog, err := p.ParseProgram()
	if err != nil {
		fmt.Println("Error parsing program:", err)
		return
	}

	// Create (or overwrite) the output file for AST.
	file, err := os.Create("ast.out")
	if err != nil {
		fmt.Println("Error creating ast.out file:", err)
		return
	}
	defer file.Close()

	drawAST(prog, "", file)
	fmt.Println("AST was successfully written to ast.out")
}

// drawAST recursively prints a tree-like representation of the AST into the provided file.
func drawAST(node parser.Node, indent string, file *os.File) {
	switch n := node.(type) {
	// Program node: print each class.
	case *parser.Program:
		fmt.Fprintf(file, "%sProgram\n", indent)
		for _, class := range n.Classes {
			drawAST(class, indent+"  ", file)
		}

	// Class declaration.
	case *parser.Class:
		inheritance := ""
		if n.Inherits != "" {
			inheritance = " inherits " + n.Inherits
		}
		fmt.Fprintf(file, "%sClass: %s%s\n", indent, n.Name, inheritance)
		for _, feat := range n.Features {
			drawAST(feat, indent+"  ", file)
		}

	// Method declaration.
	case *parser.Method:
		fmt.Fprintf(file, "%sMethod: %s : %s\n", indent, n.Ident, n.Type)
		if len(n.Formals) > 0 {
			fmt.Fprintf(file, "%s  Formals:\n", indent)
			for _, formal := range n.Formals {
				drawAST(formal, indent+"    ", file)
			}
		}
		fmt.Fprintf(file, "%s  Body:\n", indent)
		drawAST(n.Body, indent+"    ", file)

	// Attribute declaration.
	case *parser.Attribute:
		fmt.Fprintf(file, "%sAttribute: %s : %s\n", indent, n.Ident, n.Type)
		if n.Init != nil {
			fmt.Fprintf(file, "%s  Init:\n", indent)
			drawAST(n.Init, indent+"    ", file)
		}

	// Formal parameter.
	case *parser.Formal:
		fmt.Fprintf(file, "%sFormal: %s : %s\n", indent, n.Ident, n.Type)

	// Assignment expression.
	case *parser.Assignment:
		fmt.Fprintf(file, "%sAssignment:\n", indent)
		fmt.Fprintf(file, "%s  Ident:\n", indent)
		drawAST(n.Ident, indent+"    ", file)
		fmt.Fprintf(file, "%s  Expr:\n", indent)
		drawAST(n.Expr, indent+"    ", file)

	// Method call expression.
	case *parser.MethodCall:
		fmt.Fprintf(file, "%sMethodCall:\n", indent)
		fmt.Fprintf(file, "%s  Object:\n", indent)
		drawAST(n.Object, indent+"    ", file)
		if n.TargetType != "" {
			fmt.Fprintf(file, "%s  TargetType: %s\n", indent+"    ", n.TargetType)
		}
		fmt.Fprintf(file, "%s  Method:\n", indent)
		drawAST(n.Method, indent+"    ", file)

	// Function call: typically used as the call structure inside a method call.
	case *parser.FunctionCall:
		fmt.Fprintf(file, "%sFunctionCall: %s\n", indent, n.Ident)
		if len(n.Params) > 0 {
			fmt.Fprintf(file, "%s  Params:\n", indent)
			for _, param := range n.Params {
				drawAST(param, indent+"    ", file)
			}
		}

	// IF expression.
	case *parser.If:
		fmt.Fprintf(file, "%sIf Expression:\n", indent)
		fmt.Fprintf(file, "%s  Condition:\n", indent)
		drawAST(n.Condition, indent+"    ", file)
		fmt.Fprintf(file, "%s  True Branch:\n", indent)
		drawAST(n.True, indent+"    ", file)
		fmt.Fprintf(file, "%s  False Branch:\n", indent)
		drawAST(n.False, indent+"    ", file)

	// WHILE loop.
	case *parser.While:
		fmt.Fprintf(file, "%sWhile Loop:\n", indent)
		fmt.Fprintf(file, "%s  Condition:\n", indent)
		drawAST(n.Condition, indent+"    ", file)
		fmt.Fprintf(file, "%s  Body:\n", indent)
		drawAST(n.Body, indent+"    ", file)

	// Block: a sequence of expressions.
	case *parser.Block:
		fmt.Fprintf(file, "%sBlock:\n", indent)
		for _, expr := range n.Exprs {
			drawAST(expr, indent+"  ", file)
		}

	// LET expression.
	case *parser.Let:
		fmt.Fprintf(file, "%sLet Expression:\n", indent)
		fmt.Fprintf(file, "%s  Assignments:\n", indent)
		for _, asg := range n.Assignments {
			drawAST(asg, indent+"    ", file)
		}
		fmt.Fprintf(file, "%s  Body:\n", indent)
		drawAST(n.Body, indent+"    ", file)

	// NEW expression.
	case *parser.New:
		fmt.Fprintf(file, "%sNew: %s\n", indent, n.Type)

	// Binary operation.
	case *parser.BinaryOperation:
		fmt.Fprintf(file, "%sBinaryOperation: %s\n", indent, n.Operator)
		fmt.Fprintf(file, "%s  Left:\n", indent)
		drawAST(n.Left, indent+"    ", file)
		fmt.Fprintf(file, "%s  Right:\n", indent)
		drawAST(n.Right, indent+"    ", file)

	// Unary operation.
	case *parser.UnaryOperation:
		fmt.Fprintf(file, "%sUnaryOperation: %s\n", indent, n.Operator)
		fmt.Fprintf(file, "%s  Right:\n", indent)
		drawAST(n.Right, indent+"    ", file)

	// Identifier.
	case *parser.Ident:
		fmt.Fprintf(file, "%sIdent: %s\n", indent, n.Name)

	// SELF keyword.
	case *parser.Self:
		fmt.Fprintf(file, "%sSelf\n", indent)

	// Integer constant.
	case *parser.IntConst:
		fmt.Fprintf(file, "%sIntConst: %d\n", indent, n.Value)

	// Boolean constant.
	case *parser.BoolConst:
		fmt.Fprintf(file, "%sBoolConst: %t\n", indent, n.Value)

	// String constant.
	case *parser.StringConst:
		fmt.Fprintf(file, "%sStringConst: \"%s\"\n", indent, n.Value)

	// Unknown node type.
	default:
		fmt.Fprintf(file, "%sUnknown node type: %T\n", indent, n)
	}
}
