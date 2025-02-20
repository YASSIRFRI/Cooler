class BinaryTrieSet inherits IO { 
    root : BinaryTrieNode; 
    bits : Int;

    init_set() : BinaryTrieSet {
        {
            root <- new BinaryTrieNode;
            root.init_node();
            bits <- 16;   -- or 32 for 32-bit
            self;
        }
    };

    pow(exp : Int) : Int {
        let result : Int <- 1 in {
            let i : Int <- 1 in {
                while i <= exp loop {
                    result <- result * 2;
                    i <- i + 1;
                } pool;
                result
            }
        }
    };

    mod(a : Int, b : Int) : Int {
        let q : Int <- a / b in {
            a - q * b
        }
    };

    get_bit(value : Int, bit_pos : Int) : Int {
        let divisor : Int <- pow(bit_pos) in {
            let quotient : Int <- value / divisor in {
                mod(quotient, 2)
            }
        }
    };

insert(val : Int) : BinaryTrieSet {
    let current : BinaryTrieNode <- root in {
        let i : Int <- bits - 1 in {
            while not (i < 0) loop {  -- using not (i < 0) instead of i >= 0
                let bit_val : Int <- get_bit(val, i) in {
                    if bit_val = 0 then
                        if current.get_zero_child() = void then
                            let new_node : BinaryTrieNode <- new BinaryTrieNode in {
                                new_node.init_node();
                                current.set_zero_child(new_node);
                            }
                        fi;
                        current <- current.get_zero_child();
                    else
                        if current.get_one_child() = void then {
                            let new_node : BinaryTrieNode <- new BinaryTrieNode in {
                                new_node.init_node();
                                current.set_one_child(new_node);
                            }
                        } fi;
                        current <- current.get_one_child();
                    fi;
                };
                i <- i - 1;
            } pool;
            current.set_is_end(true);
            self
        }
    }
};

    search(val : Int) : Bool {
        let current : BinaryTrieNode <- root in {
            let i : Int <- bits - 1 in {
                let found : Bool <- true in {
                    while not (i < 0) loop {
                        let bit_val : Int <- get_bit(val, i) in {
                            if bit_val = 0 then
                                if current.get_zero_child() = void then {
                                    found <- false;
                                    i <- -1;  -- break the loop
                                } else {
                                    current <- current.get_zero_child();
                                } fi;
                            else
                                if current.get_one_child() = void then {
                                    found <- false;
                                    i <- -1;  -- break the loop
                                } else {
                                    current <- current.get_one_child();
                                } fi;
                            fi;
                        };
                        i <- i - 1;
                    } pool;
                    if found and current.get_is_end() then
                        true
                    else
                        false
                    fi
                }
            }
        }
    };

    print_all() : BinaryTrieSet {
        {
            recurse_print(root, 0, bits - 1);
            out_string("\n");
            self;
        }
    };

recurse_print(n : BinaryTrieNode, current_val : Int, bit_pos : Int) : Void {
    if n = void then {
        -- do nothing
    } else {
        if bit_pos < 0 then
            if n.get_is_end() then {
                out_int(current_val);
                out_string(" ");
            } fi;
        else {
            let zero_node : BinaryTrieNode <- n.get_zero_child() in {
                recurse_print(zero_node, current_val, bit_pos - 1);
            };
            let one_node : BinaryTrieNode <- n.get_one_child() in {
                let add : Int <- pow(bit_pos) in {
                    recurse_print(one_node, current_val + add, bit_pos - 1);
                }
            }
        }
    }
};
};

class Main inherits IO { 
    main() : Object { let my_set : BinaryTrieSet <- new BinaryTrieSet in { my_set.init_set();
        -- Insert numbers 1 through 10 into the set
        let i : Int <- 1 in {
            while i <= 10 loop {
                my_set.insert(i);
                i <- i + 1;
            } pool;
        };

        out_string("Elements in set (ascending order):\n");
        my_set.print_all();

        out_string("Enter a value to search: ");
        let search_val : Int <- in_int() in {
            if my_set.search(search_val) then
                out_string("Value found.\n")
            else
                out_string("Value not found.\n")
            fi
        };

        my_set.print_all();
        self;
    }
};
};