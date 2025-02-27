class Main inherits IO{
    main() : Object {
      {
        out_string("Enter some Number: ");
        let s : String <- in_string() in{
            out_string("You entered: ");
            out_string(s);
            out_string("\n");
            out_string("Again: ");
            let n : Int <- in_int() in{
                out_string("You entered the integer: ");
                out_int(n);
                out_string("\n");
            }
        }
    }
    };
};
