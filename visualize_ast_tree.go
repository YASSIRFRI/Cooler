package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"

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

	// Create (or overwrite) the output DOT file for AST.
	dotFile, err := os.Create("ast.dot")
	if err != nil {
		fmt.Println("Error creating ast.dot file:", err)
		return
	}
	defer dotFile.Close()

	// Initialize DOT file
	fmt.Fprintln(dotFile, "digraph AST {")
	fmt.Fprintln(dotFile, "    node [shape=box];") // Optional: sets all nodes to have box shape

	// Unique identifier generator
	idCounter := 0
	getUniqueID := func() string {
		id := strconv.Itoa(idCounter)
		idCounter++
		return "node" + id
	}

	// Draw AST and get the root node ID
	rootID := drawASTVisu(prog, dotFile, getUniqueID)

	// Optionally, you can highlight the root node
	fmt.Fprintf(dotFile, "    %s [style=filled, fillcolor=lightblue];\n", rootID)

	fmt.Fprintln(dotFile, "}") // Close DOT graph

	fmt.Println("AST was successfully written to ast.dot")
	fmt.Println("Use Graphviz to visualize it, e.g., run: dot -Tpng ast.dot -o ast.png")
}

// drawASTVisu recursively writes the AST nodes and edges in DOT format.
// It returns the unique ID of the current node.
func drawASTVisu(node parser.Node, file *os.File, getUniqueID func() string) string {
	currentID := getUniqueID()
	label := ""

	switch n := node.(type) {
	// Program node: label as "Program"
	case *parser.Program:
		label = "Program"
	case *parser.Class:
		if n.Inherits != "" {
			label = fmt.Sprintf("Class: %s\\n(Inherits: %s)", n.Name, n.Inherits)
		} else {
			label = fmt.Sprintf("Class: %s", n.Name)
		}
	case *parser.Method:
		label = fmt.Sprintf("Method: %s : %s", n.Ident, n.Type)
	case *parser.Attribute:
		label = fmt.Sprintf("Attribute: %s : %s", n.Ident, n.Type)
	case *parser.Formal:
		label = fmt.Sprintf("Formal: %s : %s", n.Ident, n.Type)
	case *parser.Assignment:
		label = "Assignment"
	case *parser.MethodCall:
		label = "MethodCall"
	case *parser.FunctionCall:
		label = fmt.Sprintf("FunctionCall: %s", n.Ident)
	case *parser.If:
		label = "If"
	case *parser.While:
		label = "While"
	case *parser.Block:
		label = "Block"
	case *parser.Let:
		label = "Let"
	case *parser.New:
		label = fmt.Sprintf("New: %s", n.Type)
	case *parser.BinaryOperation:
		label = fmt.Sprintf("BinaryOp: %s", n.Operator)
	case *parser.UnaryOperation:
		label = fmt.Sprintf("UnaryOp: %s", n.Operator)
	case *parser.Ident:
		label = fmt.Sprintf("Ident: %s", n.Name)
	case *parser.Self:
		label = "Self"
	case *parser.IntConst:
		label = fmt.Sprintf("IntConst: %d", n.Value)
	case *parser.BoolConst:
		label = fmt.Sprintf("BoolConst: %t", n.Value)
	case *parser.StringConst:
		label = fmt.Sprintf("StringConst: \"%s\"", n.Value)
	default:
		label = fmt.Sprintf("Unknown: %T", n)
	}

	// Escape quotes in labels
	label = escapeLabel(label)

	// Write the current node with its label
	fmt.Fprintf(file, "    %s [label=\"%s\"];\n", currentID, label)

	// Now handle children and connect them
	switch n := node.(type) {
	case *parser.Program:
		for _, class := range n.Classes {
			childID := drawASTVisu(class, file, getUniqueID) // Pass the function, not the result
			fmt.Fprintf(file, "    %s -> %s;\n", currentID, childID)
		}
	case *parser.Class:
		for _, feat := range n.Features {
			childID := drawASTVisu(feat, file, getUniqueID) // Pass the function, not the result
			fmt.Fprintf(file, "    %s -> %s;\n", currentID, childID)
		}
	case *parser.Method:
		// Formals
		if len(n.Formals) > 0 {
			formalsID := getUniqueID()
			fmt.Fprintf(file, "    %s -> %s [label=\"Formals\"];\n", currentID, formalsID)
			fmt.Fprintf(file, "    %s [shape=plaintext, label=\"Formals\"];\n", formalsID)
			for _, formal := range n.Formals {
				childID := drawASTVisu(formal, file, getUniqueID) // Pass the function
				fmt.Fprintf(file, "    %s -> %s;\n", formalsID, childID)
			}
		}
		// Body
		bodyID := drawASTVisu(n.Body, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Body\"];\n", currentID, bodyID)
	case *parser.Attribute:
		if n.Init != nil {
			initID := drawASTVisu(n.Init, file, getUniqueID) // Pass the function
			fmt.Fprintf(file, "    %s -> %s [label=\"Init\"];\n", currentID, initID)
		}
	case *parser.Assignment:
		// Ident
		identID := drawASTVisu(n.Ident, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Ident\"];\n", currentID, identID)
		// Expr
		exprID := drawASTVisu(n.Expr, file, getUniqueID) // Pass the function, not getUniqueID()
		fmt.Fprintf(file, "    %s -> %s [label=\"Expr\"];\n", currentID, exprID)
	case *parser.MethodCall:
		// Object
		objectID := drawASTVisu(n.Object, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Object\"];\n", currentID, objectID)
		// TargetType (optional)
		if n.TargetType != "" {
			// Adjusted to include TargetType in the label
			fmt.Fprintf(file, "    %s [label=\"%s\\n(TargetType: %s)\"];\n", currentID, "MethodCall", n.TargetType)
		}
		// Method
		methodID := drawASTVisu(n.Method, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Method\"];\n", currentID, methodID)
	case *parser.FunctionCall:
		if len(n.Params) > 0 {
			paramsID := getUniqueID()
			fmt.Fprintf(file, "    %s -> %s [label=\"Params\"];\n", currentID, paramsID)
			fmt.Fprintf(file, "    %s [shape=plaintext, label=\"Params\"];\n", paramsID)
			for _, param := range n.Params {
				childID := drawASTVisu(param, file, getUniqueID) // Pass the function
				fmt.Fprintf(file, "    %s -> %s;\n", paramsID, childID)
			}
		}
	case *parser.If:
		// Condition
		condID := drawASTVisu(n.Condition, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Condition\"];\n", currentID, condID)
		// True Branch
		trueID := drawASTVisu(n.True, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"True\"];\n", currentID, trueID)
		// False Branch
		falseID := drawASTVisu(n.False, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"False\"];\n", currentID, falseID)
	case *parser.While:
		// Condition
		condID := drawASTVisu(n.Condition, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Condition\"];\n", currentID, condID)
		// Body
		bodyID := drawASTVisu(n.Body, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Body\"];\n", currentID, bodyID)
	case *parser.Block:
		for _, expr := range n.Exprs {
			childID := drawASTVisu(expr, file, getUniqueID) // Pass the function
			fmt.Fprintf(file, "    %s -> %s;\n", currentID, childID)
		}
	case *parser.Let:
		// Assignments
		if len(n.Assignments) > 0 {
			assignsID := getUniqueID()
			fmt.Fprintf(file, "    %s -> %s [label=\"Assignments\"];\n", currentID, assignsID)
			fmt.Fprintf(file, "    %s [shape=plaintext, label=\"Assignments\"];\n", assignsID)
			for _, asg := range n.Assignments {
				childID := drawASTVisu(asg, file, getUniqueID) // Pass the function
				fmt.Fprintf(file, "    %s -> %s;\n", assignsID, childID)
			}
		}
		// Body
		bodyID := drawASTVisu(n.Body, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Body\"];\n", currentID, bodyID)
	case *parser.BinaryOperation:
		// Left
		leftID := drawASTVisu(n.Left, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Left\"];\n", currentID, leftID)
		// Right
		rightID := drawASTVisu(n.Right, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Right\"];\n", currentID, rightID)
	case *parser.UnaryOperation:
		// Right
		rightID := drawASTVisu(n.Right, file, getUniqueID) // Pass the function
		fmt.Fprintf(file, "    %s -> %s [label=\"Right\"];\n", currentID, rightID)
	// For leaf nodes like Ident, Self, IntConst, BoolConst, StringConst, no children
	}

	return currentID
}

// escapeLabel escapes quotes and backslashes in labels for DOT format
func escapeLabel(label string) string {
	label = strings.ReplaceAll(label, "\\", "\\\\")
	label = strings.ReplaceAll(label, "\"", "\\\"")
	return label
}
