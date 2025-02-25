class Main inherits IO {
    -- Computes the factorial of n recursively.
    factorial(n : Int) : Int {
        if n < 2 then
            1
        else
            n * self.factorial(n - 1)
        fi
        -- Example: factorial(5)=120.
    };

    fibonacci(n : Int) : Int {
        if n < 2 then
            n
        else
            self.fibonacci(n - 1) + self.fibonacci(n - 2)
        fi
        -- Example: fibonacci(7)=13.
    };

    sumTo(n : Int) : Int {
        -- We'll simulate a for loop using a while loop.
        let i : Int <- 0, s : Int <- 0 in {
            while i < n loop {
                s <- s + i;
                i <- i + 1
            }pool;
            s
            -- Example: sumTo(5)=0+1+2+3+4=10.
        }
    };

    complexCalculation(a : Int, b : Int, c : Int) : Int {
        -- Compute: x = (a + b) * c - a / b
        -- Then return: x + (a - c) * (b + c)
        let x : Int <- ((a + b) * c) - (a / b) in {
            x + ((a - c) * (b + c))
        }
    };

    -- main() performs several tests in sequence.
    main() : Int {
        {
            -- Test 1: Factorial
            out_string("Enter a number for factorial: ");
            let n : Int <- in_int() in {
                let f : Int <- self.factorial(n) in {
                    out_string("Factorial is: ");
                    out_int(f);
                    out_string("\n")
                }
            };

            -- Test 2: Fibonacci
            out_string("Enter a number for fibonacci: ");
            let m : Int <- in_int() in {
                let fib : Int <- self.fibonacci(m) in {
                    out_string("Fibonacci is: ");
                    out_int(fib);
                    out_string("\n")
                }
            };

            out_string("Enter a number for sumTo: ");
            let t : Int <- in_int() in {
                let s : Int <- sumTo(t) in {
                    out_string("Sum is: ");
                    out_int(s);
                    out_string("\n")
                }
            };
            out_string("Complex calculation (complexCalculation(5,3,2)) returns: ");
            let r : Int <- self.complexCalculation(5, 3, 2) in {
                out_int(r);
                out_string("\n")
            };
            0
        }
    };
};


