class Main inherits IO {
    main() : Object {
        let arr : Array <- Array[Int] in {
            arr.resize(7);
            arr.set(0, 1);
            arr.set(1, 3);
            arr.set(2, 5);
            arr.set(3, 7);
            arr.set(4, 9);
            arr.set(5, 11);
            arr.set(6, 13);
            
            let target : Int <- 7 in {
                let low : Int <- 0 in {
                    let high : Int <- arr.length() - 1 in {
                        let index : Int <- -1 in {
                            while low <= high loop {
                                let mid : Int <- (low + high) / 2 in {
                                    if arr.get(mid) = target then {
                                        index <- mid;
                                        low <- high + 1;  -- Force exit from loop.
                                    } else if arr.get(mid) < target then {
                                        low <- mid + 1;
                                    } else {
                                        high <- mid - 1;
                                    } fi;
                                }
                            } pool;
                            if index = -1 then {
                                out_string("Target not found\n")
                            } else {
                                out_string("Target found at index ");
                                out_int(index);
                                out_string("\n")
                            } fi;
                        }
                    }
                }
            };
            self
        }
    };
};
