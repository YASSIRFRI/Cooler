package parser

import (
	"cooler/lexer"
	"errors"
	"fmt"
	"strconv"
)

// ----------------------------------------------------
//               AST DEFINITIONS (unchanged)
// ----------------------------------------------------

type Node interface{ isNode() }

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
    Features []Node // Methods or Attributes
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
    Init  Node // nil if no init
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
    TargetType string
    Method     *FunctionCall
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
    Operator string // +, -, *, /, <, <=, =, etc.
    Left     Node
    Right    Node
}

type UnaryOperation struct {
    Operator string // ~, not, isvoid, etc.
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

// ----------------------------------------------------
//              Pratt Parsing – Setup
// ----------------------------------------------------

// Precedence levels – you can adjust these as needed.
const (
    _LOWEST = iota
    _ASSIGN      // (for "<-")
    _LOGIC       // <, <=, =
    _ADD         // +, -
    _MUL         // *, /
    _PREFIX      // unary operators (~, not, isvoid)
    _CALL        // method calls (DOT / AT)
)

var precedences = map[string]int{
    // We do NOT treat ASSIGN as a normal infix operator here (explicitly handled).
    "LT":       _LOGIC,
    "LTEQ":     _LOGIC,
    "EQ":       _LOGIC,
    "PLUS":     _ADD,
    "MINUS":    _ADD,
    "MULTIPLY": _MUL,
    "DIVIDE":   _MUL,
    "DOT":      _CALL,
    "AT":       _CALL,
}

// Define function types for prefix and infix parsers.
type prefixParseFn func() (Node, error)
type infixParseFn func(Node) (Node, error)

// ----------------------------------------------------
//                   PARSER STRUCT
// ----------------------------------------------------

type Parser struct {
    tokens []*lexer.Token
    pos    int
    errors []string

    prefixParseFns map[string]prefixParseFn
    infixParseFns  map[string]infixParseFn
}

func NewParser(tokens []*lexer.Token) *Parser {
    p := &Parser{
        tokens:         tokens,
        pos:            0,
        errors:         []string{},
        prefixParseFns: make(map[string]prefixParseFn),
        infixParseFns:  make(map[string]infixParseFn),
    }

    // Register prefix parse functions:
    p.registerPrefix("ID", p.parseIdent)
    p.registerPrefix("INTEGER", p.parseIntConst)
    p.registerPrefix("BOOL", p.parseBoolConst)
    p.registerPrefix("STRING", p.parseStringConst)
    p.registerPrefix("SELF", p.parseSelf)
    p.registerPrefix("LPAREN", p.parseGroupedExpression)
    p.registerPrefix("LBRACE", p.parseBlockExpression)
    p.registerPrefix("IF", p.parseIfExpression)
    p.registerPrefix("WHILE", p.parseWhileExpression)
    p.registerPrefix("LET", p.parseLetExpression)
    p.registerPrefix("NEW", p.parseNewExpression)
    // You could also register "CASE", "NOT", "ISVOID", "~", etc. if desired:
    // p.registerPrefix("CASE", p.parseCaseExpression)
    p.registerPrefix("ISVOID", p.parseUnaryOperation)
    p.registerPrefix("NOT", p.parseUnaryOperation)
    p.registerPrefix("TILDE", p.parseUnaryOperation)
	p.registerPrefix("INT_COMP", p.parseUnaryOperation)

    // Register infix parse functions:
    p.registerInfix("PLUS", p.parseInfixExpression)
    p.registerInfix("MINUS", p.parseInfixExpression)
    p.registerInfix("MULTIPLY", p.parseInfixExpression)
    p.registerInfix("DIVIDE", p.parseInfixExpression)
    p.registerInfix("LT", p.parseInfixExpression)
    p.registerInfix("LTEQ", p.parseInfixExpression)
    p.registerInfix("EQ", p.parseInfixExpression)
    p.registerInfix("DOT", p.parseCallOrMethodCall)
    p.registerInfix("AT", p.parseCallOrMethodCall)



    // NOTE: If you prefer to treat "<-" as an infix operator, you can do:
    // p.registerInfix("ASSIGN", p.parseAssignmentExpression)
    // ... but the code comments suggest doing it separately in parseIdent.

    return p
}

// Utility functions:
func (p *Parser) currentToken() *lexer.Token {
    if p.pos >= len(p.tokens) {
        return nil
    }
    return p.tokens[p.pos]
}

func (p *Parser) peekToken() *lexer.Token {
    if p.pos+1 >= len(p.tokens) {
        return nil
    }
    return p.tokens[p.pos+1]
}

func (p *Parser) nextToken() {
    p.pos++
}

func (p *Parser) curPrecedence() int {
    if tok := p.currentToken(); tok != nil {
        if prec, ok := precedences[tok.Type]; ok {
            return prec
        }
    }
    return _LOWEST
}

func (p *Parser) peekPrecedence() int {
	fmt.Println("peeking")
	fmt.Println(p.peekToken())
    if tok := p.peekToken(); tok != nil {
		fmt.Println(("getting PeekToken"),tok.Type)
        if prec, ok := precedences[tok.Type]; ok {
            return prec
        }
    }
    return _LOWEST
}

// Registration functions for prefix/infix parsers:
func (p *Parser) registerPrefix(tokenType string, fn prefixParseFn) {
    p.prefixParseFns[tokenType] = fn
}

func (p *Parser) registerInfix(tokenType string, fn infixParseFn) {
    p.infixParseFns[tokenType] = fn
}

// ----------------------------------------------------
//           Expression Parsing (Pratt Parser)
// ----------------------------------------------------

func (p *Parser) parseExpression(precedence int) (Node, error) {
    tok := p.currentToken()
    if tok == nil {
        return nil, errors.New("unexpected end of input")
    }
	fmt.Println("Current Tok",tok,tok.Type)
    prefix := p.prefixParseFns[tok.Type]
    if prefix == nil {
		fmt.Println(tok.Type)
		return nil, nil
    }else{
		fmt.Println(tok.Type)
	}
    left, err := prefix()
	fmt.Println("Left",left)
    if err != nil {
        return nil, err
    }
	fmt.Println("Should be lt",p.currentToken())
	fmt.Println("Peekpre",p.curPrecedence())
	fmt.Println("Precedence",precedence)
    for p.currentToken() != nil && precedence < p.curPrecedence() {
        current := p.currentToken().Type
		fmt.Println("PeekType",current)
        infix := p.infixParseFns[current]
		fmt.Println("Infix",infix)
        if infix == nil {
            break
        }
        left, err = infix(left)
        if err != nil {
            return nil, err
        }else{
			fmt.Println("Infix parsed",left)
		}
    }
	fmt.Println("Returning",left)
    return left, nil
}

// ----------------------------------------------------
//              PREFIX PARSERS
// ----------------------------------------------------


// parseIdent also handles assignment "id <- expr" inline, as the code
// comment says we don't treat '<-' as a normal infix operator.
func (p *Parser) parseIdent() (Node, error) {
    tok := p.currentToken()
    if tok == nil {
        return nil, errors.New("expected identifier, got nil")
    }

    name := tok.Value.(string)
    p.nextToken() // consume the ID

    // Check if next token is ASSIGN (i.e. "<-")
    if p.currentToken() != nil && p.currentToken().Type == "ASSIGN" {
        // parse assignment
        p.nextToken() // consume ASSIGN
        right, err := p.parseExpression(_LOWEST)
        if err != nil {
            return nil, err
        }
        return &Assignment{
            Ident: &Ident{Name: name},
            Expr:  right,
        }, nil
    }

    return &Ident{Name: name}, nil
}

func (p *Parser) parseIntConst() (Node, error) {
    tok := p.currentToken()
    strVal := fmt.Sprintf("%v", tok.Value)
    val, err := strconv.Atoi(strVal)
    if err != nil {
        return nil, fmt.Errorf("could not parse integer %s", strVal)
    }
    p.nextToken()
    return &IntConst{Value: val}, nil
}

func (p *Parser) parseBoolConst() (Node, error) {
    tok := p.currentToken()
    boolVal, ok := tok.Value.(bool)
    if !ok {
        return nil, fmt.Errorf("could not parse bool %v", tok.Value)
    }
    p.nextToken()
    return &BoolConst{Value: boolVal}, nil
}

func (p *Parser) parseStringConst() (Node, error) {
    tok := p.currentToken()
    strVal, ok := tok.Value.(string)
    if !ok {
        return nil, fmt.Errorf("could not parse string %v", tok.Value)
    }
    p.nextToken()
    return &StringConst{Value: strVal}, nil
}

func (p *Parser) parseSelf() (Node, error) {
    p.nextToken() // consume SELF
    return &Self{}, nil
}

func (p *Parser) parseGroupedExpression() (Node, error) {
    // Consume LPAREN
    p.nextToken()
    exp, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    // Expect RPAREN
    if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
        return nil, fmt.Errorf("expected RPAREN, got %v", p.currentToken())
    }
    p.nextToken()
    return exp, nil
}

