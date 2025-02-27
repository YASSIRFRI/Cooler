<p align="center">
  <img src="/assets/logo.png" alt="COOL Logo" width="200"/>
</p>

# Cooler: A COOL Language Compiler in Go 🚀

Cooler is a no-nonsense, efficient compiler for the Classroom Object-Oriented Language (COOL) written in Go. Designed for clarity and simplicity Cooler not only supports standard language features but also includes a powerful code generation backend that leverages LLVM IR for native code generation.

## Platform Support & Requirements ⚙️


### Requirements
- Go 1.19 or higher
- Clang compiler
- For Windows users:
  - Visual Studio Build Tools (not needed for Windows 11)
  - LLVM toolchain

#### Supported Platforms
- ✅ Windows
- ✅ Linux
- ⚠️ macOS (some features may have limited compatibility)


---

## Overview
- **Parsing & Pratt Parsing**
- **Semantic Analysis & Inheritance Graph Construction**
- **Visualization of AST and Class Hierarchies**
- **Code Generation & Runtime**

---


### Extensions 🌟

Cooler extends the COOL language with powerful features to enhance modularity and data structure capabilities:

#### Module System 📦

- **Description:** Cooler's module system allows you to split your COOL code into multiple files and import them into other files. The compiler automatically searches for imported files in the local directory.
- **Technical Details:** The preprocessor identifies `import` statements, locates the specified COOL files, and effectively copies the code into the main source file before compilation. This process also detects and prevents cyclic imports, ensuring code integrity.
- **Usage:**
  ```cool
  -- main.cool
  import "module1.cool";
  import "module2.cool";

  class Main inherits IO {
      main() : Object {
          (new Module1).print();
      };
  };
  ```

#### Container Types 🗄️

Cooler introduces two container types to provide flexible data storage options:

1. **Native Arrays 🚀**
   - **Description:** Native arrays offer high-performance storage for COOL's native types (Int, String, Bool).
   - **Technical Details:** Arrays are implemented using COOL builtin types, providing efficient memory access (O(1)). Array bounds are checked at runtime to prevent out-of-bounds errors.
   - **Usage:**
     ```cool
     class Main inherits IO {
         arr : Array[Int] <- new Array[Int]; -- Initialize an array of 10 Ints by default
         main() : Object {
             {
                 arr.set(0, 5);
                 out_int(arr.get(0));
             }
         };
     };
     ```

2. **Generic Linked List ⛓️**
   - **Description:** A generic container type implemented using a linked list, allowing storage of any COOL object.
   - **Technical Details:** The linked list provides dynamic resizing and supports insertion, deletion, and search operations. It uses COOL's object system to store elements, ensuring type safety.
   - **Usage:**
     ```cool
     class Main inherits IO {
         list : List[String] <- new List[String];
         main() : Object {
             {
                 list.insert("hello");
                 list.insert("world");
                 list.print(); -- Prints "hello world"
             }
         };
     };
     ```


## Key Features

### Lexical Analysis & Preprocessing ✂️
- **Tokenization:**  
  - Supports multi-line nested comments (`(* ... *)`), single-line comments (`--`), string literals with escape sequences, integer literals, identifiers, and keywords.
- **Preprocessor:**  
  - Validates import statements and handles module dependencies and cyclic imports.
  - All files are looked up in the current working directory; paths can also be specified explicitly.

### Parsing 🔥
- **Pratt Parsing Approach:**  
  - Implements a Pratt parsing strategy that dynamically registers both prefix and infix parse functions to handle operator precedence.
  - Efficiently parses expressions, method calls, and nested structures by leveraging clear precedence rules.
- **Parser Features:**  
  - Supports COOL’s full grammar—including class definitions, methods, attributes, and control structures.
  - Provides detailed error messages with contextual token information for easier debugging.
