@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@vtable_Animal = constant [1 x {}* ({}*, ...)*] [{}* ({}*, ...)* bitcast ({ i8* }* ({}*)* @Animal_speak to {}* ({}*, ...)*)]
@vtable_Dog = constant [1 x {}* ({}*, ...)*] [{}* ({}*, ...)* bitcast ({ i8* }* ({}*)* @Dog_speak to {}* ({}*, ...)*)]
@vtable_Cat = constant [1 x {}* ({}*, ...)*] [{}* ({}*, ...)* bitcast ({ i8* }* ({}*)* @Cat_speak to {}* ({}*, ...)*)]
@vtable_Bird = constant [1 x {}* ({}*, ...)*] [{}* ({}*, ...)* bitcast ({ i8* }* ({}*)* @Bird_speak to {}* ({}*, ...)*)]
@vtable_Fish = constant [1 x {}* ({}*, ...)*] [{}* ({}*, ...)* bitcast ({ i8* }* ({}*)* @Fish_speak to {}* ({}*, ...)*)]
@vtable_Parrot = constant [1 x {}* ({}*, ...)*] [{}* ({}*, ...)* bitcast ({ i8* }* ({}*)* @Parrot_speak to {}* ({}*, ...)*)]
@vtable_Goldfish = constant [1 x {}* ({}*, ...)*] [{}* ({}*, ...)* bitcast ({ i8* }* ({}*)* @Goldfish_speak to {}* ({}*, ...)*)]
@vtable_Main = constant [1 x {}* ({}*, ...)*] [{}* ({}*, ...)* bitcast ({}* ({}*)* @Main_main to {}* ({}*, ...)*)]
@str_0 = constant [17 x i8] c"I am an animal.\0A\00"
@str_obj_13 = constant { i8* } { i8* getelementptr ([17 x i8], [17 x i8]* @str_0, i32 0, i32 0) }
@str_1 = constant [7 x i8] c"Woof!\0A\00"
@str_obj_15 = constant { i8* } { i8* getelementptr ([7 x i8], [7 x i8]* @str_1, i32 0, i32 0) }
@str_2 = constant [7 x i8] c"Meow!\0A\00"
@str_obj_17 = constant { i8* } { i8* getelementptr ([7 x i8], [7 x i8]* @str_2, i32 0, i32 0) }
@str_3 = constant [8 x i8] c"Chirp!\0A\00"
@str_obj_19 = constant { i8* } { i8* getelementptr ([8 x i8], [8 x i8]* @str_3, i32 0, i32 0) }
@str_4 = constant [12 x i8] c"Blub blub!\0A\00"
@str_obj_21 = constant { i8* } { i8* getelementptr ([12 x i8], [12 x i8]* @str_4, i32 0, i32 0) }
@str_5 = constant [24 x i8] c"Polly wants a cracker!\0A\00"
@str_obj_23 = constant { i8* } { i8* getelementptr ([24 x i8], [24 x i8]* @str_5, i32 0, i32 0) }
@str_6 = constant [12 x i8] c"Glub glub!\0A\00"
@str_obj_25 = constant { i8* } { i8* getelementptr ([12 x i8], [12 x i8]* @str_6, i32 0, i32 0) }

declare i32 @printf(i8* nocapture %fmt, ...)

declare i32 @scanf(i8* nocapture %fmt, ...)

declare i8* @malloc(i64 %size)

define i32 @String_length({ i8* }* %str) {
entry:
	%0 = getelementptr { i8* }, { i8* }* %str, i32 0, i32 0
	%1 = load i8*, i8** %0
	%2 = alloca i32
	store i32 0, i32* %2
	br label %loop

loop:
	%3 = load i32, i32* %2
	%4 = getelementptr i8, i8* %1, i32 %3
	%5 = load i8, i8* %4
	%6 = icmp eq i8 %5, 0
	br i1 %6, label %exit, label %inc

inc:
	%7 = add i32 %3, 1
	store i32 %7, i32* %2
	br label %loop

exit:
	%8 = load i32, i32* %2
	ret i32 %8
}

