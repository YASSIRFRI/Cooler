%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%Tchh_struct = type { i8* }
%Main_struct = type { i8* }

@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@str_0 = global [7 x i8] c"Object\00"
@str_obj_1 = constant { i8* } { [7 x i8]* getelementptr inbounds ([7 x i8], [7 x i8]* @str_0) }
@vtable_Object = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Int = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_String = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Bool = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_IO = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %StringStruct*)* @IO_out_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %IntStruct*)* @IO_out_int to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%IOStruct*)* @IO_in_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%IOStruct*)* @IO_in_int to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Tchh = constant [2 x i8*] [i8* bitcast (%IntStruct* (%Tchh_struct*, %IntStruct*)* @Tchh_factorial to i8*), i8* bitcast (%IOStruct* (%Tchh_struct*)* @Tchh_main to i8*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%ObjectStruct* (%Main_struct*)* @Main_main to i8*)]
@str_2 = global [2 x i8] c" \00"
@str_obj_3 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_2) }
@str_4 = global [2 x i8] c"*\00"
@str_obj_5 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_4) }
@str_6 = global [2 x i8] c"\0A\00"
@str_obj_7 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_6) }

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

define %IOStruct* @IO_out_string(%IOStruct* %self, %StringStruct* %str) {
entry:
	%0 = getelementptr %StringStruct, %StringStruct* %str, i32 0, i32 1
	%1 = load i8*, i8** %0
	%2 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%3 = call i32 (i8*, ...) @printf(i8* %2, i8* %1)
	ret %IOStruct* %self
}

define %IOStruct* @IO_out_int(%IOStruct* %self, %IntStruct* %int) {
entry:
	%0 = getelementptr %IntStruct, %IntStruct* %int, i32 0, i32 1
	%1 = load i32, i32* %0
	%2 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%3 = call i32 (i8*, ...) @printf(i8* %2, i32 %1)
	ret %IOStruct* %self
}

define %StringStruct* @IO_in_string(%IOStruct* %self) {
entry:
	%0 = alloca [1024 x i8]
	%1 = getelementptr [1024 x i8], [1024 x i8]* %0, i32 0, i32 0
	%2 = getelementptr [7 x i8], [7 x i8]* @fmt_str_in_2, i32 0, i32 0
	%3 = call i32 (i8*, ...) @scanf(i8* %2, i8* %1)
	%4 = call i8* @malloc(i64 16)
	%5 = bitcast i8* %4 to %StringStruct*
	%6 = getelementptr %StringStruct, %StringStruct* %5, i32 0, i32 1
	store i8* %1, i8** %6
	ret %StringStruct* %5
}

define %IntStruct* @IO_in_int(%IOStruct* %self) {
entry:
	%0 = alloca i32
	%1 = getelementptr [3 x i8], [3 x i8]* @fmt_int_in_3, i32 0, i32 0
	%2 = call i32 (i8*, ...) @scanf(i8* %1, i32* %0)
	%3 = load i32, i32* %0
	%4 = call i8* @malloc(i64 16)
	%5 = bitcast i8* %4 to %IntStruct*
	%6 = getelementptr %IntStruct, %IntStruct* %5, i32 0, i32 1
	store i32 %3, i32* %6
	ret %IntStruct* %5
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
	%0 = call i8* @malloc(i64 8)
	%1 = bitcast i8* %0 to %Main_struct*
	%2 = bitcast [1 x i8*]* @vtable_Main to i8*
	%3 = getelementptr %Main_struct, %Main_struct* %1, i32 0, i32 0
	store i8* %2, i8** %3
	%4 = call %ObjectStruct* @Main_main(%Main_struct* %1)
	ret i32 0
}

