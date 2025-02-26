class Main inherits IO {
  --a: Int;
   main(): Object {
     {
      let a: Int in {
        let b : String in{
        a<- 1;
        b<-a.copy();
        out_int(b);
        out_int(a);
        }
      }
     }
   };
};


