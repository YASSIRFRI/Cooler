class Tchh inherits IO {
    factorial(n: Int): Int {
        if n = 0 then 1 else n * factorial(n - 1) fi
    };
    main(): IO {
        {
            out_int(factorial(5));
        }
    };
};
