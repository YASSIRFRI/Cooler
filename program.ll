%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%Factorial_struct = type { i8* }
%Main_struct = type { i8*, %Factorial_struct*, %IntStruct* }

@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@str_0 = global [7 x i8] c"Object\00"
@str_obj_1 = constant { i8* } { [7 x i8]* getelementptr inbounds ([7 x i8], [7 x i8]* @str_0) }
@vtable_Object = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Int = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_String = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Bool = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_IO = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Factorial = constant [1 x i8*] [i8* bitcast (%IntStruct* (%Factorial_struct*, %IntStruct*)* @Factorial_factorial to i8*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%IOStruct* (%Main_struct*)* @Main_main to i8*)]
@str_2 = global [5 x i8] c"Test\00"
@str_obj_3 = constant { i8* } { [5 x i8]* getelementptr inbounds ([5 x i8], [5 x i8]* @str_2) }

declare i32 @printf(i8* nocapture %fmt, ...)

declare i32 @scanf(i8* nocapture %fmt, ...)

declare i8* @malloc(i64 %size)

define i32 @String_length(%StringStruct* %str) {
entry:
	%0 = getelementptr %StringStruct, %StringStruct* %str, i32 0, i32 1
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

define %StringStruct* @String_concat(%StringStruct* %str, %StringStruct* %other) {
entry:
	%0 = getelementptr %StringStruct, %StringStruct* %str, i32 0, i32 0
	%1 = load i8*, i8** %0
	%2 = getelementptr %StringStruct, %StringStruct* %other, i32 0, i32 0
	%3 = load i8*, i8** %2
	%4 = call i32 @String_length(%StringStruct* %str)
	%5 = call i32 @String_length(%StringStruct* %other)
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
	%14 = call i8* @malloc(i64 16)
	%15 = bitcast i8* %14 to %StringStruct*
	%16 = getelementptr %StringStruct, %StringStruct* %15, i32 0, i32 0
	store i8* %9, i8** %16
	ret %StringStruct* %15
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest, i8* %src, i64 %size, i32 %align, i1 %isvolatile)

declare void @exit(i32 %status)

define %ObjectStruct* @Object_abort(%ObjectStruct* %self) {
entry:
	call void @exit(i32 1)
	unreachable
}

define %StringStruct* @Object_type_name(%ObjectStruct* %self) {
entry:
	ret %StringStruct* bitcast ({ i8* }* @str_obj_1 to %StringStruct*)
}

define %ObjectStruct* @Object_copy(%ObjectStruct* %self) {
entry:
	%0 = call i8* @malloc(i64 8)
	%1 = bitcast i8* %0 to %ObjectStruct*
	%2 = bitcast %ObjectStruct* %self to %ObjectStruct*
	%3 = getelementptr %ObjectStruct, %ObjectStruct* %2, i32 0, i32 0
	%4 = getelementptr %ObjectStruct, %ObjectStruct* %1, i32 0, i32 0
	%5 = load i8*, i8** %3
	store i8* %5, i8** %4
	ret %ObjectStruct* %1
}

define %StringStruct* @String_substr(%StringStruct* %str, i32 %start, i32 %len) {
entry:
	%0 = getelementptr %StringStruct, %StringStruct* %str, i32 0, i32 1
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
	%14 = call i8* @malloc(i64 16)
	%15 = bitcast i8* %14 to %StringStruct*
	%16 = getelementptr %StringStruct, %StringStruct* %15, i32 0, i32 0
	store i8* %4, i8** %16
	ret %StringStruct* %15
}

define i32 @main() {
entry:
	%0 = call i8* @malloc(i64 24)
	%1 = bitcast i8* %0 to %Main_struct*
	%2 = bitcast [1 x i8*]* @vtable_Main to i8*
	%3 = getelementptr %Main_struct, %Main_struct* %1, i32 0, i32 0
	store i8* %2, i8** %3
	%4 = call %IOStruct* @Main_main(%Main_struct* %1)
	ret i32 0
}

define %IntStruct* @Factorial_factorial(%Factorial_struct* %self, %IntStruct* %n) {
entry:
	%0 = alloca %Factorial_struct*
	store %Factorial_struct* %self, %Factorial_struct** %0
	%1 = load %Factorial_struct*, %Factorial_struct** %0
	%2 = bitcast %Factorial_struct* %1 to %Factorial_struct*
	%3 = alloca %Factorial_struct*
	store %Factorial_struct* %2, %Factorial_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %n, %IntStruct** %4
	%5 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*), i32 0, i32 0
	%6 = load i8*, i8** %5
	%7 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%8 = call i32 (i8*, ...) @printf(i8* %7, i8* %6)
	%9 = load %Factorial_struct*, %Factorial_struct** %3
	%10 = load %IntStruct*, %IntStruct** %4
	%11 = call i8* @malloc(i64 16)
	%12 = bitcast i8* %11 to %IntStruct*
	%13 = getelementptr %IntStruct, %IntStruct* %12, i32 0, i32 1
	store i32 0, i32* %13
	%14 = getelementptr %IntStruct, %IntStruct* %10, i32 0, i32 1
	%15 = load i32, i32* %14
	%16 = getelementptr %IntStruct, %IntStruct* %12, i32 0, i32 1
	%17 = load i32, i32* %16
	%18 = icmp eq i32 %15, %17
	%19 = call i8* @malloc(i64 16)
	%20 = bitcast i8* %19 to %BoolStruct*
	%21 = getelementptr %BoolStruct, %BoolStruct* %20, i32 0, i32 1
	store i1 %18, i1* %21
	%22 = getelementptr %BoolStruct, %BoolStruct* %20, i32 0, i32 1
	%23 = load i1, i1* %22
	%24 = icmp ne i1 %23, false
	br i1 %24, label %if_then_0, label %if_else_1

if_then_0:
	%25 = call i8* @malloc(i64 16)
	%26 = bitcast i8* %25 to %IntStruct*
	%27 = getelementptr %IntStruct, %IntStruct* %26, i32 0, i32 1
	store i32 1, i32* %27
	br label %if_end_2

if_else_1:
	%28 = load %IntStruct*, %IntStruct** %4
	%29 = load %Factorial_struct*, %Factorial_struct** %3
	%30 = load %IntStruct*, %IntStruct** %4
	%31 = call i8* @malloc(i64 16)
	%32 = bitcast i8* %31 to %IntStruct*
	%33 = getelementptr %IntStruct, %IntStruct* %32, i32 0, i32 1
	store i32 1, i32* %33
	%34 = getelementptr %IntStruct, %IntStruct* %30, i32 0, i32 1
	%35 = load i32, i32* %34
	%36 = getelementptr %IntStruct, %IntStruct* %32, i32 0, i32 1
	%37 = load i32, i32* %36
	%38 = sub i32 %35, %37
	%39 = call i8* @malloc(i64 16)
	%40 = bitcast i8* %39 to %IntStruct*
	%41 = getelementptr %IntStruct, %IntStruct* %40, i32 0, i32 1
	store i32 %38, i32* %41
	%42 = call %IntStruct* @Factorial_factorial(%Factorial_struct* %29, %IntStruct* %40)
	%43 = getelementptr %IntStruct, %IntStruct* %28, i32 0, i32 1
	%44 = load i32, i32* %43
	%45 = getelementptr %IntStruct, %IntStruct* %42, i32 0, i32 1
	%46 = load i32, i32* %45
	%47 = mul i32 %44, %46
	%48 = call i8* @malloc(i64 16)
	%49 = bitcast i8* %48 to %IntStruct*
	%50 = getelementptr %IntStruct, %IntStruct* %49, i32 0, i32 1
	store i32 %47, i32* %50
	br label %if_end_2

if_end_2:
	%51 = phi %IntStruct* [ %26, %if_then_0 ], [ %49, %if_else_1 ]
	ret %IntStruct* %51
}

