(*----------------------------------------------------------
   Stress Test File for COOL Lexer
   This file is purposely written with a variety of tokens,
   operators, nested comments, and reserved keywords to
   stress the lexer.
----------------------------------------------------------*)

class StressTest {
    (* Declare variables using 'let' and test various types *)
    let a : Int <- 12345;
    let b : String <- "Hello, COOL world! @ cool-language.";
    let c : Bool <- true;
    let d : Bool <- false;
    
    -- Single-line comment: The following line uses several operators.
    a <- a + 1;
    b <- b . " extended string";  -- Concatenation operator represented by a DOT.
    c <- not c;                  -- 'not' operator; case-insensitive.
    d <- isvoid a;               -- 'isvoid' keyword.

    (* 
       Multi-line comment: 
       Testing various symbols and tokens:  ( + - * / : ; ( ) { } < = <= <- => 
       Also, observe that the lexer should handle nested comments.
    *)
    (* Outer comment begins here.
       (* Inner nested comment begins.
           More tokens in a nested comment: 999, "nested", false, and operators like <= and <-.
       Inner nested comment ends. *)
       Back to the outer comment.
    *)

    if a < 100 then
        a <- a * 2;
    else
        a <- a - 1;
    fi;

    while a <= 200 loop
        a <- a + 10;
    pool;

    case a of
        10 => "ten";
        20 => "twenty";
        30 => "other";
    esac;

    new StressTest;  -- Use of 'new' keyword.
}

(* Additional Nested Comment Test:
   This comment tests deep nesting and mixing tokens with whitespace.

   (* Level 1
        (* Level 2 
             (* Level 3 
                Use tokens: + - * / :=; () {} @ . , < = <= <- => not
             *) 
        *)
   *)
*)

-- End of the stress test file.