define %IntStruct* @Tchh_factorial(%Tchh_struct* %self, %IntStruct* %n) {
entry:
	%0 = alloca %Tchh_struct*
	store %Tchh_struct* %self, %Tchh_struct** %0
	%1 = load %Tchh_struct*, %Tchh_struct** %0
	%2 = bitcast %Tchh_struct* %1 to %Tchh_struct*
	%3 = alloca %Tchh_struct*
	store %Tchh_struct* %2, %Tchh_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %n, %IntStruct** %4
	%5 = load %IntStruct*, %IntStruct** %4
	%6 = call i8* @malloc(i64 16)
	%7 = bitcast i8* %6 to %IntStruct*
	%8 = getelementptr %IntStruct, %IntStruct* %7, i32 0, i32 1
	store i32 0, i32* %8
	%9 = getelementptr %IntStruct, %IntStruct* %5, i32 0, i32 1
	%10 = load i32, i32* %9
	%11 = getelementptr %IntStruct, %IntStruct* %7, i32 0, i32 1
	%12 = load i32, i32* %11
	%13 = icmp eq i32 %10, %12
	%14 = call i8* @malloc(i64 16)
	%15 = bitcast i8* %14 to %BoolStruct*
	%16 = getelementptr %BoolStruct, %BoolStruct* %15, i32 0, i32 1
	store i1 %13, i1* %16
	%17 = getelementptr %BoolStruct, %BoolStruct* %15, i32 0, i32 1
	%18 = load i1, i1* %17
	%19 = icmp ne i1 %18, false
	br i1 %19, label %if_then_0, label %if_else_1

if_then_0:
	%20 = call i8* @malloc(i64 16)
	%21 = bitcast i8* %20 to %IntStruct*
	%22 = getelementptr %IntStruct, %IntStruct* %21, i32 0, i32 1
	store i32 1, i32* %22
	br label %if_end_2

if_else_1:
	%23 = load %IntStruct*, %IntStruct** %4
	%24 = load %Tchh_struct*, %Tchh_struct** %3
	%25 = load %IntStruct*, %IntStruct** %4
	%26 = call i8* @malloc(i64 16)
	%27 = bitcast i8* %26 to %IntStruct*
	%28 = getelementptr %IntStruct, %IntStruct* %27, i32 0, i32 1
	store i32 1, i32* %28
	%29 = getelementptr %IntStruct, %IntStruct* %25, i32 0, i32 1
	%30 = load i32, i32* %29
	%31 = getelementptr %IntStruct, %IntStruct* %27, i32 0, i32 1
	%32 = load i32, i32* %31
	%33 = sub i32 %30, %32
	%34 = call i8* @malloc(i64 16)
	%35 = bitcast i8* %34 to %IntStruct*
	%36 = getelementptr %IntStruct, %IntStruct* %35, i32 0, i32 1
	store i32 %33, i32* %36
	%37 = call %IntStruct* @Tchh_factorial(%Tchh_struct* %24, %IntStruct* %35)
	%38 = getelementptr %IntStruct, %IntStruct* %23, i32 0, i32 1
	%39 = load i32, i32* %38
	%40 = getelementptr %IntStruct, %IntStruct* %37, i32 0, i32 1
	%41 = load i32, i32* %40
	%42 = mul i32 %39, %41
	%43 = call i8* @malloc(i64 16)
	%44 = bitcast i8* %43 to %IntStruct*
	%45 = getelementptr %IntStruct, %IntStruct* %44, i32 0, i32 1
	store i32 %42, i32* %45
	br label %if_end_2

if_end_2:
	%46 = phi %IntStruct* [ %21, %if_then_0 ], [ %44, %if_else_1 ]
	ret %IntStruct* %46
}

define %IOStruct* @Tchh_main(%Tchh_struct* %self) {
entry:
	%0 = alloca %Tchh_struct*
	store %Tchh_struct* %self, %Tchh_struct** %0
	%1 = load %Tchh_struct*, %Tchh_struct** %0
	%2 = bitcast %Tchh_struct* %1 to %Tchh_struct*
	%3 = alloca %Tchh_struct*
	store %Tchh_struct* %2, %Tchh_struct** %3
	%4 = load %Tchh_struct*, %Tchh_struct** %3
	%5 = call i8* @malloc(i64 16)
	%6 = bitcast i8* %5 to %IntStruct*
	%7 = getelementptr %IntStruct, %IntStruct* %6, i32 0, i32 1
	store i32 5, i32* %7
	%8 = call %IntStruct* @Tchh_factorial(%Tchh_struct* %4, %IntStruct* %6)
	%9 = getelementptr %IntStruct, %IntStruct* %8, i32 0, i32 1
	%10 = load i32, i32* %9
	%11 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%12 = call i32 (i8*, ...) @printf(i8* %11, i32 %10)
	%13 = load %Tchh_struct*, %Tchh_struct** %3
	%14 = bitcast %Tchh_struct* %13 to %IOStruct*
	ret %IOStruct* %14
}