define %IOStruct* @Main_main(%Main_struct* %self) {
entry:
	%0 = alloca %Main_struct*
	store %Main_struct* %self, %Main_struct** %0
	%1 = load %Main_struct*, %Main_struct** %0
	%2 = bitcast %Main_struct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = call i8* @malloc(i64 8)
	%5 = bitcast i8* %4 to %Factorial_struct*
	%6 = getelementptr %Factorial_struct, %Factorial_struct* %5, i32 0, i32 0
	store i8* bitcast ([1 x i8*]* bitcast ([1 x i8*]* @vtable_Factorial to [1 x i8*]*) to i8*), i8** %6
	%7 = load %Main_struct*, %Main_struct** %3
	%8 = getelementptr %Factorial_struct*, %Main_struct* %7, i32 1
	store %Factorial_struct* %5, %Factorial_struct** %8
	%9 = load %Main_struct*, %Main_struct** %3
	%10 = bitcast %Main_struct* %9 to %Main_struct*
	%11 = getelementptr %Main_struct, %Main_struct* %10, i32 0, i32 1
	%12 = load %Factorial_struct*, %Factorial_struct** %11
	%13 = bitcast %Factorial_struct* %12 to %ObjectStruct*
	%14 = call i8* @malloc(i64 16)
	%15 = bitcast i8* %14 to %IntStruct*
	%16 = getelementptr %IntStruct, %IntStruct* %15, i32 0, i32 1
	store i32 5, i32* %16
	%17 = bitcast %ObjectStruct* %13 to %Factorial_struct*
	%18 = getelementptr %Factorial_struct, %Factorial_struct* %17, i32 0, i32 0
	%19 = load i8*, i8** %18
	%20 = bitcast i8* %19 to [1 x %ObjectStruct* (%ObjectStruct*)*]*
	%21 = getelementptr [1 x %ObjectStruct* (%ObjectStruct*)*], [1 x %ObjectStruct* (%ObjectStruct*)*]* %20, i32 0, i32 0
	%22 = load i8*, %ObjectStruct* (%ObjectStruct*)** %21
	%23 = bitcast i8* %22 to %IntStruct* (%Factorial_struct*, %IntStruct*)*
	%24 = call %IntStruct* %23(%ObjectStruct* %13, %IntStruct* %15)
	%25 = getelementptr %IntStruct, %IntStruct* %24, i32 0, i32 1
	%26 = load i32, i32* %25
	%27 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%28 = call i32 (i8*, ...) @printf(i8* %27, i32 %26)
	%29 = load %Main_struct*, %Main_struct** %3
	%30 = bitcast %Main_struct* %29 to %IOStruct*
	ret %IOStruct* %30
}
