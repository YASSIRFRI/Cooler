package parser

import (
    "cooler/lexer"
    "fmt"
    "strconv"
)

// ----------------------------------------------------
//               AST DEFINITIONS
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

const (
    _LOWEST = iota
    _ASSIGN      // (for "<-")
    _LOGIC       // <, <=, =
    _ADD         // +, -
    _MUL         // *, /
    _PREFIX      // unary operators (~, not, isvoid)
    _CALL        // method calls (DOT / AT / LPAREN)
)

var precedences = map[string]int{
    "LT":       _LOGIC,
    "LTEQ":     _LOGIC,
    "EQ":       _LOGIC,
    "PLUS":     _ADD,
    "MINUS":    _ADD,
    "MULTIPLY": _MUL,
    "DIVIDE":   _MUL,
    "DOT":      _CALL,
    "AT":       _CALL,
    "LPAREN":   _CALL,
}

type prefixParseFn func() (Node, error)
type infixParseFn func(Node) (Node, error)

// ----------------------------------------------------
//                   PARSER STRUCT
// ----------------------------------------------------

type Parser struct {
    tokens []*lexer.Token
    pos    int

    prefixParseFns map[string]prefixParseFn
    infixParseFns  map[string]infixParseFn
}

// errorf is a helper that attaches the current line/token context
// to the error message.
func (p *Parser) errorf(format string, args ...interface{}) error {
    tok := p.currentToken()
    line := -1
    tokenType := "EOF" // fallback if we have no current token
    var tokenVal interface{}

    if tok != nil {
        line = tok.Line
        tokenType = tok.Type
        tokenVal = tok.Value
    }

    prefix := fmt.Sprintf("[Line %d, token: %s, value: %v] ", line, tokenType, tokenVal)
    return fmt.Errorf(prefix+format, args...)
}

func NewParser(tokens []*lexer.Token) *Parser {
    p := &Parser{
        tokens:         tokens,
        pos:            0,
        prefixParseFns: make(map[string]prefixParseFn),
        infixParseFns:  make(map[string]infixParseFn),
    }

    // Prefix parsers:
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
    p.registerPrefix("ISVOID", p.parseUnaryOperation)
    p.registerPrefix("NOT", p.parseUnaryOperation)
    p.registerPrefix("TILDE", p.parseUnaryOperation)
    p.registerPrefix("INT_COMP", p.parseUnaryOperation)
    p.registerPrefix("CASE", p.parseCaseExpression)

    // Infix operators:
    p.registerInfix("PLUS", p.parseInfixExpression)
    p.registerInfix("MINUS", p.parseInfixExpression)
    p.registerInfix("MULTIPLY", p.parseInfixExpression)
    p.registerInfix("DIVIDE", p.parseInfixExpression)
    p.registerInfix("LT", p.parseInfixExpression)
    p.registerInfix("LTEQ", p.parseInfixExpression)
    p.registerInfix("EQ", p.parseInfixExpression)

    p.registerInfix("DOT", p.parseCallOrMethodCall)
    p.registerInfix("AT", p.parseCallOrMethodCall)
    p.registerInfix("LPAREN", p.parseCallOrMethodCall)

    return p
}

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
    if tok := p.peekToken(); tok != nil {
        if prec, ok := precedences[tok.Type]; ok {
            return prec
        }
    }
    return _LOWEST
}

func (p *Parser) registerPrefix(tokenType string, fn prefixParseFn) {
    p.prefixParseFns[tokenType] = fn
}

func (p *Parser) registerInfix(tokenType string, fn infixParseFn) {
    p.infixParseFns[tokenType] = fn
}

// ----------------------------------------------------
//               parseExpression (core)
// ----------------------------------------------------
func (p *Parser) parseExpression(precedence int) (Node, error) {
    tok := p.currentToken()
    if tok == nil {
        return nil, p.errorf("unexpected end of input")
    }

    prefix := p.prefixParseFns[tok.Type]
    if prefix == nil {
        return nil, p.errorf("no prefix parse function for token %s", tok.Type)
    }

    // Parse left side via prefix function:
    left, err := prefix()
    if err != nil {
        return nil, err
    }

    // Now see if there's any infix operator with higher precedence:
    for p.currentToken() != nil && precedence < p.curPrecedence() {
        current := p.currentToken().Type
        infix := p.infixParseFns[current]
        if infix == nil {
            break
        }
        // Let the infix function handle it:
        left, err = infix(left)
        if err != nil {
            return nil, err
        }
    }
    return left, nil
}

// ----------------------------------------------------
//              PREFIX PARSERS
// ----------------------------------------------------

