%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%ArrayStruct = type { i8*, i64, i8* }
%Main_struct = type { i8*, %IntStruct* }

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
@vtable_Array = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%ArrayStruct*)* @Array_length to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* (%ArrayStruct*, i64)* @Array_get to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (void (%ArrayStruct*, i64, i8*)* @Array_set to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ArrayStruct* (%ArrayStruct*, i64)* @Array_resize to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%ObjectStruct* (%Main_struct*)* @Main_main to i8*)]
@str_2 = global [10 x i8] c"a is null\00"
@str_obj_3 = constant { i8* } { [10 x i8]* getelementptr inbounds ([10 x i8], [10 x i8]* @str_2) }
@str_4 = global [15 x i8] c"a is not null\0A\00"
@str_obj_5 = constant { i8* } { [15 x i8]* getelementptr inbounds ([15 x i8], [15 x i8]* @str_4) }
@str_6 = global [8 x i8] c"Test 1\0A\00"
@str_obj_7 = constant { i8* } { [8 x i8]* getelementptr inbounds ([8 x i8], [8 x i8]* @str_6) }
@str_8 = global [8 x i8] c"Test 2\0A\00"
@str_obj_9 = constant { i8* } { [8 x i8]* getelementptr inbounds ([8 x i8], [8 x i8]* @str_8) }
@str_10 = global [2 x i8] c"\0A\00"
@str_obj_11 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_10) }
@str_12 = global [2 x i8] c"\0A\00"
@str_obj_13 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_12) }

declare i8* @malloc(i64 %size)

declare i32 @printf(i8* nocapture %fmt, ...)

declare i32 @scanf(i8* nocapture %fmt, ...)

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

declare void @llvm.memset.p0i8.i64(i8* %dest, i8 %val, i64 %len, i32 %align, i1 %isvolatile)

define i8* @Array_get(%ArrayStruct* %self, i64 %index) {
entry:
	%0 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 1
	%1 = load i64, i64* %0
	%2 = icmp ult i64 %index, %1
	br i1 %2, label %valid, label %error

valid:
	%3 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 2
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8**
	%6 = getelementptr i8*, i8** %5, i64 %index
	%7 = load i8*, i8** %6
	ret i8* %7

error:
	ret i8* null
}

define void @Array_set(%ArrayStruct* %self, i64 %index, i8* %value) {
entry:
	%0 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 1
	%1 = load i64, i64* %0
	%2 = icmp ult i64 %index, %1
	br i1 %2, label %valid, label %error

valid:
	%3 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 2
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8**
	%6 = getelementptr i8*, i8** %5, i64 %index
	store i8* %value, i8** %6
	ret void

error:
	ret void
}

define %ArrayStruct* @Array_resize(%ArrayStruct* %self, i64 %new_size) {
entry:
	%0 = mul i64 %new_size, 8
	%1 = call i8* @malloc(i64 %0)
	call void @llvm.memset.p0i8.i64(i8* %1, i8 0, i64 %0, i32 8, i1 false)
	%2 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 2
	%3 = load i8*, i8** %2
	%4 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 1
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %new_size
	%7 = select i1 %6, i64 %5, i64 %new_size
	%8 = mul i64 %7, 8
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* %1, i8* %3, i64 %8, i32 8, i1 false)
	store i8* %1, i8** %2
	store i64 %new_size, i64* %4
	ret %ArrayStruct* %self
}

define %IntStruct* @Array_length(%ArrayStruct* %self) {
entry:
	%0 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 1
	%1 = load i64, i64* %0
	%2 = trunc i64 %1 to i32
	%3 = call i8* @malloc(i64 16)
	%4 = bitcast i8* %3 to %IntStruct*
	%5 = getelementptr %IntStruct, %IntStruct* %4, i32 0, i32 1
	store i32 %2, i32* %5
	ret %IntStruct* %4
}

define i32 @main() {
entry:
	%0 = call i8* @malloc(i64 16)
	%1 = bitcast i8* %0 to %Main_struct*
	%2 = bitcast [1 x i8*]* @vtable_Main to i8*
	%3 = getelementptr %Main_struct, %Main_struct* %1, i32 0, i32 0
	store i8* %2, i8** %3
	%4 = call %ObjectStruct* @Main_main(%Main_struct* %1)
	ret i32 0
}

