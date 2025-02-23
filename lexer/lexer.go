package lexer

import (
    "fmt"
    "io/ioutil"
    "os"
    "path/filepath"
    "regexp"
    "strings"
)

// ------------------------------------
// Data structures for Module System
// ------------------------------------

// ImportError represents a failure to import a file, either from
// a missing file, or from a cyclic import.
type ImportError struct {
    Path      string
    ErrorType string
    Message   string
}

// ModuleSystem tracks which files have been visited to detect cyclic imports,
// as well as any import-related errors encountered.
type ModuleSystem struct {
    visited map[string]bool
    errors  []ImportError
}

// NewModuleSystem creates a new ModuleSystem.
func NewModuleSystem() *ModuleSystem {
    return &ModuleSystem{
        visited: make(map[string]bool),
        errors:  []ImportError{},
    }
}

// HasErrors returns true if we have recorded any import errors.
func (ms *ModuleSystem) HasErrors() bool {
    return len(ms.errors) > 0
}

// AddError appends a new ImportError to the system's list of errors.
func (ms *ModuleSystem) AddError(path, etype, msg string) {
    ms.errors = append(ms.errors, ImportError{
        Path:      path,
        ErrorType: etype,
        Message:   msg,
    })
}

// Errors returns the recorded import errors.
func (ms *ModuleSystem) Errors() []ImportError {
    return ms.errors
}

// ------------------------------------
// Import Expansion Logic (Preprocessor)
// ------------------------------------

// ExpandImports scans the given `source` looking for statements of the form:
//
//     import ./SomePath;
//
// It reads the file at `path`, recursively expands any imports in that file,
// and **replaces** the import statement in the original source with the file’s content.
func ExpandImports(source string, baseDir string, ms *ModuleSystem) (string, error) {
    importRegex := regexp.MustCompile(`(?m)^\s*import\s+([^\s;]+)\s*;`)

    // Repeatedly look for "import <path>;" until no matches remain
    for {
        loc := importRegex.FindStringSubmatchIndex(source)
        if loc == nil {
            // No more matches found, break
            break
        }

        // loc[0], loc[1] => indices of the full matched import line
        // loc[2], loc[3] => indices of the captured group (the path)
        fullMatchStart := loc[0]
        fullMatchEnd := loc[1]
        pathStart := loc[2]
        pathEnd := loc[3]

        importPath := strings.TrimSpace(source[pathStart:pathEnd])

        // Resolve the absolute or relative path
        fullImportPath := importPath
        if !filepath.IsAbs(importPath) {
            fullImportPath = filepath.Join(baseDir, importPath)
        }

        // Expand that file
        expanded, err := expandFile(fullImportPath, ms)
        if err != nil {
            // Return on first error
            return source, err
        }

        // Replace the import statement with the expanded content
        source = source[:fullMatchStart] + expanded + source[fullMatchEnd:]
    }

    return source, nil
}

// expandFile is a helper that reads the file at `path`, checks for cyclic imports,
// and if okay, recursively expands all imports in that file.
func expandFile(path string, ms *ModuleSystem) (string, error) {
    // add .cl extension if not present
    if filepath.Ext(path) != ".cl" {
        path += ".cl"
    }
    absPath, err := filepath.Abs(path)
    if err != nil {
        // fallback
        absPath = path
    }

    // Detect cyclic import
    if ms.visited[absPath] {
        msg := fmt.Sprintf("Cyclic import detected for path %s", absPath)
        ms.AddError(absPath, "CyclicImport", msg)
        return "", fmt.Errorf(msg)
    }

    // Mark as visited
    ms.visited[absPath] = true

    // Read file
    data, err := ioutil.ReadFile(absPath)
    if err != nil {
        msg := fmt.Sprintf("Cannot read file: %s, error: %v", absPath, err)
        ms.AddError(absPath, "FileNotFound", msg)
        return "", fmt.Errorf(msg)
    }

    // Recursively expand any imports in that file
    content := string(data)
    expanded, err := ExpandImports(content, filepath.Dir(absPath), ms)
    if err != nil {
        return "", err
    }

    // If you want to allow re-importing the same file from a different chain:
    // unmark after expansion is done.
    ms.visited[absPath] = false

    return expanded, nil
}