// parseIdent also handles assignment "id <- expr" inline.
func (p *Parser) parseIdent() (Node, error) {
    tok := p.currentToken()
    if tok == nil {
        return nil, p.errorf("expected identifier, got nil token")
    }

    name, ok := tok.Value.(string)
    if !ok {
        return nil, p.errorf("identifier token value is not a string")
    }
    p.nextToken() // consume the ID

    // Check if next token is ASSIGN (i.e. "<-")
    if p.currentToken() != nil && p.currentToken().Type == "ASSIGN" {
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

    // If there's no "<-", then it's just an identifier.
    return &Ident{Name: name}, nil
}

func (p *Parser) parseIntConst() (Node, error) {
    tok := p.currentToken()
    if tok == nil {
        return nil, p.errorf("expected integer, got nil token")
    }
    strVal := fmt.Sprintf("%v", tok.Value)
    val, err := strconv.Atoi(strVal)
    if err != nil {
        return nil, p.errorf("could not parse integer %s", strVal)
    }
    p.nextToken()
    return &IntConst{Value: val}, nil
}

func (p *Parser) parseBoolConst() (Node, error) {
    tok := p.currentToken()
    if tok == nil {
        return nil, p.errorf("expected bool, got nil token")
    }
    boolVal, ok := tok.Value.(bool)
    if !ok {
        return nil, p.errorf("could not parse bool %v", tok.Value)
    }
    p.nextToken()
    return &BoolConst{Value: boolVal}, nil
}

func (p *Parser) parseStringConst() (Node, error) {
    tok := p.currentToken()
    if tok == nil {
        return nil, p.errorf("expected string, got nil token")
    }
    strVal, ok := tok.Value.(string)
    if !ok {
        return nil, p.errorf("could not parse string %v", tok.Value)
    }
    p.nextToken()
    return &StringConst{Value: strVal}, nil
}

func (p *Parser) parseSelf() (Node, error) {
    if p.currentToken() == nil {
        return nil, p.errorf("expected SELF, got nil token")
    }
    p.nextToken() // consume SELF
    return &Self{}, nil
}

// Distinguish (expr) from bare function call:
func (p *Parser) parseGroupedExpression() (Node, error) {
    if p.currentToken() == nil {
        return nil, p.errorf("expected '(' but got nil token")
    }
    p.nextToken() // consume '('

    exp, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
        return nil, p.errorf("expected RPAREN, got %v", p.currentToken())
    }
    p.nextToken() // consume ')'
    return exp, nil
}

func (p *Parser) parseBlockExpression() (Node, error) {
    // A block is: { expr1 ; expr2 ; ... exprN }
    if p.currentToken() == nil {
        return nil, p.errorf("expected '{', got nil token")
    }
    p.nextToken() // consume LBRACE

    var exprs []Node
    for p.currentToken() != nil && p.currentToken().Type != "RBRACE" {
        e, err := p.parseExpression(_LOWEST)
        if err != nil {
            return nil, err
        }
        exprs = append(exprs, e)

        if p.currentToken() == nil {
            return nil, p.errorf("unexpected end of input in block")
        }
        if p.currentToken().Type == "SEMICOLON" {
            p.nextToken() // consume semicolon
        } else if p.currentToken().Type != "RBRACE" {
            return nil, p.errorf("expected '}' or ';', got %v", p.currentToken())
        }
    }

    if p.currentToken() == nil || p.currentToken().Type != "RBRACE" {
        return nil, p.errorf("expected '}' at end of block, got %v", p.currentToken())
    }
    p.nextToken() // consume RBRACE
    return &Block{Exprs: exprs}, nil
}

func (p *Parser) parseIfExpression() (Node, error) {
    if p.currentToken() == nil {
        return nil, p.errorf("expected IF, got nil token")
    }
    p.nextToken() // consume IF
    cond, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "THEN" {
        return nil, p.errorf("expected THEN, got %v", p.currentToken())
    }
    p.nextToken() // consume THEN
    trueBranch, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "ELSE" {
        return nil, p.errorf("expected ELSE, got %v", p.currentToken())
    }
    p.nextToken() // consume ELSE
    falseBranch, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "FI" {
        return nil, p.errorf("expected FI, got %v", p.currentToken())
    }
    p.nextToken() // consume FI
    return &If{Condition: cond, True: trueBranch, False: falseBranch}, nil
}