define %ObjectStruct* @Main_main(%Main_struct* %self) {
entry:
	%0 = alloca %Main_struct*
	store %Main_struct* %self, %Main_struct** %0
	%1 = load %Main_struct*, %Main_struct** %0
	%2 = bitcast %Main_struct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = alloca %ArrayStruct*
	%5 = call i8* @malloc(i64 24)
	%6 = bitcast i8* %5 to %ArrayStruct*
	%7 = mul i64 8, 8
	%8 = call i8* @malloc(i64 %7)
	%9 = getelementptr %ArrayStruct, %ArrayStruct* %6, i32 0, i32 1
	store i64 0, i64* %9
	%10 = getelementptr %ArrayStruct, %ArrayStruct* %6, i32 0, i32 2
	store i8* %8, i8** %10
	%11 = bitcast [7 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_Array to i8*
	%12 = getelementptr %ArrayStruct, %ArrayStruct* %6, i32 0, i32 0
	store i8* %11, i8** %12
	store %ArrayStruct* %6, %ArrayStruct** %4
	%13 = load %ArrayStruct*, %ArrayStruct** %4
	%14 = icmp eq %ArrayStruct* %13, null
	%15 = call i8* @malloc(i64 16)
	%16 = bitcast i8* %15 to %BoolStruct*
	%17 = getelementptr %BoolStruct, %BoolStruct* %16, i32 0, i32 1
	store i1 %14, i1* %17
	%18 = getelementptr %BoolStruct, %BoolStruct* %16, i32 0, i32 1
	%19 = load i1, i1* %18
	%20 = icmp ne i1 %19, false
	br i1 %20, label %if_then_0, label %if_else_1

if_then_0:
	%21 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*), i32 0, i32 0
	%22 = load i8*, i8** %21
	%23 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%24 = call i32 (i8*, ...) @printf(i8* %23, i8* %22)
	%25 = load %Main_struct*, %Main_struct** %3
	br label %if_end_2

if_else_1:
	%26 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%27 = load i8*, i8** %26
	%28 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%29 = call i32 (i8*, ...) @printf(i8* %28, i8* %27)
	%30 = load %Main_struct*, %Main_struct** %3
	br label %if_end_2

if_end_2:
	%31 = phi %Main_struct* [ %25, %if_then_0 ], [ %30, %if_else_1 ]
	%32 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%33 = load i8*, i8** %32
	%34 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%35 = call i32 (i8*, ...) @printf(i8* %34, i8* %33)
	%36 = load %Main_struct*, %Main_struct** %3
	%37 = load %ArrayStruct*, %ArrayStruct** %4
	%38 = bitcast %ArrayStruct* %37 to %ObjectStruct*
	%39 = call i8* @malloc(i64 16)
	%40 = bitcast i8* %39 to %IntStruct*
	%41 = getelementptr %IntStruct, %IntStruct* %40, i32 0, i32 1
	store i32 3, i32* %41
	%42 = call i8* @malloc(i64 16)
	%43 = bitcast i8* %42 to %IntStruct*
	%44 = getelementptr %IntStruct, %IntStruct* %43, i32 0, i32 1
	store i32 3, i32* %44
	%45 = getelementptr %IntStruct, %IntStruct* %43, i32 0, i32 1
	%46 = load i32, i32* %45
	%47 = sext i32 %46 to i64
	%48 = call %ArrayStruct* @Array_resize(%ObjectStruct* %38, i64 %47)
	%49 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*), i32 0, i32 0
	%50 = load i8*, i8** %49
	%51 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%52 = call i32 (i8*, ...) @printf(i8* %51, i8* %50)
	%53 = load %Main_struct*, %Main_struct** %3
	%54 = load %ArrayStruct*, %ArrayStruct** %4
	%55 = bitcast %ArrayStruct* %54 to %ObjectStruct*
	%56 = call i8* @malloc(i64 16)
	%57 = bitcast i8* %56 to %IntStruct*
	%58 = getelementptr %IntStruct, %IntStruct* %57, i32 0, i32 1
	store i32 0, i32* %58
	%59 = call i8* @malloc(i64 16)
	%60 = bitcast i8* %59 to %IntStruct*
	%61 = getelementptr %IntStruct, %IntStruct* %60, i32 0, i32 1
	store i32 42, i32* %61
	%62 = call i8* @malloc(i64 16)
	%63 = bitcast i8* %62 to %IntStruct*
	%64 = getelementptr %IntStruct, %IntStruct* %63, i32 0, i32 1
	store i32 0, i32* %64
	%65 = getelementptr %IntStruct, %IntStruct* %63, i32 0, i32 1
	%66 = load i32, i32* %65
	%67 = sext i32 %66 to i64
	%68 = call i8* @malloc(i64 16)
	%69 = bitcast i8* %68 to %IntStruct*
	%70 = getelementptr %IntStruct, %IntStruct* %69, i32 0, i32 1
	store i32 42, i32* %70
	%71 = bitcast %IntStruct* %69 to i8*
	call void @Array_set(%ObjectStruct* %55, i64 %67, i8* %71)
	%72 = load %ArrayStruct*, %ArrayStruct** %4
	%73 = bitcast %ArrayStruct* %72 to %ObjectStruct*
	%74 = call i8* @malloc(i64 16)
	%75 = bitcast i8* %74 to %IntStruct*
	%76 = getelementptr %IntStruct, %IntStruct* %75, i32 0, i32 1
	store i32 1, i32* %76
	%77 = call i8* @malloc(i64 16)
	%78 = bitcast i8* %77 to %IntStruct*
	%79 = getelementptr %IntStruct, %IntStruct* %78, i32 0, i32 1
	store i32 100, i32* %79
	%80 = call i8* @malloc(i64 16)
	%81 = bitcast i8* %80 to %IntStruct*
	%82 = getelementptr %IntStruct, %IntStruct* %81, i32 0, i32 1
	store i32 1, i32* %82
	%83 = getelementptr %IntStruct, %IntStruct* %81, i32 0, i32 1
	%84 = load i32, i32* %83
	%85 = sext i32 %84 to i64
	%86 = call i8* @malloc(i64 16)
	%87 = bitcast i8* %86 to %IntStruct*
	%88 = getelementptr %IntStruct, %IntStruct* %87, i32 0, i32 1
	store i32 100, i32* %88
	%89 = bitcast %IntStruct* %87 to i8*
	call void @Array_set(%ObjectStruct* %73, i64 %85, i8* %89)
	%90 = load %ArrayStruct*, %ArrayStruct** %4
	%91 = bitcast %ArrayStruct* %90 to %ObjectStruct*
	%92 = call i8* @malloc(i64 16)
	%93 = bitcast i8* %92 to %IntStruct*
	%94 = getelementptr %IntStruct, %IntStruct* %93, i32 0, i32 1
	store i32 2, i32* %94
	%95 = call i8* @malloc(i64 16)
	%96 = bitcast i8* %95 to %IntStruct*
	%97 = getelementptr %IntStruct, %IntStruct* %96, i32 0, i32 1
	store i32 200, i32* %97
	%98 = call i8* @malloc(i64 16)
	%99 = bitcast i8* %98 to %IntStruct*
	%100 = getelementptr %IntStruct, %IntStruct* %99, i32 0, i32 1
	store i32 2, i32* %100
	%101 = getelementptr %IntStruct, %IntStruct* %99, i32 0, i32 1
	%102 = load i32, i32* %101
	%103 = sext i32 %102 to i64
	%104 = call i8* @malloc(i64 16)
	%105 = bitcast i8* %104 to %IntStruct*
	%106 = getelementptr %IntStruct, %IntStruct* %105, i32 0, i32 1
	store i32 200, i32* %106
	%107 = bitcast %IntStruct* %105 to i8*
	call void @Array_set(%ObjectStruct* %91, i64 %103, i8* %107)
	%108 = alloca %IntStruct*
	%109 = bitcast %IntStruct** null to %IntStruct*
	store %IntStruct* %109, %IntStruct** %108
	%110 = load %ArrayStruct*, %ArrayStruct** %4
	%111 = bitcast %ArrayStruct* %110 to %ObjectStruct*
	%112 = call i8* @malloc(i64 16)
	%113 = bitcast i8* %112 to %IntStruct*
	%114 = getelementptr %IntStruct, %IntStruct* %113, i32 0, i32 1
	store i32 1, i32* %114
	%115 = call i8* @malloc(i64 16)
	%116 = bitcast i8* %115 to %IntStruct*
	%117 = getelementptr %IntStruct, %IntStruct* %116, i32 0, i32 1
	store i32 1, i32* %117
	%118 = getelementptr %IntStruct, %IntStruct* %116, i32 0, i32 1
	%119 = load i32, i32* %118
	%120 = sext i32 %119 to i64
	%121 = call i8* @Array_get(%ObjectStruct* %111, i64 %120)
	%122 = bitcast i8* %121 to %IntStruct*
	%123 = load %Main_struct*, %Main_struct** %3
	%124 = getelementptr %IntStruct*, %Main_struct* %123, i32 1
	store %IntStruct* %122, %IntStruct** %124
	%125 = call i8* @malloc(i64 16)
	%126 = bitcast i8* %125 to %IntStruct*
	%127 = getelementptr %IntStruct, %IntStruct* %126, i32 0, i32 1
	store i32 1, i32* %127
	%128 = load %Main_struct*, %Main_struct** %3
	%129 = getelementptr %IntStruct*, %Main_struct* %128, i32 1
	store %IntStruct* %126, %IntStruct** %129
	%130 = load %ArrayStruct*, %ArrayStruct** %4
	%131 = bitcast %ArrayStruct* %130 to %ObjectStruct*
	%132 = call i8* @malloc(i64 16)
	%133 = bitcast i8* %132 to %IntStruct*
	%134 = getelementptr %IntStruct, %IntStruct* %133, i32 0, i32 1
	store i32 0, i32* %134
	%135 = call i8* @malloc(i64 16)
	%136 = bitcast i8* %135 to %IntStruct*
	%137 = getelementptr %IntStruct, %IntStruct* %136, i32 0, i32 1
	store i32 0, i32* %137
	%138 = getelementptr %IntStruct, %IntStruct* %136, i32 0, i32 1
	%139 = load i32, i32* %138
	%140 = sext i32 %139 to i64
	%141 = call i8* @Array_get(%ObjectStruct* %131, i64 %140)
	%142 = bitcast i8* %141 to %IntStruct*
	%143 = getelementptr %IntStruct, %IntStruct* %142, i32 0, i32 1
	%144 = load i32, i32* %143
	%145 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%146 = call i32 (i8*, ...) @printf(i8* %145, i32 %144)
	%147 = load %Main_struct*, %Main_struct** %3
	%148 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_11 to %StringStruct*), i32 0, i32 0
	%149 = load i8*, i8** %148
	%150 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%151 = call i32 (i8*, ...) @printf(i8* %150, i8* %149)
	%152 = load %Main_struct*, %Main_struct** %3
	%153 = load %ArrayStruct*, %ArrayStruct** %4
	%154 = bitcast %ArrayStruct* %153 to %ObjectStruct*
	%155 = call %IntStruct* @Array_length(%ObjectStruct* %154)
	%156 = getelementptr %IntStruct, %IntStruct* %155, i32 0, i32 1
	%157 = load i32, i32* %156
	%158 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%159 = call i32 (i8*, ...) @printf(i8* %158, i32 %157)
	%160 = load %Main_struct*, %Main_struct** %3
	%161 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_13 to %StringStruct*), i32 0, i32 0
	%162 = load i8*, i8** %161
	%163 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%164 = call i32 (i8*, ...) @printf(i8* %163, i8* %162)
	%165 = load %Main_struct*, %Main_struct** %3
	%166 = load %ArrayStruct*, %ArrayStruct** %4
	%167 = bitcast %ArrayStruct* %166 to %ObjectStruct*
	%168 = getelementptr %IntStruct, i8* null, i32 0, i32 1
	%169 = load i32, i32* %168
	%170 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%171 = call i32 (i8*, ...) @printf(i8* %170, i32 %169)
	%172 = load %Main_struct*, %Main_struct** %3
	%173 = bitcast %Main_struct* %172 to %ObjectStruct*
	ret %ObjectStruct* %173
}
