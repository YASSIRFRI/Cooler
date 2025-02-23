package parser

import (
	"testing"
	"cooler/lexer"
	"fmt"
)

func tokenize(input string) []*lexer.Token {
	lx := lexer.NewLexer(input)
	var tokens []*lexer.Token
	for {
		tok := lx.NextToken()
		if tok == nil {
			break
		}
		tokens = append(tokens, tok)
	}
	return tokens
}

func TestSimpleProgram(t *testing.T) {
	input := `
   class Main {
      x : Int <- 42;
      y : Int;
   };
   `
	tokens := tokenize(input)
	for _, tok := range tokens {
		fmt.Println(tok)
	}
	p := NewParser(tokens)
	fmt.Println(p)
	prog, err := p.ParseProgram()
	if err != nil {
		t.Fatalf("ParseProgram() error: %v", err)
	}
	if len(prog.Classes) != 1 {
		t.Fatalf("expected 1 class, got %d", len(prog.Classes))
	}
	class := prog.Classes[0]
	if class.Name != "Main" {
		t.Errorf("expected class name Main, got %s", class.Name)
	}
	if len(class.Features) != 2 {
		t.Fatalf("expected 2 features, got %d", len(class.Features))
	}

	// Feature 1: attribute "x" : Int <- 42
	attrX, ok := class.Features[0].(*Attribute)
	if !ok {
		t.Fatalf("expected first feature is Attribute, got %T", class.Features[0])
	}
	if attrX.Ident != "x" || attrX.Type != "Int" {
		t.Errorf("expected attribute x:Int, got %s:%s", attrX.Ident, attrX.Type)
	}
	intVal, ok := attrX.Init.(*IntConst)
	if !ok || intVal.Value != 42 {
		t.Errorf("expected attribute x init 42, got %v", attrX.Init)
	}

	// Feature 2: attribute "y" : Int (no initializer)
	attrY, ok := class.Features[1].(*Attribute)
	if !ok {
		t.Fatalf("expected second feature is Attribute, got %T", class.Features[1])
	}
	if attrY.Ident != "y" || attrY.Type != "Int" {
		t.Errorf("expected attribute y:Int, got %s:%s", attrY.Ident, attrY.Type)
	}
	if attrY.Init != nil {
		t.Errorf("expected attribute y with no init, got %v", attrY.Init)
	}
}

func TestIfExpression(t *testing.T) {
	input := `if 
	x < 10 
	then x <- x + 1 else x <- x - 1 fi`
	tokens := tokenize(input)
	p := NewParser(tokens)
	expr, err := p.parseExpression(0)
	if err != nil {
		t.Fatalf("parseExpression error: %v", err)
	}

	ifExpr, ok := expr.(*If)
	if !ok {
		t.Fatalf("expected If node, got %T", expr)
	}
	// Check condition: should be a binary operation: x < 10
	cond, ok := ifExpr.Condition.(*BinaryOperation)
	if !ok {
		t.Errorf("expected condition to be BinaryOperation, got %T", ifExpr.Condition)
	} else if cond.Operator != "<" {
		t.Errorf("expected condition operator '<', got %s", cond.Operator)
	}
	// Check branches: both should be assignments.
	_, ok = ifExpr.True.(*Assignment)
	if !ok {
		t.Errorf("expected true branch to be Assignment, got %T", ifExpr.True)
	}
	_, ok = ifExpr.False.(*Assignment)
	if !ok {
		t.Errorf("expected false branch to be Assignment, got %T", ifExpr.False)
	}
}

func TestExprPrecedence(t *testing.T) {
	input := "1 + 2 * 3"
	tokens := tokenize(input)
	p := NewParser(tokens)
	expr, err := p.parseExpression(0)
	if err != nil {
		t.Fatalf("parseExpression error: %v", err)
	}
	// Expected: 1 + (2 * 3)
	bop, ok := expr.(*BinaryOperation)
	if !ok {
		t.Fatalf("expected BinaryOperation, got %T", expr)
	}
	if bop.Operator != "+" {
		t.Errorf("expected top operator '+', got %s", bop.Operator)
	}
	left, ok := bop.Left.(*IntConst)
	if !ok || left.Value != 1 {
		t.Errorf("expected left operand 1, got %v", bop.Left)
	}
	right, ok := bop.Right.(*BinaryOperation)
	if !ok {
		t.Fatalf("expected right operand to be BinaryOperation, got %T", bop.Right)
	}
	if right.Operator != "*" {
		t.Errorf("expected right operator '*', got %s", right.Operator)
	}
	l2, ok := right.Left.(*IntConst)
	if !ok || l2.Value != 2 {
		t.Errorf("expected right left operand 2, got %v", right.Left)
	}
	r2, ok := right.Right.(*IntConst)
	if !ok || r2.Value != 3 {
		t.Errorf("expected right right operand 3, got %v", right.Right)
	}
}