func (p *Parser) parseWhileExpression() (Node, error) {
    if p.currentToken() == nil {
        return nil, p.errorf("expected WHILE, got nil token")
    }
    p.nextToken() // consume WHILE
    cond, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "LOOP" {
        return nil, p.errorf("expected LOOP, got %v", p.currentToken())
    }
    p.nextToken() // consume LOOP
    body, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "POOL" {
        return nil, p.errorf("expected POOL, got %v", p.currentToken())
    }
    p.nextToken() // consume POOL
    return &While{Condition: cond, Body: body}, nil
}

func (p *Parser) parseLetExpression() (Node, error) {
    // consume LET
    if p.currentToken() == nil {
        return nil, p.errorf("expected LET, got nil token")
    }
    p.nextToken()

    var attrs []*Attribute
    // parse one or more attributes separated by commas
    for {
        attrNode, err := p.parseAttrDef()
        if err != nil {
            return nil, err
        }
        attr, ok := attrNode.(*Attribute)
        if !ok {
            return nil, p.errorf("expected attribute in let, got %T", attrNode)
        }
        attrs = append(attrs, attr)

        if p.currentToken() != nil && p.currentToken().Type == "COMMA" {
            p.nextToken() // consume comma
        } else {
            break
        }
    }

    if p.currentToken() == nil || p.currentToken().Type != "IN" {
        return nil, p.errorf("expected IN, got %v", p.currentToken())
    }
    p.nextToken() // consume IN

    body, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    return &Let{Assignments: attrs, Body: body}, nil
}

func (p *Parser) parseNewExpression() (Node, error) {
    // consume NEW
    if p.currentToken() == nil {
        return nil, p.errorf("expected NEW, got nil token")
    }
    p.nextToken()
    tok := p.currentToken()
    if tok == nil || tok.Type != "TYPE" {
        return nil, p.errorf("expected TYPE after NEW, got %v", tok)
    }
    typeName := tok.Value.(string)
    p.nextToken()
    return &New{Type: typeName}, nil
}

func (p *Parser) parseUnaryOperation() (Node, error) {
    opTok := p.currentToken()
    if opTok == nil {
        return nil, p.errorf("expected unary operator, got nil token")
    }
    p.nextToken() // consume operator
    right, err := p.parseExpression(_PREFIX)
    if err != nil {
        return nil, err
    }
    return &UnaryOperation{Operator: opTok.Value.(string), Right: right}, nil
}

func (p *Parser) parseCaseExpression() (Node, error) {
    // consume CASE token
    if p.currentToken() == nil {
        return nil, p.errorf("expected CASE, got nil token")
    }
    p.nextToken()

    expr, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "OF" {
        return nil, p.errorf("expected OF after CASE, got %v", p.currentToken())
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
            return nil, p.errorf("expected ';' after case branch, got %v", p.currentToken())
        }
        p.nextToken() // consume semicolon
    }

    if p.currentToken() == nil || p.currentToken().Type != "ESAC" {
        return nil, p.errorf("expected ESAC at end of case, got %v", p.currentToken())
    }
    p.nextToken() // consume ESAC

    return &Case{
        Expr:        expr,
        TypeActions: actions,
    }, nil
}

func (p *Parser) parseTypeAction() (*TypeAction, error) {
    // id : TYPE => expr
    idTok := p.currentToken()
    if idTok == nil || idTok.Type != "ID" {
        return nil, p.errorf("expected ID in case branch, got %v", idTok)
    }
    ident := idTok.Value.(string)
    p.nextToken() // consume ID

    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, p.errorf("expected ':' in case branch, got %v", p.currentToken())
    }
    p.nextToken()

    typeTok := p.currentToken()
    if typeTok == nil || typeTok.Type != "TYPE" {
        return nil, p.errorf("expected TYPE in case branch, got %v", typeTok)
    }
    ty := typeTok.Value.(string)
    p.nextToken()

    if p.currentToken() == nil || p.currentToken().Type != "ACTION" {
        return nil, p.errorf("expected '=>' in case branch, got %v", p.currentToken())
    }
    p.nextToken() // consume '=>'

    expr, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    return &TypeAction{
        Ident: ident,
        Type:  ty,
        Expr:  expr,
    }, nil
}

// parseAttrDef is used for let-bindings or class attributes
func (p *Parser) parseAttrDef() (Node, error) {
    tok := p.currentToken()
    if tok == nil || tok.Type != "ID" {
        return nil, p.errorf("expected attribute identifier, got %v", tok)
    }
    idName := tok.Value.(string)
    p.nextToken()

    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, p.errorf("expected ':' after attribute identifier, got %v", p.currentToken())
    }
    p.nextToken()

    typeTok := p.currentToken()
    if typeTok == nil || typeTok.Type != "TYPE" {
        return nil, p.errorf("expected type after ':', got %v", typeTok)
    }
    typeName := typeTok.Value.(string)
    p.nextToken()

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
    if opToken == nil {
        return nil, p.errorf("expected infix operator, got nil token")
    }
    precedence := p.curPrecedence()
    opStr := fmt.Sprintf("%v", opToken.Value)

    p.nextToken() // consume operator

    right, err := p.parseExpression(precedence)
    if err != nil {
        return nil, err
    }
    return &BinaryOperation{
        Operator: opStr,
        Left:     left,
        Right:    right,
    }, nil
}

