class Main inherits IO {
    factorial(n: Int): Int {
        if n = 0 then 1 else n * factorial(n - 1) fi
    };
    main(): SELF_TYPE {
        {
            t : Int <- 10;
            out_int(t);
        };
    };
};
