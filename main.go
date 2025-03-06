package main

import (
	"cooler/codegen"
	"cooler/lexer"
	"cooler/parser"
	semant "cooler/semantic"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
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
	if filepath.Ext(sourceFile) != ".cool" || filepath.Ext(sourceFile) != ".cl" {
		fmt.Printf("Error: Source file %q must have a .cool or .cl extension.\n", sourceFile)
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

	ms := lexer.NewModuleSystem()
	// TODO: ExpandImports should not allow repeated imports.
	// you are right, I only check for cyclic imports, but I should also check for repeated imports.
	expandedSource, err := lexer.ExpandImports(string(srcBytes), ".", ms)
	if err != nil {
		log.Fatalf("Import expansion error: %v\n", err)
	}
	if ms.HasErrors() {
		for _, e := range ms.Errors() {
			fmt.Printf("Import error: %v\n", e)
		}
		return
	}

	lx := lexer.NewLexer(expandedSource)
	var tokens []*lexer.Token
	for tok := lx.NextToken(); tok != nil; tok = lx.NextToken() {
		tokens = append(tokens, tok)
	}
	// TODO: You could make use of the lexer objecet instead of reading all tokens.
	// I agree, I should use the lexer object instead of reading all tokens.
	p := parser.NewParser(tokens)
	prog, err := p.ParseProgram()
	if err != nil {
		log.Fatalf("Parsing error: %v", err)
	}
	analyzer := semant.NewSemanticAnalyzer()
	analyzer.Analyze(prog)
	if errs := analyzer.Errors(); len(errs) > 0 {
		fmt.Println("\033[1;31mSemantic errors found:\033[0m")
		for _, e := range errs {
			fmt.Printf("  - %s\n", e)
		}
		os.Exit(1)
	}
	llvmModule := codegen.CodegenProgram(prog)
	//fmt.Println(llvmModule)
	//fmt.Println("IR Code generation completed.")
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
		if os.PathSeparator == '\\' && !strings.HasSuffix(exeName, ".exe") {
			exeName += ".exe"
		}
	}

	// Check if clang is installed
	_, err = exec.LookPath("clang")
	if err != nil {
		fmt.Println("\033[1;31mError: Clang compiler not found!\033[0m")
		fmt.Println("\033[1;33mTo install Clang:\033[0m")

		if os.PathSeparator == '\\' {
			fmt.Println("  - Download LLVM from https://github.com/llvm/llvm-project/releases/")
			fmt.Println("  - Or install with Chocolatey: choco install llvm")
			fmt.Println("  - Ensure clang.exe is in your PATH environment variable")
		} else {
			fmt.Println("  - Ubuntu/Debian: sudo apt-get install clang")
			fmt.Println("  - Fedora/RHEL: sudo dnf install clang")
			fmt.Println("  - macOS: brew install llvm")
		}

		fmt.Println("\033[1;33mAfter installation, try compiling again.\033[0m")
		os.Exit(1)
	}

	clangCmd := exec.Command("clang", llFile, "-o", exeName)
	clangCmd.Stdout = os.Stdout
	clangCmd.Stderr = os.Stderr
	if err := clangCmd.Run(); err != nil {
		log.Fatalf("Clang failed: %v", err)
	}
	fmt.Printf("\033[1;32mCompilation successful! Executable %q generated.\033[0m\n", exeName)
}
