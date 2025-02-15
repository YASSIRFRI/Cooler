package parser

import (
    "cooler/lexer"
    "errors"
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
        return nil, errors.New("unexpected end of input")
    }

    prefix := p.prefixParseFns[tok.Type]
    if prefix == nil {
        return nil, fmt.Errorf("no prefix parse function for token %s", tok.Type)
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
        return nil, errors.New("expected identifier, got nil")
    }

    name := tok.Value.(string)
    p.nextToken() //  the ID

    // Check if next token is ASSIGN (i.e. "<-")
    if p.currentToken() != nil && p.currentToken().Type == "ASSIGN" {
        // parse assignment
        p.nextToken() //  ASSIGN
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
    p.nextToken() //  SELF
    return &Self{}, nil
}

// Distinguish (expr) from bare function call:
func (p *Parser) parseGroupedExpression() (Node, error) {
    // We have '(' as current
    p.nextToken() //  '('

    exp, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
        return nil, fmt.Errorf("expected RPAREN, got %v", p.currentToken())
    }
    p.nextToken() //  ')'
    return exp, nil
}

func (p *Parser) parseBlockExpression() (Node, error) {
    // A block is: { expr1 ; expr2 ; ... exprN }
    p.nextToken() //  LBRACE

    var exprs []Node
    for p.currentToken() != nil && p.currentToken().Type != "RBRACE" {
        e, err := p.parseExpression(_LOWEST)
        if err != nil {
            return nil, err
        }
        exprs = append(exprs, e)

        if p.currentToken() == nil {
            return nil, errors.New("unexpected end of input in block")
        }
        if p.currentToken().Type == "SEMICOLON" {
            p.nextToken() //  semicolon
        } else if p.currentToken().Type != "RBRACE" {
            return nil, fmt.Errorf("expected '}' or ';', got %v", p.currentToken())
        }
    }

    if p.currentToken() == nil || p.currentToken().Type != "RBRACE" {
        return nil, fmt.Errorf("expected '}' at end of block, got %v", p.currentToken())
    }
    p.nextToken() //  RBRACE
    return &Block{Exprs: exprs}, nil
}

func (p *Parser) parseIfExpression() (Node, error) {
    p.nextToken() //  IF
    cond, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "THEN" {
        return nil, fmt.Errorf("expected THEN, got %v", p.currentToken())
    }
    p.nextToken() //  THEN
    trueBranch, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "ELSE" {
        return nil, fmt.Errorf("expected ELSE, got %v", p.currentToken())
    }
    p.nextToken() //  ELSE
    falseBranch, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "FI" {
        return nil, fmt.Errorf("expected FI, got %v", p.currentToken())
    }
    p.nextToken() //  FI
    return &If{Condition: cond, True: trueBranch, False: falseBranch}, nil
}

func (p *Parser) parseWhileExpression() (Node, error) {
    //  WHILE
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
    //  LET
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
            return nil, fmt.Errorf("expected attribute in let, got %T", attrNode)
        }
        attrs = append(attrs, attr)

        if p.currentToken() != nil && p.currentToken().Type == "COMMA" {
            p.nextToken() //  comma
        } else {
            break
        }
    }

    if p.currentToken() == nil || p.currentToken().Type != "IN" {
        return nil, fmt.Errorf("expected IN, got %v", p.currentToken())
    }
    p.nextToken() //  IN

    body, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    return &Let{Assignments: attrs, Body: body}, nil
}

func (p *Parser) parseNewExpression() (Node, error) {
    //  NEW
    p.nextToken()
    tok := p.currentToken()
    if tok == nil || tok.Type != "TYPE" {
        return nil, fmt.Errorf("expected TYPE after NEW, got %v", tok)
    }
    typeName := tok.Value.(string)
    fmt.Println("Parser*** The type name is: ",typeName)
    p.nextToken()
    return &New{Type: typeName}, nil
}

func (p *Parser) parseUnaryOperation() (Node, error) {
    opTok := p.currentToken()
    p.nextToken() //  operator
    right, err := p.parseExpression(_PREFIX)
    if err != nil {
        return nil, err
    }
    return &UnaryOperation{Operator: opTok.Value.(string), Right: right}, nil
}

