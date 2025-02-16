package lexer

import (
    "fmt"
    "os"
    "regexp"
    "strings"
)

type Token struct {
    Type  string
    Value interface{}
    Line  int
}

type Lexer struct {
    input        string
    pos          int
    line         int
    state        string
    commentCount int
}

var reserved = map[string]string{
    "class":    "CLASS",
    "inherits": "INHERITS",
    "if":       "IF",
    "in":       "IN",
    "then":     "THEN",
    "else":     "ELSE",
    "fi":       "FI",
    "while":    "WHILE",
    "loop":     "LOOP",
    "pool":     "POOL",
    "let":      "LET",
    "case":     "CASE",
    "of":       "OF",
    "esac":     "ESAC",
    "new":      "NEW",
    "self":     "SELF",
    "isvoid":   "ISVOID",
    "array":    "ARRAY", // Added for array support
}

func NewLexer(input string) *Lexer {
    return &Lexer{
        input: input,
        pos:   0,
        line:  1,
        state: "DEFAULT",
    }
}

func (lx *Lexer) nextToken() *Token {
    lx.skipWhitespace()
    if lx.pos >= len(lx.input) {
        return nil
    }
    if lx.state == "COMMENT" {
        lx.skipComment()
        lx.skipWhitespace()
        if lx.pos >= len(lx.input) {
            return nil
        }
    }

    for strings.HasPrefix(lx.input[lx.pos:], "(*") {
        lx.state = "COMMENT"
        lx.pos += 2
        lx.skipComment()
        lx.skipWhitespace()
        if lx.pos >= len(lx.input) {
            return nil
        }
    }

    for strings.HasPrefix(lx.input[lx.pos:], "--") {
        lx.skipSingleLineComment()
        lx.skipWhitespace()
        if lx.pos >= len(lx.input) {
            return nil
        }
    }

    if m, text := lx.matchRegex(`^[0-9]+`); m {
        lx.pos += len(text)
        return &Token{Type: "INTEGER", Value: toInt(text), Line: lx.line}
    }

    if m, text := lx.matchRegex(`^"[^"]*"`); m {
        lx.pos += len(text)
        return &Token{Type: "STRING", Value: text[1 : len(text)-1], Line: lx.line}
    }

    if m, text := lx.matchRegex(`^(true|false)\b`); m {
        lx.pos += len(text)
        boolVal := (text == "true")
        return &Token{Type: "BOOL", Value: boolVal, Line: lx.line}
    }

    if m, text := lx.matchRegex(`^(?i)not\b`); m {
        lx.pos += len(text)
        return &Token{Type: "NOT", Value: text, Line: lx.line}
    }

    if m, text := lx.matchRegex(`^[A-Z][A-Za-z0-9_]*`); m {
        lx.pos += len(text)
        return &Token{Type: "TYPE", Value: text, Line: lx.line}
    }

    if m, text := lx.matchRegex(`^[a-z_][A-Za-z0-9_]*`); m {
        lx.pos += len(text)
        if t, ok := reserved[strings.ToLower(text)]; ok {
            return &Token{Type: t, Value: text, Line: lx.line}
        }
        return &Token{Type: "ID", Value: text, Line: lx.line}
    }

    if strings.HasPrefix(lx.input[lx.pos:], "<-") {
        lx.pos += 2
        return &Token{Type: "ASSIGN", Value: "<-", Line: lx.line}
    }
    if strings.HasPrefix(lx.input[lx.pos:], "<=") {
        lx.pos += 2
        return &Token{Type: "LTEQ", Value: "<=", Line: lx.line}
    }
    if strings.HasPrefix(lx.input[lx.pos:], "=>") {
        lx.pos += 2
        return &Token{Type: "ACTION", Value: "=>", Line: lx.line}
    }

    ch := lx.input[lx.pos]
    switch ch {
    case '+':
        lx.pos++
        return &Token{Type: "PLUS", Value: "+", Line: lx.line}
    case '-':
        lx.pos++
        return &Token{Type: "MINUS", Value: "-", Line: lx.line}
    case '*':
        lx.pos++
        return &Token{Type: "MULTIPLY", Value: "*", Line: lx.line}
    case '/':
        lx.pos++
        return &Token{Type: "DIVIDE", Value: "/", Line: lx.line}
    case '~':
        lx.pos++
        return &Token{Type: "INT_COMP", Value: "~", Line: lx.line}
    case '<':
        lx.pos++
        return &Token{Type: "LT", Value: "<", Line: lx.line}
    case '=':
        lx.pos++
        return &Token{Type: "EQ", Value: "=", Line: lx.line}
    case '(':
        lx.pos++
        return &Token{Type: "LPAREN", Value: "(", Line: lx.line}
    case ')':
        lx.pos++
        return &Token{Type: "RPAREN", Value: ")", Line: lx.line}
    case '{':
        lx.pos++
        return &Token{Type: "LBRACE", Value: "{", Line: lx.line}
    case '}':
        lx.pos++
        return &Token{Type: "RBRACE", Value: "}", Line: lx.line}
    case ':':
        lx.pos++
        return &Token{Type: "COLON", Value: ":", Line: lx.line}
    case ',':
        lx.pos++
        return &Token{Type: "COMMA", Value: ",", Line: lx.line}
    case '.':
        lx.pos++
        return &Token{Type: "DOT", Value: ".", Line: lx.line}
    case ';':
        lx.pos++
        return &Token{Type: "SEMICOLON", Value: ";", Line: lx.line}
    case '@':
        lx.pos++
        return &Token{Type: "AT", Value: "@", Line: lx.line}
    case '[': // Added bracket support
        lx.pos++
        return &Token{Type: "LBRACKET", Value: "[", Line: lx.line}
    case ']': // Added bracket support
        lx.pos++
        return &Token{Type: "RBRACKET", Value: "]", Line: lx.line}
    default:
        errChar := string(ch)
        fmt.Fprintf(os.Stderr, "Illegal character '%s' at line %d\n", errChar, lx.line)
        lx.pos++
        return lx.nextToken()
    }
}

