  <p align="center">
    <img src="/logo.png" alt="COOL Logo" width="200"/>
  </p>


  # Cooler: A COOL Language Compiler in Go 🚀


  Cooler is a no-nonsense, efficient compiler for the Classroom Object-Oriented Language (COOL) written in Go. Designed for clarity, performance, and robustness, Cooler not only supports standard language features but also includes a powerful code generation backend that leverages LLVM IR for native code generation.

  ---

  ## Overview

  Cooler transforms COOL source code into optimized LLVM IR, enabling advanced runtime features such as dynamic dispatch, comprehensive error reporting, and seamless memory management. Its architecture is divided into clear phases:

  - **Lexical Analysis & Preprocessing**
  - **Semantic Analysis & Inheritance Graph Construction**
  - **Visualization of AST and Class Hierarchies**
  - **Code Generation & Runtime**

  ---

  ## Key Features

  ### Lexical Analysis & Preprocessing ✂️
  - **Tokenization:**  
    - Supports multi-line nested comments (`(* ... *)`), single-line comments (`--`), string literals with escape sequences, integer literals, identifiers, and keywords.
  - **Preprocessor:**  
    - Validates import statements and handles module dependencies and cyclic imports.
    - All the files are looked up in the current working director, they can be also specified via the correct path.

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
    - Includes screenshots that demonstrate both the semantic analyzer code and the interactive visualization tool.

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
      - Relies on `malloc` for object allocation and uses LLVM’s memory intrinsic functions for operations like `memcpy` and `memset`.

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
  go run main.go <source_file.cool>
  ```

  ### Visualizing the Compiler’s Output
  Launch the visualization tool to inspect the AST and class hierarchy:
  ```bash
  go run visualize.go
  ```
  Then open the provided URL in your browser for an interactive view.

  ---

  ## Detailed Code Generation Features

  The code generation module is the backbone of Cooler’s runtime performance. Key aspects include:

  - **LLVM IR Translation:**  
    Every COOL AST node is translated into corresponding LLVM IR instructions. This includes arithmetic operations, control structures, and method calls, ensuring a smooth path from high-level COOL constructs to low-level, optimized machine code.

  - **Boxing & Unboxing:**  
    Primitive types like `Int` and `Bool` are encapsulated (boxed) into object representations for uniform handling. Unboxing is then performed when native LLVM operations are needed.

  - **Dynamic Dispatch & VTable Management:**  
    Each class (including user-defined ones) has an associated dispatch table (VTable) that is built by inheriting parent layouts and adding or overriding methods as necessary. This supports proper dynamic dispatch during method calls.

  - **Built-in Methods Implementation:**  
    The compiler defines and generates built-in functions:
    - **String Methods:**  
      - `String_length`: Iterates over the character array until a null terminator is found.
      - `String_concat`: Allocates memory for the concatenated string, uses `llvm.memcpy` for efficient data copying, and manages null termination.
      - `String_substr`: Extracts a substring based on given start and length parameters.
    - **Array Methods:**  
      - Methods like `Array_get`, `Array_set`, `Array_resize`, and `Array_length` support dynamic arrays with proper bounds checking and memory reallocation.
    
  - **Runtime I/O Support:**  
    External functions like `printf` and `scanf` are declared and used within the generated code, enabling direct I/O operations within COOL programs.

  - **Robust Error Handling:**  
    Runtime errors such as out-of-bound array accesses or failed type checks are gracefully managed, ensuring that COOL programs either execute correctly or fail with meaningful error messages.

  ---

  ## Contributing

  Contributions are welcome! Please open an issue or submit a pull request with improvements or new features.

  ---

  ## License

  This project is licensed under the MIT License.
  ---

  Enjoy compiling COOL with Cooler! 😎🔥