func (p *Parser) parseBlockExpression() (Node, error) {
    // A block is: { expr1 ; expr2 ; ... exprN }
    p.nextToken() // consume LBRACE

    var exprs []Node
    for p.currentToken() != nil && p.currentToken().Type != "RBRACE" {
        e, err := p.parseExpression(_LOWEST)
        if err != nil {
            return nil, err
        }
        exprs = append(exprs, e)
        // Each expression in a block is typically followed by a SEMICOLON,
        // unless it's the last one and we see RBRACE.
        if p.currentToken() == nil {
            return nil, errors.New("unexpected end of input in block")
        }
        if p.currentToken().Type == "SEMICOLON" {
            p.nextToken() // consume semicolon
            // continue reading next expression if not RBRACE
        } else if p.currentToken().Type != "RBRACE" {
            return nil, fmt.Errorf("expected '}' or ';', got %v", p.currentToken())
        }
    }

    if p.currentToken() == nil || p.currentToken().Type != "RBRACE" {
        return nil, fmt.Errorf("expected '}' at end of block, got %v", p.currentToken())
    }
    p.nextToken() // consume RBRACE
    return &Block{Exprs: exprs}, nil
}

func (p *Parser) parseIfExpression() (Node, error) {
    p.nextToken()
	//parse condition
	fmt.Println("Parsing condition",p.currentToken())
    cond, err := p.parseExpression(0)
	fmt.Println("Parsed condition",cond)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "THEN" {
        return nil, fmt.Errorf("expected THEN, got %v", p.currentToken())
    }
    p.nextToken()
    trueBranch, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "ELSE" {
        return nil, fmt.Errorf("expected ELSE, got %v", p.currentToken())
    }
    p.nextToken()
    falseBranch, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "FI" {
        return nil, fmt.Errorf("expected FI, got %v", p.currentToken())
    }
    p.nextToken()
    return &If{Condition: cond, True: trueBranch, False: falseBranch}, nil
}

