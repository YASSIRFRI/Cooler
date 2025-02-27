class Shape {
   draw() : String { "Generic Shape" };
};

class Circle inherits Shape {
   draw() : String { "Circle" };
};

class Square inherits Shape {
   draw() : String { "Square" };
};

class Main inherits IO {
   main() : Object {
      let my_shape : Shape <- new Circle in {
         case my_shape of
            c : Circle => out_string("It's a circle.\n");
            s : Square => out_string("It's a square.\n");
            sh : Shape => out_string("It's some kind of shape.\n");
         esac;
         0
      }
   };
};
