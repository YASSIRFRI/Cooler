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

	// 3) Add built-in String methods
	sa.addStringMethods()

	return sa
}

// --------------------------------------------------------
//          IO METHODS INTEGRATION
// --------------------------------------------------------
func (sa *SemanticAnalyzer) addIOMethods() {
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
			returnType: "IO",
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
//          STRING METHODS INTEGRATION
// --------------------------------------------------------
func (sa *SemanticAnalyzer) addStringMethods() {
	// Built-in: length() : Int, concat(String) : String, substr(Int, Int) : String
	methods := []struct {
		fullName   string
		methodName string
		returnType string
		paramNames []string
		paramTypes []string
	}{
		{
			fullName:   "String.length",
			methodName: "length",
			returnType: "Int",
			paramNames: []string{},
			paramTypes: []string{},
		},
		{
			fullName:   "String.concat",
			methodName: "concat",
			returnType: "String",
			paramNames: []string{"s"},
			paramTypes: []string{"String"},
		},
		{
			fullName:   "String.substr",
			methodName: "substr",
			returnType: "String",
			paramNames: []string{"start", "len"},
			paramTypes: []string{"Int", "Int"},
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

// A helper that formats error messages with a "verbose" prefix.
func (sa *SemanticAnalyzer) verbosef(context, format string, args ...interface{}) {
	prefix := fmt.Sprintf("[SEMANT-ERROR in %s] ", context)
	msg := fmt.Sprintf(format, args...)
	sa.errors = append(sa.errors, prefix+msg)
}

func (sa *SemanticAnalyzer) errorf(format string, args ...interface{}) {
	msg := fmt.Sprintf(format, args...)
	sa.errors = append(sa.errors, "[SEMANT-ERROR] "+msg)
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

		// Check for redefinition of a basic class.
		// It is not allowed to redefine String (or any built-in).
		if className == "String" {
			sa.verbosef("buildClassSymbols", "Redefinition of basic class String is not allowed")
			continue
		}

		if _, exists := sa.global.Lookup(className); exists {
			sa.verbosef("buildClassSymbols", "class %q is already defined", className)
			continue
		}

		err := sa.global.Add(className, &SymbolEntry{
			Name: className,
			Type: className,
		})
		if err != nil {
			sa.verbosef("buildClassSymbols", err.Error())
		}

		if classNode.Inherits != "" {
			// It is an error to inherit from the basic class String.
			if classNode.Inherits == "String" {
				sa.verbosef("buildClassSymbols", "class %q cannot inherit from basic class String", className)
			} else if _, ok := sa.global.Lookup(classNode.Inherits); !ok {
				sa.verbosef("buildClassSymbols", "class %q inherits from unknown class %q", className, classNode.Inherits)
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
		// If the class was not successfully registered, skip processing its features.
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
	if attr.Type != "SELF_TYPE" {
		if _, ok := sa.global.Lookup(attr.Type); !ok {
			sa.verbosef("registerAttribute",
				"in class %s: attribute %q has undefined type %q",
				className, attr.Ident, attr.Type)
		}
	}

	err := scope.Add(attr.Ident, &SymbolEntry{
		Name: attr.Ident,
		Type: attr.Type,
	})
	if err != nil {
		sa.verbosef("registerAttribute", "in class %s: %v", className, err)
	}
}

func (sa *SemanticAnalyzer) registerMethod(className string, method *parser.Method, scope *SymbolTable) {
	// Accept SELF_TYPE as return type
	if method.Type != "SELF_TYPE" {
		if _, ok := sa.global.Lookup(method.Type); !ok {
			sa.verbosef("registerMethod",
				"in class %s: method %q has undefined return type %q",
				className, method.Ident, method.Type)
		}
	}

	paramNames := make([]string, 0, len(method.Formals))
	paramTypes := make([]string, 0, len(method.Formals))
	seenParam := make(map[string]bool)

	for _, fm := range method.Formals {
		if fm.Type != "SELF_TYPE" {
			if _, ok := sa.global.Lookup(fm.Type); !ok {
				sa.verbosef("registerMethod",
					"in class %s: method %q has param %q with unknown type %q",
					className, method.Ident, fm.Ident, fm.Type)
			}
		}
		if seenParam[fm.Ident] {
			sa.verbosef("registerMethod",
				"in class %s: method %q has duplicate parameter %q",
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

	// 1) Add to the class' local scope
	err := scope.Add(method.Ident, &SymbolEntry{
		Name:   method.Ident,
		Type:   method.Type,
		Method: signature,
	})
	if err != nil {
		sa.verbosef("registerMethod", "in class %s: %v", className, err)
	}

	// 2) Also add to the global table, so method dispatch can find it
	//    e.g. "CellularAutomaton.init"
	methodKey := className + "." + method.Ident
	if gerr := sa.global.Add(methodKey, &SymbolEntry{
		Name:   method.Ident,
		Type:   method.Type,
		Method: signature,
	}); gerr != nil {
		// If there's a conflict, let's just log it
		sa.verbosef("registerMethod",
			"in class %s: method %q could not be globally registered: %v",
			className, method.Ident, gerr)
	}
}

// --------------------------------------------------------
//          3) TYPE CHECK
// --------------------------------------------------------
func (sa *SemanticAnalyzer) typeCheck(prog *parser.Program) {
	for _, classNode := range prog.Classes {
		classScope := NewSymbolTable(sa.global)

		// Add features (attributes / methods) to scope
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
					initType := sa.getExprType(f.Init, classScope, classNode.Name)
					// If attribute is declared SELF_TYPE, interpret that as classNode.Name
					declared := f.Type
					if declared == "SELF_TYPE" {
						declared = classNode.Name
					}
					// Similarly if initType is SELF_TYPE, interpret as current class
					if initType == "SELF_TYPE" {
						initType = classNode.Name
					}
					if !sa.isTypeConformant(initType, declared) {
						sa.verbosef("typeCheck(attribute)",
							"in class %s: attribute %q init type %q does not conform to %q",
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

	bodyType := sa.getExprType(m.Body, methodScope, className)

	// If the body evaluates to SELF_TYPE, treat it as the current class
	if bodyType == "SELF_TYPE" {
		bodyType = className
	}
	// If the method is declared SELF_TYPE, treat it also as the current class
	declaredType := m.Type
	if declaredType == "SELF_TYPE" {
		declaredType = className
	}

	if !sa.isTypeConformant(bodyType, declaredType) && !sa.isTypeConformant(declaredType, bodyType) {
		fmt.Println("Type check failed")
		fmt.Println(bodyType)
		fmt.Println(declaredType)
		sa.verbosef("typeCheckMethod",
			"in class %s: method %q returns type %q but declared %q",
			className, m.Ident, bodyType, m.Type)
	}
}

// --------------------------------------------------------
//          getExprType
// --------------------------------------------------------
func (sa *SemanticAnalyzer) getExprType(expr parser.Node, scope *SymbolTable, currentClass string) string {
	switch e := expr.(type) {
	case *parser.IntConst:
		return "Int"

	case *parser.BoolConst:
		return "Bool"

	case *parser.StringConst:
		return "String"

	case *parser.Self:
		// 'self' has static type SELF_TYPE in COOL
		return "SELF_TYPE"

	case *parser.Ident:
		entry, ok := scope.Lookup(e.Name)
		if !ok {
			sa.verbosef("getExprType",
				"use of undeclared identifier %q", e.Name)
			return "Object"
		}
		return entry.Type

	case *parser.Assignment:
		rightType := sa.getExprType(e.Expr, scope, currentClass)
		leftName := e.Ident.Name
		entry, ok := scope.Lookup(leftName)
		if !ok {
			sa.verbosef("getExprType(assignment)",
				"assignment to undeclared identifier %q", leftName)
			return "Object"
		}
		// If the left side is declared SELF_TYPE, interpret as current class
		leftDeclared := entry.Type
		if leftDeclared == "SELF_TYPE" {
			leftDeclared = currentClass
		}
		// If the right side is SELF_TYPE, interpret as current class
		expandedRight := rightType
		if expandedRight == "SELF_TYPE" {
			expandedRight = currentClass
		}
		if !sa.isTypeConformant(expandedRight, leftDeclared) {
			sa.verbosef("getExprType(assignment)",
				"cannot assign type %q to identifier %q of type %q",
				rightType, leftName, entry.Type)
		}
		// Return the declared type of the variable
		return entry.Type

	case *parser.If:
		condType := sa.getExprType(e.Condition, scope, currentClass)
		if condType != "Bool" {
			sa.verbosef("getExprType(if)",
				"if-condition has type %q, expected Bool", condType)
		}
		trueType := sa.getExprType(e.True, scope, currentClass)
		falseType := sa.getExprType(e.False, scope, currentClass)
		if trueType == falseType {
			return trueType
		}
		return "Object"

	case *parser.While:
		condType := sa.getExprType(e.Condition, scope, currentClass)
		if condType != "Bool" {
			sa.verbosef("getExprType(while)",
				"while-condition has type %q, expected Bool", condType)
		}
		_ = sa.getExprType(e.Body, scope, currentClass)
		return "Object"

	case *parser.Block:
		var lastType = "Object"
		for _, sub := range e.Exprs {
			lastType = sa.getExprType(sub, scope, currentClass)
		}
		return lastType

	case *parser.Let:
		letScope := NewSymbolTable(scope)
		for _, attr := range e.Assignments {
			if attr.Type != "SELF_TYPE" {
				if _, ok := sa.global.Lookup(attr.Type); !ok {
					sa.verbosef("getExprType(let)",
						"unknown type %q for %q", attr.Type, attr.Ident)
				}
			}
			if attr.Init != nil {
				initType := sa.getExprType(attr.Init, letScope, currentClass)
				expandedInit := initType
				if expandedInit == "SELF_TYPE" {
					expandedInit = currentClass
				}
				declared := attr.Type
				if declared == "SELF_TYPE" {
					declared = currentClass
				}
				if !sa.isTypeConformant(expandedInit, declared) {
					sa.verbosef("getExprType(let)",
						"init type %q does not conform to declared type %q",
						initType, attr.Type)
				}
			}
			_ = letScope.Add(attr.Ident, &SymbolEntry{
				Name: attr.Ident,
				Type: attr.Type,
			})
		}
		return sa.getExprType(e.Body, letScope, currentClass)

	case *parser.New:
		if e.Type == "SELF_TYPE" {
			return "SELF_TYPE"
		}
		if _, ok := sa.global.Lookup(e.Type); !ok {
			sa.verbosef("getExprType(new)",
				"use of new on unknown type %q", e.Type)
			return "Object"
		}
		return e.Type

	case *parser.BinaryOperation:
		leftT := sa.getExprType(e.Left, scope, currentClass)
		rightT := sa.getExprType(e.Right, scope, currentClass)
		// Expand SELF_TYPE
		if leftT == "SELF_TYPE" {
			leftT = currentClass
		}
		if rightT == "SELF_TYPE" {
			rightT = currentClass
		}
		switch e.Operator {
		case "+", "-", "*", "/":
			if leftT != "Int" || rightT != "Int" {
				sa.verbosef("getExprType(binaryOp)",
					"arithmetic %q on non-Int types %q and %q",
					e.Operator, leftT, rightT)
			}
			return "Int"
		case "<", "<=", "=":
			if leftT != rightT {
				sa.verbosef("getExprType(binaryOp)",
					"comparison %q between incompatible types %q and %q",
					e.Operator, leftT, rightT)
			}
			return "Bool"
		default:
			sa.verbosef("getExprType(binaryOp)",
				"unknown binary operator %q", e.Operator)
			return "Object"
		}

	case *parser.UnaryOperation:
		rightT := sa.getExprType(e.Right, scope, currentClass)
		if rightT == "SELF_TYPE" {
			rightT = currentClass
		}
		switch e.Operator {
		case "~":
			if rightT != "Int" {
				sa.verbosef("getExprType(unaryOp)",
					"operator '~' applied to non-Int type %q", rightT)
			}
			return "Int"
		case "not":
			if rightT != "Bool" {
				sa.verbosef("getExprType(unaryOp)",
					"operator 'not' applied to non-Bool type %q", rightT)
			}
			return "Bool"
		case "isvoid":
			return "Bool"
		default:
			sa.verbosef("getExprType(unaryOp)",
				"unhandled unary operator %q", e.Operator)
			return "Object"
		}

	case *parser.MethodCall:
		// 1) get static type of the object
		objType := sa.getExprType(e.Object, scope, currentClass)
		// Expand SELF_TYPE => currentClass for method lookup
		receiverType := objType
		if receiverType == "SELF_TYPE" {
			receiverType = currentClass
		}

		// 2) find the method in that class or its parents
		entry := sa.lookupMethod(receiverType, e.Method.Ident)
		if entry == nil || entry.Method == nil {
			// If not found, we type-check the params anyway, but default to "Object"
			sa.verbosef("getExprType(methodCall)",
				"no method %q found in class %q or ancestors",
				e.Method.Ident, receiverType)
			for _, paramExpr := range e.Method.Params {
				_ = sa.getExprType(paramExpr, scope, currentClass)
			}
			return "Object"
		}

		// 3) Check param count and types
		if len(e.Method.Params) != len(entry.Method.ParamTypes) {
			sa.verbosef("getExprType(methodCall)",
				"method %q expects %d params, got %d",
				e.Method.Ident, len(entry.Method.ParamTypes), len(e.Method.Params))
		} else {
			for i, pNode := range e.Method.Params {
				pt := sa.getExprType(pNode, scope, currentClass)
				if pt == "SELF_TYPE" {
					pt = currentClass
				}
				declared := entry.Method.ParamTypes[i]
				if declared == "SELF_TYPE" {
					declared = receiverType
				}
				if !sa.isTypeConformant(pt, declared) {
					sa.verbosef("getExprType(methodCall)",
						"method %q param #%d type mismatch: got %q, want %q",
						e.Method.Ident, i, pt, entry.Method.ParamTypes[i])
				}
			}
		}

		// 4) If method's return type is SELF_TYPE, the call's type is
		// the static type of the receiver (which might be "SELF_TYPE" if the object was "self").
		if entry.Method.ReturnType == "SELF_TYPE" {
			return objType // Keep it "SELF_TYPE" if that's what the caller has
		}
		return entry.Method.ReturnType

	case *parser.FunctionCall:
		// E.g. out_string(...)
		// Treat as self.out_string(...)
		switch e.Ident {
		case "out_string", "out_int", "in_string", "in_int":
			syntheticMC := &parser.MethodCall{
				Object: &parser.Self{},
				TargetType: "",
				Method: &parser.FunctionCall{
					Ident:  e.Ident,
					Params: e.Params,
				},
			}
			return sa.getExprType(syntheticMC, scope, currentClass)
		default:
			// normal local function call
			name := e.Ident
			entry, ok := scope.Lookup(name)
			if !ok || entry.Method == nil {
				sa.verbosef("getExprType(functionCall)",
					"call to undeclared function %q", name)
				for _, p := range e.Params {
					_ = sa.getExprType(p, scope, currentClass)
				}
				return "Object"
			}
			// check param count
			if len(e.Params) != len(entry.Method.ParamTypes) {
				sa.verbosef("getExprType(functionCall)",
					"function %q expects %d args, got %d",
					name, len(entry.Method.ParamTypes), len(e.Params))
			} else {
				for i, param := range e.Params {
					pt := sa.getExprType(param, scope, currentClass)
					if pt == "SELF_TYPE" {
						pt = currentClass
					}
					declared := entry.Method.ParamTypes[i]
					if declared == "SELF_TYPE" {
						declared = currentClass
					}
					if !sa.isTypeConformant(pt, declared) {
						sa.verbosef("getExprType(functionCall)",
							"function %q param #%d has type %q, expected %q",
							name, i, pt, entry.Method.ParamTypes[i])
					}
				}
			}
			if entry.Method.ReturnType == "SELF_TYPE" {
				return "SELF_TYPE"
			}
			return entry.Method.ReturnType
		}

	case *parser.Case:
		_ = sa.getExprType(e.Expr, scope, currentClass)
		var resultType string
		for i, ta := range e.TypeActions {
			branchScope := NewSymbolTable(scope)
			_ = branchScope.Add(ta.Ident, &SymbolEntry{
				Name: ta.Ident,
				Type: ta.Type,
			})
			branchType := sa.getExprType(ta.Expr, branchScope, currentClass)
			if i == 0 {
				resultType = branchType
			} else if resultType != branchType {
				// Proper COOL does a least-common-ancestor.
				// For simplicity, we degrade to Object if they differ.
				if resultType != branchType {
					resultType = "Object"
				}
			}
		}
		if resultType == "" {
			resultType = "Object"
		}
		return resultType

	default:
		sa.verbosef("getExprType(unknown)", "unhandled AST node type")
		return "Object"
	}
}

// --------------------------------------------------------
//    lookupMethod: search class or parents for the method
// --------------------------------------------------------
func (sa *SemanticAnalyzer) lookupMethod(className, methodName string) *SymbolEntry {
	current := className
	for {
		methodKey := current + "." + methodName
		if entry, ok := sa.global.Lookup(methodKey); ok {
			return entry
		}
		parent, hasParent := sa.parentOf[current]
		if !hasParent {
			break
		}
		current = parent
	}
	return nil
}

// --------------------------------------------------------
//          isTypeConformant
// --------------------------------------------------------
func (sa *SemanticAnalyzer) isTypeConformant(actual, expected string) bool {
	// Caller should expand SELF_TYPE => concrete class name beforehand
	if actual == expected {
		return true
	}
	// For debugging, you may print the parent chain:
	// fmt.Printf("Checking %q against %q\n", actual, expected)
	current := actual
	for {
		// Uncomment the following lines to trace parent lookup:
		// fmt.Printf("  - %q\n", current)
		p, hasParent := sa.parentOf[current]
		// fmt.Printf("  - %q\n", p)
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