// ----------------------------------------------------
//    parseCallOrMethodCall
// ----------------------------------------------------
func (p *Parser) parseCallOrMethodCall(left Node) (Node, error) {
    opToken := p.currentToken()
    if opToken == nil {
        return nil, p.errorf("expected call symbol (DOT, AT, LPAREN), got nil token")
    }

    switch opToken.Type {
    case "DOT":
        // object.method(...)
        p.nextToken() // consume DOT
        fnCall, err := p.parseMethodNameAndArgs()
        if err != nil {
            return nil, err
        }
        // left is the object
        return &MethodCall{
            Object:     left,
            TargetType: "",
            Method:     fnCall,
        }, nil

    case "AT":
        // object @ Type . method(...)
        p.nextToken() // consume '@'
        tyTok := p.currentToken()
        if tyTok == nil || tyTok.Type != "TYPE" {
            return nil, p.errorf("expected TYPE after '@', got %v", tyTok)
        }
        targetType := tyTok.Value.(string)
        p.nextToken() // consume type

        if p.currentToken() == nil || p.currentToken().Type != "DOT" {
            return nil, p.errorf("expected DOT after '@ TYPE', got %v", p.currentToken())
        }
        p.nextToken() // consume DOT

        fnCall, err := p.parseMethodNameAndArgs()
        if err != nil {
            return nil, err
        }
        return &MethodCall{
            Object:     left,
            TargetType: targetType,
            Method:     fnCall,
        }, nil

    case "LPAREN":
        // Bare function call on an identifier:  id(...)
        identLeft, ok := left.(*Ident)
        if !ok {
            return nil, p.errorf("cannot do '(...)' after non-identifier %T", left)
        }
        p.nextToken() // consume '('
        params, err := p.parseParamsOpt()
        if err != nil {
            return nil, err
        }
        if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
            return nil, p.errorf("expected ')', got %v", p.currentToken())
        }
        p.nextToken() // consume ')'
        return &FunctionCall{
            Ident:  identLeft.Name,
            Params: params,
        }, nil

    default:
        return nil, p.errorf("unexpected token %q in parseCallOrMethodCall", opToken.Type)
    }
}

// ----------------------------------------------------
//  parseMethodNameAndArgs
//  This is used only after DOT or "obj @Type ."
// ----------------------------------------------------
func (p *Parser) parseMethodNameAndArgs() (*FunctionCall, error) {
    // We expect an ID for the method name:
    tok := p.currentToken()
    if tok == nil || tok.Type != "ID" {
        return nil, p.errorf("expected method name ID, got %v", tok)
    }
    methodName := tok.Value.(string)
    p.nextToken() // consume the method name

    if p.currentToken() == nil || p.currentToken().Type != "LPAREN" {
        return nil, p.errorf("expected '(', got %v", p.currentToken())
    }
    p.nextToken() // consume '('

    params, err := p.parseParamsOpt()
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
        return nil, p.errorf("expected ')', got %v", p.currentToken())
    }
    p.nextToken() // consume ')'

    return &FunctionCall{
        Ident:  methodName,
        Params: params,
    }, nil
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

func (p *Parser) parseFeature() (Node, error) {
    idTok := p.currentToken()
    if idTok == nil || idTok.Type != "ID" {
        return nil, p.errorf("expected feature identifier, got %v", idTok)
    }
    featName := idTok.Value.(string)
    p.nextToken() // consume the feature name

    if p.currentToken() == nil {
        return nil, p.errorf("unexpected end after feature name %s", featName)
    }

    switch p.currentToken().Type {
    case "LPAREN":
        // method definition
        return p.parseMethodDef(featName)
    case "COLON":
        // attribute definition
        return p.parseAttributeDef(featName)
    default:
        return nil, p.errorf("expected '(' or ':' after feature name %s, got %v", featName, p.currentToken())
    }
}

