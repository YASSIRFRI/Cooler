// package semant
package semant

import (
    "fmt"

    "cooler/parser"
)

// --------------------------------------------------------
//          SYMBOL TABLE / ENTRIES
// --------------------------------------------------------
type SymbolTable struct {
    parent  *SymbolTable
    entries map[string]*SymbolEntry
}

type SymbolEntry struct {
    Name   string
    Type   string
    Method *MethodSignature
}

type MethodSignature struct {
    ParamNames []string
    ParamTypes []string
    ReturnType string
}

func NewSymbolTable(parent *SymbolTable) *SymbolTable {
    return &SymbolTable{
        parent:  parent,
        entries: make(map[string]*SymbolEntry),
    }
}

func (st *SymbolTable) Add(name string, entry *SymbolEntry) error {
    if _, exists := st.entries[name]; exists {
        return fmt.Errorf("name %q is already declared in this scope", name)
    }
    st.entries[name] = entry
    return nil
}

func (st *SymbolTable) Lookup(name string) (*SymbolEntry, bool) {
    if entry, ok := st.entries[name]; ok {
        return entry, true
    }
    if st.parent != nil {
        return st.parent.Lookup(name)
    }
    return nil, false
}

// --------------------------------------------------------
//          SEMANTIC ANALYZER
// --------------------------------------------------------
type SemanticAnalyzer struct {
    global   *SymbolTable
    errors   []string
    parentOf map[string]string // Maps className -> parentName, for inheritance
}

func NewSemanticAnalyzer() *SemanticAnalyzer {
    sa := &SemanticAnalyzer{
        global:   NewSymbolTable(nil),
        errors:   []string{},
        parentOf: make(map[string]string),
    }

    // 1) Create builtin classes
    builtins := []string{"Object", "Int", "Bool", "String", "IO"}
    for _, b := range builtins {
        _ = sa.global.Add(b, &SymbolEntry{
            Name: b,
            Type: b,
        })
    }

    // 2) Add IO methods to the global table
    sa.addIOMethods()

    return sa
}

// --------------------------------------------------------
//          IO METHODS INTEGRATION
// --------------------------------------------------------
func (sa *SemanticAnalyzer) addIOMethods() {
    // We'll store each IO method as "IO.out_string", "IO.out_int", etc.
    methods := []struct {
        fullName   string
        methodName string
        returnType string
        paramNames []string
        paramTypes []string
    }{
        {
            fullName:   "IO.out_string",
            methodName: "out_string",
            returnType: "IO",  // Could be SELF_TYPE, but simplified
            paramNames: []string{"x"},
            paramTypes: []string{"String"},
        },
        {
            fullName:   "IO.out_int",
            methodName: "out_int",
            returnType: "IO",
            paramNames: []string{"x"},
            paramTypes: []string{"Int"},
        },
        {
            fullName:   "IO.in_string",
            methodName: "in_string",
            returnType: "String",
            paramNames: []string{},
            paramTypes: []string{},
        },
        {
            fullName:   "IO.in_int",
            methodName: "in_int",
            returnType: "Int",
            paramNames: []string{},
            paramTypes: []string{},
        },
    }

    for _, m := range methods {
        _ = sa.global.Add(m.fullName, &SymbolEntry{
            Name: m.methodName,
            Type: m.returnType,
            Method: &MethodSignature{
                ParamNames: m.paramNames,
                ParamTypes: m.paramTypes,
                ReturnType: m.returnType,
            },
        })
    }
}

// --------------------------------------------------------
//          PUBLIC INTERFACES
// --------------------------------------------------------
func (sa *SemanticAnalyzer) Errors() []string {
    return sa.errors
}

func (sa *SemanticAnalyzer) errorf(format string, args ...interface{}) {
    msg := fmt.Sprintf(format, args...)
    sa.errors = append(sa.errors, msg)
}

func (sa *SemanticAnalyzer) Analyze(program *parser.Program) {
    sa.buildClassSymbols(program)
    sa.buildFeatures(program)
    sa.typeCheck(program)
}