// ------------------------------------
// Lexer Implementation
// ------------------------------------

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
    "array":    "ARRAY",
}

// NewLexer takes the fully expanded source code (where all imports have been
// replaced) and returns a Lexer ready to produce tokens.
func NewLexer(input string) *Lexer {
    return &Lexer{
        input: input,
        pos:   0,
        line:  1,
        state: "DEFAULT",
    }
}

// NextToken is the public method to get the next token from the input.
func (lx *Lexer) NextToken() *Token {
    return lx.nextToken()
}

func (lx *Lexer) nextToken() *Token {
    lx.skipWhitespace()
    if lx.pos >= len(lx.input) {
        return nil
    }

    // If we are in a comment state, skip it first
    if lx.state == "COMMENT" {
        lx.skipComment()
        lx.skipWhitespace()
        if lx.pos >= len(lx.input) {
            return nil
        }
    }

    // Check for multiline comment starts: "(*"
    for strings.HasPrefix(lx.input[lx.pos:], "(*") {
        lx.state = "COMMENT"
        lx.pos += 2
        lx.skipComment()
        lx.skipWhitespace()
        if lx.pos >= len(lx.input) {
            return nil
        }
    }

    // Check for single-line comment: "--"
    for strings.HasPrefix(lx.input[lx.pos:], "--") {
        lx.skipSingleLineComment()
        lx.skipWhitespace()
        if lx.pos >= len(lx.input) {
            return nil
        }
    }

    // INTEGER
    if m, text := lx.matchRegex(`^[0-9]+`); m {
        lx.pos += len(text)
        return &Token{Type: "INTEGER", Value: toInt(text), Line: lx.line}
    }

    // STRING (naive: doesn't handle escaped quotes, etc.)
    if m, text := lx.matchRegex(`^"[^"]*"`); m {
        lx.pos += len(text)
        return &Token{Type: "STRING", Value: text[1 : len(text)-1], Line: lx.line}
    }

    // BOOL
    if m, text := lx.matchRegex(`^(true|false)\b`); m {
        lx.pos += len(text)
        boolVal := (text == "true")
        return &Token{Type: "BOOL", Value: boolVal, Line: lx.line}
    }

    // NOT
    if m, text := lx.matchRegex(`^(?i)not\b`); m {
        lx.pos += len(text)
        return &Token{Type: "NOT", Value: text, Line: lx.line}
    }

    // TYPE: must start with a capital letter
    if m, text := lx.matchRegex(`^[A-Z][A-Za-z0-9_]*`); m {
        lx.pos += len(text)
        return &Token{Type: "TYPE", Value: text, Line: lx.line}
    }

    // ID or reserved word
    if m, text := lx.matchRegex(`^[a-z_][A-Za-z0-9_]*`); m {
        lx.pos += len(text)
        lower := strings.ToLower(text)
        if t, ok := reserved[lower]; ok {
            return &Token{Type: t, Value: text, Line: lx.line}
        }
        return &Token{Type: "ID", Value: text, Line: lx.line}
    }

    // Double-character operators
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

    // Single-character tokens
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
    case '[':
        lx.pos++
        return &Token{Type: "LBRACKET", Value: "[", Line: lx.line}
    case ']':
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

// skipComment handles nested (* ... *) style comments.
func (lx *Lexer) skipComment() {
    for lx.pos < len(lx.input) {
        // Look for a nested start
        if strings.HasPrefix(lx.input[lx.pos:], "(*") {
            lx.commentCount++
            lx.pos += 2
            continue
        }
        // Look for comment end
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
        // Count newlines for line numbering
        if lx.input[lx.pos] == '\n' {
            lx.line++
        }
        lx.pos++
    }
    // If we exhaust the file, exit comment mode
    lx.state = "DEFAULT"
}

// matchRegex tries to match `pattern` at the current position
// of the input and returns (true, matchedString) if it matches.
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
