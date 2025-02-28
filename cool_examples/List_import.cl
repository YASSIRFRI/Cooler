import List;

class Main inherits IO {
    main() : Object {
        let list : List <- new List in {
            list.init_list();
            out_string("test");
            list.insert(10);
            list.insert(20);
            list.insert(30);
            list.print();
        }
    };
};
