package lexer

import (
	"fmt"
	"testing"
)

func getAllTokens(input string) []*Token {
	lexer := NewLexer(input)
	var tokens []*Token
	for {
		token := lexer.nextToken()
		if token == nil {
			break
		}
		tokens = append(tokens, token)
	}
	return tokens
}

func assertToken(t *testing.T, got *Token, wantType string, wantValue interface{}, wantLine int) {
	if got == nil {
		t.Fatalf("expected token {%s, %v, %d}, got nil", wantType, wantValue, wantLine)
	}
	if got.Type != wantType || got.Value != wantValue || got.Line != wantLine {
		t.Errorf("expected {%s, %v, %d}, got {%s, %v, %d}",
			wantType, wantValue, wantLine,
			got.Type, got.Value, got.Line)
	}
}

func TestBasicTokens(t *testing.T) {
	input := "123 \"hello\" true false"
	tokens := getAllTokens(input)

	expected := []*Token{
		{Type: "INTEGER", Value: 123, Line: 1},
		{Type: "STRING", Value: "hello", Line: 1},
		{Type: "BOOL", Value: true, Line: 1},
		{Type: "BOOL", Value: false, Line: 1},
	}

	for i, want := range expected {
		assertToken(t, tokens[i], want.Type, want.Value, want.Line)
	}
}

func TestOperators(t *testing.T) {
	input := "+ - * / < <= <- => = ~ @"
	tokens := getAllTokens(input)

	expected := []*Token{
		{Type: "PLUS", Value: "+", Line: 1},
		{Type: "MINUS", Value: "-", Line: 1},
		{Type: "MULTIPLY", Value: "*", Line: 1},
		{Type: "DIVIDE", Value: "/", Line: 1},
		{Type: "LT", Value: "<", Line: 1},
		{Type: "LTEQ", Value: "<=", Line: 1},
		{Type: "ASSIGN", Value: "<-", Line: 1},
		{Type: "ACTION", Value: "=>", Line: 1},
		{Type: "EQ", Value: "=", Line: 1},
		{Type: "INT_COMP", Value: "~", Line: 1},
		{Type: "AT", Value: "@", Line: 1},
	}

	for i, want := range expected {
		assertToken(t, tokens[i], want.Type, want.Value, want.Line)
	}
}

func TestReservedKeywords(t *testing.T) {
	input := "class inherits if then else fi while loop pool let case of esac new self isvoid"
	tokens := getAllTokens(input)

	expected := []*Token{
		{Type: "CLASS", Value: "class", Line: 1},
		{Type: "INHERITS", Value: "inherits", Line: 1},
		{Type: "IF", Value: "if", Line: 1},
		{Type: "THEN", Value: "then", Line: 1},
		{Type: "ELSE", Value: "else", Line: 1},
		{Type: "FI", Value: "fi", Line: 1},
		{Type: "WHILE", Value: "while", Line: 1},
		{Type: "LOOP", Value: "loop", Line: 1},
		{Type: "POOL", Value: "pool", Line: 1},
		{Type: "LET", Value: "let", Line: 1},
		{Type: "CASE", Value: "case", Line: 1},
		{Type: "OF", Value: "of", Line: 1},
		{Type: "ESAC", Value: "esac", Line: 1},
		{Type: "NEW", Value: "new", Line: 1},
		{Type: "SELF", Value: "self", Line: 1},
		{Type: "ISVOID", Value: "isvoid", Line: 1},
	}

	for i, want := range expected {
		assertToken(t, tokens[i], want.Type, want.Value, want.Line)
	}
}

func TestComments(t *testing.T) {
	input := `
        (* This is a comment *)
        -- This is a single line comment
        (* Nested (* comment *) test *)
        token
    `
	tokens := getAllTokens(input)
	if len(tokens) != 1 {
		t.Errorf("expected 1 token, got %d", len(tokens))
	}
	// The token "token" appears on line 5
	assertToken(t, tokens[0], "ID", "token", 5)
}