// --------------------------------------------------------
//          1) BUILD CLASS SYMBOLS
// --------------------------------------------------------
func (sa *SemanticAnalyzer) buildClassSymbols(prog *parser.Program) {
    for _, classNode := range prog.Classes {
        className := classNode.Name

        if _, exists := sa.global.Lookup(className); exists {
            sa.errorf("class %q is already defined", className)
            continue
        }

        err := sa.global.Add(className, &SymbolEntry{
            Name: className,
            Type: className,
        })
        if err != nil {
            sa.errorf(err.Error())
        }

        if classNode.Inherits != "" {
            if _, ok := sa.global.Lookup(classNode.Inherits); !ok {
                sa.errorf("class %q inherits from unknown class %q", className, classNode.Inherits)
            } else {
                sa.parentOf[className] = classNode.Inherits
            }
        }
    }
}

// --------------------------------------------------------
//          2) BUILD FEATURES
// --------------------------------------------------------
func (sa *SemanticAnalyzer) buildFeatures(prog *parser.Program) {
    for _, classNode := range prog.Classes {
        _, ok := sa.global.Lookup(classNode.Name)
        if !ok {
            continue
        }
        classScope := NewSymbolTable(sa.global)

        for _, feat := range classNode.Features {
            switch f := feat.(type) {
            case *parser.Attribute:
                sa.registerAttribute(classNode.Name, f, classScope)
            case *parser.Method:
                sa.registerMethod(classNode.Name, f, classScope)
            }
        }
    }
}

func (sa *SemanticAnalyzer) registerAttribute(className string, attr *parser.Attribute, scope *SymbolTable) {
    if _, ok := sa.global.Lookup(attr.Type); !ok {
        sa.errorf("in class %s: attribute %q has undefined type %q",
            className, attr.Ident, attr.Type)
    }

    err := scope.Add(attr.Ident, &SymbolEntry{
        Name: attr.Ident,
        Type: attr.Type,
    })
    if err != nil {
        sa.errorf("in class %s: %v", className, err)
    }
}

func (sa *SemanticAnalyzer) registerMethod(className string, method *parser.Method, scope *SymbolTable) {
    if _, ok := sa.global.Lookup(method.Type); !ok {
        sa.errorf("in class %s: method %q has undefined return type %q",
            className, method.Ident, method.Type)
    }

    paramNames := make([]string, 0, len(method.Formals))
    paramTypes := make([]string, 0, len(method.Formals))
    seenParam := make(map[string]bool)

    for _, fm := range method.Formals {
        if _, ok := sa.global.Lookup(fm.Type); !ok {
            sa.errorf("in class %s: method %q has param %q with unknown type %q",
                className, method.Ident, fm.Ident, fm.Type)
        }
        if seenParam[fm.Ident] {
            sa.errorf("in class %s: method %q has duplicate parameter %q",
                className, method.Ident, fm.Ident)
        }
        seenParam[fm.Ident] = true

        paramNames = append(paramNames, fm.Ident)
        paramTypes = append(paramTypes, fm.Type)
    }

    signature := &MethodSignature{
        ParamNames: paramNames,
        ParamTypes: paramTypes,
        ReturnType: method.Type,
    }

    err := scope.Add(method.Ident, &SymbolEntry{
        Name:   method.Ident,
        Type:   method.Type,
        Method: signature,
    })
    if err != nil {
        sa.errorf("in class %s: %v", className, err)
    }
}

// --------------------------------------------------------
//          3) TYPE CHECK
// --------------------------------------------------------
func (sa *SemanticAnalyzer) typeCheck(prog *parser.Program) {
    for _, classNode := range prog.Classes {
        classScope := NewSymbolTable(sa.global)

        // Add features to scope
        for _, feat := range classNode.Features {
            switch f := feat.(type) {
            case *parser.Attribute:
                _ = classScope.Add(f.Ident, &SymbolEntry{
                    Name: f.Ident,
                    Type: f.Type,
                })
            case *parser.Method:
                signature := &MethodSignature{
                    ParamNames: make([]string, len(f.Formals)),
                    ParamTypes: make([]string, len(f.Formals)),
                    ReturnType: f.Type,
                }
                for i, fm := range f.Formals {
                    signature.ParamNames[i] = fm.Ident
                    signature.ParamTypes[i] = fm.Type
                }
                _ = classScope.Add(f.Ident, &SymbolEntry{
                    Name:   f.Ident,
                    Type:   f.Type,
                    Method: signature,
                })
            }
        }

        // Now type-check the feature bodies
        for _, feat := range classNode.Features {
            switch f := feat.(type) {
            case *parser.Attribute:
                if f.Init != nil {
                    initType := sa.getExprType(f.Init, classScope)
                    if !sa.isTypeConformant(initType, f.Type) {
                        sa.errorf("in class %s: attribute %q init type %q does not conform to %q",
                            classNode.Name, f.Ident, initType, f.Type)
                    }
                }
            case *parser.Method:
                sa.typeCheckMethod(f, classScope, classNode.Name)
            }
        }
    }
}