func (lx *Lexer) skipWhitespace() {
    for lx.pos < len(lx.input) {
        ch := lx.input[lx.pos]
        if ch == ' ' || ch == '\t' || ch == '\r' {
            lx.pos++
        } else if ch == '\n' {
            lx.line++
            lx.pos++
        } else {
            break
        }
    }
}

func (lx *Lexer) skipSingleLineComment() {
    for lx.pos < len(lx.input) && lx.input[lx.pos] != '\n' {
        lx.pos++
    }
    if lx.pos < len(lx.input) && lx.input[lx.pos] == '\n' {
        lx.line++
        lx.pos++
    }
}

func (lx *Lexer) skipComment() {
    for lx.pos < len(lx.input) {
        if strings.HasPrefix(lx.input[lx.pos:], "(*") {
            lx.commentCount++
            lx.pos += 2
            continue
        }
        if strings.HasPrefix(lx.input[lx.pos:], "*)") {
            if lx.commentCount == 0 {
                lx.pos += 2
                lx.state = "DEFAULT"
                return
            }
            lx.commentCount--
            lx.pos += 2
            continue
        }
        if lx.input[lx.pos] == '\n' {
            lx.line++
        }
        lx.pos++
    }
    lx.state = "DEFAULT"
}

func (lx *Lexer) matchRegex(pattern string) (bool, string) {
    re := regexp.MustCompile(pattern)
    remaining := lx.input[lx.pos:]
    loc := re.FindStringIndex(remaining)
    if loc != nil && loc[0] == 0 {
        return true, remaining[loc[0]:loc[1]]
    }
    return false, ""
}

func toInt(s string) int {
    var n int
    fmt.Sscanf(s, "%d", &n)
    return n
}

func (lx *Lexer) NextToken() *Token {
    return lx.nextToken()
}