func TestLineNumbers(t *testing.T) {
	input := "token1\ntoken2\n\ntoken3"
	tokens := getAllTokens(input)

	expected := []*Token{
		{Type: "ID", Value: "token1", Line: 1},
		{Type: "ID", Value: "token2", Line: 2},
		{Type: "ID", Value: "token3", Line: 4},
	}

	for i, want := range expected {
		assertToken(t, tokens[i], want.Type, want.Value, want.Line)
	}
}

func TestComplexProgram(t *testing.T) {
	input := `
        class Main {
            let x: Int <- 42;
            if x <= 100 then
                x <- x + 1
            else
                x <- x - 1
            fi;
        }
    `
	tokens := getAllTokens(input)

	expected := []*Token{
		{Type: "CLASS", Value: "class", Line: 2},
		{Type: "TYPE", Value: "Main", Line: 2},
		{Type: "LBRACE", Value: "{", Line: 2},
		{Type: "LET", Value: "let", Line: 3},
		{Type: "ID", Value: "x", Line: 3},
		{Type: "COLON", Value: ":", Line: 3},
		{Type: "TYPE", Value: "Int", Line: 3},
		{Type: "ASSIGN", Value: "<-", Line: 3},
		{Type: "INTEGER", Value: 42, Line: 3},
		{Type: "SEMICOLON", Value: ";", Line: 3},
		{Type: "IF", Value: "if", Line: 4},
		{Type: "ID", Value: "x", Line: 4},
		{Type: "LTEQ", Value: "<=", Line: 4},
		{Type: "INTEGER", Value: 100, Line: 4},
		{Type: "THEN", Value: "then", Line: 4},
		{Type: "ID", Value: "x", Line: 5},
		{Type: "ASSIGN", Value: "<-", Line: 5},
		{Type: "ID", Value: "x", Line: 5},
		{Type: "PLUS", Value: "+", Line: 5},
		{Type: "INTEGER", Value: 1, Line: 5},
		{Type: "ELSE", Value: "else", Line: 6},
		{Type: "ID", Value: "x", Line: 7},
		{Type: "ASSIGN", Value: "<-", Line: 7},
		{Type: "ID", Value: "x", Line: 7},
		{Type: "MINUS", Value: "-", Line: 7},
		{Type: "INTEGER", Value: 1, Line: 7},
		{Type: "FI", Value: "fi", Line: 8},
		{Type: "SEMICOLON", Value: ";", Line: 8},
		{Type: "RBRACE", Value: "}", Line: 9},
	}

	for i, want := range expected {
		assertToken(t, tokens[i], want.Type, want.Value, want.Line)
	}
}

func TestIllegalCharacters(t *testing.T) {
	input := "valid_token #$ another_token"
	tokens := getAllTokens(input)
	for i := 0; i < len(tokens); i++ {
		fmt.Println(tokens[i])
	}
	if len(tokens) != 2 {
		t.Errorf("expected 2 tokens, got %d", len(tokens))
	}
	assertToken(t, tokens[0], "ID", "valid_token", 1)
	assertToken(t, tokens[1], "ID", "another_token", 1)
}

func TestNotOperator(t *testing.T) {
	input := "not Not nOT"
	tokens := getAllTokens(input)
	expected := []*Token{
		{Type: "NOT", Value: "not", Line: 1},
		{Type: "NOT", Value: "Not", Line: 1},
		{Type: "NOT", Value: "nOT", Line: 1},
	}
	for i, want := range expected {
		assertToken(t, tokens[i], want.Type, want.Value, want.Line)
	}
}

func TestIdentifierAndType(t *testing.T) {
	input := "MyType myVar anotherVar AnotherType"
	tokens := getAllTokens(input)
	expected := []*Token{
		{Type: "TYPE", Value: "MyType", Line: 1},
		{Type: "ID", Value: "myVar", Line: 1},
		{Type: "ID", Value: "anotherVar", Line: 1},
		{Type: "TYPE", Value: "AnotherType", Line: 1},
	}
	for i, want := range expected {
		assertToken(t, tokens[i], want.Type, want.Value, want.Line)
	}
}

