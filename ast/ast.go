package ast



// ----------------------------------------------------
//               AST DEFINITIONS
// ----------------------------------------------------

// Node is the interface for all AST nodes.
type Node interface {
	isNode()
}

// We define a bunch of structs for COOL AST. You can expand or revise as needed.

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

type Program struct {
    Classes []*Class
}

type Class struct {
    Name     string
    Inherits string
    Features []Node // mix of Methods and Attributes
}

type Method struct {
    Ident   string
    Type    string
    Formals []*Formal
    Body    Node
}

type Attribute struct {
    Ident string
    Type  string
    Init  Node // may be nil if no init
}

type Formal struct {
    Ident string
    Type  string
}

type Assignment struct {
    Ident *Ident
    Expr  Node
}

type MethodCall struct {
    Object     Node
    TargetType string         // optional @Type
    Method     *FunctionCall  // e.g. the 'f(x,y)'
}

type FunctionCall struct {
    Ident  string
    Params []Node
}

type If struct {
    Condition Node
    True      Node
    False     Node
}

type While struct {
    Condition Node
    Body      Node
}

type Block struct {
    Exprs []Node
}

type Case struct {
    Expr        Node
    TypeActions []*TypeAction
}

type TypeAction struct {
    Ident string
    Type  string
    Expr  Node
}

type Let struct {
    Assignments []*Attribute
    Body        Node
}

type New struct {
    Type string
}

type BinaryOperation struct {
    Operator string // "+", "-", "*", "/", "<", "<=", "=", or "<-"
    Left     Node
    Right    Node
}

type UnaryOperation struct {
    Operator string // "~", "not", "isvoid"
    Right    Node
}

type Ident struct {
    Name string
}

type Self struct{}

type IntConst struct {
    Value int
}

type BoolConst struct {
    Value bool
}

type StringConst struct {
    Value string
}