define %ObjectStruct* @Main_main(%Main_struct* %self) {
entry:
	%0 = alloca %Main_struct*
	store %Main_struct* %self, %Main_struct** %0
	%1 = load %Main_struct*, %Main_struct** %0
	%2 = bitcast %Main_struct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = alloca %IntStruct*
	%5 = call i8* @malloc(i64 16)
	%6 = bitcast i8* %5 to %IntStruct*
	%7 = getelementptr %IntStruct, %IntStruct* %6, i32 0, i32 1
	store i32 5, i32* %7
	store %IntStruct* %6, %IntStruct** %4
	%8 = alloca %IntStruct*
	%9 = call i8* @malloc(i64 16)
	%10 = bitcast i8* %9 to %IntStruct*
	%11 = getelementptr %IntStruct, %IntStruct* %10, i32 0, i32 1
	store i32 1, i32* %11
	store %IntStruct* %10, %IntStruct** %8
	br label %while_cond_3

while_cond_3:
	%12 = load %IntStruct*, %IntStruct** %8
	%13 = load %IntStruct*, %IntStruct** %4
	%14 = getelementptr %IntStruct, %IntStruct* %12, i32 0, i32 1
	%15 = load i32, i32* %14
	%16 = getelementptr %IntStruct, %IntStruct* %13, i32 0, i32 1
	%17 = load i32, i32* %16
	%18 = icmp sle i32 %15, %17
	%19 = call i8* @malloc(i64 16)
	%20 = bitcast i8* %19 to %BoolStruct*
	%21 = getelementptr %BoolStruct, %BoolStruct* %20, i32 0, i32 1
	store i1 %18, i1* %21
	%22 = getelementptr %BoolStruct, %BoolStruct* %20, i32 0, i32 1
	%23 = load i1, i1* %22
	%24 = icmp ne i1 %23, false
	br i1 %24, label %while_body_4, label %while_end_5

while_body_4:
	%25 = alloca %IntStruct*
	%26 = call i8* @malloc(i64 16)
	%27 = bitcast i8* %26 to %IntStruct*
	%28 = getelementptr %IntStruct, %IntStruct* %27, i32 0, i32 1
	store i32 1, i32* %28
	store %IntStruct* %27, %IntStruct** %25
	br label %while_cond_6

while_end_5:
	%29 = load %Main_struct*, %Main_struct** %3
	%30 = bitcast %Main_struct* %29 to %ObjectStruct*
	ret %ObjectStruct* %30

while_cond_6:
	%31 = load %IntStruct*, %IntStruct** %25
	%32 = load %IntStruct*, %IntStruct** %4
	%33 = load %IntStruct*, %IntStruct** %8
	%34 = getelementptr %IntStruct, %IntStruct* %32, i32 0, i32 1
	%35 = load i32, i32* %34
	%36 = getelementptr %IntStruct, %IntStruct* %33, i32 0, i32 1
	%37 = load i32, i32* %36
	%38 = sub i32 %35, %37
	%39 = call i8* @malloc(i64 16)
	%40 = bitcast i8* %39 to %IntStruct*
	%41 = getelementptr %IntStruct, %IntStruct* %40, i32 0, i32 1
	store i32 %38, i32* %41
	%42 = getelementptr %IntStruct, %IntStruct* %31, i32 0, i32 1
	%43 = load i32, i32* %42
	%44 = getelementptr %IntStruct, %IntStruct* %40, i32 0, i32 1
	%45 = load i32, i32* %44
	%46 = icmp sle i32 %43, %45
	%47 = call i8* @malloc(i64 16)
	%48 = bitcast i8* %47 to %BoolStruct*
	%49 = getelementptr %BoolStruct, %BoolStruct* %48, i32 0, i32 1
	store i1 %46, i1* %49
	%50 = getelementptr %BoolStruct, %BoolStruct* %48, i32 0, i32 1
	%51 = load i1, i1* %50
	%52 = icmp ne i1 %51, false
	br i1 %52, label %while_body_7, label %while_end_8

while_body_7:
	%53 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*), i32 0, i32 0
	%54 = load i8*, i8** %53
	%55 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%56 = call i32 (i8*, ...) @printf(i8* %55, i8* %54)
	%57 = load %Main_struct*, %Main_struct** %3
	%58 = load %IntStruct*, %IntStruct** %25
	%59 = call i8* @malloc(i64 16)
	%60 = bitcast i8* %59 to %IntStruct*
	%61 = getelementptr %IntStruct, %IntStruct* %60, i32 0, i32 1
	store i32 1, i32* %61
	%62 = getelementptr %IntStruct, %IntStruct* %58, i32 0, i32 1
	%63 = load i32, i32* %62
	%64 = getelementptr %IntStruct, %IntStruct* %60, i32 0, i32 1
	%65 = load i32, i32* %64
	%66 = add i32 %63, %65
	%67 = call i8* @malloc(i64 16)
	%68 = bitcast i8* %67 to %IntStruct*
	%69 = getelementptr %IntStruct, %IntStruct* %68, i32 0, i32 1
	store i32 %66, i32* %69
	store %IntStruct* %68, %IntStruct** %25
	br label %while_cond_6

while_end_8:
	%70 = alloca %IntStruct*
	%71 = call i8* @malloc(i64 16)
	%72 = bitcast i8* %71 to %IntStruct*
	%73 = getelementptr %IntStruct, %IntStruct* %72, i32 0, i32 1
	store i32 1, i32* %73
	store %IntStruct* %72, %IntStruct** %70
	br label %while_cond_9