func TestSymbolsEdge(t *testing.T) {
	input := " ( ) { } : , . ; "
	tokens := getAllTokens(input)
	expected := []*Token{
		{Type: "LPAREN", Value: "(", Line: 1},
		{Type: "RPAREN", Value: ")", Line: 1},
		{Type: "LBRACE", Value: "{", Line: 1},
		{Type: "RBRACE", Value: "}", Line: 1},
		{Type: "COLON", Value: ":", Line: 1},
		{Type: "COMMA", Value: ",", Line: 1},
		{Type: "DOT", Value: ".", Line: 1},
		{Type: "SEMICOLON", Value: ";", Line: 1},
	}
	for i, want := range expected {
		assertToken(t, tokens[i], want.Type, want.Value, want.Line)
	}
}


func TestStressTestFile(t *testing.T) {

	/*
	tokens: class, typeid, let, obid, col, typeid, assign, int, sem, let, obid, col, typeid, assign, string, sem, let, obid, col, typeid, assign, bool, sem, let, obid, col, typeid, assign, bool, sem, obid, assign, obid, plus, int, sem, obid, assign, obid, dot, string, sem, obid, assign, not, obid, sem, obid, assign, isvoid, obid, sem, if, obid, lt, int, then, obid, assign, obid, mult, int, else, obid, assign, obid, minus, int, fi, sem, while, obid, le, int, loop, obid, assign, obid, plus, int, pool, sem, case, obid, of, int, action, string, int, action, string, action, string, esac, sem, new, typeid, sem, rbrace
	*/
	input := `(*----------------------------------------------------------
   Stress Test File for COOL Lexer
   This file is purposely written with a variety of tokens,
   operators, nested comments, and reserved keywords to
   stress the lexer.
----------------------------------------------------------*)

class StressTest {
    (* Declare variables using 'let' and test various types *)
    let a : Int <- 12345;
    let b : String <- "Hello, COOL world! @ cool-language.";
    let c : Bool <- true;
    let d : Bool <- false;
    
    -- Single-line comment: The following line uses several operators.
    a <- a + 1;
    b <- b . " extended string";  -- Concatenation operator represented by a DOT.
    c <- not c;                  -- 'not' operator; case-insensitive.
    d <- isvoid a;               -- 'isvoid' keyword.

    (* 
       Multi-line comment: 
       Testing various symbols and tokens:  ( + - * / : ; ( ) { } < = <= <- => 
       Also, observe that the lexer should handle nested comments.
    *)
    (* Outer comment begins here.
       (* Inner nested comment begins.
           More tokens in a nested comment: 999, "nested", false, and operators like <= and <-.
       Inner nested comment ends. *)
       Back to the outer comment.
    *)

    if a < 100 then
        a <- a * 2;
    else
        a <- a - 1;
    fi;

    while a <= 200 loop
        a <- a + 10;
    pool;

    case a of
        10 => "ten";
        20 => "twenty";
        _ => "other";
    esac;

    new StressTest;  -- Use of 'new' keyword.
}

(* Additional Nested Comment Test:
   This comment tests deep nesting and mixing tokens with whitespace.

   (* Level 1
        (* Level 2 
             (* Level 3 
                Use tokens: + - * / :=; () {} @ . , < = <= <- => not
             *) 
        *)
   *)
*)

-- End of the stress test file.`

	tokens := getAllTokens(input)

	expected := []struct {
		Type  string
		Value interface{}
		Line  int
	}{
		// "class StressTest {" from line 8:
		{Type: "CLASS", Value: "class", Line: 8},
		{Type: "TYPE", Value: "StressTest", Line: 8},
		{Type: "LBRACE", Value: "{", Line: 8},

		// "let a : Int <- 12345;" from line 10:
		{Type: "LET", Value: "let", Line: 10},
		{Type: "ID", Value: "a", Line: 10},
		{Type: "COLON", Value: ":", Line: 10},
		{Type: "TYPE", Value: "Int", Line: 10},
		{Type: "ASSIGN", Value: "<-", Line: 10},
		{Type: "INTEGER", Value: 12345, Line: 10},
		{Type: "SEMICOLON", Value: ";", Line: 10},

		// "let b : String <- "Hello, COOL world! @ cool-language.";" from line 11:
		{Type: "LET", Value: "let", Line: 11},
		{Type: "ID", Value: "b", Line: 11},
		{Type: "COLON", Value: ":", Line: 11},
		{Type: "TYPE", Value: "String", Line: 11},
		{Type: "ASSIGN", Value: "<-", Line: 11},
		{Type: "STRING", Value: "Hello, COOL world! @ cool-language.", Line: 11},
		{Type: "SEMICOLON", Value: ";", Line: 11},

		// "let c : Bool <- true;" from line 12:
		{Type: "LET", Value: "let", Line: 12},
		{Type: "ID", Value: "c", Line: 12},
		{Type: "COLON", Value: ":", Line: 12},
		{Type: "TYPE", Value: "Bool", Line: 12},
		{Type: "ASSIGN", Value: "<-", Line: 12},
		{Type: "BOOL", Value: true, Line: 12},
		{Type: "SEMICOLON", Value: ";", Line: 12},

		// "let d : Bool <- false;" from line 13:
		{Type: "LET", Value: "let", Line: 13},
		{Type: "ID", Value: "d", Line: 13},
		{Type: "COLON", Value: ":", Line: 13},
		{Type: "TYPE", Value: "Bool", Line: 13},
		{Type: "ASSIGN", Value: "<-", Line: 13},
		{Type: "BOOL", Value: false, Line: 13},
		{Type: "SEMICOLON", Value: ";", Line: 13},


		// One of the operator statements: from line 16 "a <- a + 1;"
		{Type: "ID", Value: "a", Line: 16},
		{Type: "ASSIGN", Value: "<-", Line: 16},
		{Type: "ID", Value: "a", Line: 16},
		{Type: "PLUS", Value: "+", Line: 16},
		{Type: "INTEGER", Value: 1, Line: 16},
		{Type: "SEMICOLON", Value: ";", Line: 16},

		// The usage of dot operator on line 17: "b <- b . " extended string";"
		{Type: "ID", Value: "b", Line: 17},
		{Type: "ASSIGN", Value: "<-", Line: 17},
		{Type: "ID", Value: "b", Line: 17},
		{Type: "DOT", Value: ".", Line: 17},
		{Type: "STRING", Value: " extended string", Line: 17},
		{Type: "SEMICOLON", Value: ";", Line: 17},

		// The usage of not on line 18: "c <- not c;"
		{Type: "ID", Value: "c", Line: 18},
		{Type: "ASSIGN", Value: "<-", Line: 18},
		{Type: "NOT", Value: "not", Line: 18},
		{Type: "ID", Value: "c", Line: 18},
		{Type: "SEMICOLON", Value: ";", Line: 18},

		// The usage of isvoid on line 19: "d <- isvoid a;"
		{Type: "ID", Value: "d", Line: 19},
		{Type: "ASSIGN", Value: "<-", Line: 19},
		{Type: "ISVOID", Value: "isvoid", Line: 19},
		{Type: "ID", Value: "a", Line: 19},
		{Type: "SEMICOLON", Value: ";", Line: 19},

		// The usage of if on line 33: "if a < 100 then"
		{Type: "IF", Value: "if", Line: 33},
		{Type: "ID", Value: "a", Line: 33},
		{Type: "LT", Value: "<", Line: 33},
		{Type: "INTEGER", Value: 100, Line: 33},
		{Type: "THEN", Value: "then", Line: 33},


		// The usage of a<-a*2; on line 34: "a <- a * 2;"
		{Type: "ID", Value: "a", Line: 34},
		{Type: "ASSIGN", Value: "<-", Line: 34},
		{Type: "ID", Value: "a", Line: 34},
		{Type: "MULTIPLY", Value: "*", Line: 34},
		{Type: "INTEGER", Value: 2, Line: 34},
		{Type: "SEMICOLON", Value: ";", Line: 34},

		// The usage of else on line 36: "else"
		{Type: "ELSE", Value: "else", Line: 35},

		// The usage of a<-a-1; on line 36: "a <- a - 1;"
		{Type: "ID", Value: "a", Line: 36},
		{Type: "ASSIGN", Value: "<-", Line: 36},
		{Type: "ID", Value: "a", Line: 36},
		{Type: "MINUS", Value: "-", Line: 36},
		{Type: "INTEGER", Value: 1, Line: 36},
		{Type: "SEMICOLON", Value: ";", Line: 36},

		// The usage of fi on line 38: "fi;"
		{Type: "FI", Value: "fi", Line: 37},
		{Type: "SEMICOLON", Value: ";", Line: 37},


		// The usage of while on line 39: "while a <= 200 loop";
		{Type: "WHILE", Value: "while", Line: 39},
		{Type: "ID", Value: "a", Line: 39},
		{Type: "LTEQ", Value: "<=", Line: 39},
		{Type: "INTEGER", Value: 200, Line: 39},
		{Type: "LOOP", Value: "loop", Line: 39},

		// The usage of a<-a+10; on line 40: "a <- a + 10;"
		{Type: "ID", Value: "a", Line: 40},
		{Type: "ASSIGN", Value: "<-", Line: 40},
		{Type: "ID", Value: "a", Line: 40},
		{Type: "PLUS", Value: "+", Line: 40},
		{Type: "INTEGER", Value: 10, Line: 40},
		{Type: "SEMICOLON", Value: ";", Line: 40},

		// The usage of pool on line 41: "pool;"
		{Type: "POOL", Value: "pool", Line: 41},
		{Type: "SEMICOLON", Value: ";", Line: 41},


		// The usage of case on line 43: "case a of"
		{Type: "CASE", Value: "case", Line: 43},
		{Type: "ID", Value: "a", Line: 43},
		{Type: "OF", Value: "of", Line: 43},

		// The usage of 10 => "ten"; on line 44: "10 => "ten";"
		{Type: "INTEGER", Value: 10, Line: 44},
		{Type: "ACTION", Value: "=>", Line: 44},
		{Type: "STRING", Value: "ten", Line: 44},
		{Type: "SEMICOLON", Value: ";", Line: 44},

		// The usage of 20 => "twenty"; on line 45: "20 => "twenty";"
		{Type: "INTEGER", Value: 20, Line: 45},
		{Type: "ACTION", Value: "=>", Line: 45},
		{Type: "STRING", Value: "twenty", Line: 45},
		{Type: "SEMICOLON", Value: ";", Line: 45},

		// The usage of _ => "other"; on line 46: "_ => "other";"
		{Type: "UNDERSCORE", Value: "_", Line: 46},
		{Type: "ACTION", Value: "=>", Line: 46},
		{Type: "STRING", Value: "other", Line: 46},
		{Type: "SEMICOLON", Value: ";", Line: 46},

		// The usage of esac on line 47: "esac;"
		{Type: "ESAC", Value: "esac", Line: 47},
		{Type: "SEMICOLON", Value: ";", Line: 47},



		// The usage of case on line 29: "case a of"
		{Type: "CASE", Value: "case", Line: 29},
		{Type: "ID", Value: "a", Line: 29},
		{Type: "OF", Value: "of", Line: 29},


		// The usage of new on line 49: "new StressTest;  -- Use of 'new' keyword."
		{Type: "NEW", Value: "new", Line: 49},
		{Type: "TYPE", Value: "StressTest", Line: 49},
		{Type: "SEMICOLON", Value: ";", Line: 49},

		// Closing bracket on line 50 ("}")
		{Type: "RBRACE", Value: "}", Line: 50},
	}

	if len(tokens) < len(expected) {
		t.Fatalf("expected at least %d tokens, got %d", len(expected), len(tokens))
	}

	for i, exp := range expected {
		assertToken(t, tokens[i], exp.Type, exp.Value, exp.Line)
	}
}
