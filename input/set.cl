

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
