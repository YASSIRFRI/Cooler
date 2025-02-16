class Main {
   main(): Object {
      let x: Int <- 10 in {
         case x of
            1 => { out_string("One\n"); };
            2 => { out_string("Two\n"); };
            10 => { out_string("Ten\n"); };
            _ => { out_string("Other\n"); };
         esac;
         out_int(x);
         out_string("\n");
      }
   };
};