while_cond_9:
	%74 = load %IntStruct*, %IntStruct** %70
	%75 = call i8* @malloc(i64 16)
	%76 = bitcast i8* %75 to %IntStruct*
	%77 = getelementptr %IntStruct, %IntStruct* %76, i32 0, i32 1
	store i32 2, i32* %77
	%78 = load %IntStruct*, %IntStruct** %8
	%79 = getelementptr %IntStruct, %IntStruct* %76, i32 0, i32 1
	%80 = load i32, i32* %79
	%81 = getelementptr %IntStruct, %IntStruct* %78, i32 0, i32 1
	%82 = load i32, i32* %81
	%83 = mul i32 %80, %82
	%84 = call i8* @malloc(i64 16)
	%85 = bitcast i8* %84 to %IntStruct*
	%86 = getelementptr %IntStruct, %IntStruct* %85, i32 0, i32 1
	store i32 %83, i32* %86
	%87 = call i8* @malloc(i64 16)
	%88 = bitcast i8* %87 to %IntStruct*
	%89 = getelementptr %IntStruct, %IntStruct* %88, i32 0, i32 1
	store i32 1, i32* %89
	%90 = getelementptr %IntStruct, %IntStruct* %85, i32 0, i32 1
	%91 = load i32, i32* %90
	%92 = getelementptr %IntStruct, %IntStruct* %88, i32 0, i32 1
	%93 = load i32, i32* %92
	%94 = sub i32 %91, %93
	%95 = call i8* @malloc(i64 16)
	%96 = bitcast i8* %95 to %IntStruct*
	%97 = getelementptr %IntStruct, %IntStruct* %96, i32 0, i32 1
	store i32 %94, i32* %97
	%98 = getelementptr %IntStruct, %IntStruct* %74, i32 0, i32 1
	%99 = load i32, i32* %98
	%100 = getelementptr %IntStruct, %IntStruct* %96, i32 0, i32 1
	%101 = load i32, i32* %100
	%102 = icmp sle i32 %99, %101
	%103 = call i8* @malloc(i64 16)
	%104 = bitcast i8* %103 to %BoolStruct*
	%105 = getelementptr %BoolStruct, %BoolStruct* %104, i32 0, i32 1
	store i1 %102, i1* %105
	%106 = getelementptr %BoolStruct, %BoolStruct* %104, i32 0, i32 1
	%107 = load i1, i1* %106
	%108 = icmp ne i1 %107, false
	br i1 %108, label %while_body_10, label %while_end_11

while_body_10:
	%109 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%110 = load i8*, i8** %109
	%111 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%112 = call i32 (i8*, ...) @printf(i8* %111, i8* %110)
	%113 = load %Main_struct*, %Main_struct** %3
	%114 = load %IntStruct*, %IntStruct** %70
	%115 = call i8* @malloc(i64 16)
	%116 = bitcast i8* %115 to %IntStruct*
	%117 = getelementptr %IntStruct, %IntStruct* %116, i32 0, i32 1
	store i32 1, i32* %117
	%118 = getelementptr %IntStruct, %IntStruct* %114, i32 0, i32 1
	%119 = load i32, i32* %118
	%120 = getelementptr %IntStruct, %IntStruct* %116, i32 0, i32 1
	%121 = load i32, i32* %120
	%122 = add i32 %119, %121
	%123 = call i8* @malloc(i64 16)
	%124 = bitcast i8* %123 to %IntStruct*
	%125 = getelementptr %IntStruct, %IntStruct* %124, i32 0, i32 1
	store i32 %122, i32* %125
	store %IntStruct* %124, %IntStruct** %70
	br label %while_cond_9

while_end_11:
	%126 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%127 = load i8*, i8** %126
	%128 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%129 = call i32 (i8*, ...) @printf(i8* %128, i8* %127)
	%130 = load %Main_struct*, %Main_struct** %3
	%131 = load %IntStruct*, %IntStruct** %8
	%132 = call i8* @malloc(i64 16)
	%133 = bitcast i8* %132 to %IntStruct*
	%134 = getelementptr %IntStruct, %IntStruct* %133, i32 0, i32 1
	store i32 1, i32* %134
	%135 = getelementptr %IntStruct, %IntStruct* %131, i32 0, i32 1
	%136 = load i32, i32* %135
	%137 = getelementptr %IntStruct, %IntStruct* %133, i32 0, i32 1
	%138 = load i32, i32* %137
	%139 = add i32 %136, %138
	%140 = call i8* @malloc(i64 16)
	%141 = bitcast i8* %140 to %IntStruct*
	%142 = getelementptr %IntStruct, %IntStruct* %141, i32 0, i32 1
	store i32 %139, i32* %142
	store %IntStruct* %141, %IntStruct** %8
	br label %while_cond_3
}
