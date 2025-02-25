%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%ArrayStruct = type { i8*, i64, i8* }
%ArraySet_struct = type { i8*, i8*, %IntStruct*, %IntStruct*, %IntStruct* }
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
@vtable_Array = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%ArrayStruct*)* @Array_length to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* (%ArrayStruct*, i64)* @Array_get to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (void (%ArrayStruct*, i64, i8*)* @Array_set to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ArrayStruct* (%ArrayStruct*, i64)* @Array_resize to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_ArraySet = constant [5 x i8*] [i8* bitcast (%ArraySet_struct* (%ArraySet_struct*)* @ArraySet_init_set to i8*), i8* bitcast (%BoolStruct* (%ArraySet_struct*, %IntStruct*)* @ArraySet_contains to i8*), i8* bitcast (%ArraySet_struct* (%ArraySet_struct*, %IntStruct*)* @ArraySet_insert to i8*), i8* bitcast (%ArraySet_struct* (%ArraySet_struct*, %IntStruct*)* @ArraySet_delete to i8*), i8* bitcast (%ArraySet_struct* (%ArraySet_struct*)* @ArraySet_print_set to i8*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%ObjectStruct* (%Main_struct*)* @Main_main to i8*)]
@str_2 = global [5 x i8] c"Test\00"
@str_obj_3 = constant { i8* } { [5 x i8]* getelementptr inbounds ([5 x i8], [5 x i8]* @str_2) }
@str_4 = global [2 x i8] c" \00"
@str_obj_5 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_4) }
@str_6 = global [2 x i8] c"\0A\00"
@str_obj_7 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_6) }
@str_8 = global [31 x i8] c"Current set contents (Array):\0A\00"
@str_obj_9 = constant { i8* } { [31 x i8]* getelementptr inbounds ([31 x i8], [31 x i8]* @str_8) }
@str_10 = global [25 x i8] c"Deleting 20 from set...\0A\00"
@str_obj_11 = constant { i8* } { [25 x i8]* getelementptr inbounds ([25 x i8], [25 x i8]* @str_10) }
@str_12 = global [14 x i8] c"Contains 20? \00"
@str_obj_13 = constant { i8* } { [14 x i8]* getelementptr inbounds ([14 x i8], [14 x i8]* @str_12) }
@str_14 = global [5 x i8] c"Yes\0A\00"
@str_obj_15 = constant { i8* } { [5 x i8]* getelementptr inbounds ([5 x i8], [5 x i8]* @str_14) }
@str_16 = global [4 x i8] c"No\0A\00"
@str_obj_17 = constant { i8* } { [4 x i8]* getelementptr inbounds ([4 x i8], [4 x i8]* @str_16) }

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
	%0 = call i8* @malloc(i64 8)
	%1 = bitcast i8* %0 to %Main_struct*
	%2 = bitcast [1 x i8*]* @vtable_Main to i8*
	%3 = getelementptr %Main_struct, %Main_struct* %1, i32 0, i32 0
	store i8* %2, i8** %3
	%4 = call %ObjectStruct* @Main_main(%Main_struct* %1)
	ret i32 0
}