func TestMethodCall(t *testing.T) {
	input := `obj@Type.method(1, 2)`
	tokens := tokenize(input)
	p := NewParser(tokens)
	expr, err := p.parseExpression(0)
	if err != nil {
		t.Fatalf("parseExpression error: %v", err)
	}
	mc, ok := expr.(*MethodCall)
	if !ok {
		t.Fatalf("expected MethodCall, got %T", expr)
	}
	ident, ok := mc.Object.(*Ident)
	if !ok || ident.Name != "obj" {
		t.Errorf("expected object 'obj', got %v", mc.Object)
	}
	if mc.TargetType != "Type" {
		t.Errorf("expected target type 'Type', got %s", mc.TargetType)
	}
	fc := mc.Method
	if fc.Ident != "method" {
		t.Errorf("expected method name 'method', got %s", fc.Ident)
	}
	if len(fc.Params) != 2 {
		t.Fatalf("expected 2 parameters, got %d", len(fc.Params))
	}
	p1, ok := fc.Params[0].(*IntConst)
	if !ok || p1.Value != 1 {
		t.Errorf("expected first parameter 1, got %v", fc.Params[0])
	}
	p2, ok := fc.Params[1].(*IntConst)
	if !ok || p2.Value != 2 {
		t.Errorf("expected second parameter 2, got %v", fc.Params[1])
	}
}

func TestLetExpression(t *testing.T) {
	input := `let a : Int <- 10, b : Int in a + b`
	tokens := tokenize(input)
	p := NewParser(tokens)
	expr, err := p.parseExpression(0)
	if err != nil {
		t.Fatalf("parseExpression error: %v", err)
	}
	letExpr, ok := expr.(*Let)
	if !ok {
		t.Fatalf("expected Let expression, got %T", expr)
	}
	if len(letExpr.Assignments) != 2 {
		t.Fatalf("expected 2 assignments in let, got %d", len(letExpr.Assignments))
	}
	// Check first assignment: a : Int <- 10
	assignA := letExpr.Assignments[0]
	if assignA.Ident != "a" || assignA.Type != "Int" {
		t.Errorf("expected first assignment 'a : Int', got %s : %s", assignA.Ident, assignA.Type)
	}
	aInit, ok := assignA.Init.(*IntConst)
	if !ok || aInit.Value != 10 {
		t.Errorf("expected first assignment init 10, got %v", assignA.Init)
	}
	// Second assignment: b : Int with no initializer
	assignB := letExpr.Assignments[1]
	if assignB.Ident != "b" || assignB.Type != "Int" {
		t.Errorf("expected second assignment 'b : Int', got %s : %s", assignB.Ident, assignB.Type)
	}
	if assignB.Init != nil {
		t.Errorf("expected second assignment with no initializer, got %v", assignB.Init)
	}
	// Body of let should be a binary operation: a + b
	bop, ok := letExpr.Body.(*BinaryOperation)
	if !ok || bop.Operator != "+" {
		t.Fatalf("expected let body to be BinaryOperation '+', got %T with op %v", letExpr.Body, bop)
	}
}

