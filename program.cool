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
            next <- self;  -- points to itself (sentinel)
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

    -- Insert a new node at the beginning (after the head)
    insert(val : Int) : LinkedList {
        let new_node : Node <- new Node in {
            new_node.set_value(val);
            new_node.set_next(head.get_next());
            head.set_next(new_node);
            self;
        }
    };

    -- Delete the first occurrence of a value in the list.
    delete(val : Int) : LinkedList {
        {
            let prev : Node <- head in {
                let curr : Node <- head.get_next() in {
                    while not (curr = head) loop {
                        if curr.get_value() = val then {
                            -- Bypass the current node
                            prev.set_next(curr.get_next());
                            curr <- head;  -- force exit from loop
                        } else {
                            prev <- curr;
                            curr <- curr.get_next();
                        } fi;
                    } pool;
                }
            };
            self;
        }
    };

    -- Search for a value. Returns true if found.
    search(val : Int) : Bool {
        let temp : Node <- head.get_next() in {
            let found : Bool <- false in {
                while not (temp = head) loop {
                    if temp.get_value() = val then {
                        found <- true;
                        temp <- head;  -- force exit from loop
                    } else {
                        temp <- temp.get_next();
                    } fi;
                } pool;
                found
            }
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
};

-- Set implementation using a linked list.
class SetLL inherits IO {
    l : LinkedList;

    init_set() : SetLL {
        {
            l <- new LinkedList;
            l.init_list();
            self;
        }
    };

    insert(val : Int) : SetLL {
        {
            if not l.search(val) then
                l.insert(val)
            else {} fi;
            self;
        }
    };

    contains(val : Int) : Bool {
        l.search(val)
    };

    delete(val : Int) : SetLL {
        {
            l.delete(val);
            self;
        }
    };

    print_set() : SetLL {
        {
            l.print();
            self;
        }
    };
};

class Main inherits IO {
    main() : Object {
        let s : SetLL <- new SetLL in {
            s.init_set();

            -- Insert some values (duplicate insert of 2 is ignored)
            s.insert(1);
            s.insert(2);
            s.insert(3);
            s.insert(2);

            out_string("Current set contents (Linked List):\n");
            s.print_set();

            out_string("Deleting 2 from set...\n");
            s.delete(2);
            s.print_set();

            out_string("Contains 2? ");
            if s.contains(2) then
                out_string("Yes\n")
            else
                out_string("No\n")
            fi;
            self;
        }
    };
};
