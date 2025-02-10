class Main inherits IO {
  main(): Object {
    let i: Int <- 0 in {
      while i < 5 loop {
        out_string("Loop iteration: ");
        out_int(i);
        out_string("\n");
        i <- i + 1;
      } pool;
      0;
    }
  };
};