func TestCaseExpression(t *testing.T) {
    input := `case x of 
        l : String => "one"; 
        ll : String => "two"; 
        _ : String => "other"; 
    esac`
    tokens := tokenize(input)
    p := NewParser(tokens)
    expr, err := p.parseExpression(0)
    if err != nil {
        t.Fatalf("parseExpression error: %v", err)
    }
    caseExpr, ok := expr.(*Case)
    if !ok {
        t.Fatalf("expected Case expression, got %T", expr)
    }
    if caseExpr.Expr == nil {
        t.Errorf("expected case subject expression, got nil")
    }
    if len(caseExpr.TypeActions) != 3 {
        t.Fatalf("expected 3 type actions, got %d", len(caseExpr.TypeActions))
    }
    
    // First type action: "l : String => "one";"
    ta1 := caseExpr.TypeActions[0]
    if ta1.Ident != "l" {
        t.Errorf("expected first type action identifier 'l', got %s", ta1.Ident)
    }
    if ta1.Type != "String" {
        t.Errorf("expected first type to be 'String', got %s", ta1.Type)
    }
    str1, ok := ta1.Expr.(*StringConst)
    if !ok || str1.Value != "one" {
        t.Errorf("expected first type action expr \"one\", got %v", ta1.Expr)
    }

    // Second type action: "ll : String => "two";"
    ta2 := caseExpr.TypeActions[1]
    if ta2.Ident != "ll" {
        t.Errorf("expected second type action identifier 'll', got %s", ta2.Ident)
    }
    if ta2.Type != "String" {
        t.Errorf("expected second type to be 'String', got %s", ta2.Type)
    }
    str2, ok := ta2.Expr.(*StringConst)
    if !ok || str2.Value != "two" {
        t.Errorf("expected second type action expr \"two\", got %v", ta2.Expr)
    }

    // Third type action: "_ : String => "other";"
    ta3 := caseExpr.TypeActions[2]
    if ta3.Ident != "_" {
        t.Errorf("expected third type action identifier '_', got %s", ta3.Ident)
    }
    if ta3.Type != "String" {
        t.Errorf("expected third type to be 'String', got %s", ta3.Type)
    }
    str3, ok := ta3.Expr.(*StringConst)
    if !ok || str3.Value != "other" {
        t.Errorf("expected third type action expr \"other\", got %v", ta3.Expr)
    }
}




// TestComplexProgram parses a program with multiple classes, inheritance,
// methods with bodies, and attribute initialization.
func TestComplexProgram(t *testing.T) {
	input := `
		class Main {
		   main(): Int {
		      let a : Int <- 10, b : Int in a + b
		   };
		};
		class Other inherits Main {
		   greeting : String <- "Hello, world!";
		   compute(x: Int): Int {
		      if x < 0 then ~x else x fi
		   };
		};
	`
	tokens := tokenize(input)
	p := NewParser(tokens)
	prog, err := p.ParseProgram()
	if err != nil {
		t.Fatalf("ParseProgram() error: %v", err)
	}
	if len(prog.Classes) != 2 {
		t.Fatalf("expected 2 classes, got %d", len(prog.Classes))
	}
	// Check inheritance and method bodies.
	mainClass := prog.Classes[0]
	if mainClass.Name != "Main" {
		t.Errorf("expected first class name 'Main', got %s", mainClass.Name)
	}
	otherClass := prog.Classes[1]
	if otherClass.Inherits != "Main" {
		t.Errorf("expected Other to inherit from 'Main', got %s", otherClass.Inherits)
	}
	// Check that Other has at least one attribute and one method.
	if len(otherClass.Features) < 2 {
		t.Fatalf("expected Other to have at least 2 features, got %d", len(otherClass.Features))
	}
	// Check for a method called compute and test its body structure.
	var computeMethod *Method
	for _, feat := range otherClass.Features {
		if m, ok := feat.(*Method); ok && m.Ident == "compute" {
			computeMethod = m
			break
		}
	}
	if computeMethod == nil {
		t.Fatalf("expected method 'compute' in class Other")
	}
	// Assume computeMethod.Body is an If expression.
	ifExpr, ok := computeMethod.Body.(*If)
	if !ok {
		t.Fatalf("expected compute method body to be an If expression, got %T", computeMethod.Body)
	}
	// Check the condition of the if expression
	cond, ok := ifExpr.Condition.(*BinaryOperation)
	if !ok || cond.Operator != "<" {
		t.Errorf("expected if condition to be a binary operation with operator '<', got %T with op %s", ifExpr.Condition, getOp(cond))
	}
}

