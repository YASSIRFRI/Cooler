package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"cooler/codegen"
	"cooler/lexer"
	"cooler/parser"
	"cooler/semantic"
)

func main() {
	var output string
	flag.StringVar(&output, "o", "", "Name of the output executable")
	flag.Parse()

	if flag.NArg() < 1 {
		fmt.Println("Usage: coolc [-o output_executable] source.cool")
		os.Exit(1)
	}

	sourceFile := flag.Arg(0)
	if filepath.Ext(sourceFile) != ".cool" {
		fmt.Printf("Error: Source file %q must have a .cool extension.\n", sourceFile)
		os.Exit(1)
	}

	srcBytes, err := ioutil.ReadFile(sourceFile)
	if err != nil {
		log.Fatalf("Error reading source file %q: %v", sourceFile, err)
	}

	fmt.Println("\033[1;34m========================================\033[0m")
	fmt.Println("\033[1;34m       Cool Compiler (coolc) v0.1       \033[0m")
	fmt.Println("\033[1;34m========================================\033[0m")
	fmt.Printf("Compiling %s...\n", sourceFile)

	lx := lexer.NewLexer(string(srcBytes))
	var tokens []*lexer.Token
	for tok := lx.NextToken(); tok != nil; tok = lx.NextToken() {
		tokens = append(tokens, tok)
	}
	fmt.Printf("Lexing completed: %d tokens generated.\n", len(tokens))

	p := parser.NewParser(tokens)
	prog, err := p.ParseProgram()
	if err != nil {
		log.Fatalf("Parsing error: %v", err)
	}
	fmt.Println("Parsing completed successfully.")

	analyzer := semant.NewSemanticAnalyzer()
	analyzer.Analyze(prog)
	if errs := analyzer.Errors(); len(errs) > 0 {
		fmt.Println("\033[1;31mSemantic errors found:\033[0m")
		for _, e := range errs {
			fmt.Printf("  - %s\n", e)
		}
		os.Exit(1)
	}
	fmt.Println("Semantic analysis passed.")

	llvmModule := codegen.CodegenProgram(prog)
	//fmt.Println(llvmModule)
	fmt.Println("IR Code generation completed.")
	fmt.Println("\033[1;34m========================================\033[0m")
	llvmIR := llvmModule.String()
	baseName := strings.TrimSuffix(sourceFile, ".cool")
	llFile := baseName + ".ll"

	if err := ioutil.WriteFile(llFile, []byte(llvmIR), 0644); err != nil {
		log.Fatalf("Error writing LLVM IR file %q: %v", llFile, err)
	}
	fmt.Printf("LLVM IR written to %s\n", llFile)

	exeName := output
	if exeName == "" {
		exeName = baseName
		// On Windows, append .exe if needed.
		if os.PathSeparator == '\\' && !strings.HasSuffix(exeName, ".exe") {
			exeName += ".exe"
		}
	}

	clangCmd := exec.Command("clang", llFile, "-o", exeName)
	clangCmd.Stdout = os.Stdout
	clangCmd.Stderr = os.Stderr
	fmt.Printf("Invoking clang to produce executable %q...\n", exeName)
	if err := clangCmd.Run(); err != nil {
		log.Fatalf("Clang failed: %v", err)
	}
	fmt.Printf("\033[1;32mCompilation successful! Executable %q generated.\033[0m\n", exeName)
}