func (p *Parser) parseWhileExpression() (Node, error) {
    // Consume WHILE
    p.nextToken()
    cond, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "LOOP" {
        return nil, fmt.Errorf("expected LOOP, got %v", p.currentToken())
    }
    p.nextToken()
    body, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "POOL" {
        return nil, fmt.Errorf("expected POOL, got %v", p.currentToken())
    }
    p.nextToken()
    return &While{Condition: cond, Body: body}, nil
}

func (p *Parser) parseLetExpression() (Node, error) {
    // Consume LET
    p.nextToken()

    // For simplicity, parse a single or multiple attributes separated by commas
    // Then "IN" expression. (The “multi-let” approach:  let x : Int <- 1, y : String in ... )

    var attrs []*Attribute

    // We expect at least one attribute
    for {
        attrNode, err := p.parseAttrDef()
        if err != nil {
            return nil, err
        }
        attr, ok := attrNode.(*Attribute)
        if !ok {
            return nil, fmt.Errorf("expected attribute in let, got %T", attrNode)
        }
        attrs = append(attrs, attr)

        // If the next token is COMMA, parse another attribute
        if p.currentToken() != nil && p.currentToken().Type == "COMMA" {
            p.nextToken() // consume comma
        } else {
            break
        }
    }

    if p.currentToken() == nil || p.currentToken().Type != "IN" {
        return nil, fmt.Errorf("expected IN, got %v", p.currentToken())
    }
    p.nextToken()

    body, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    return &Let{Assignments: attrs, Body: body}, nil
}