// TestNestedIfExpression tests nested if expressions with inner and outer branches.
func TestNestedIfExpression(t *testing.T) {
	// Nested if: if a < b then if c = d then 1 else 2 fi else 3 fi
	input := `
		if a < b then 
			if c = d then 1 else 2 fi
		else 
			3 
		fi
	`
	tokens := tokenize(input)
	p := NewParser(tokens)
	expr, err := p.parseExpression(0)
	if err != nil {
		t.Fatalf("parseExpression error: %v", err)
	}
	outerIf, ok := expr.(*If)
	if !ok {
		t.Fatalf("expected outer node to be If, got %T", expr)
	}
	// Outer condition should be a binary op: a < b
	cond, ok := outerIf.Condition.(*BinaryOperation)
	if !ok || cond.Operator != "<" {
		t.Errorf("expected outer if condition to be binary operation with '<', got %T with op %v", outerIf.Condition, getOp(cond))
	}
	innerIf, ok := outerIf.True.(*If)
	if !ok {
		t.Fatalf("expected outer if true branch to be an If, got %T", outerIf.True)
	}
	innerCond, ok := innerIf.Condition.(*BinaryOperation)
	if !ok || innerCond.Operator != "=" {
		t.Errorf("expected inner if condition to be binary operation '=' , got %T with op %v", innerIf.Condition, getOp(innerCond))
	}
	if _, ok := innerIf.True.(*IntConst); !ok {
		t.Errorf("expected inner if true branch to be IntConst, got %T", innerIf.True)
	}
	if _, ok := innerIf.False.(*IntConst); !ok {
		t.Errorf("expected inner if false branch to be IntConst, got %T", innerIf.False)
	}
	if _, ok := outerIf.False.(*IntConst); !ok {
		t.Errorf("expected outer if false branch to be IntConst, got %T", outerIf.False)
	}
}

func TestChainedMethodCall(t *testing.T) {
	// Example: obj.method1( 1, obj2.method2(2, 3) )
	input := `obj.method1(1, obj2.method2(2, 3))`
	tokens := tokenize(input)
	p := NewParser(tokens)
	expr, err := p.parseExpression(0)
	if err != nil {
		t.Fatalf("parseExpression error: %v", err)
	}
	mc1, ok := expr.(*MethodCall)
	if !ok {
		t.Fatalf("expected MethodCall, got %T", expr)
	}
	// Check primary method call on obj.method1
	ident, ok := mc1.Object.(*Ident)
	if !ok || ident.Name != "obj" {
		t.Errorf("expected object 'obj', got %v", mc1.Object)
	}
	if mc1.Method.Ident != "method1" {
		t.Errorf("expected method name 'method1', got %s", mc1.Method.Ident)
	}
	// method1 should have two parameters.
	if len(mc1.Method.Params) != 2 {
		t.Fatalf("expected 2 parameters for method1, got %d", len(mc1.Method.Params))
	}
	// First parameter should be IntConst 1.
	param1, ok := mc1.Method.Params[0].(*IntConst)
	if !ok || param1.Value != 1 {
		t.Errorf("expected first parameter to be IntConst(1), got %v", mc1.Method.Params[0])
	}
	// Second parameter should be another method call: obj2.method2(2,3)
	mc2, ok := mc1.Method.Params[1].(*MethodCall)
	if !ok {
		t.Fatalf("expected second parameter to be a MethodCall, got %T", mc1.Method.Params[1])
	}
	ident2, ok := mc2.Object.(*Ident)
	if !ok || ident2.Name != "obj2" {
		t.Errorf("expected inner method call object 'obj2', got %v", mc2.Object)
	}
	if mc2.Method.Ident != "method2" {
		t.Errorf("expected inner method call name 'method2', got %s", mc2.Method.Ident)
	}
	if len(mc2.Method.Params) != 2 {
		t.Fatalf("expected 2 parameters for method2, got %d", len(mc2.Method.Params))
	}
	// Validate inner method call parameters.
	p2, ok := mc2.Method.Params[0].(*IntConst)
	if !ok || p2.Value != 2 {
		t.Errorf("expected inner first parameter to be 2, got %v", mc2.Method.Params[0])
	}
	p3, ok := mc2.Method.Params[1].(*IntConst)
	if !ok || p3.Value != 3 {
		t.Errorf("expected inner second parameter to be 3, got %v", mc2.Method.Params[1])
	}
}