- **Core Code Snippet (Pratt Parsing in Action):**
  ```go
  func (p *Parser) parseExpression(precedence int) (Node, error) {
      tok := p.currentToken()
      if tok == nil {
          return nil, p.errorf("unexpected end of input")
      }
  
      prefix := p.prefixParseFns[tok.Type]
      if prefix == nil {
          return nil, p.errorf("no prefix parse function for token %s", tok.Type)
      }
  
      left, err := prefix()
      if err != nil {
          return nil, err
      }
      for p.currentToken() != nil && precedence < p.curPrecedence() {
          current := p.currentToken().Type
          infix := p.infixParseFns[current]
          if infix == nil {
              break
          }
          left, err = infix(left)
          if err != nil {
              return nil, err
          }
      }
      return left, nil
  }
  ```
  - This function is the heart of the parser, demonstrating how COOL expressions are evaluated with respect to operator precedence.

### Semantic Analysis & Inheritance Graph 🌳
- **Inheritance Graph Building:**  
  - Constructs a clear inheritance chain (from `Object` to each user-defined class).
  - Supports visualization of class hierarchies for quick debugging insights.
- **Error Detection & Reporting:**  
  - Detects duplicate definitions, undefined types/identifiers, type mismatches in assignments/method returns, and method signature errors.
  - Provides detailed error messages with context (e.g., `[SEMANT-ERROR in getExprType] use of undeclared identifier "x"`).
- **Expression Evaluation:**  
  - Thoroughly checks arithmetic, logical, and control expressions.
  - Handles `SELF_TYPE` and dynamic method dispatch with robust type conformance.

### Visualization Tool 🎨
- **Graphical Output:**  
  - Visualizes Abstract Syntax Trees (AST) and inheritance graphs.
  - Supports multiple visualization types:

1. **AST Visualization Example:**
```go
// Example 1: Visualizing an AST for a simple COOL program


class Node {
    value : Int;
    next  : Node;

    get_value() : Int {
        value
    };

    set_value(v : Int) : Node {
        {
            value <- v;
            self;
        }
    };

    get_next() : Node {
        next
    };

    set_next(n : Node) : Node {
        {
            next <- n;
            self;
        }
    };

    init_node() : Node {
        {
            value <- 0;
            next <- self;
            self;
        }
    };
};

class LinkedList inherits IO {
    head : Node;

    init_list() : LinkedList {
        {
            head <- new Node;
            head.init_node();
            self;
        }
    };

    insert(val : Int) : LinkedList {
        let new_node : Node <- new Node in {
            new_node.set_value(val);
            new_node.set_next(head.get_next());
            head.set_next(new_node);
            self;
        }
    };

    print() : LinkedList {
        let temp : Node <- head.get_next() in {
            while not (temp = head) loop {
                out_int(temp.get_value());
                out_string(" ");
                temp <- temp.get_next();
            } pool;
            out_string("\n");
            self;
        }
    };

    -- Search for a value in the list. Returns true if found, false otherwise.
    search(val : Int) : Bool {
        let temp : Node <- head.get_next() in {
            let found : Bool <- false in {
                while not (temp = head) loop {
                    if temp.get_value() = val then {
                        found <- true;
                        temp <- head;  -- Force exit from loop
                    } else {
                        temp <- temp.get_next();
                    } fi;
                } pool;
                found
            }
        }
    };
};

class DumbSet inherits IO {
    l : LinkedList;

    init_set() : DumbSet {
        {
            l <- new LinkedList;
            l.init_list();
            self;
        }
    };

    insert(val : Int) : DumbSet {
        {
            if not l.search(val) then
                l.insert(val)
            else {}
            fi;
        self;
        }
    };

    has(val : Int) : Bool {
        l.search(val)
    };

    print_set() : DumbSet {
        {
            l.print();
            self;
        }
    };
};

class Main inherits IO {
    main() : Object {
        let s : DumbSet <- new DumbSet in {
            s.init_set();

            -- Insert some values.
            s.insert(1);
            s.insert(2);
            s.insert(3);
            s.insert(2);  -- Duplicate insert (won't be inserted again)

            out_string("Current set contents:\n");
            s.print_set();

            -- Check membership
            out_string("Check if 2 is in the set: ");
            if s.has(2) then
                out_string("Yes\n")
            else
                out_string("No\n")
            fi;

            out_string("Check if 99 is in the set: ");
            if s.has(99) then
                out_string("Yes\n")
            else
                out_string("No\n")
            fi;

            self;
        }
    };
};

```
<p align="center">
  <img src="/assets/complex_visu.png" alt="AST Visualization" width="600"/>
