package codegen

import (
	"strings"
	"testing"
	"cooler/parser"
	"fmt"
)

// TestMethodIntConst creates a class with one method that returns an integer constant.
func TestMethodIntConst(t *testing.T) {
	// Create a class "Main" with a method "main_method" that returns 123.
	prog := &parser.Program{
		Classes: []*parser.Class{
			{
				Name:     "Main",
				Inherits: "",
				Features: []parser.Node{
					&parser.Method{
						Ident:   "main_method",
						Type:    "Int",
						Formals: []*parser.Formal{},
						Body:    &parser.IntConst{Value: 123},
					},
				},
			},
		},
	}

	mod := CodegenProgram(prog)
	llvmIR := mod.String()

	// Check that the IR contains the constant 123.
	if !strings.Contains(llvmIR, "123") {
		t.Errorf("Expected LLVM IR to contain 123; got:\n%s", llvmIR)
	}
}

// TestBinaryOperation creates a method that computes a binary expression:
// (10 + 20) * 2
func TestBinaryOperation(t *testing.T) {
	expr := &parser.BinaryOperation{
		Operator: "*",
		Left: &parser.BinaryOperation{
			Operator: "+",
			Left:     &parser.IntConst{Value: 10},
			Right:    &parser.IntConst{Value: 20},
		},
		Right: &parser.IntConst{Value: 2},
	}

	prog := &parser.Program{
		Classes: []*parser.Class{
			{
				Name:     "Math",
				Inherits: "",
				Features: []parser.Node{
					&parser.Method{
						Ident:   "compute",
						Type:    "Int",
						Formals: []*parser.Formal{},
						Body:    expr,
					},
				},
			},
		},
	}

	mod := CodegenProgram(prog)
	llvmIR := mod.String()
	fmt.Println(llvmIR)

	// Look for the LLVM multiplication instruction.
	if !strings.Contains(llvmIR, "mul") {
		t.Errorf("Expected LLVM IR to contain a mul instruction; got:\n%s", llvmIR)
	}
}

// TestIfExpression creates a method that uses an if-then-else:
// if (1 < 2) then 100 else 200 fi
func TestIfExpression(t *testing.T) {
	expr := &parser.If{
		Condition: &parser.BinaryOperation{
			Operator: "<",
			Left:     &parser.IntConst{Value: 1},
			Right:    &parser.IntConst{Value: 2},
		},
		True:  &parser.IntConst{Value: 100},
		False: &parser.IntConst{Value: 200},
	}

	prog := &parser.Program{
		Classes: []*parser.Class{
			{
				Name:     "Conditional",
				Inherits: "",
				Features: []parser.Node{
					&parser.Method{
						Ident:   "select",
						Type:    "Int",
						Formals: []*parser.Formal{},
						Body:    expr,
					},
				},
			},
		},
	}

	mod := CodegenProgram(prog)
	llvmIR := mod.String()

	// The generated IR should include a phi node for merging the two branches.
	if !strings.Contains(llvmIR, "phi") {
		t.Errorf("Expected LLVM IR to contain a phi instruction; got:\n%s", llvmIR)
	}
}

// TestWhileLoop creates a method that performs a while loop:
// {
//    x <- 0;
//    while (x < 10) loop x <- x + 1 pool;
//    x
// }
func TestWhileLoop(t *testing.T) {
	// Create an assignment x <- 0.
	assignInit := &parser.Assignment{
		Ident: &parser.Ident{Name: "x"},
		Expr:  &parser.IntConst{Value: 0},
	}
	// while (x < 10) loop x <- x + 1 pool
	whileExpr := &parser.While{
		Condition: &parser.BinaryOperation{
			Operator: "<",
			Left:     &parser.Ident{Name: "x"},
			Right:    &parser.IntConst{Value: 10},
		},
		Body: &parser.Assignment{
			Ident: &parser.Ident{Name: "x"},
			Expr: &parser.BinaryOperation{
				Operator: "+",
				Left:     &parser.Ident{Name: "x"},
				Right:    &parser.IntConst{Value: 1},
			},
		},
	}
	// Block: { x <- 0; while ...; x }
	block := &parser.Block{
		Exprs: []parser.Node{
			assignInit,
			whileExpr,
			&parser.Ident{Name: "x"},
		},
	}

	prog := &parser.Program{
		Classes: []*parser.Class{
			{
				Name:     "LoopTest",
				Inherits: "",
				Features: []parser.Node{
					&parser.Method{
						Ident:   "increment",
						Type:    "Int",
						Formals: []*parser.Formal{},
						Body:    block,
					},
				},
			},
		},
	}

	mod := CodegenProgram(prog)
	llvmIR := mod.String()
	fmt.Println(llvmIR)

	// Check that the while loop produces at least one conditional branch.
	if !strings.Contains(llvmIR, "br i1") {
		t.Errorf("Expected LLVM IR to contain a conditional branch; got:\n%s", llvmIR)
	}
}