define { i8* }* @String_concat({ i8* }* %str, { i8* }* %other) {
entry:
	%0 = getelementptr { i8* }, { i8* }* %str, i32 0, i32 0
	%1 = load i8*, i8** %0
	%2 = getelementptr { i8* }, { i8* }* %other, i32 0, i32 0
	%3 = load i8*, i8** %2
	%4 = call i32 @String_length({ i8* }* %str)
	%5 = call i32 @String_length({ i8* }* %other)
	%6 = add i32 %4, %5
	%7 = add i32 %6, 1
	%8 = sext i32 %7 to i64
	%9 = call i8* @malloc(i64 %8)
	%10 = sext i32 %4 to i64
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* %9, i8* %1, i64 %10, i32 1, i1 false)
	%11 = getelementptr i8, i8* %9, i32 %4
	%12 = sext i32 %5 to i64
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* %11, i8* %3, i64 %12, i32 1, i1 false)
	%13 = getelementptr i8, i8* %9, i32 %6
	store i8 0, i8* %13
	%14 = call i8* @malloc(i64 4)
	%15 = bitcast i8* %14 to { i8* }*
	%16 = getelementptr { i8* }, { i8* }* %15, i32 0, i32 0
	store i8* %9, i8** %16
	ret { i8* }* %15
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest, i8* %src, i64 %size, i32 %align, i1 %isvolatile)

define { i8* }* @String_substr({ i8* }* %str, i32 %start, i32 %len) {
entry:
	%0 = getelementptr { i8* }, { i8* }* %str, i32 0, i32 0
	%1 = load i8*, i8** %0
	%2 = add i32 %len, 1
	%3 = sext i32 %2 to i64
	%4 = call i8* @malloc(i64 %3)
	%5 = alloca i32
	store i32 0, i32* %5
	br label %loop

loop:
	%6 = load i32, i32* %5
	%7 = icmp slt i32 %6, %len
	br i1 %7, label %body, label %finish

body:
	%8 = add i32 %start, %6
	%9 = getelementptr i8, i8* %1, i32 %8
	%10 = load i8, i8* %9
	%11 = getelementptr i8, i8* %4, i32 %6
	store i8 %10, i8* %11
	%12 = add i32 %6, 1
	store i32 %12, i32* %5
	br label %loop

finish:
	%13 = getelementptr i8, i8* %4, i32 %len
	store i8 0, i8* %13
	%14 = call i8* @malloc(i64 4)
	%15 = bitcast i8* %14 to { i8* }*
	%16 = getelementptr { i8* }, { i8* }* %15, i32 0, i32 0
	store i8* %4, i8** %16
	ret { i8* }* %15
}

define i32 @main() {
entry:
	%0 = call {}* @Main_main()
	ret i32 0
}

define { i8* }* @Animal_speak({}* %self) {
entry:
	%0 = alloca {}*
	store {}* %self, {}** %0
	ret { i8* }* bitcast ({ i8* }* @str_obj_13 to { i8* }*)
}

define { i8* }* @Dog_speak({}* %self) {
entry:
	%0 = alloca {}*
	store {}* %self, {}** %0
	ret { i8* }* bitcast ({ i8* }* @str_obj_15 to { i8* }*)
}

define { i8* }* @Cat_speak({}* %self) {
entry:
	%0 = alloca {}*
	store {}* %self, {}** %0
	ret { i8* }* bitcast ({ i8* }* @str_obj_17 to { i8* }*)
}

define { i8* }* @Bird_speak({}* %self) {
entry:
	%0 = alloca {}*
	store {}* %self, {}** %0
	ret { i8* }* bitcast ({ i8* }* @str_obj_19 to { i8* }*)
}

define { i8* }* @Fish_speak({}* %self) {
entry:
	%0 = alloca {}*
	store {}* %self, {}** %0
	ret { i8* }* bitcast ({ i8* }* @str_obj_21 to { i8* }*)
}

define { i8* }* @Parrot_speak({}* %self) {
entry:
	%0 = alloca {}*
	store {}* %self, {}** %0
	ret { i8* }* bitcast ({ i8* }* @str_obj_23 to { i8* }*)
}

