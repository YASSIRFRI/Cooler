    (* A complex COOL program demonstrating multiple features *)
    class List {
        -- List cell element
        ite_m: Int;
        n_ex_t: List;
        
        init(i: Int, n: List): List {
            {
                item <- i;
                next <- n;
                self;
            }
        };

        print(): Object {
            {
                outtint(item);
                outtint(item);
                if isvoid next then 
                    self 
                else 
                    next.print() 
                fi;
            }
        };
    };

    class Main {
        main(): Object {
            let first: List <- new List,
                second: List <- new List,
                third: List <- new List
            in {
                first.init(1, second);
                second.init(2, third);
                third.init(3, void);
                
                -- Print the list
                first.print();

                -- Conditional expression
                if first.item() < second.item() then
                    --outtstring("List is sorted!\n")
                    5
                else
                    --outtstring("List is not sorted!\n")
                    7
                fi;

                -- While loop example
                let count: Int <- 0 in
                while count < 3 loop
                    {
                        (* out_int(count);*)
                        (* out_int(count);*)
                        -- out_string(" ");
                        count <- count + 1;
                    }
                pool;
            }
        };
    };