// TestUnaryOperations creates a method that tests unary operators:
// ~42 and not 0.
func TestUnaryOperations(t *testing.T) {
	negExpr := &parser.UnaryOperation{
		Operator: "~",
		Right:    &parser.IntConst{Value: 42},
	}
	notExpr := &parser.UnaryOperation{
		Operator: "not",
		Right:    &parser.IntConst{Value: 0},
	}

	// Put the two expressions in a block so that both are generated;
	// note that the block returns the value of its last expression.
	block := &parser.Block{
		Exprs: []parser.Node{
			negExpr,
			notExpr,
		},
	}

	prog := &parser.Program{
		Classes: []*parser.Class{
			{
				Name:     "UnaryTest",
				Inherits: "",
				Features: []parser.Node{
					&parser.Method{
						Ident:   "testOps",
						Type:    "Int",
						Formals: []*parser.Formal{},
						Body:    block,
					},
				},
			},
		},
	}

	mod := CodegenProgram(prog)
	llvmIR := mod.String()
	fmt.Println(llvmIR)

	// Check for evidence of subtraction (for "~") and an icmp (for "not")
	if !strings.Contains(llvmIR, "sub") || !strings.Contains(llvmIR, "icmp") {
		t.Errorf("Expected LLVM IR to contain subtraction and icmp instructions; got:\n%s", llvmIR)
	}
}

// TestAssignment creates a method that assigns a value to a variable and then returns it:
// { x <- 5; x }
func TestAssignment(t *testing.T) {
	assignExpr := &parser.Assignment{
		Ident: &parser.Ident{Name: "x"},
		Expr:  &parser.IntConst{Value: 5},
	}
	block := &parser.Block{
		Exprs: []parser.Node{
			assignExpr,
			&parser.Ident{Name: "x"},
		},
	}

	prog := &parser.Program{
		Classes: []*parser.Class{
			{
				Name:     "AssignTest",
				Inherits: "",
				Features: []parser.Node{
					&parser.Method{
						Ident:   "getX",
						Type:    "Int",
						Formals: []*parser.Formal{},
						Body:    block,
					},
				},
			},
		},
	}

	mod := CodegenProgram(prog)
	llvmIR := mod.String()

	// Check that the generated IR includes a store and load for variable "x".
	if !strings.Contains(llvmIR, "store") || !strings.Contains(llvmIR, "load") {
		t.Errorf("Expected LLVM IR to contain both store and load instructions for assignment; got:\n%s", llvmIR)
	}
}



//test io:
// class MyIO inherits IO {
// 	main(): Object {
// 	  {
// 		out_string("Hello World\n");
// 		out_int(42);
// 	  }
// 	};
//  };


// TestPrintString creates a method that prints a string constant.
func TestPrintString(t *testing.T) {
	// Create a method that prints a string constant.
	prog := &parser.Program{
		Classes: []*parser.Class{
			{
				Name:     "MyIO",
				Inherits: "IO",
				Features: []parser.Node{
					&parser.Method{
						Ident:   "main",
						Type:    "Object",
						Formals: []*parser.Formal{},
						Body: &parser.Block{
							Exprs: []parser.Node{
								&parser.MethodCall{
									Object: &parser.Self{},
									//method is of type functioncall
									Method: &parser.FunctionCall{
										Ident: "out_string",
										Params:  []parser.Node{&parser.StringConst{Value: "Hello World\n"}},
									},
								},
							},
						},
					},
				},
			},
		},
	}

	mod := CodegenProgram(prog)
	llvmIR := mod.String()

	if !strings.Contains(llvmIR, "@printf") {
		t.Errorf("Expected LLVM IR to contain a call to out_string; got:\n%s", llvmIR)
	}
}

