package ast

import (
	"fmt"
	"strconv"
)

// ----------------------------------------------------
//               AST DEFINITIONS
// ----------------------------------------------------

type Node interface {
	isNode()
}

// Make sure each type implements Node.
func (*Program) isNode()         {}
func (*Class) isNode()           {}
func (*Method) isNode()          {}
func (*Attribute) isNode()       {}
func (*Formal) isNode()          {}
func (*Assignment) isNode()      {}
func (*MethodCall) isNode()      {}
func (*FunctionCall) isNode()    {}
func (*If) isNode()              {}
func (*While) isNode()           {}
func (*Block) isNode()           {}
func (*Case) isNode()            {}
func (*TypeAction) isNode()      {}
func (*Let) isNode()             {}
func (*New) isNode()             {}
func (*BinaryOperation) isNode() {}
func (*UnaryOperation) isNode()  {}
func (*Ident) isNode()           {}
func (*Self) isNode()            {}
func (*IntConst) isNode()        {}
func (*BoolConst) isNode()       {}
func (*StringConst) isNode()     {}

// Program is the root node for a COOL program.
type Program struct {
	Classes []*Class
}

// Class represents a class in COOL.
type Class struct {
	Name     string
	Inherits string
	Features []Node // Methods or Attributes
}

// Method represents a method definition.
type Method struct {
	Ident   string
	Type    string
	Formals []*Formal
	Body    Node
}

// Attribute represents a class attribute.
type Attribute struct {
	Ident string
	Type  string
	Init  Node // nil if no initialization provided
}

// Formal represents a formal parameter in a method.
type Formal struct {
	Ident string
	Type  string
}

// Assignment represents an assignment expression.
type Assignment struct {
	Ident *Ident
	Expr  Node
}

// MethodCall represents a method call expression with an explicit receiver.
type MethodCall struct {
	Object     Node
	TargetType string
	Method     *FunctionCall
}

// FunctionCall represents a function (or bare method) call.
type FunctionCall struct {
	Ident  string
	Params []Node
}

// If represents an if-then-else expression.
type If struct {
	Condition Node
	True      Node
	False     Node
}

// While represents a while loop.
type While struct {
	Condition Node
	Body      Node
}

// Block represents a block of expressions.
type Block struct {
	Exprs []Node
}

// Case represents a case expression.
type Case struct {
	Expr        Node
	TypeActions []*TypeAction
}

// TypeAction represents a branch in a case expression.
type TypeAction struct {
	Ident string
	Type  string
	Expr  Node
}

// Let represents a let expression.
type Let struct {
	Assignments []*Attribute
	Body        Node
}

// New represents an object instantiation.
type New struct {
	Type string
}

// BinaryOperation represents a binary operator expression.
type BinaryOperation struct {
	Operator string // e.g. "+", "-", "*", "/", "<", "<=", "="
	Left     Node
	Right    Node
}

// UnaryOperation represents a unary operator expression.
type UnaryOperation struct {
	Operator string // e.g. "~", "not", "isvoid"
	Right    Node
}

// Ident represents an identifier.
type Ident struct {
	Name string
}

// Self represents the SELF keyword.
type Self struct{}

// IntConst represents an integer constant.
type IntConst struct {
	Value int
}

// BoolConst represents a boolean constant.
type BoolConst struct {
	Value bool
}

// StringConst represents a string constant.
type StringConst struct {
	Value string
}

// (Optional) You can keep utility functions here too. For example, you may
// want to include a String method to pretty-print nodes.
func (i *IntConst) String() string {
	return strconv.Itoa(i.Value)
}

func (i *Ident) String() string {
	return i.Name
}

func (u *UnaryOperation) String() string {
	return fmt.Sprintf("(%s %v)", u.Operator, u.Right)
}

// …and so on.