func (p *Parser) parseCaseExpression() (Node, error) {
    //eat out the CASE token
    p.nextToken() 

    expr, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }
    fmt.Println("The expression in case is: ",expr)
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
            return nil, fmt.Errorf("expected ';' after case branch, got %v", p.currentToken())
        }
        p.nextToken() //  semicolon
    }

    if p.currentToken() == nil || p.currentToken().Type != "ESAC" {
        return nil, fmt.Errorf("expected ESAC at end of case, got %v", p.currentToken())
    }
    p.nextToken() //  ESAC

    return &Case{
        Expr:        expr,
        TypeActions: actions,
    }, nil
}

func (p *Parser) parseTypeAction() (*TypeAction, error) {
    // id : TYPE => expr
    idTok := p.currentToken()
    if idTok == nil || idTok.Type != "ID" {
        return nil, fmt.Errorf("expected ID in case branch, got %v", idTok)
    }
    ident := idTok.Value.(string)
    p.nextToken() //  ID

    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, fmt.Errorf("expected ':' in case branch, got %v", p.currentToken())
    }
    p.nextToken()

    typeTok := p.currentToken()
    if typeTok == nil || typeTok.Type != "TYPE" {
        return nil, fmt.Errorf("expected TYPE in case branch, got %v", typeTok)
    }
    ty := typeTok.Value.(string)
    p.nextToken()

    if p.currentToken() == nil || p.currentToken().Type != "ACTION" {
        return nil, fmt.Errorf("expected '=>' in case branch, got %v", p.currentToken())
    }
    p.nextToken() //  '=>'

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

    var initExpr Node
    if p.currentToken() != nil && p.currentToken().Type == "ASSIGN" {
        p.nextToken() //  '<-'
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
    opStr := fmt.Sprintf("%v", opToken.Value)

    p.nextToken() //  operator

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
//    *** CHANGED *** parseCallOrMethodCall
// ----------------------------------------------------
// We handle three tokens here: DOT, AT, LPAREN
//   1) obj . method(...)          => MethodCall
//   2) obj @ Type . method(...)   => MethodCall
//   3) id(...) with no object     => FunctionCall ( left is an Ident )
func (p *Parser) parseCallOrMethodCall(left Node) (Node, error) {
    opToken := p.currentToken()

    switch opToken.Type {
    case "DOT":
        // object.method(...)
        p.nextToken() //  DOT
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
        p.nextToken() //  '@'
        tyTok := p.currentToken()
        if tyTok == nil || tyTok.Type != "TYPE" {
            return nil, fmt.Errorf("expected TYPE after '@', got %v", tyTok)
        }
        targetType := tyTok.Value.(string)
        p.nextToken() //  type

        if p.currentToken() == nil || p.currentToken().Type != "DOT" {
            return nil, fmt.Errorf("expected DOT after '@ TYPE', got %v", p.currentToken())
        }
        p.nextToken() 

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
            return nil, fmt.Errorf("cannot do '(...)' after non-identifier %T", left)
        }
        p.nextToken() //  '('
        params, err := p.parseParamsOpt()
        if err != nil {
            return nil, err
        }
        if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
            return nil, fmt.Errorf("expected ')', got %v", p.currentToken())
        }
        p.nextToken() //  ')'
        return &FunctionCall{
            Ident:  identLeft.Name,
            Params: params,
        }, nil

    default:
        return nil, fmt.Errorf("unexpected token %q in parseCallOrMethodCall", opToken.Type)
    }
}