define { i8* }* @Goldfish_speak({}* %self) {
entry:
	%0 = alloca {}*
	store {}* %self, {}** %0
	ret { i8* }* bitcast ({ i8* }* @str_obj_25 to { i8* }*)
}

define {}* @Main_main({}* %self) {
entry:
	%0 = alloca {}*
	store {}* %self, {}** %0
	%1 = alloca { {}* ({}*, ...)* }*
	%2 = call i8* @malloc(i64 4)
	%3 = bitcast i8* %2 to { {}* ({}*, ...)* }*
	%4 = bitcast [1 x {}* ({}*, ...)*]* @vtable_Animal to [1 x {}* ({}*, ...)*]*
	%5 = getelementptr [1 x {}* ({}*, ...)*], [1 x {}* ({}*, ...)*]* %4, i32 0, i32 0
	%6 = bitcast {}* ({}*, ...)** %5 to {}* ({}*, ...)*
	%7 = getelementptr { {}* ({}*, ...)* }, { {}* ({}*, ...)* }* %3, i32 0, i32 0
	store {}* ({}*, ...)* %6, {}* ({}*, ...)** %7
	store { {}* ({}*, ...)* }* %3, { {}* ({}*, ...)* }** %1
	%8 = alloca { {}* ({}*, ...)* }*
	%9 = call i8* @malloc(i64 4)
	%10 = bitcast i8* %9 to { {}* ({}*, ...)* }*
	%11 = bitcast [1 x {}* ({}*, ...)*]* @vtable_Dog to [1 x {}* ({}*, ...)*]*
	%12 = getelementptr [1 x {}* ({}*, ...)*], [1 x {}* ({}*, ...)*]* %11, i32 0, i32 0
	%13 = bitcast {}* ({}*, ...)** %12 to {}* ({}*, ...)*
	%14 = getelementptr { {}* ({}*, ...)* }, { {}* ({}*, ...)* }* %10, i32 0, i32 0
	store {}* ({}*, ...)* %13, {}* ({}*, ...)** %14
	store { {}* ({}*, ...)* }* %10, { {}* ({}*, ...)* }** %8
	%15 = alloca { {}* ({}*, ...)* }*
	%16 = call i8* @malloc(i64 4)
	%17 = bitcast i8* %16 to { {}* ({}*, ...)* }*
	%18 = bitcast [1 x {}* ({}*, ...)*]* @vtable_Cat to [1 x {}* ({}*, ...)*]*
	%19 = getelementptr [1 x {}* ({}*, ...)*], [1 x {}* ({}*, ...)*]* %18, i32 0, i32 0
	%20 = bitcast {}* ({}*, ...)** %19 to {}* ({}*, ...)*
	%21 = getelementptr { {}* ({}*, ...)* }, { {}* ({}*, ...)* }* %17, i32 0, i32 0
	store {}* ({}*, ...)* %20, {}* ({}*, ...)** %21
	store { {}* ({}*, ...)* }* %17, { {}* ({}*, ...)* }** %15
	%22 = alloca { {}* ({}*, ...)* }*
	%23 = call i8* @malloc(i64 4)
	%24 = bitcast i8* %23 to { {}* ({}*, ...)* }*
	%25 = bitcast [1 x {}* ({}*, ...)*]* @vtable_Bird to [1 x {}* ({}*, ...)*]*
	%26 = getelementptr [1 x {}* ({}*, ...)*], [1 x {}* ({}*, ...)*]* %25, i32 0, i32 0
	%27 = bitcast {}* ({}*, ...)** %26 to {}* ({}*, ...)*
	%28 = getelementptr { {}* ({}*, ...)* }, { {}* ({}*, ...)* }* %24, i32 0, i32 0
	store {}* ({}*, ...)* %27, {}* ({}*, ...)** %28
	store { {}* ({}*, ...)* }* %24, { {}* ({}*, ...)* }** %22
	%29 = load { {}* ({}*, ...)* }*, { {}* ({}*, ...)* }** %1
	%30 = getelementptr { {}* ({}*, ...)* }, { {}* ({}*, ...)* }* %29, i32 0, i32 0
	%31 = load {}* ({}*, ...)*, {}* ({}*, ...)** %30
	%32 = getelementptr {}* ({}*, ...)*, {}* ({}*, ...)* %31, i32 0
	%33 = load {}* ({}*, ...)*, {}* ({}*, ...)** %32
	%34 = bitcast { {}* ({}*, ...)* }* %29 to {}*
	%35 = bitcast {}* ({}*, ...)* %33 to { i8* }* ({}*)*
	%36 = call { i8* }* %35({}* %34)
	%37 = getelementptr { i8* }, { i8* }* %36, i32 0, i32 0
	%38 = load i8*, i8** %37
	%39 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%40 = call i32 (i8*, ...) @printf(i8* %39, i8* %38)
	%41 = load {}*, {}** %0
	%42 = load { {}* ({}*, ...)* }*, { {}* ({}*, ...)* }** %8
	%43 = getelementptr { {}* ({}*, ...)* }, { {}* ({}*, ...)* }* %42, i32 0, i32 0
	%44 = load {}* ({}*, ...)*, {}* ({}*, ...)** %43
	%45 = getelementptr {}* ({}*, ...)*, {}* ({}*, ...)* %44, i32 0
	%46 = load {}* ({}*, ...)*, {}* ({}*, ...)** %45
	%47 = bitcast { {}* ({}*, ...)* }* %42 to {}*
	%48 = bitcast {}* ({}*, ...)* %46 to { i8* }* ({}*)*
	%49 = call { i8* }* %48({}* %47)
	%50 = getelementptr { i8* }, { i8* }* %49, i32 0, i32 0
	%51 = load i8*, i8** %50
	%52 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%53 = call i32 (i8*, ...) @printf(i8* %52, i8* %51)
	%54 = load {}*, {}** %0
	%55 = load { {}* ({}*, ...)* }*, { {}* ({}*, ...)* }** %15
	%56 = getelementptr { {}* ({}*, ...)* }, { {}* ({}*, ...)* }* %55, i32 0, i32 0
	%57 = load {}* ({}*, ...)*, {}* ({}*, ...)** %56
	%58 = getelementptr {}* ({}*, ...)*, {}* ({}*, ...)* %57, i32 0
	%59 = load {}* ({}*, ...)*, {}* ({}*, ...)** %58
	%60 = bitcast { {}* ({}*, ...)* }* %55 to {}*
	%61 = bitcast {}* ({}*, ...)* %59 to { i8* }* ({}*)*
	%62 = call { i8* }* %61({}* %60)
	%63 = getelementptr { i8* }, { i8* }* %62, i32 0, i32 0
	%64 = load i8*, i8** %63
	%65 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%66 = call i32 (i8*, ...) @printf(i8* %65, i8* %64)
	%67 = load {}*, {}** %0
	%68 = load { {}* ({}*, ...)* }*, { {}* ({}*, ...)* }** %22
	%69 = getelementptr { {}* ({}*, ...)* }, { {}* ({}*, ...)* }* %68, i32 0, i32 0
	%70 = load {}* ({}*, ...)*, {}* ({}*, ...)** %69
	%71 = getelementptr {}* ({}*, ...)*, {}* ({}*, ...)* %70, i32 0
	%72 = load {}* ({}*, ...)*, {}* ({}*, ...)** %71
	%73 = bitcast { {}* ({}*, ...)* }* %68 to {}*
	%74 = bitcast {}* ({}*, ...)* %72 to { i8* }* ({}*)*
	%75 = call { i8* }* %74({}* %73)
	%76 = getelementptr { i8* }, { i8* }* %75, i32 0, i32 0
	%77 = load i8*, i8** %76
	%78 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%79 = call i32 (i8*, ...) @printf(i8* %78, i8* %77)
	%80 = load {}*, {}** %0
	%81 = bitcast {}* %80 to {}*
	ret {}* %81
}