func (p *Parser) parseNewExpression() (Node, error) {
    // Consume NEW
    p.nextToken()
    tok := p.currentToken()
    if tok == nil || tok.Type != "TYPE" {
        return nil, fmt.Errorf("expected TYPE after NEW, got %v", tok)
    }
    typeName := tok.Value.(string)
    p.nextToken()
    return &New{Type: typeName}, nil
}



func (p *Parser) parseUnaryOperation() (Node, error) {
	// Consume the operator token
	opTok := p.currentToken()
	p.nextToken()

	right, err := p.parseExpression(_PREFIX)
	if err != nil {
		return nil, err
	}
	return &UnaryOperation{Operator: opTok.Value.(string), Right: right}, nil
}

// Optionally, parse a CASE expression if you need it:
/*
func (p *Parser) parseCaseExpression() (Node, error) {
    // Consume CASE
    p.nextToken()
    expr, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    // Expect OF
    if p.currentToken() == nil || p.currentToken().Type != "OF" {
        return nil, fmt.Errorf("expected OF after CASE, got %v", p.currentToken())
    }
    p.nextToken()

    var actions []*TypeAction
    for p.currentToken() != nil && p.currentToken().Type != "ESAC" {
        ta, err := p.parseTypeAction()
        if err != nil {
            return nil, err
        }
        actions = append(actions, ta)
        if p.currentToken() == nil || p.currentToken().Type != "SEMICOLON" {
            return nil, errors.New("expected ';' after case branch")
        }
        p.nextToken() // consume SEMICOLON
    }
    if p.currentToken() == nil || p.currentToken().Type != "ESAC" {
        return nil, errors.New("expected ESAC at end of case")
    }
    p.nextToken() // consume ESAC
    return &Case{Expr: expr, TypeActions: actions}, nil
}

func (p *Parser) parseTypeAction() (*TypeAction, error) {
    // id : TYPE => expr
    idTok := p.currentToken()
    if idTok == nil || idTok.Type != "ID" {
        return nil, errors.New("expected ID in case branch")
    }
    ident := idTok.Value.(string)
    p.nextToken()

    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, errors.New("expected ':' in case branch")
    }
    p.nextToken()

    typeTok := p.currentToken()
    if typeTok == nil || typeTok.Type != "TYPE" {
        return nil, errors.New("expected TYPE in case branch")
    }
    ty := typeTok.Value.(string)
    p.nextToken()

    if p.currentToken() == nil || p.currentToken().Type != "DARROW" {
        return nil, errors.New("expected '=>' in case branch")
    }
    p.nextToken()

    expr, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    return &TypeAction{Ident: ident, Type: ty, Expr: expr}, nil
}
*/