// ----------------------------------------------------
//  *** CHANGED *** parseMethodNameAndArgs
//  This is used only after DOT or "obj @Type ."
// ----------------------------------------------------
func (p *Parser) parseMethodNameAndArgs() (*FunctionCall, error) {
    // We expect an ID for the method name:
    tok := p.currentToken()
    if tok == nil || tok.Type != "ID" {
        return nil, fmt.Errorf("expected method name ID, got %v", tok)
    }
    methodName := tok.Value.(string)
    p.nextToken() //  the method name

    if p.currentToken() == nil || p.currentToken().Type != "LPAREN" {
        return nil, fmt.Errorf("expected '(', got %v", p.currentToken())
    }
    p.nextToken() //  '('

    params, err := p.parseParamsOpt()
    if err != nil {
        return nil, err
    }
    if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
        return nil, fmt.Errorf("expected ')', got %v", p.currentToken())
    }
    p.nextToken() //  ')'

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
        p.nextToken() //  comma
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
    fmt.Println("The feature name is: ",idTok)
    if idTok == nil || idTok.Type != "ID" {
        return nil, errors.New("expected feature identifier")
    }
    featName := idTok.Value.(string)
    p.nextToken() //  the feature name

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
    // Current token is LPAREN
    p.nextToken() //  '('

    formals, err := p.parseFormals()
    if err != nil {
        return nil, err
    }

    // expect ')'
    if p.currentToken() == nil || p.currentToken().Type != "RPAREN" {
        return nil, errors.New("expected ')' after method formals")
    }
    p.nextToken() //  ')'

    // expect ':'
    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, errors.New("expected ':' after method formals")
    }
    p.nextToken() //  ':'

    // expect TYPE
    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, errors.New("expected return TYPE after ':'")
    }
    retType := p.currentToken().Value.(string)
    p.nextToken() //  TYPE

    // expect '{'
    if p.currentToken() == nil || p.currentToken().Type != "LBRACE" {
        return nil, errors.New("expected '{' before method body")
    }
    p.nextToken() //  '{'

    // parse body as expression
    body, err := p.parseExpression(_LOWEST)
    if err != nil {
        return nil, err
    }

    // expect '}'
    if p.currentToken() == nil || p.currentToken().Type != "RBRACE" {
        fmt.Println(p.currentToken())
        return nil, errors.New("expected '}' after method body")
    }
    p.nextToken() //  '}'

    return &Method{
        Ident:   methodName,
        Type:    retType,
        Formals: formals,
        Body:    body,
    }, nil
}

func (p *Parser) parseAttributeDef(attrName string) (Node, error) {
    // current token is "COLON",  it
    p.nextToken()

    // expect TYPE
    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, errors.New("expected TYPE after ':' in attribute definition")
    }
    attrType := p.currentToken().Value.(string)
    p.nextToken() //  TYPE

    var initExpr Node
    // optional '<-' expr
    if p.currentToken() != nil && p.currentToken().Type == "ASSIGN" {
        p.nextToken() //  '<-'
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
        return formals, nil
    }

    f, err := p.parseFormal()
    if err != nil {
        return nil, err
    }
    formals = append(formals, f)

    for p.currentToken() != nil && p.currentToken().Type == "COMMA" {
        p.nextToken() //  comma
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
    p.nextToken() //  ID

    // expect ':'
    if p.currentToken() == nil || p.currentToken().Type != "COLON" {
        return nil, errors.New("expected ':' after formal parameter name")
    }
    p.nextToken() //  ':'

    // expect TYPE
    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, errors.New("expected TYPE after ':' in formal")
    }
    ty := p.currentToken().Value.(string)
    p.nextToken() //  TYPE

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
        return nil, fmt.Errorf("no classes found")
    }
    return &Program{Classes: classes}, nil
}

func (p *Parser) parseClass() (*Class, error) {
    if p.currentToken() == nil || p.currentToken().Type != "CLASS" {
        return nil, errors.New("expected CLASS keyword")
    }
    p.nextToken() //  CLASS

    if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
        return nil, errors.New("expected class TYPE")
    }
    className := p.currentToken().Value.(string)
    p.nextToken() //  TYPE

    inherits := ""
    if p.currentToken() != nil && p.currentToken().Type == "INHERITS" {
        p.nextToken() //  INHERITS
        if p.currentToken() == nil || p.currentToken().Type != "TYPE" {
            return nil, errors.New("expected TYPE after INHERITS")
        }
        inherits = p.currentToken().Value.(string)
        p.nextToken() //  TYPE
    }

    if p.currentToken() == nil || p.currentToken().Type != "LBRACE" {
        return nil, errors.New("expected '{' in class")
    }
    p.nextToken() //  '{'

    features, err := p.parseFeatures()
    if err != nil {
        return nil, err
    }

    if p.currentToken() == nil || p.currentToken().Type != "RBRACE" {
        return nil, errors.New("expected '}' in class")
    }
    p.nextToken()

    if p.currentToken() == nil || p.currentToken().Type != "SEMICOLON" {
        return nil, errors.New("expected ';' after class")
    }
    p.nextToken() 

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
            return nil, fmt.Errorf("expected ';' after feature definition, got %v", p.currentToken())
        }
        p.nextToken() //  ';'
        features = append(features, f)
    }
    return features, nil
}
