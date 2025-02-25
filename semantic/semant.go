// package semant
package semant

import (
	"fmt"

	"cooler/parser"
)

// --------------------------------------------------------
//
//	SYMBOL TABLE / ENTRIES
//
// --------------------------------------------------------
type SymbolTable struct {
	parent  *SymbolTable
	entries map[string]*SymbolEntry
}

type SymbolEntry struct {
	Name     string
	Type     string
	Method   *MethodSignature
	ElemType string // Add this field for arrays
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
//
//	SEMANTIC ANALYZER
//
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

	// 1) Create builtin classes.
	// In COOL the basic classes all exist in the system.
	builtins := []string{"Object", "Int", "Bool", "String", "IO", "Array"}
	for _, b := range builtins {
		_ = sa.global.Add(b, &SymbolEntry{
			Name: b,
			Type: b,
		})
	}
	sa.parentOf["Int"] = "Object"
	sa.parentOf["Bool"] = "Object"
	sa.parentOf["IO"] = "Object"
	sa.parentOf["String"] = "Object"
	sa.parentOf["Array"] = "Object"

	sa.addObjectMethods()
	sa.addIOMethods()
	sa.addStringMethods()
	sa.addArrayMethods()

	return sa
}

// --------------------------------------------------------
//
//	OBJECT METHODS INTEGRATION
//
// --------------------------------------------------------
func (sa *SemanticAnalyzer) addObjectMethods() {
	methods := []struct {
		fullName   string
		methodName string
		returnType string
		paramNames []string
		paramTypes []string
	}{
		{
			fullName:   "Object.abort",
			methodName: "abort",
			returnType: "Object",
			paramNames: nil,
			paramTypes: nil,
		},
		{
			fullName:   "Object.type_name",
			methodName: "type_name",
			returnType: "String",
			paramNames: nil,
			paramTypes: nil,
		},
		{
			fullName:   "Object.copy",
			methodName: "copy",
			returnType: "SELF_TYPE",
			paramNames: nil,
			paramTypes: nil,
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
//
//	IO METHODS INTEGRATION
//
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
			returnType: "SELF_TYPE",
			paramNames: []string{"x"},
			paramTypes: []string{"String"},
		},
		{
			fullName:   "IO.out_int",
			methodName: "out_int",
			returnType: "SELF_TYPE",
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
//
//	STRING METHODS INTEGRATION
//
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

func (sa *SemanticAnalyzer) Errors() []string {
	return sa.errors
}

// A helper that formats error messages with a "verbose" prefix.
func (sa *SemanticAnalyzer) verbosef(context, format string, args ...interface{}) {
	prefix := fmt.Sprintf("[SEMANT-ERROR in %s] ", context)
	msg := fmt.Sprintf(format, args...)
	sa.errors = append(sa.errors, prefix+msg)
}

func (sa *SemanticAnalyzer) Analyze(program *parser.Program) {
	// First pass: register all class names.
	sa.buildClassSymbols(program)
	// Then register attributes and methods.
	sa.buildFeatures(program)
	// Finally, type-check the bodies.
	sa.typeCheck(program)
}

// --------------------------------------------------------
//  1. BUILD CLASS SYMBOLS
//
// --------------------------------------------------------
// To avoid ordering issues we do two passes:
//
//	(a) register all classes (by name) in the global table,
//	(b) then set up inheritance (and check that parent names exist).
func (sa *SemanticAnalyzer) buildClassSymbols(prog *parser.Program) {
	// First pass: register all classes.
	for _, classNode := range prog.Classes {
		className := classNode.Name
		// Disallow redefinition of basic classes.
		if className == "String" {
			sa.verbosef("buildClassSymbols", "Redefinition of basic class String is not allowed")
			continue
		}
		// Do not worry about inheritance here.
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
	}

	// Second pass: set default inheritance and check parent classes.
	for _, classNode := range prog.Classes {
		className := classNode.Name
		// Default inheritance: if no parent is specified and this is not Object,
		// then inherit from Object.
		if className != "Object" && classNode.Inherits == "" {
			classNode.Inherits = "Object"
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
		} else if className != "Object" {
			// Implicit inheritance from Object.
			sa.parentOf[className] = "Object"
		}
	}
}

// --------------------------------------------------------
//  2. BUILD FEATURES
//
// --------------------------------------------------------
// Register each class’s attributes and methods in a first pass so that
// later method calls (even from subclasses) can find inherited methods.
func (sa *SemanticAnalyzer) buildFeatures(prog *parser.Program) {
	for _, classNode := range prog.Classes {
		// If the class was not successfully registered, skip processing its features.
		_, ok := sa.global.Lookup(classNode.Name)
		if !ok {
			continue
		}
		// We use a temporary scope here (its only effect is to register methods globally).
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

	// 1) Add to the class’ local scope.
	err := scope.Add(method.Ident, &SymbolEntry{
		Name:   method.Ident,
		Type:   method.Type,
		Method: signature,
	})
	if err != nil {
		sa.verbosef("registerMethod", "in class %s: %v", className, err)
	}

	// 2) Also add to the global table, so method dispatch can find it,
	//    e.g. "Foo.init"
	methodKey := className + "." + method.Ident
	if gerr := sa.global.Add(methodKey, &SymbolEntry{
		Name:   method.Ident,
		Type:   method.Type,
		Method: signature,
	}); gerr != nil {
		// If there's a conflict, log it.
		sa.verbosef("registerMethod",
			"in class %s: method %q could not be globally registered: %v",
			className, method.Ident, gerr)
	}
}

// --------------------------------------------------------
//  3. TYPE CHECK
//
// --------------------------------------------------------
// When type–checking a class we build a symbol table that not only
// contains the class’s own features but also those inherited from its ancestors.
func (sa *SemanticAnalyzer) typeCheck(prog *parser.Program) {
	// Build a map from class name to class AST node.
	classesByName := make(map[string]*parser.Class)
	for _, classNode := range prog.Classes {
		classesByName[classNode.Name] = classNode
	}

	for _, classNode := range prog.Classes {
		// Build an environment with inherited attributes.
		inheritedEnv := sa.buildInheritedAttributes(classNode.Name, classesByName)
		// Create the class scope on top of the inherited environment.
		classScope := NewSymbolTable(inheritedEnv)

		// Add the current class’s features.
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

		// Type-check each feature body.
		for _, feat := range classNode.Features {
			switch f := feat.(type) {
			case *parser.Attribute:
				if f.Init != nil {
					initType := sa.getExprType(f.Init, classScope, classNode.Name)
					// Expand SELF_TYPE to current class.
					declared := f.Type
					if declared == "SELF_TYPE" {
						declared = classNode.Name
					}
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

	// Expand SELF_TYPE.
	if bodyType == "SELF_TYPE" {
		bodyType = className
	}
	declaredType := m.Type
	if declaredType == "SELF_TYPE" {
		declaredType = className
	}

	if !sa.isTypeConformant(bodyType, declaredType) {
		sa.verbosef("typeCheckMethod",
			"in class %s: method %q returns type %q but declared %q",
			className, m.Ident, bodyType, m.Type)
	}
}

// --------------------------------------------------------
//
//	getExprType
//
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
		// 'self' has static type SELF_TYPE in COOL.
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
		leftDeclared := entry.Type
		if leftDeclared == "SELF_TYPE" {
			leftDeclared = currentClass
		}
		expandedRight := rightType
		if expandedRight == "SELF_TYPE" {
			expandedRight = currentClass
		}
		if !sa.isTypeConformant(expandedRight, leftDeclared) {
			sa.verbosef("getExprType(assignment)",
				"cannot assign type %q to identifier %q of type %q",
				rightType, leftName, entry.Type)
		}
		return entry.Type

	case *parser.If:
		condType := sa.getExprType(e.Condition, scope, currentClass)
		if condType != "Bool" {
			sa.verbosef("getExprType(if)",
				"if-condition has type %q, expected Bool", condType)
		}
		trueType := sa.getExprType(e.True, scope, currentClass)
		falseType := sa.getExprType(e.False, scope, currentClass)
		// Use join (least upper bound) of branch types.
		return sa.join(trueType, falseType)

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
			entry := &SymbolEntry{
				Name: attr.Ident,
				Type: attr.Type,
			}
			// I
			if attr.Type == "Array" && attr.Init != nil {
				if arrExpr, ok := attr.Init.(*parser.ArrayExpression); ok {
					entry.ElemType = arrExpr.ElemType
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
				var elemType string
				if arrayExpr, ok := attr.Init.(*parser.ArrayExpression); ok {
					elemType = arrayExpr.ElemType
					if _, ok := sa.global.Lookup(elemType); !ok {
						sa.verbosef("getExprType(let)", "unknown element type %q for array", elemType)
						elemType = "" // Invalidate if unknown
					}
				}
				entry := &SymbolEntry{
					Name: attr.Ident,
					Type: declared,
				}
				if elemType != "" {
					entry.ElemType = elemType
				}
				if err := letScope.Add(attr.Ident, entry); err != nil {
					sa.verbosef("getExprType(let)", "failed to add variable %q: %v", attr.Ident, err)
				}
			} else {
				_ = letScope.Add(attr.Ident, &SymbolEntry{
					Name: attr.Ident,
					Type: attr.Type,
				})
			}
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
					"arithmetic operator %q applied to non-Int types %q and %q",
					e.Operator, leftT, rightT)
			}
			return "Int"
		case "<", "<=", "=":
			if leftT != rightT {
				sa.verbosef("getExprType(binaryOp)",
					"comparison operator %q between incompatible types %q and %q",
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

	case *parser.ArrayExpression:
		if _, ok := sa.global.Lookup(e.ElemType); !ok {
			sa.verbosef("getExprType(ArrayExpression)", "undefined element type %q", e.ElemType)
			return "Array"
		}
		return "Array"

	case *parser.MethodCall:
		objType := sa.getExprType(e.Object, scope, currentClass)
		receiverType := objType
		if receiverType == "SELF_TYPE" {
			receiverType = currentClass
		}

		// 2) Handle explicit static dispatch (a@T.f()).
		var lookupType string
		if e.TargetType != "" {
			lookupType = e.TargetType
			actualType := sa.getExprType(e.Object, scope, currentClass)
			if actualType == "SELF_TYPE" {
				actualType = currentClass
			}
			if !sa.isTypeConformant(actualType, lookupType) {
				sa.verbosef("getExprType(methodCall)",
					"object type %q does not conform to static dispatch type %q",
					actualType, lookupType)
			}
		} else {
			lookupType = receiverType
		}

		// 3) Look up the method in the class (or its ancestors).
		entry := sa.lookupMethod(lookupType, e.Method.Ident)
		if entry == nil || entry.Method == nil {
			sa.verbosef("getExprType(methodCall)",
				"no method %q found in class %q or its ancestors",
				e.Method.Ident, lookupType)
			// Type-check parameters anyway.
			for _, paramExpr := range e.Method.Params {
				_ = sa.getExprType(paramExpr, scope, currentClass)
			}
			return "Object"
		}

		// 4) Check parameter count and types.
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
					declared = lookupType
				}
				if !sa.isTypeConformant(pt, declared) {
					sa.verbosef("getExprType(methodCall)",
						"method %q param #%d type mismatch: got %q, expected %q",
						e.Method.Ident, i, pt, declared)
				}
			}
		}

		if entry.Method.ReturnType == "SELF_TYPE" {
			return objType
		}

		if entry.Method.ReturnType == "ELEM_TYPE" {
			var elemType string
			if objIdent, ok := e.Object.(*parser.Ident); ok {
				objEntry, found := scope.Lookup(objIdent.Name)
				if found {
					elemType = objEntry.ElemType
				}
			}
			if elemType == "" {
				sa.verbosef("getExprType(methodCall)", "ELEM_TYPE used but element type is unknown")
				return "Object"
			}
			return elemType
		} else if entry.Method.ReturnType == "SELF_TYPE" {
			return objType
		}
		return entry.Method.ReturnType

	case *parser.FunctionCall:
		// In COOL all function calls are really method calls on 'self'.
		syntheticMC := &parser.MethodCall{
			Object:     &parser.Self{},
			TargetType: "",
			Method: &parser.FunctionCall{
				Ident:  e.Ident,
				Params: e.Params,
			},
		}
		return sa.getExprType(syntheticMC, scope, currentClass)

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
			if branchType == "SELF_TYPE" {
				branchType = currentClass
			}
			if i == 0 {
				resultType = branchType
			} else {
				resultType = sa.join(resultType, branchType)
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
//
//	lookupMethod: search class or parents for the method
//
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
//
//	isTypeConformant
//
// --------------------------------------------------------
func (sa *SemanticAnalyzer) isTypeConformant(actual, expected string) bool {
	// Both actual and expected should be expanded (i.e. SELF_TYPE replaced)
	if actual == expected {
		return true
	}
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

// --------------------------------------------------------
//
//	join: compute least upper bound of two types
//
// --------------------------------------------------------
func (sa *SemanticAnalyzer) join(type1, type2 string) string {
	// If either is SELF_TYPE, assume it’s already been expanded by callers.
	if type1 == type2 {
		return type1
	}
	ancestors := make(map[string]bool)
	for t := type1; ; {
		ancestors[t] = true
		if t == "Object" {
			break
		}
		p, ok := sa.parentOf[t]
		if !ok {
			break
		}
		t = p
	}
	for t := type2; ; {
		if ancestors[t] {
			return t
		}
		if t == "Object" {
			break
		}
		p, ok := sa.parentOf[t]
		if !ok {
			break
		}
		t = p
	}
	return "Object"
}

// --------------------------------------------------------
//
//	buildInheritanceChain: return the chain from Object to the given class.
//
// --------------------------------------------------------
func (sa *SemanticAnalyzer) getInheritanceChain(className string) []string {
	chain := []string{}
	for curr := className; ; {
		chain = append(chain, curr)
		if curr == "Object" {
			break
		}
		p, ok := sa.parentOf[curr]
		if !ok {
			break
		}
		curr = p
	}
	// Reverse the chain so that Object is first.
	for i, j := 0, len(chain)-1; i < j; i, j = i+1, j-1 {
		chain[i], chain[j] = chain[j], chain[i]
	}
	return chain
}

// --------------------------------------------------------
//
//	buildInheritedAttributes: build a symbol table containing all attributes
//	declared in ancestor classes (but not the current class).
//
// --------------------------------------------------------
func (sa *SemanticAnalyzer) buildInheritedAttributes(className string, classesByName map[string]*parser.Class) *SymbolTable {
	env := NewSymbolTable(nil)
	chain := sa.getInheritanceChain(className)
	// Exclude the last element (the current class).
	for i := 0; i < len(chain)-1; i++ {
		ancName := chain[i]
		if ancClass, ok := classesByName[ancName]; ok {
			for _, feat := range ancClass.Features {
				if attr, ok := feat.(*parser.Attribute); ok {
					// Do not override if already defined (subclasses may override later).
					if _, exists := env.entries[attr.Ident]; !exists {
						env.entries[attr.Ident] = &SymbolEntry{
							Name: attr.Ident,
							Type: attr.Type,
						}
					}
				}
			}
		}
	}
	return env
}

func (sa *SemanticAnalyzer) addArrayMethods() {
	// Define built-in Array methods.
	methods := []struct {
		fullName   string
		methodName string
		returnType string
		paramNames []string
		paramTypes []string
	}{
		{
			fullName:   "Array.get",
			methodName: "get",
			returnType: "ELEM_TYPE", // Special marker that will be replaced during type checking
			paramNames: []string{"index"},
			paramTypes: []string{"Int"},
		},
		{
			fullName:   "Array.set",
			methodName: "set",
			returnType: "Array", // Return type is typically the array itself for chaining
			paramNames: []string{"index", "value"},
			paramTypes: []string{"Int", "Object"}, // Accept "Object" as the value type
		},
		{
			fullName:   "Array.length",
			methodName: "length",
			returnType: "Int",
			paramNames: []string{},
			paramTypes: []string{},
		},
		{
			fullName:   "Array.size",
			methodName: "size",
			returnType: "Int",
			paramNames: []string{},
			paramTypes: []string{},
		},
		{
			fullName:   "Array.resize",
			methodName: "resize",
			returnType: "Array",
			paramNames: []string{"new_size"},
			paramTypes: []string{"Int"},
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