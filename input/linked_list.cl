class Node {
    value : Int;
    next  : Node <- null;

    get_value() : Int {
        value;
    };

    set_value(v : Int) : Node {
        value <- v;
        self;
    };

    get_next() : Node {
        next;
    };

    set_next(n : Node) : Node {
        next <- n;
        self;
    };
};

class LinkedList {
    head : Node <- null;

    get_head() : Node {
        head;
    };

    set_head(n : Node) : LinkedList {
        head <- n;
        self;
    };

    insert(val : Int) : LinkedList {
        let new_node : Node <- new Node in {
            new_node.set_value(val);
            new_node.set_next(null);
            if head = null then {
                head <- new_node;
            } else {
                let temp : Node <- head in {
                    while temp.get_next() <> null loop {
                        temp <- temp.get_next();
                    } pool;
                    temp.set_next(new_node);
                }
            } fi;
            self
        }
    };

    print() : LinkedList {
        let temp : Node <- head in {
            while temp <> null loop {
                out_int(temp.get_value());
                out_string(" ");
                temp <- temp.get_next();
            } pool;
            out_string("\n");
            self
        }
    };
};

class Main inherits IO {
    main() : Object {
        let list : LinkedList <- new LinkedList in {
            list.insert(10);
            list.insert(20);
            list.insert(30);
            list.print();
        }
    }
};