func (p *Parser) parseMethodDef(methodName string) (Node, error) {
    // Current token is LPAREN
    if p.currentToken() == nil || p.currentToken().Type != "LPAREN" {
        return nil, p.errorf("expected '(' after method name %s, got %v", methodName, p.currentToken())
    }
    p.nextToken() // consume '('

    formals, err := p.parseFormals()
    if err != nil {
        return nil, err
    }

    // expect ')'
    if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
        return nil, p.errorf("expected ')' after method formals for %s, got %v", methodName, p.currentToken())
    }
    p.nextToken() // consume ')'

    // expect ':'
    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, p.errorf("expected ':' after method formals for %s, got %v", methodName, p.currentToken())
    }
    p.nextToken() // consume ':'

    // expect TYPE
    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, p.errorf("expected return TYPE after ':' in method %s, got %v", methodName, p.currentToken())
    }
    retType := p.currentToken().Value.(string)
    p.nextToken() // consume TYPE

    // expect '{'
    if p.currentToken() == nil || p.currentToken().Type != "LBRACE" {
        return nil, p.errorf("expected '{' before method body in method %s, got %v", methodName, p.currentToken())
    }
    p.nextToken() // consume '{'

    // parse body as expression
    body, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }

    // expect '}'
    if p.currentToken() == nil || p.currentToken().Type != "RBRACE" {
        return nil, p.errorf("expected '}' after method body of %s, got %v", methodName, p.currentToken())
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
    // current token is "COLON", consume it
    p.nextToken()

    // expect TYPE
    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, p.errorf("expected TYPE after ':' in attribute definition %s, got %v", attrName, p.currentToken())
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

func (p *Parser) parseFormals() ([]*Formal, error) {
    var formals []*Formal

    if p.currentToken() == nil || p.currentToken().Type == "RPAREN" {
        // no formals
        return formals, nil
    }

    f, err := p.parseFormal()
    if err != nil {
        return nil, err
    }
    formals = append(formals, f)

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
        return nil, p.errorf("expected formal parameter name (ID), got %v", idTok)
    }
    name := idTok.Value.(string)
    p.nextToken() // consume ID

    // expect ':'
    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, p.errorf("expected ':' after formal parameter name %s, got %v", name, p.currentToken())
    }
    p.nextToken() // consume ':'

    // expect TYPE
    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, p.errorf("expected TYPE after ':' in formal for %s, got %v", name, p.currentToken())
    }
    ty := p.currentToken().Value.(string)
    p.nextToken() // consume TYPE

    return &Formal{Ident: name, Type: ty}, nil
}

// ----------------------------------------------------
//                 TOP-LEVEL PARSER
// ----------------------------------------------------

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
        return nil, p.errorf("no classes found")
    }
    return &Program{Classes: classes}, nil
}

func (p *Parser) parseClass() (*Class, error) {
    if p.currentToken() == nil || p.currentToken().Type != "CLASS" {
        return nil, p.errorf("expected CLASS keyword, got %v", p.currentToken())
    }
    p.nextToken() // consume CLASS

    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, p.errorf("expected class TYPE, got %v", p.currentToken())
    }
    className := p.currentToken().Value.(string)
    p.nextToken() // consume TYPE

    inherits := ""
    if p.currentToken() != nil && p.currentToken().Type == "INHERITS" {
        p.nextToken() // consume INHERITS
        if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
            return nil, p.errorf("expected TYPE after INHERITS, got %v", p.currentToken())
        }
        inherits = p.currentToken().Value.(string)
        p.nextToken() // consume TYPE
    }

    if p.currentToken() == nil || p.currentToken().Type != "LBRACE" {
        return nil, p.errorf("expected '{' in class %s, got %v", className, p.currentToken())
    }
    p.nextToken() // consume '{'

    features, err := p.parseFeatures()
    if err != nil {
        return nil, err
    }

    if p.currentToken() == nil || p.currentToken().Type != "RBRACE" {
        return nil, p.errorf("expected '}' in class %s, got %v", className, p.currentToken())
    }
    p.nextToken() // consume '}'

    if p.currentToken() == nil || p.currentToken().Type != "SEMICOLON" {
        return nil, p.errorf("expected ';' after class %s, got %v", className, p.currentToken())
    }
    p.nextToken() // consume ';'

    return &Class{Name: className, Inherits: inherits, Features: features}, nil
}

func (p *Parser) parseFeatures() ([]Node, error) {
    var features []Node
    for p.currentToken() != nil && p.currentToken().Type != "RBRACE" {
        f, err := p.parseFeature()
        if err != nil {
            return nil, err
        }
        if p.currentToken() == nil || p.currentToken().Type != "SEMICOLON" {
            return nil, p.errorf("expected ';' after feature definition, got %v", p.currentToken())
        }
        p.nextToken() // consume ';'
        features = append(features, f)
    }
    return features, nil
}
