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

    -- Initialize the list with a sentinel node.
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
                        -- Break the loop by setting temp to head.
                        temp <- head;
                    } else {
                        temp <- temp.get_next();
                    }fi;
                } pool;
                found
            }
        }
    };
};

class Main inherits IO {
    main() : Object {
        let list : LinkedList <- new LinkedList in {
            list.init_list();
            -- Insert a lot of values (for example, 1 through 100)
            let i : Int <- 1 in {
                while i <= 100 loop {
                    list.insert(i);
                    i <- i + 1;
                } pool;
            };
            list.print();
            out_string("Enter a value to search: ");
            let search_val : Int <- in_int() in {
                if list.search(search_val) then
                    out_string("Value found.\n")
                else
                    out_string("Value not found.\n")
                fi
            };
            list.print();
            self;
        }
    };
};