func (sa *SemanticAnalyzer) typeCheckMethod(m *parser.Method, classScope *SymbolTable, className string) {
    methodScope := NewSymbolTable(classScope)
    for _, fm := range m.Formals {
        _ = methodScope.Add(fm.Ident, &SymbolEntry{
            Name: fm.Ident,
            Type: fm.Type,
        })
    }

    bodyType := sa.getExprType(m.Body, methodScope)
    if !sa.isTypeConformant(bodyType, m.Type) {
        sa.errorf("in class %s: method %q returns type %q but declared %q",
            className, m.Ident, bodyType, m.Type)
    }
}

// --------------------------------------------------------
//          getExprType
// --------------------------------------------------------
func (sa *SemanticAnalyzer) getExprType(expr parser.Node, scope *SymbolTable) string {
    switch e := expr.(type) {

    case *parser.IntConst:
        return "Int"
    case *parser.BoolConst:
        return "Bool"
    case *parser.StringConst:
        return "String"
    case *parser.Self:
        return "Object" // or SELF_TYPE logic

    case *parser.Ident:
        entry, ok := scope.Lookup(e.Name)
        if !ok {
            sa.errorf("use of undeclared identifier %q", e.Name)
            return "Object"
        }
        return entry.Type

    case *parser.Assignment:
        rightType := sa.getExprType(e.Expr, scope)
        leftName := e.Ident.Name
        entry, ok := scope.Lookup(leftName)
        if !ok {
            sa.errorf("assignment to undeclared identifier %q", leftName)
            return "Object"
        }
        if !sa.isTypeConformant(rightType, entry.Type) {
            sa.errorf("cannot assign type %q to identifier %q of type %q",
                rightType, leftName, entry.Type)
        }
        return rightType

    case *parser.If:
        condType := sa.getExprType(e.Condition, scope)
        if condType != "Bool" {
            sa.errorf("if-condition has type %q, expected Bool", condType)
        }
        trueType := sa.getExprType(e.True, scope)
        falseType := sa.getExprType(e.False, scope)
        if trueType == falseType {
            return trueType
        }
        return "Object"

    case *parser.While:
        condType := sa.getExprType(e.Condition, scope)
        if condType != "Bool" {
            sa.errorf("while-condition has type %q, expected Bool", condType)
        }
        _ = sa.getExprType(e.Body, scope)
        return "Object"

    case *parser.Block:
        var lastType = "Object"
        for _, sub := range e.Exprs {
            lastType = sa.getExprType(sub, scope)
        }
        return lastType

    case *parser.Let:
        letScope := NewSymbolTable(scope)
        for _, attr := range e.Assignments {
            if _, ok := sa.global.Lookup(attr.Type); !ok {
                sa.errorf("in let: unknown type %q for %q", attr.Type, attr.Ident)
            }
            if attr.Init != nil {
                initType := sa.getExprType(attr.Init, letScope)
                if !sa.isTypeConformant(initType, attr.Type) {
                    sa.errorf("in let: init type %q does not conform to declared type %q",
                        initType, attr.Type)
                }
            }
            _ = letScope.Add(attr.Ident, &SymbolEntry{
                Name: attr.Ident,
                Type: attr.Type,
            })
        }
        return sa.getExprType(e.Body, letScope)

    case *parser.New:
        if _, ok := sa.global.Lookup(e.Type); !ok {
            sa.errorf("use of new on unknown type %q", e.Type)
            return "Object"
        }
        return e.Type

    case *parser.BinaryOperation:
        leftT := sa.getExprType(e.Left, scope)
        rightT := sa.getExprType(e.Right, scope)
        switch e.Operator {
        case "+", "-", "*", "/":
            if leftT != "Int" || rightT != "Int" {
                sa.errorf("arithmetic %q on non-Int types %q and %q", e.Operator, leftT, rightT)
            }
            return "Int"
        case "<", "<=", "=":
            if leftT != rightT {
                sa.errorf("comparison %q between incompatible types %q and %q",
                    e.Operator, leftT, rightT)
            }
            return "Bool"
        default:
            sa.errorf("unknown binary operator %q", e.Operator)
            return "Object"
        }

    case *parser.UnaryOperation:
        rightT := sa.getExprType(e.Right, scope)
        switch e.Operator {
        case "~":
            if rightT != "Int" {
                sa.errorf("operator '~' applied to non-Int type %q", rightT)
            }
            return "Int"
        case "not":
            if rightT != "Bool" {
                sa.errorf("operator 'not' applied to non-Bool type %q", rightT)
            }
            return "Bool"
        case "isvoid":
            return "Bool"
        default:
            sa.errorf("unhandled unary operator %q", e.Operator)
            return "Object"
        }

    case *parser.MethodCall:
        // 1) get object type
        objType := sa.getExprType(e.Object, scope)
        // 2) If objType conforms to IO, we do the IO lookup:
        if sa.isTypeConformant(objType, "IO") {
            key := "IO." + e.Method.Ident
            entry, ok := sa.global.Lookup(key)
            if ok && entry.Method != nil {
                if len(e.Method.Params) != len(entry.Method.ParamTypes) {
                    sa.errorf("IO method %q expects %d params, got %d",
                        e.Method.Ident, len(entry.Method.ParamTypes), len(e.Method.Params))
                } else {
                    for i, pNode := range e.Method.Params {
                        pt := sa.getExprType(pNode, scope)
                        if !sa.isTypeConformant(pt, entry.Method.ParamTypes[i]) {
                            sa.errorf("IO method %q param %d type mismatch: got %q, want %q",
                                e.Method.Ident, i, pt, entry.Method.ParamTypes[i])
                        }
                    }
                }
                return entry.Type
            }
        }
        // Otherwise normal dispatch => "Object"
        for _, param := range e.Method.Params {
            _ = sa.getExprType(param, scope)
        }
        return "Object"

    case *parser.FunctionCall:
        // -- NEW for IO calls with no explicit object -- 
        // If the user wrote `out_string(...)` or `out_int(...)` without "self.",
        // treat it as if it were `self.out_string(...)`.
        switch e.Ident {
        case "out_string", "out_int", "in_string", "in_int":
            // Create a synthetic MethodCall node:
            syntheticMC := &parser.MethodCall{
                Object:     &parser.Self{},
                TargetType: "",
                Method: &parser.FunctionCall{
                    Ident:  e.Ident,
                    Params: e.Params,
                },
            }
            return sa.getExprType(syntheticMC, scope)
        }

        // Otherwise, normal function call
        name := e.Ident
        entry, ok := scope.Lookup(name)
        if !ok || entry.Method == nil {
            sa.errorf("call to undeclared function %q", name)
            for _, p := range e.Params {
                _ = sa.getExprType(p, scope)
            }
            return "Object"
        }
        // check param count
        if len(e.Params) != len(entry.Method.ParamTypes) {
            sa.errorf("function %q expects %d args, got %d",
                name, len(entry.Method.ParamTypes), len(e.Params))
        } else {
            for i, param := range e.Params {
                pt := sa.getExprType(param, scope)
                if !sa.isTypeConformant(pt, entry.Method.ParamTypes[i]) {
                    sa.errorf("function %q param #%d has type %q, expected %q",
                        name, i, pt, entry.Method.ParamTypes[i])
                }
            }
        }
        return entry.Type

    case *parser.Case:
        _ = sa.getExprType(e.Expr, scope)
        var resultType string
        for i, ta := range e.TypeActions {
            branchScope := NewSymbolTable(scope)
            _ = branchScope.Add(ta.Ident, &SymbolEntry{
                Name: ta.Ident,
                Type: ta.Type,
            })
            branchType := sa.getExprType(ta.Expr, branchScope)
            if i == 0 {
                resultType = branchType
            } else if resultType != branchType {
                resultType = "Object"
            }
        }
        if resultType == "" {
            resultType = "Object"
        }
        return resultType

    default:
        return "Object"
    }
}

// --------------------------------------------------------
//          isTypeConformant
// --------------------------------------------------------
func (sa *SemanticAnalyzer) isTypeConformant(actual, expected string) bool {
    if actual == expected {
        return true
    }
    // Climb up the parent chain of `actual`
    current := actual
    for {
        p, hasParent := sa.parentOf[current]
        if !hasParent {
            break
        }
        if p == expected {
            return true
        }
        current = p
    }
    return false
}
