class Main inherits IO {
    main() : Object {
        out_string("Enter the size: ");
        let n : Int <- in_int() in {
            let arr : Array <- Array[Int] in {
                arr.resize(n);
                -- Prompt the user to enter n numbers.
                let i : Int <- 0 in {
                    while i < n loop {
                        out_string("Enter number for index ");
                        out_int(i);
                        out_string(": ");
                        let num : Int <- in_int() in {
                            arr.set(i, num);
                        };
                        i <- i + 1;
                    } pool;
                };

                -- Bubble sort the array.
                let i : Int <- 0 in {
                    while i < n - 1 loop {
                        let j : Int <- 0 in {
                            while j < (n - 1 - i) loop {
                                let a : Int <- arr.get(j) in {
                                    let b : Int <- arr.get(j + 1) in {
                                        if b < a then {
                                            -- Swap arr[j] and arr[j+1]
                                            arr.set(j, b);
                                            arr.set(j + 1, a);
                                        } fi;
                                    };
                                };
                                j <- j + 1;
                            } pool;
                        };
                        i <- i + 1;
                    } pool;
                };

                -- Print the sorted array.
                out_string("Sorted array: ");
                let i : Int <- 0 in {
                    while i < n loop {
                        out_int(arr.get(i));
                        out_string(" ");
                        i <- i + 1;
                    } pool;
                    out_string("\n");
                };
                self
            }
        }
    };
};