// parseAttrDef is used in "let" and can also be used for attributes:
func (p *Parser) parseAttrDef() (Node, error) {
    tok := p.currentToken()
    if tok == nil || tok.Type != "ID" {
        return nil, errors.New("expected attribute identifier")
    }
    idName := tok.Value.(string)
    p.nextToken()

    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, errors.New("expected ':' after attribute identifier")
    }
    p.nextToken()

    typeTok := p.currentToken()
    if typeTok == nil || typeTok.Type != "TYPE" {
        return nil, errors.New("expected type after ':'")
    }
    typeName := typeTok.Value.(string)
    p.nextToken()

    // Optionally parse an initialization (using ASSIGN)
    var initExpr Node
    if p.currentToken() != nil && p.currentToken().Type == "ASSIGN" {
        p.nextToken() // consume '<-'
        e, err := p.parseExpression(_LOWEST)
        if err != nil {
            return nil, err
        }
        initExpr = e
    }

    return &Attribute{
        Ident: idName,
        Type:  typeName,
        Init:  initExpr,
    }, nil
}

// ----------------------------------------------------
//              INFIX PARSERS
// ----------------------------------------------------

func (p *Parser) parseInfixExpression(left Node) (Node, error) {
    opToken := p.currentToken()
    precedence := p.curPrecedence()

    // The operator string (for +, -, <, etc.) is typically in Value
    // or you might store it in Type. Adjust as needed.
	fmt.Println("OpToken",opToken.Value)
	opStr := fmt.Sprintf("%v", opToken.Value)

    p.nextToken() 

    right, err := p.parseExpression(precedence)
	fmt.Println("Right from infixExpression",right)
    if err != nil {
        return nil, err
    }
    return &BinaryOperation{
        Operator: opStr,
        Left:     left,
        Right:    right,
    }, nil
}

// parseCallOrMethodCall handles expressions like `obj.foo(...)` or `obj@Type.foo(...)`.
func (p *Parser) parseCallOrMethodCall(left Node) (Node, error) {
    opToken := p.currentToken() // DOT or AT
    var targetType string

    if opToken.Type == "AT" {
        // 'obj @ SomeType . method(...)'
        p.nextToken() // consume '@'
        tyTok := p.currentToken()
        if tyTok == nil || tyTok.Type != "TYPE" {
            return nil, fmt.Errorf("expected TYPE after '@', got %v", tyTok)
        }
        targetType = tyTok.Value.(string)
        p.nextToken() // consume type

        // expect DOT
        if p.currentToken() == nil || p.currentToken().Type != "DOT" {
            return nil, fmt.Errorf("expected DOT after '@ TYPE', got %v", p.currentToken())
        }
        p.nextToken() // consume DOT
    } else {
        // For a DOT call, just consume the '.' token
        p.nextToken()
    }

    fnCall, err := p.parseFunctionCall()
    if err != nil {
        return nil, err
    }
    return &MethodCall{
        Object:     left,
        TargetType: targetType,
        Method:     fnCall,
    }, nil
}

// parseFunctionCall parses something like `myMethod(expr1, expr2, ...)`
func (p *Parser) parseFunctionCall() (*FunctionCall, error) {
    tok := p.currentToken()
    if tok == nil || tok.Type != "ID" {
        return nil, fmt.Errorf("expected method name, got %v", tok)
    }
    methodName := tok.Value.(string)
    p.nextToken() // consume method name

    if p.currentToken() == nil || p.currentToken().Type != "LPAREN" {
        return nil, fmt.Errorf("expected '(', got %v", p.currentToken())
    }
    p.nextToken() // consume '('

    params, err := p.parseParamsOpt()
    if err != nil {
        return nil, err
    }

    if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
        return nil, fmt.Errorf("expected ')', got %v", p.currentToken())
    }
    p.nextToken() // consume ')'

    return &FunctionCall{Ident: methodName, Params: params}, nil
}

// parseParamsOpt parses zero or more expressions separated by commas, stopping at ')'.
func (p *Parser) parseParamsOpt() ([]Node, error) {
    var params []Node

    // If the next token is RPAREN, then there are no parameters.
    if p.currentToken() != nil && p.currentToken().Type == "RPAREN" {
        return params, nil
    }

    // Parse first expression
    exp, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    params = append(params, exp)

    // Parse additional parameters (if any) separated by COMMA
    for p.currentToken() != nil && p.currentToken().Type == "COMMA" {
        p.nextToken() // consume comma
        exp, err := p.parseExpression(_LOWEST)
        if err != nil {
            return nil, err
        }
        params = append(params, exp)
    }
    return params, nil
}