// TestUnaryAndBinaryPrecedence tests an expression with unary and binary operators to ensure
// precedence is handled correctly.
// Example: ~2 * 3 + 4  should parse as ((~2 * 3) + 4)
func TestUnaryAndBinaryPrecedence(t *testing.T) {
	input := "~2 * 3 + 4"
	tokens := tokenize(input)
	p := NewParser(tokens)
	expr, err := p.parseExpression(0)
	fmt.Println(expr)
	if err != nil {
		t.Fatalf("parseExpression error: %v", err)
	}
	bop, ok := expr.(*BinaryOperation)
	if !ok {
		t.Fatalf("expected top level BinaryOperation, got %T", expr)
	}
	if bop.Operator != "+" {
		t.Errorf("expected top operator '+', got %s", bop.Operator)
	}
	// Left branch should be (~2 * 3)
	mul, ok := bop.Left.(*BinaryOperation)
	if !ok {
		t.Fatalf("expected left branch to be BinaryOperation, got %T", bop.Left)
	}
	if mul.Operator != "*" {
		t.Errorf("expected multiplication operator '*', got %s", mul.Operator)
	}
	unary, ok := mul.Left.(*UnaryOperation)
	if !ok {
		t.Fatalf("expected left branch of '*' to be UnaryOperation, got %T", mul.Left)
	}
	if unary.Operator != "~" {
		t.Errorf("expected unary operator '~', got %s", unary.Operator)
	}
	 int2, ok := unary.Right.(*IntConst)
	 if !ok || int2.Value != 2 {
	 	t.Errorf("expected operand of '~' to be 2, got %v", unary.Right)
	 }
	int3, ok := mul.Right.(*IntConst)
	if !ok || int3.Value != 3 {
		t.Errorf("expected right operand of '*' to be 3, got %v", mul.Right)
	}
	int4, ok := bop.Right.(*IntConst)
	if !ok || int4.Value != 4 {
		t.Errorf("expected right operand of '+' to be 4, got %v", bop.Right)
	}
}


// class Looper {
// 	loop(): Object {
// 		while 1 loop
// 			x <- 0
// 		pool
// 	};
// }

func TestWhileLoop(t *testing.T) {
	input := `
		class Looper {
			iterate(): Object {
				while 1 loop
					x <- 0
				pool
			};
		};
	`
	tokens := tokenize(input)
	p := NewParser(tokens)
	prog, err := p.ParseProgram()
	if err != nil {
		t.Fatalf("ParseProgram() error: %v", err)
	}
	if len(prog.Classes) != 1 {
		t.Fatalf("expected 1 class, got %d", len(prog.Classes))
	}
	looper := prog.Classes[0]
	if looper.Name != "Looper" {
		t.Errorf("expected class name 'Looper', got %s", looper.Name)
	}
	if len(looper.Features) != 1 {
		t.Fatalf("expected 1 feature, got %d", len(looper.Features))
	}
	loopMethod, ok := looper.Features[0].(*Method)
	if !ok {
		t.Fatalf("expected method, got %T", looper.Features[0])
	}
	if loopMethod.Ident != "iterate" {
		t.Errorf("expected method name 'loop', got %s", loopMethod.Ident)
	}
	// Assume loopMethod.Body is a While expression.
	whileExpr, ok := loopMethod.Body.(*While)
	if !ok {
		t.Fatalf("expected While expression, got %T", loopMethod.Body)
	}
	// Check the condition of the while expression
	int1, ok := whileExpr.Condition.(*IntConst)
	if !ok || int1.Value != 1 {
		t.Errorf("expected while condition to be IntConst(1), got %v", whileExpr.Condition)
	}
}

func getOp(node *BinaryOperation) string {
	if node == nil {
		return "<nil>"
	}
	return node.Operator
}




func TestArrayExpression(t *testing.T) {
	input := `
		class ArrayTest {
			arr : Array <- Array[Int];
		};
	`
	tokens := tokenize(input)
	p := NewParser(tokens)
	prog, err := p.ParseProgram()
	if err != nil {
		t.Fatalf("ParseProgram() error: %v", err)
	}
	if len(prog.Classes) != 1 {
		t.Fatalf("expected 1 class, got %d", len(prog.Classes))
	}
	class := prog.Classes[0]
	if class.Name != "ArrayTest" {
		t.Errorf("expected class name 'ArrayTest', got %s", class.Name)
	}
	if len(class.Features) != 1 {
		t.Fatalf("expected 1 feature, got %d", len(class.Features))
	}
	attr, ok := class.Features[0].(*Attribute)
	if !ok {
		t.Fatalf("expected feature to be an Attribute, got %T", class.Features[0])
	}
	if attr.Ident != "arr" {
		t.Errorf("expected attribute name 'arr', got %s", attr.Ident)
	}
	if attr.Type != "Array" {
		t.Errorf("expected attribute type 'Array', got %s", attr.Type)
	}
	arrExpr, ok := attr.Init.(*ArrayExpression)
	if !ok {
		t.Fatalf("expected initializer to be ArrayExpression, got %T", attr.Init)
	}
	if arrExpr.ElemType != "Int" {
		t.Errorf("expected array element type 'Int', got %s", arrExpr.ElemType)
	}
}

