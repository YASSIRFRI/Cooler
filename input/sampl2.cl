    (* A complex COOL program demonstrating multiple features *)
    class List inherits IO{
        -- List cell element
        item: Int;
        next: List;
        
        ite(i: Int, n: List): List {
            {
                item <- i;
                next <- n;
                self;
            }
        };

        print(): Object {
            {
                out_int(item);
                out_int(item);
                if isvoid next then 
                    self 
                else 
                    next.print() 
                fi;
            }
        };
    };

    class Main inherits IO{
        main(): Object {
            let first: List <- new List,
                second: List <- new List,
                third: List <- new List
            in {
                first.ite(1, second);
                second.ite(2, third);
                -- third.ite(3, void);
                
                first.print();

                -- While loop example
                let count: Int <- 0 in
                while count < 3 loop
                    {
                        out_string(" ");
                        count <- count + 1;
                    }
                pool;
            }
        };
    };