define %ArraySet_struct* @ArraySet_init_set(%ArraySet_struct* %self) {
entry:
	%0 = alloca %ArraySet_struct*
	store %ArraySet_struct* %self, %ArraySet_struct** %0
	%1 = load %ArraySet_struct*, %ArraySet_struct** %0
	%2 = bitcast %ArraySet_struct* %1 to %ArraySet_struct*
	%3 = alloca %ArraySet_struct*
	store %ArraySet_struct* %2, %ArraySet_struct** %3
	%4 = call i8* @malloc(i64 16)
	%5 = bitcast i8* %4 to %IntStruct*
	%6 = getelementptr %IntStruct, %IntStruct* %5, i32 0, i32 1
	store i32 10, i32* %6
	%7 = load %ArraySet_struct*, %ArraySet_struct** %3
	%8 = getelementptr %IntStruct*, %ArraySet_struct* %7, i32 3
	store %IntStruct* %5, %IntStruct** %8
	%9 = call i8* @malloc(i64 16)
	%10 = bitcast i8* %9 to %IntStruct*
	%11 = getelementptr %IntStruct, %IntStruct* %10, i32 0, i32 1
	store i32 0, i32* %11
	%12 = load %ArraySet_struct*, %ArraySet_struct** %3
	%13 = getelementptr %IntStruct*, %ArraySet_struct* %12, i32 2
	store %IntStruct* %10, %IntStruct** %13
	%14 = call i8* @malloc(i64 24)
	%15 = bitcast i8* %14 to %ArrayStruct*
	%16 = mul i64 8, 8
	%17 = call i8* @malloc(i64 %16)
	%18 = getelementptr %ArrayStruct, %ArrayStruct* %15, i32 0, i32 1
	store i64 0, i64* %18
	%19 = getelementptr %ArrayStruct, %ArrayStruct* %15, i32 0, i32 2
	store i8* %17, i8** %19
	%20 = bitcast [7 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_Array to i8*
	%21 = getelementptr %ArrayStruct, %ArrayStruct* %15, i32 0, i32 0
	store i8* %20, i8** %21
	%22 = load %ArraySet_struct*, %ArraySet_struct** %3
	%23 = getelementptr %ArrayStruct*, %ArraySet_struct* %22, i32 1
	store %ArrayStruct* %15, %ArrayStruct** %23
	%24 = load %ArraySet_struct*, %ArraySet_struct** %3
	%25 = bitcast %ArraySet_struct* %24 to %ArraySet_struct*
	%26 = getelementptr %ArraySet_struct, %ArraySet_struct* %25, i32 0, i32 1
	%27 = load i8*, i8** %26
	%28 = bitcast i8* %27 to %ObjectStruct*
	%29 = load %ArraySet_struct*, %ArraySet_struct** %3
	%30 = bitcast %ArraySet_struct* %29 to %ArraySet_struct*
	%31 = getelementptr %ArraySet_struct, %ArraySet_struct* %30, i32 0, i32 3
	%32 = load %IntStruct*, %IntStruct** %31
	%33 = load %ArraySet_struct*, %ArraySet_struct** %3
	ret %ArraySet_struct* %33
}

define %BoolStruct* @ArraySet_contains(%ArraySet_struct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %ArraySet_struct*
	store %ArraySet_struct* %self, %ArraySet_struct** %0
	%1 = load %ArraySet_struct*, %ArraySet_struct** %0
	%2 = bitcast %ArraySet_struct* %1 to %ArraySet_struct*
	%3 = alloca %ArraySet_struct*
	store %ArraySet_struct* %2, %ArraySet_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = alloca %IntStruct*
	%6 = call i8* @malloc(i64 16)
	%7 = bitcast i8* %6 to %IntStruct*
	%8 = getelementptr %IntStruct, %IntStruct* %7, i32 0, i32 1
	store i32 0, i32* %8
	store %IntStruct* %7, %IntStruct** %5
	%9 = alloca %BoolStruct*
	%10 = call i8* @malloc(i64 16)
	%11 = bitcast i8* %10 to %BoolStruct*
	%12 = getelementptr %BoolStruct, %BoolStruct* %11, i32 0, i32 1
	store i1 false, i1* %12
	store %BoolStruct* %11, %BoolStruct** %9
	br label %while_cond_0

while_cond_0:
	%13 = load %IntStruct*, %IntStruct** %5
	%14 = load %ArraySet_struct*, %ArraySet_struct** %3
	%15 = bitcast %ArraySet_struct* %14 to %ArraySet_struct*
	%16 = getelementptr %ArraySet_struct, %ArraySet_struct* %15, i32 0, i32 2
	%17 = load %IntStruct*, %IntStruct** %16
	%18 = getelementptr %IntStruct, %IntStruct* %13, i32 0, i32 1
	%19 = load i32, i32* %18
	%20 = getelementptr %IntStruct, %IntStruct* %17, i32 0, i32 1
	%21 = load i32, i32* %20
	%22 = icmp slt i32 %19, %21
	%23 = call i8* @malloc(i64 16)
	%24 = bitcast i8* %23 to %BoolStruct*
	%25 = getelementptr %BoolStruct, %BoolStruct* %24, i32 0, i32 1
	store i1 %22, i1* %25
	%26 = getelementptr %BoolStruct, %BoolStruct* %24, i32 0, i32 1
	%27 = load i1, i1* %26
	%28 = icmp ne i1 %27, false
	br i1 %28, label %while_body_1, label %while_end_2

while_body_1:
	%29 = load %ArraySet_struct*, %ArraySet_struct** %3
	%30 = bitcast %ArraySet_struct* %29 to %ArraySet_struct*
	%31 = getelementptr %ArraySet_struct, %ArraySet_struct* %30, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = bitcast i8* %32 to %ObjectStruct*
	%34 = load %IntStruct*, %IntStruct** %5
	%35 = load %IntStruct*, %IntStruct** %4
	%36 = icmp eq i8* null, %35
	%37 = call i8* @malloc(i64 16)
	%38 = bitcast i8* %37 to %BoolStruct*
	%39 = getelementptr %BoolStruct, %BoolStruct* %38, i32 0, i32 1
	store i1 %36, i1* %39
	%40 = getelementptr %BoolStruct, %BoolStruct* %38, i32 0, i32 1
	%41 = load i1, i1* %40
	%42 = icmp ne i1 %41, false
	br i1 %42, label %if_then_3, label %if_else_4

while_end_2:
	%43 = load %BoolStruct*, %BoolStruct** %9
	ret %BoolStruct* %43

if_then_3:
	%44 = call i8* @malloc(i64 16)
	%45 = bitcast i8* %44 to %BoolStruct*
	%46 = getelementptr %BoolStruct, %BoolStruct* %45, i32 0, i32 1
	store i1 true, i1* %46
	store %BoolStruct* %45, %BoolStruct** %9
	%47 = load %ArraySet_struct*, %ArraySet_struct** %3
	%48 = bitcast %ArraySet_struct* %47 to %ArraySet_struct*
	%49 = getelementptr %ArraySet_struct, %ArraySet_struct* %48, i32 0, i32 2
	%50 = load %IntStruct*, %IntStruct** %49
	store %IntStruct* %50, %IntStruct** %5
	br label %if_end_5

if_else_4:
	%51 = load %IntStruct*, %IntStruct** %5
	%52 = call i8* @malloc(i64 16)
	%53 = bitcast i8* %52 to %IntStruct*
	%54 = getelementptr %IntStruct, %IntStruct* %53, i32 0, i32 1
	store i32 1, i32* %54
	%55 = getelementptr %IntStruct, %IntStruct* %51, i32 0, i32 1
	%56 = load i32, i32* %55
	%57 = getelementptr %IntStruct, %IntStruct* %53, i32 0, i32 1
	%58 = load i32, i32* %57
	%59 = add i32 %56, %58
	%60 = call i8* @malloc(i64 16)
	%61 = bitcast i8* %60 to %IntStruct*
	%62 = getelementptr %IntStruct, %IntStruct* %61, i32 0, i32 1
	store i32 %59, i32* %62
	store %IntStruct* %61, %IntStruct** %5
	br label %if_end_5

if_end_5:
	%63 = phi %IntStruct* [ %50, %if_then_3 ], [ %61, %if_else_4 ]
	br label %while_cond_0
}

define %ArraySet_struct* @ArraySet_insert(%ArraySet_struct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %ArraySet_struct*
	store %ArraySet_struct* %self, %ArraySet_struct** %0
	%1 = load %ArraySet_struct*, %ArraySet_struct** %0
	%2 = bitcast %ArraySet_struct* %1 to %ArraySet_struct*
	%3 = alloca %ArraySet_struct*
	store %ArraySet_struct* %2, %ArraySet_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = load %ArraySet_struct*, %ArraySet_struct** %3
	%6 = load %IntStruct*, %IntStruct** %4
	%7 = call %BoolStruct* @ArraySet_contains(%ArraySet_struct* %5, %IntStruct* %6)
	%8 = getelementptr %BoolStruct, %BoolStruct* %7, i32 0, i32 1
	%9 = load i1, i1* %8
	%10 = xor i1 %9, true
	%11 = call i8* @malloc(i64 16)
	%12 = bitcast i8* %11 to %BoolStruct*
	%13 = getelementptr %BoolStruct, %BoolStruct* %12, i32 0, i32 1
	store i1 %10, i1* %13
	%14 = getelementptr %BoolStruct, %BoolStruct* %12, i32 0, i32 1
	%15 = load i1, i1* %14
	%16 = icmp ne i1 %15, false
	br i1 %16, label %if_then_6, label %if_else_7

if_then_6:
	%17 = load %ArraySet_struct*, %ArraySet_struct** %3
	%18 = bitcast %ArraySet_struct* %17 to %ArraySet_struct*
	%19 = getelementptr %ArraySet_struct, %ArraySet_struct* %18, i32 0, i32 2
	%20 = load %IntStruct*, %IntStruct** %19
	%21 = load %ArraySet_struct*, %ArraySet_struct** %3
	%22 = bitcast %ArraySet_struct* %21 to %ArraySet_struct*
	%23 = getelementptr %ArraySet_struct, %ArraySet_struct* %22, i32 0, i32 3
	%24 = load %IntStruct*, %IntStruct** %23
	%25 = getelementptr %IntStruct, %IntStruct* %20, i32 0, i32 1
	%26 = load i32, i32* %25
	%27 = getelementptr %IntStruct, %IntStruct* %24, i32 0, i32 1
	%28 = load i32, i32* %27
	%29 = icmp eq i32 %26, %28
	%30 = call i8* @malloc(i64 16)
	%31 = bitcast i8* %30 to %BoolStruct*
	%32 = getelementptr %BoolStruct, %BoolStruct* %31, i32 0, i32 1
	store i1 %29, i1* %32
	%33 = getelementptr %BoolStruct, %BoolStruct* %31, i32 0, i32 1
	%34 = load i1, i1* %33
	%35 = icmp ne i1 %34, false
	br i1 %35, label %if_then_9, label %if_else_10

if_else_7:
	br label %if_end_8

if_end_8:
	%36 = phi %IntStruct* [ %88, %if_then_6 ], [ null, %if_else_7 ]
	%37 = load %ArraySet_struct*, %ArraySet_struct** %3
	ret %ArraySet_struct* %37

if_then_9:
	%38 = load %ArraySet_struct*, %ArraySet_struct** %3
	%39 = bitcast %ArraySet_struct* %38 to %ArraySet_struct*
	%40 = getelementptr %ArraySet_struct, %ArraySet_struct* %39, i32 0, i32 3
	%41 = load %IntStruct*, %IntStruct** %40
	%42 = call i8* @malloc(i64 16)
	%43 = bitcast i8* %42 to %IntStruct*
	%44 = getelementptr %IntStruct, %IntStruct* %43, i32 0, i32 1
	store i32 2, i32* %44
	%45 = getelementptr %IntStruct, %IntStruct* %41, i32 0, i32 1
	%46 = load i32, i32* %45
	%47 = getelementptr %IntStruct, %IntStruct* %43, i32 0, i32 1
	%48 = load i32, i32* %47
	%49 = mul i32 %46, %48
	%50 = call i8* @malloc(i64 16)
	%51 = bitcast i8* %50 to %IntStruct*
	%52 = getelementptr %IntStruct, %IntStruct* %51, i32 0, i32 1
	store i32 %49, i32* %52
	%53 = load %ArraySet_struct*, %ArraySet_struct** %3
	%54 = getelementptr %IntStruct*, %ArraySet_struct* %53, i32 3
	store %IntStruct* %51, %IntStruct** %54
	%55 = load %ArraySet_struct*, %ArraySet_struct** %3
	%56 = bitcast %ArraySet_struct* %55 to %ArraySet_struct*
	%57 = getelementptr %ArraySet_struct, %ArraySet_struct* %56, i32 0, i32 1
	%58 = load i8*, i8** %57
	%59 = bitcast i8* %58 to %ObjectStruct*
	%60 = load %ArraySet_struct*, %ArraySet_struct** %3
	%61 = bitcast %ArraySet_struct* %60 to %ArraySet_struct*
	%62 = getelementptr %ArraySet_struct, %ArraySet_struct* %61, i32 0, i32 3
	%63 = load %IntStruct*, %IntStruct** %62
	br label %if_end_11

if_else_10:
	br label %if_end_11

if_end_11:
	%64 = phi i8* [ null, %if_then_9 ], [ null, %if_else_10 ]
	%65 = load %ArraySet_struct*, %ArraySet_struct** %3
	%66 = bitcast %ArraySet_struct* %65 to %ArraySet_struct*
	%67 = getelementptr %ArraySet_struct, %ArraySet_struct* %66, i32 0, i32 1
	%68 = load i8*, i8** %67
	%69 = bitcast i8* %68 to %ObjectStruct*
	%70 = load %ArraySet_struct*, %ArraySet_struct** %3
	%71 = bitcast %ArraySet_struct* %70 to %ArraySet_struct*
	%72 = getelementptr %ArraySet_struct, %ArraySet_struct* %71, i32 0, i32 2
	%73 = load %IntStruct*, %IntStruct** %72
	%74 = load %IntStruct*, %IntStruct** %4
	%75 = load %ArraySet_struct*, %ArraySet_struct** %3
	%76 = bitcast %ArraySet_struct* %75 to %ArraySet_struct*
	%77 = getelementptr %ArraySet_struct, %ArraySet_struct* %76, i32 0, i32 2
	%78 = load %IntStruct*, %IntStruct** %77
	%79 = call i8* @malloc(i64 16)
	%80 = bitcast i8* %79 to %IntStruct*
	%81 = getelementptr %IntStruct, %IntStruct* %80, i32 0, i32 1
	store i32 1, i32* %81
	%82 = getelementptr %IntStruct, %IntStruct* %78, i32 0, i32 1
	%83 = load i32, i32* %82
	%84 = getelementptr %IntStruct, %IntStruct* %80, i32 0, i32 1
	%85 = load i32, i32* %84
	%86 = add i32 %83, %85
	%87 = call i8* @malloc(i64 16)
	%88 = bitcast i8* %87 to %IntStruct*
	%89 = getelementptr %IntStruct, %IntStruct* %88, i32 0, i32 1
	store i32 %86, i32* %89
	%90 = load %ArraySet_struct*, %ArraySet_struct** %3
	%91 = getelementptr %IntStruct*, %ArraySet_struct* %90, i32 2
	store %IntStruct* %88, %IntStruct** %91
	br label %if_end_8
}

define %ArraySet_struct* @ArraySet_delete(%ArraySet_struct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %ArraySet_struct*
	store %ArraySet_struct* %self, %ArraySet_struct** %0
	%1 = load %ArraySet_struct*, %ArraySet_struct** %0
	%2 = bitcast %ArraySet_struct* %1 to %ArraySet_struct*
	%3 = alloca %ArraySet_struct*
	store %ArraySet_struct* %2, %ArraySet_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = alloca %IntStruct*
	%6 = call i8* @malloc(i64 16)
	%7 = bitcast i8* %6 to %IntStruct*
	%8 = getelementptr %IntStruct, %IntStruct* %7, i32 0, i32 1
	store i32 0, i32* %8
	store %IntStruct* %7, %IntStruct** %5
	br label %while_cond_12

while_cond_12:
	%9 = load %IntStruct*, %IntStruct** %5
	%10 = load %ArraySet_struct*, %ArraySet_struct** %3
	%11 = bitcast %ArraySet_struct* %10 to %ArraySet_struct*
	%12 = getelementptr %ArraySet_struct, %ArraySet_struct* %11, i32 0, i32 2
	%13 = load %IntStruct*, %IntStruct** %12
	%14 = getelementptr %IntStruct, %IntStruct* %9, i32 0, i32 1
	%15 = load i32, i32* %14
	%16 = getelementptr %IntStruct, %IntStruct* %13, i32 0, i32 1
	%17 = load i32, i32* %16
	%18 = icmp slt i32 %15, %17
	%19 = call i8* @malloc(i64 16)
	%20 = bitcast i8* %19 to %BoolStruct*
	%21 = getelementptr %BoolStruct, %BoolStruct* %20, i32 0, i32 1
	store i1 %18, i1* %21
	%22 = getelementptr %BoolStruct, %BoolStruct* %20, i32 0, i32 1
	%23 = load i1, i1* %22
	%24 = icmp ne i1 %23, false
	br i1 %24, label %while_body_13, label %while_end_14

while_body_13:
	%25 = load %ArraySet_struct*, %ArraySet_struct** %3
	%26 = bitcast %ArraySet_struct* %25 to %ArraySet_struct*
	%27 = getelementptr %ArraySet_struct, %ArraySet_struct* %26, i32 0, i32 1
	%28 = load i8*, i8** %27
	%29 = bitcast i8* %28 to %ObjectStruct*
	%30 = load %IntStruct*, %IntStruct** %5
	%31 = load %IntStruct*, %IntStruct** %4
	%32 = icmp eq i8* null, %31
	%33 = call i8* @malloc(i64 16)
	%34 = bitcast i8* %33 to %BoolStruct*
	%35 = getelementptr %BoolStruct, %BoolStruct* %34, i32 0, i32 1
	store i1 %32, i1* %35
	%36 = getelementptr %BoolStruct, %BoolStruct* %34, i32 0, i32 1
	%37 = load i1, i1* %36
	%38 = icmp ne i1 %37, false
	br i1 %38, label %if_then_15, label %if_else_16

while_end_14:
	%39 = load %ArraySet_struct*, %ArraySet_struct** %3
	ret %ArraySet_struct* %39

if_then_15:
	%40 = alloca %IntStruct*
	%41 = load %IntStruct*, %IntStruct** %5
	store %IntStruct* %41, %IntStruct** %40
	br label %while_cond_18

if_else_16:
	%42 = load %IntStruct*, %IntStruct** %5
	%43 = call i8* @malloc(i64 16)
	%44 = bitcast i8* %43 to %IntStruct*
	%45 = getelementptr %IntStruct, %IntStruct* %44, i32 0, i32 1
	store i32 1, i32* %45
	%46 = getelementptr %IntStruct, %IntStruct* %42, i32 0, i32 1
	%47 = load i32, i32* %46
	%48 = getelementptr %IntStruct, %IntStruct* %44, i32 0, i32 1
	%49 = load i32, i32* %48
	%50 = add i32 %47, %49
	%51 = call i8* @malloc(i64 16)
	%52 = bitcast i8* %51 to %IntStruct*
	%53 = getelementptr %IntStruct, %IntStruct* %52, i32 0, i32 1
	store i32 %50, i32* %53
	store %IntStruct* %52, %IntStruct** %5
	br label %if_end_17

if_end_17:
	%54 = phi %IntStruct* [ %137, %if_then_15 ], [ %52, %if_else_16 ]
	br label %while_cond_12

while_cond_18:
	%55 = load %IntStruct*, %IntStruct** %40
	%56 = load %ArraySet_struct*, %ArraySet_struct** %3
	%57 = bitcast %ArraySet_struct* %56 to %ArraySet_struct*
	%58 = getelementptr %ArraySet_struct, %ArraySet_struct* %57, i32 0, i32 2
	%59 = load %IntStruct*, %IntStruct** %58
	%60 = call i8* @malloc(i64 16)
	%61 = bitcast i8* %60 to %IntStruct*
	%62 = getelementptr %IntStruct, %IntStruct* %61, i32 0, i32 1
	store i32 1, i32* %62
	%63 = getelementptr %IntStruct, %IntStruct* %59, i32 0, i32 1
	%64 = load i32, i32* %63
	%65 = getelementptr %IntStruct, %IntStruct* %61, i32 0, i32 1
	%66 = load i32, i32* %65
	%67 = sub i32 %64, %66
	%68 = call i8* @malloc(i64 16)
	%69 = bitcast i8* %68 to %IntStruct*
	%70 = getelementptr %IntStruct, %IntStruct* %69, i32 0, i32 1
	store i32 %67, i32* %70
	%71 = getelementptr %IntStruct, %IntStruct* %55, i32 0, i32 1
	%72 = load i32, i32* %71
	%73 = getelementptr %IntStruct, %IntStruct* %69, i32 0, i32 1
	%74 = load i32, i32* %73
	%75 = icmp slt i32 %72, %74
	%76 = call i8* @malloc(i64 16)
	%77 = bitcast i8* %76 to %BoolStruct*
	%78 = getelementptr %BoolStruct, %BoolStruct* %77, i32 0, i32 1
	store i1 %75, i1* %78
	%79 = getelementptr %BoolStruct, %BoolStruct* %77, i32 0, i32 1
	%80 = load i1, i1* %79
	%81 = icmp ne i1 %80, false
	br i1 %81, label %while_body_19, label %while_end_20

while_body_19:
	%82 = load %ArraySet_struct*, %ArraySet_struct** %3
	%83 = bitcast %ArraySet_struct* %82 to %ArraySet_struct*
	%84 = getelementptr %ArraySet_struct, %ArraySet_struct* %83, i32 0, i32 1
	%85 = load i8*, i8** %84
	%86 = bitcast i8* %85 to %ObjectStruct*
	%87 = load %IntStruct*, %IntStruct** %40
	%88 = load %ArraySet_struct*, %ArraySet_struct** %3
	%89 = bitcast %ArraySet_struct* %88 to %ArraySet_struct*
	%90 = getelementptr %ArraySet_struct, %ArraySet_struct* %89, i32 0, i32 1
	%91 = load i8*, i8** %90
	%92 = bitcast i8* %91 to %ObjectStruct*
	%93 = load %IntStruct*, %IntStruct** %40
	%94 = call i8* @malloc(i64 16)
	%95 = bitcast i8* %94 to %IntStruct*
	%96 = getelementptr %IntStruct, %IntStruct* %95, i32 0, i32 1
	store i32 1, i32* %96
	%97 = getelementptr %IntStruct, %IntStruct* %93, i32 0, i32 1
	%98 = load i32, i32* %97
	%99 = getelementptr %IntStruct, %IntStruct* %95, i32 0, i32 1
	%100 = load i32, i32* %99
	%101 = add i32 %98, %100
	%102 = call i8* @malloc(i64 16)
	%103 = bitcast i8* %102 to %IntStruct*
	%104 = getelementptr %IntStruct, %IntStruct* %103, i32 0, i32 1
	store i32 %101, i32* %104
	%105 = load %IntStruct*, %IntStruct** %40
	%106 = call i8* @malloc(i64 16)
	%107 = bitcast i8* %106 to %IntStruct*
	%108 = getelementptr %IntStruct, %IntStruct* %107, i32 0, i32 1
	store i32 1, i32* %108
	%109 = getelementptr %IntStruct, %IntStruct* %105, i32 0, i32 1
	%110 = load i32, i32* %109
	%111 = getelementptr %IntStruct, %IntStruct* %107, i32 0, i32 1
	%112 = load i32, i32* %111
	%113 = add i32 %110, %112
	%114 = call i8* @malloc(i64 16)
	%115 = bitcast i8* %114 to %IntStruct*
	%116 = getelementptr %IntStruct, %IntStruct* %115, i32 0, i32 1
	store i32 %113, i32* %116
	store %IntStruct* %115, %IntStruct** %40
	br label %while_cond_18

while_end_20:
	%117 = load %ArraySet_struct*, %ArraySet_struct** %3
	%118 = bitcast %ArraySet_struct* %117 to %ArraySet_struct*
	%119 = getelementptr %ArraySet_struct, %ArraySet_struct* %118, i32 0, i32 2
	%120 = load %IntStruct*, %IntStruct** %119
	%121 = call i8* @malloc(i64 16)
	%122 = bitcast i8* %121 to %IntStruct*
	%123 = getelementptr %IntStruct, %IntStruct* %122, i32 0, i32 1
	store i32 1, i32* %123
	%124 = getelementptr %IntStruct, %IntStruct* %120, i32 0, i32 1
	%125 = load i32, i32* %124
	%126 = getelementptr %IntStruct, %IntStruct* %122, i32 0, i32 1
	%127 = load i32, i32* %126
	%128 = sub i32 %125, %127
	%129 = call i8* @malloc(i64 16)
	%130 = bitcast i8* %129 to %IntStruct*
	%131 = getelementptr %IntStruct, %IntStruct* %130, i32 0, i32 1
	store i32 %128, i32* %131
	%132 = load %ArraySet_struct*, %ArraySet_struct** %3
	%133 = getelementptr %IntStruct*, %ArraySet_struct* %132, i32 2
	store %IntStruct* %130, %IntStruct** %133
	%134 = load %ArraySet_struct*, %ArraySet_struct** %3
	%135 = bitcast %ArraySet_struct* %134 to %ArraySet_struct*
	%136 = getelementptr %ArraySet_struct, %ArraySet_struct* %135, i32 0, i32 2
	%137 = load %IntStruct*, %IntStruct** %136
	store %IntStruct* %137, %IntStruct** %5
	br label %if_end_17
}

define %ArraySet_struct* @ArraySet_print_set(%ArraySet_struct* %self) {
entry:
	%0 = alloca %ArraySet_struct*
	store %ArraySet_struct* %self, %ArraySet_struct** %0
	%1 = load %ArraySet_struct*, %ArraySet_struct** %0
	%2 = bitcast %ArraySet_struct* %1 to %ArraySet_struct*
	%3 = alloca %ArraySet_struct*
	store %ArraySet_struct* %2, %ArraySet_struct** %3
	%4 = alloca %IntStruct*
	%5 = call i8* @malloc(i64 16)
	%6 = bitcast i8* %5 to %IntStruct*
	%7 = getelementptr %IntStruct, %IntStruct* %6, i32 0, i32 1
	store i32 0, i32* %7
	store %IntStruct* %6, %IntStruct** %4
	%8 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*), i32 0, i32 0
	%9 = load i8*, i8** %8
	%10 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%11 = call i32 (i8*, ...) @printf(i8* %10, i8* %9)
	%12 = load %ArraySet_struct*, %ArraySet_struct** %3
	br label %while_cond_21

while_cond_21:
	%13 = load %IntStruct*, %IntStruct** %4
	%14 = load %ArraySet_struct*, %ArraySet_struct** %3
	%15 = bitcast %ArraySet_struct* %14 to %ArraySet_struct*
	%16 = getelementptr %ArraySet_struct, %ArraySet_struct* %15, i32 0, i32 2
	%17 = load %IntStruct*, %IntStruct** %16
	%18 = getelementptr %IntStruct, %IntStruct* %13, i32 0, i32 1
	%19 = load i32, i32* %18
	%20 = getelementptr %IntStruct, %IntStruct* %17, i32 0, i32 1
	%21 = load i32, i32* %20
	%22 = icmp slt i32 %19, %21
	%23 = call i8* @malloc(i64 16)
	%24 = bitcast i8* %23 to %BoolStruct*
	%25 = getelementptr %BoolStruct, %BoolStruct* %24, i32 0, i32 1
	store i1 %22, i1* %25
	%26 = getelementptr %BoolStruct, %BoolStruct* %24, i32 0, i32 1
	%27 = load i1, i1* %26
	%28 = icmp ne i1 %27, false
	br i1 %28, label %while_body_22, label %while_end_23

while_body_22:
	%29 = load %IntStruct*, %IntStruct** %4
	%30 = getelementptr %IntStruct, %IntStruct* %29, i32 0, i32 1
	%31 = load i32, i32* %30
	%32 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%33 = call i32 (i8*, ...) @printf(i8* %32, i32 %31)
	%34 = load %ArraySet_struct*, %ArraySet_struct** %3
	%35 = load %ArraySet_struct*, %ArraySet_struct** %3
	%36 = bitcast %ArraySet_struct* %35 to %ArraySet_struct*
	%37 = getelementptr %ArraySet_struct, %ArraySet_struct* %36, i32 0, i32 1
	%38 = load i8*, i8** %37
	%39 = bitcast i8* %38 to %ObjectStruct*
	%40 = load %IntStruct*, %IntStruct** %4
	%41 = load %ArraySet_struct*, %ArraySet_struct** %3
	%42 = getelementptr i8*, %ArraySet_struct* %41, i32 4
	store i8* null, i8** %42
	%43 = load %ArraySet_struct*, %ArraySet_struct** %3
	%44 = bitcast %ArraySet_struct* %43 to %ArraySet_struct*
	%45 = getelementptr %ArraySet_struct, %ArraySet_struct* %44, i32 0, i32 4
	%46 = load %IntStruct*, %IntStruct** %45
	%47 = getelementptr %IntStruct, %IntStruct* %46, i32 0, i32 1
	%48 = load i32, i32* %47
	%49 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%50 = call i32 (i8*, ...) @printf(i8* %49, i32 %48)
	%51 = load %ArraySet_struct*, %ArraySet_struct** %3
	%52 = load %IntStruct*, %IntStruct** %4
	%53 = getelementptr %IntStruct, %IntStruct* %52, i32 0, i32 1
	%54 = load i32, i32* %53
	%55 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%56 = call i32 (i8*, ...) @printf(i8* %55, i32 %54)
	%57 = load %ArraySet_struct*, %ArraySet_struct** %3
	%58 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%59 = load i8*, i8** %58
	%60 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%61 = call i32 (i8*, ...) @printf(i8* %60, i8* %59)
	%62 = load %ArraySet_struct*, %ArraySet_struct** %3
	%63 = load %IntStruct*, %IntStruct** %4
	%64 = call i8* @malloc(i64 16)
	%65 = bitcast i8* %64 to %IntStruct*
	%66 = getelementptr %IntStruct, %IntStruct* %65, i32 0, i32 1
	store i32 1, i32* %66
	%67 = getelementptr %IntStruct, %IntStruct* %63, i32 0, i32 1
	%68 = load i32, i32* %67
	%69 = getelementptr %IntStruct, %IntStruct* %65, i32 0, i32 1
	%70 = load i32, i32* %69
	%71 = add i32 %68, %70
	%72 = call i8* @malloc(i64 16)
	%73 = bitcast i8* %72 to %IntStruct*
	%74 = getelementptr %IntStruct, %IntStruct* %73, i32 0, i32 1
	store i32 %71, i32* %74
	store %IntStruct* %73, %IntStruct** %4
	br label %while_cond_21

while_end_23:
	%75 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%76 = load i8*, i8** %75
	%77 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%78 = call i32 (i8*, ...) @printf(i8* %77, i8* %76)
	%79 = load %ArraySet_struct*, %ArraySet_struct** %3
	%80 = load %ArraySet_struct*, %ArraySet_struct** %3
	ret %ArraySet_struct* %80
}