// ----------------------------------------------------
//               PARSING FEATURES (CLASS BODY)
// ----------------------------------------------------

// parseFeature decides whether it is a method or an attribute, based on the next token.
func (p *Parser) parseFeature() (Node, error) {
    // We expect an ID for the feature name:
    idTok := p.currentToken()
	fmt.Println("IDTok",idTok)
    if idTok == nil || idTok.Type != "ID" {
        return nil, errors.New("expected feature identifier")
    }
    featName := idTok.Value.(string)
    p.nextToken() 

    switch p.currentToken().Type {
    case "LPAREN":
        // method definition
        return p.parseMethodDef(featName)
    case "COLON":
        // attribute definition
        return p.parseAttributeDef(featName)
    default:
        return nil, fmt.Errorf("expected '(' or ':' after feature name, got %v", p.currentToken())
    }
}

func (p *Parser) parseMethodDef(methodName string) (Node, error) {
    // we are after the ID, which was followed by '('
    // current token is "LPAREN"
    p.nextToken() // consume '('

    formals, err := p.parseFormals()
    if err != nil {
        return nil, err
    }
	for _,f := range formals{
		fmt.Println("Formals",f)
	}

    // expect ')'
    if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
        return nil, errors.New("expected ')' after method formals")
    }
    p.nextToken() // consume ')'

    // expect ':'
    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, errors.New("expected ':' after method formals")
    }
    p.nextToken() // consume ':'

    // expect TYPE
    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, errors.New("expected return TYPE after ':'")
    }
    retType := p.currentToken().Value.(string)
    p.nextToken() // consume TYPE

    // expect '{'
    if p.currentToken() == nil || p.currentToken().Type != "LBRACE" {
        return nil, errors.New("expected '{' before method body")
    }
    p.nextToken() // consume '{'

    // parse body as expression
    body, err := p.parseExpression(_LOWEST)
	fmt.Println("Body",body)
	fmt.Println("Current Token",p.currentToken())
    if err != nil {
        return nil, err
    }
	//expect ';'
	if p.currentToken() == nil || p.currentToken().Type != "SEMICOLON" {
		return nil, errors.New("expected ';' after method body")
	}
	p.nextToken() // consume ';'

    // expect '}'
    if p.currentToken() == nil || p.currentToken().Type != "RBRACE" {
        return nil, errors.New("expected '}' after method body")
    }
    p.nextToken() // consume '}'

    return &Method{
        Ident:   methodName,
        Type:    retType,
        Formals: formals,
        Body:    body,
    }, nil
}

func (p *Parser) parseAttributeDef(attrName string) (Node, error) {
    // we're after the ID, next token was "COLON"
    p.nextToken() // consume ':'
    // expect TYPE
    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, errors.New("expected TYPE after ':' in attribute definition")
    }
    attrType := p.currentToken().Value.(string)
    p.nextToken() // consume TYPE

    var initExpr Node
    // optional '<-' expr
    if p.currentToken() != nil && p.currentToken().Type == "ASSIGN" {
        p.nextToken() // consume '<-'
        e, err := p.parseExpression(_LOWEST)
        if err != nil {
            return nil, err
        }
        initExpr = e
    }

    return &Attribute{
        Ident: attrName,
        Type:  attrType,
        Init:  initExpr,
    }, nil
}

