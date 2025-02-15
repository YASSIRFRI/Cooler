class Main inherits IO{
    main() : Object {
        let s : String <- in_string() in{
            out_string("You entered: ");
            out_string(s);
            out_string("\n");
            let n : Int <- in_int() in{
                out_string("You entered the integer: ");
                out_int(n-1);
                out_string("\n");
            }
        }
    };
};