define %ObjectStruct* @Main_main(%Main_struct* %self) {
entry:
	%0 = alloca %Main_struct*
	store %Main_struct* %self, %Main_struct** %0
	%1 = load %Main_struct*, %Main_struct** %0
	%2 = bitcast %Main_struct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = alloca %ArraySet_struct*
	%5 = call i8* @malloc(i64 40)
	%6 = bitcast i8* %5 to %ArraySet_struct*
	%7 = getelementptr %ArraySet_struct, %ArraySet_struct* %6, i32 0, i32 0
	store i8* bitcast ([5 x i8*]* bitcast ([5 x i8*]* @vtable_ArraySet to [5 x i8*]*) to i8*), i8** %7
	store %ArraySet_struct* %6, %ArraySet_struct** %4
	%8 = load %ArraySet_struct*, %ArraySet_struct** %4
	%9 = bitcast %ArraySet_struct* %8 to %ObjectStruct*
	%10 = bitcast %ObjectStruct* %9 to %ArraySet_struct*
	%11 = getelementptr %ArraySet_struct, %ArraySet_struct* %10, i32 0, i32 0
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%14 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %13, i32 0, i32 0
	%15 = load i8*, %ObjectStruct* (%ObjectStruct*)** %14
	%16 = bitcast i8* %15 to %ArraySet_struct* (%ArraySet_struct*)*
	%17 = call %ArraySet_struct* %16(%ObjectStruct* %9)
	%18 = load %ArraySet_struct*, %ArraySet_struct** %4
	%19 = bitcast %ArraySet_struct* %18 to %ObjectStruct*
	%20 = call i8* @malloc(i64 16)
	%21 = bitcast i8* %20 to %IntStruct*
	%22 = getelementptr %IntStruct, %IntStruct* %21, i32 0, i32 1
	store i32 10, i32* %22
	%23 = bitcast %ObjectStruct* %19 to %ArraySet_struct*
	%24 = getelementptr %ArraySet_struct, %ArraySet_struct* %23, i32 0, i32 0
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%27 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %26, i32 0, i32 2
	%28 = load i8*, %ObjectStruct* (%ObjectStruct*)** %27
	%29 = bitcast i8* %28 to %ArraySet_struct* (%ArraySet_struct*, %IntStruct*)*
	%30 = call %ArraySet_struct* %29(%ObjectStruct* %19, %IntStruct* %21)
	%31 = load %ArraySet_struct*, %ArraySet_struct** %4
	%32 = bitcast %ArraySet_struct* %31 to %ObjectStruct*
	%33 = call i8* @malloc(i64 16)
	%34 = bitcast i8* %33 to %IntStruct*
	%35 = getelementptr %IntStruct, %IntStruct* %34, i32 0, i32 1
	store i32 20, i32* %35
	%36 = bitcast %ObjectStruct* %32 to %ArraySet_struct*
	%37 = getelementptr %ArraySet_struct, %ArraySet_struct* %36, i32 0, i32 0
	%38 = load i8*, i8** %37
	%39 = bitcast i8* %38 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%40 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %39, i32 0, i32 2
	%41 = load i8*, %ObjectStruct* (%ObjectStruct*)** %40
	%42 = bitcast i8* %41 to %ArraySet_struct* (%ArraySet_struct*, %IntStruct*)*
	%43 = call %ArraySet_struct* %42(%ObjectStruct* %32, %IntStruct* %34)
	%44 = load %ArraySet_struct*, %ArraySet_struct** %4
	%45 = bitcast %ArraySet_struct* %44 to %ObjectStruct*
	%46 = call i8* @malloc(i64 16)
	%47 = bitcast i8* %46 to %IntStruct*
	%48 = getelementptr %IntStruct, %IntStruct* %47, i32 0, i32 1
	store i32 30, i32* %48
	%49 = bitcast %ObjectStruct* %45 to %ArraySet_struct*
	%50 = getelementptr %ArraySet_struct, %ArraySet_struct* %49, i32 0, i32 0
	%51 = load i8*, i8** %50
	%52 = bitcast i8* %51 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%53 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %52, i32 0, i32 2
	%54 = load i8*, %ObjectStruct* (%ObjectStruct*)** %53
	%55 = bitcast i8* %54 to %ArraySet_struct* (%ArraySet_struct*, %IntStruct*)*
	%56 = call %ArraySet_struct* %55(%ObjectStruct* %45, %IntStruct* %47)
	%57 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*), i32 0, i32 0
	%58 = load i8*, i8** %57
	%59 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%60 = call i32 (i8*, ...) @printf(i8* %59, i8* %58)
	%61 = load %Main_struct*, %Main_struct** %3
	%62 = load %ArraySet_struct*, %ArraySet_struct** %4
	%63 = bitcast %ArraySet_struct* %62 to %ObjectStruct*
	%64 = bitcast %ObjectStruct* %63 to %ArraySet_struct*
	%65 = getelementptr %ArraySet_struct, %ArraySet_struct* %64, i32 0, i32 0
	%66 = load i8*, i8** %65
	%67 = bitcast i8* %66 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%68 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %67, i32 0, i32 4
	%69 = load i8*, %ObjectStruct* (%ObjectStruct*)** %68
	%70 = bitcast i8* %69 to %ArraySet_struct* (%ArraySet_struct*)*
	%71 = call %ArraySet_struct* %70(%ObjectStruct* %63)
	%72 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_11 to %StringStruct*), i32 0, i32 0
	%73 = load i8*, i8** %72
	%74 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%75 = call i32 (i8*, ...) @printf(i8* %74, i8* %73)
	%76 = load %Main_struct*, %Main_struct** %3
	%77 = load %ArraySet_struct*, %ArraySet_struct** %4
	%78 = bitcast %ArraySet_struct* %77 to %ObjectStruct*
	%79 = call i8* @malloc(i64 16)
	%80 = bitcast i8* %79 to %IntStruct*
	%81 = getelementptr %IntStruct, %IntStruct* %80, i32 0, i32 1
	store i32 20, i32* %81
	%82 = bitcast %ObjectStruct* %78 to %ArraySet_struct*
	%83 = getelementptr %ArraySet_struct, %ArraySet_struct* %82, i32 0, i32 0
	%84 = load i8*, i8** %83
	%85 = bitcast i8* %84 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%86 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %85, i32 0, i32 3
	%87 = load i8*, %ObjectStruct* (%ObjectStruct*)** %86
	%88 = bitcast i8* %87 to %ArraySet_struct* (%ArraySet_struct*, %IntStruct*)*
	%89 = call %ArraySet_struct* %88(%ObjectStruct* %78, %IntStruct* %80)
	%90 = load %ArraySet_struct*, %ArraySet_struct** %4
	%91 = bitcast %ArraySet_struct* %90 to %ObjectStruct*
	%92 = bitcast %ObjectStruct* %91 to %ArraySet_struct*
	%93 = getelementptr %ArraySet_struct, %ArraySet_struct* %92, i32 0, i32 0
	%94 = load i8*, i8** %93
	%95 = bitcast i8* %94 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%96 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %95, i32 0, i32 4
	%97 = load i8*, %ObjectStruct* (%ObjectStruct*)** %96
	%98 = bitcast i8* %97 to %ArraySet_struct* (%ArraySet_struct*)*
	%99 = call %ArraySet_struct* %98(%ObjectStruct* %91)
	%100 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_13 to %StringStruct*), i32 0, i32 0
	%101 = load i8*, i8** %100
	%102 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%103 = call i32 (i8*, ...) @printf(i8* %102, i8* %101)
	%104 = load %Main_struct*, %Main_struct** %3
	%105 = load %ArraySet_struct*, %ArraySet_struct** %4
	%106 = bitcast %ArraySet_struct* %105 to %ObjectStruct*
	%107 = call i8* @malloc(i64 16)
	%108 = bitcast i8* %107 to %IntStruct*
	%109 = getelementptr %IntStruct, %IntStruct* %108, i32 0, i32 1
	store i32 20, i32* %109
	%110 = bitcast %ObjectStruct* %106 to %ArraySet_struct*
	%111 = getelementptr %ArraySet_struct, %ArraySet_struct* %110, i32 0, i32 0
	%112 = load i8*, i8** %111
	%113 = bitcast i8* %112 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%114 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %113, i32 0, i32 1
	%115 = load i8*, %ObjectStruct* (%ObjectStruct*)** %114
	%116 = bitcast i8* %115 to %BoolStruct* (%ArraySet_struct*, %IntStruct*)*
	%117 = call %BoolStruct* %116(%ObjectStruct* %106, %IntStruct* %108)
	%118 = getelementptr %BoolStruct, %BoolStruct* %117, i32 0, i32 1
	%119 = load i1, i1* %118
	%120 = icmp ne i1 %119, false
	br i1 %120, label %if_then_24, label %if_else_25

if_then_24:
	%121 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_15 to %StringStruct*), i32 0, i32 0
	%122 = load i8*, i8** %121
	%123 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%124 = call i32 (i8*, ...) @printf(i8* %123, i8* %122)
	%125 = load %Main_struct*, %Main_struct** %3
	br label %if_end_26

if_else_25:
	%126 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_17 to %StringStruct*), i32 0, i32 0
	%127 = load i8*, i8** %126
	%128 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%129 = call i32 (i8*, ...) @printf(i8* %128, i8* %127)
	%130 = load %Main_struct*, %Main_struct** %3
	br label %if_end_26

if_end_26:
	%131 = phi %Main_struct* [ %125, %if_then_24 ], [ %130, %if_else_25 ]
	%132 = load %Main_struct*, %Main_struct** %3
	%133 = bitcast %Main_struct* %132 to %ObjectStruct*
	ret %ObjectStruct* %133
}