</p>

2. **Inheritance Graph Example:**
```cool
// Example 2: Class hierarchy visualization
class Animal {
    speak(): String { "..." };
};

class Dog inherits Animal {
    speak(): String { "Woof!" };
};

class Cat inherits Animal {
    speak(): String { "Meow!" };
};
```
<p align="center">
  <img src="/assets/example2.png" alt="Inheritance Graph" width="600"/>
</p>



To generate these visualizations:
```bash
go run visualize_ast_tree.go 
# Copy the  content of the generated file (ast.dot) to : https://dreampuf.github.io/GraphvizOnline/
```

### Code Generation & Runtime ⚙️
- **LLVM IR Generation:**  
  - Translates COOL AST into LLVM IR for optimization and native code generation.
- **Memory & Object Model:**  
  - Implements boxing/unboxing for primitive types (e.g., `Int` and `Bool`).
  - Uses virtual method tables (VTables) to support dynamic dispatch.
- **Advanced Code Generation:**  
  - **Dispatch Tables & VTable Management:**  
    - Builds dispatch tables for every class.
    - Supports method overriding and correct indexing for dynamic method calls.
  - **Built-in Methods & IO Handling:**  
    - Implements essential built-in functions:
      - **String Methods:**  
        - `String_length`: Counts the number of characters in a string.
        - `String_concat`: Concatenates two strings.
        - `String_substr`: Extracts a substring.
      - **Array Methods:**  
        - `Array_get`, `Array_set`, `Array_resize`, and `Array_length` with bounds checking.
    - Integrates external I/O functions (`printf`/`scanf`) for runtime interactions.
  - **Control Flow & Expression Handling:**  
    - Generates code for conditionals (if/else), loops (while), let expressions, case expressions, and method calls.
  - **Dynamic Memory Management:**  
    - Uses `malloc` for object allocation and LLVM memory intrinsics (e.g., `memcpy`, `memset`) for efficient memory operations.

---

## Installation & Usage 🛠️

### Installation
Clone the repository and navigate into the project directory:
```bash
git clone https://github.com/YASSIRFRI/Cooler
cd cooler
```

### Running the Compiler
Compile and run the compiler with your COOL source file:
```bash
go build -o coolc.exe main.go
coolc -o output program.cool
```

Launch the visualization tool to inspect the AST and class hierarchy:
```bash
go run visualize.go
```
Then open the provided URL in your browser for an interactive view.

---

## Detailed Code Generation Features

The code generation module is the backbone of Cooler’s runtime performance. Key aspects include:
- **LLVM IR Translation:**  
  Every COOL AST node is translated into corresponding LLVM IR instructions, ensuring a smooth path from high-level COOL constructs to low-level, optimized machine code.
- **Boxing & Unboxing:**  
  Primitive types like `Int` and `Bool` are encapsulated (boxed) into object representations for uniform handling, with unboxing performed for native LLVM operations.
- **Dynamic Dispatch & VTable Management:**  
  Each class (including user-defined ones) has an associated dispatch table (VTable) built by inheriting parent layouts and adding or overriding methods as necessary, supporting proper dynamic dispatch.
- **Built-in Methods Implementation:**  
  The compiler defines and generates built-in functions:
  - **String Methods:**  
    - `String_length`: Iterates over the character array until a null terminator is found.
    - `String_concat`: Allocates memory for the concatenated string, uses `llvm.memcpy` for efficient copying, and manages null termination.
    - `String_substr`: Extracts a substring based on start and length parameters.
  - **Array Methods:**  
    - Supports dynamic arrays with methods like `Array_get`, `Array_set`, `Array_resize`, and `Array_length`, complete with bounds checking and memory reallocation.
- **Runtime I/O Support:**  
  External functions such as `printf` and `scanf` are declared and integrated within the generated code, enabling direct I/O operations in COOL programs.
- **Robust Error Handling:**  
  Runtime errors (e.g., out-of-bound accesses or failed type checks) are managed gracefully, ensuring that COOL programs either run correctly or fail with meaningful error messages.

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with improvements or new features.

---

## License

This project is licensed under the MIT License.

---

Enjoy compiling COOL with Cooler! 😎🔥