// parseFormals parses zero or more formals of the form: "id : TYPE" separated by commas.
func (p *Parser) parseFormals() ([]*Formal, error) {
    var formals []*Formal

    // if next token is RPAREN, then no formals
    if p.currentToken() == nil || p.currentToken().Type == "RPAREN" {
        return formals, nil
    }

    // parse first formal
    f, err := p.parseFormal()
    if err != nil {
        return nil, err
    }
    formals = append(formals, f)

    // parse additional formals if we see commas
    for p.currentToken() != nil && p.currentToken().Type == "COMMA" {
        p.nextToken() // consume comma
        f, err := p.parseFormal()
        if err != nil {
            return nil, err
        }
        formals = append(formals, f)
    }
    return formals, nil
}

// parseFormal expects "id : TYPE"
func (p *Parser) parseFormal() (*Formal, error) {
    // expect ID
    idTok := p.currentToken()
    if idTok == nil || idTok.Type != "ID" {
        return nil, errors.New("expected formal parameter name (ID)")
    }
    name := idTok.Value.(string)
    p.nextToken() // consume ID

    // expect ':'
    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, errors.New("expected ':' after formal parameter name")
    }
    p.nextToken() // consume ':'

    // expect TYPE
    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, errors.New("expected TYPE after ':' in formal")
    }
    ty := p.currentToken().Value.(string)
    p.nextToken() // consume TYPE

    return &Formal{Ident: name, Type: ty}, nil
}

// ----------------------------------------------------
//                 TOP-LEVEL PARSER
// ----------------------------------------------------

// ParseProgram parses the entire COOL program (sequence of class definitions).
func (p *Parser) ParseProgram() (*Program, error) {
    var classes []*Class

    for p.currentToken() != nil {
        cl, err := p.parseClass()
        if err != nil {
            return nil, err
        }
        classes = append(classes, cl)
    }

    if len(classes) == 0 {
        return nil, fmt.Errorf("no classes found")
    }
    return &Program{Classes: classes}, nil
}

func (p *Parser) parseClass() (*Class, error) {
    if p.currentToken() == nil || p.currentToken().Type != "CLASS" {
        return nil, errors.New("expected CLASS keyword")
    }
	fmt.Println("Parsing class",p.currentToken())
    p.nextToken() 

    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, errors.New("expected class TYPE")
    }
    className := p.currentToken().Value.(string)
	fmt.Println("Class name",className)
    p.nextToken() 

    // Optional INHERITS
    inherits := ""
    if p.currentToken() != nil && p.currentToken().Type == "INHERITS" {
        p.nextToken() // consume INHERITS
        if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
            return nil, errors.New("expected TYPE after INHERITS")
        }
        inherits = p.currentToken().Value.(string)
        p.nextToken() // consume TYPE
    }
    // Expect LBRACE for feature list
    if p.currentToken() == nil || p.currentToken().Type != "LBRACE" {
        return nil, errors.New("expected '{' in class")
    }
    p.nextToken() // consume '{'

    // Parse features until we see RBRACE
    features, err := p.parseFeatures()
    if err != nil {
        return nil, err
    }

    // Expect RBRACE
    if p.currentToken() == nil || p.currentToken().Type != "RBRACE" {
        return nil, errors.New("expected '}' in class")
    }
    p.nextToken() // consume '}'

    // Expect SEMICOLON after class
    if p.currentToken() == nil || p.currentToken().Type != "SEMICOLON" {
        return nil, errors.New("expected ';' after class")
    }
    p.nextToken() // consume ';'

    return &Class{Name: className, Inherits: inherits, Features: features}, nil
}

func (p *Parser) parseFeatures() ([]Node, error) {
    var features []Node
    // Keep parsing features until '}' or end of file
    for p.currentToken() != nil && p.currentToken().Type != "RBRACE" {
        f, err := p.parseFeature()
		fmt.Println("Feature",f)
        if err != nil {
            return nil, err
        }
        // After a feature definition, expect a semicolon
        if p.currentToken() == nil || p.currentToken().Type != "SEMICOLON" {
            return nil, fmt.Errorf("expected ';' after feature definition, got %v", p.currentToken())
        }
        p.nextToken() // consume semicolon
        features = append(features, f)
    }
    return features, nil
}
