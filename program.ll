%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%ArrayStruct = type { i8*, i64, i8* }
%Main_struct = type { i8* }

@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@str_0 = global [7 x i8] c"String\00"
@str_obj_1 = constant { i8* } { i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_0, i32 0, i32 0) }
@str_2 = global [7 x i8] c"Object\00"
@str_obj_3 = constant { i8* } { i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_2, i32 0, i32 0) }
@vtable_Object = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Int = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null, %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%ObjectStruct*)* @Int_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_String = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%StringStruct*)* @String_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null]
@vtable_Bool = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null]
@vtable_IO = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %StringStruct*)* @IO_out_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %IntStruct*)* @IO_out_int to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%IOStruct*)* @IO_in_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%IOStruct*)* @IO_in_int to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Array = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%ObjectStruct*)* @Array_length to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* (%ObjectStruct*, i64)* @Array_get to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (void (%ObjectStruct*, i64, i8*)* @Array_set to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ArrayStruct* (%ObjectStruct*, i64)* @Array_resize to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%ObjectStruct* (%ObjectStruct*)* @Main_main to i8*)]
@str_4 = global [2 x i8] c"\0A\00"
@str_obj_5 = constant { i8* } { i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str_4, i32 0, i32 0) }

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

define %StringStruct* @String_type_name(%StringStruct* %self) {
entry:
	ret %StringStruct* bitcast ({ i8* }* @str_obj_1 to %StringStruct*)
}

declare void @exit(i32 %status)

define %ObjectStruct* @Object_abort(%ObjectStruct* %self) {
entry:
	call void @exit(i32 1)
	unreachable
}

define %StringStruct* @Object_type_name(%ObjectStruct* %self) {
entry:
	ret %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*)
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

define %IntStruct* @Int_copy(%ObjectStruct* %self) {
entry:
	%0 = bitcast %ObjectStruct* %self to %IntStruct*
	%1 = call i8* @malloc(i64 16)
	%2 = bitcast i8* %1 to %IntStruct*
	%3 = getelementptr %IntStruct, %IntStruct* %0, i32 0, i32 0
	%4 = load i8*, i8** %3
	%5 = getelementptr %IntStruct, %IntStruct* %2, i32 0, i32 0
	store i8* %4, i8** %5
	%6 = getelementptr %IntStruct, %IntStruct* %0, i32 0, i32 1
	%7 = load i32, i32* %6
	%8 = getelementptr %IntStruct, %IntStruct* %2, i32 0, i32 1
	store i32 %7, i32* %8
	ret %IntStruct* %2
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

define i8* @Array_get(%ObjectStruct* %self, i64 %index) {
entry:
	%0 = bitcast %ObjectStruct* %self to %ArrayStruct*
	%1 = getelementptr %ArrayStruct, %ArrayStruct* %0, i32 0, i32 1
	%2 = load i64, i64* %1
	%3 = icmp ult i64 %index, %2
	br i1 %3, label %valid, label %error

valid:
	%4 = getelementptr %ArrayStruct, %ArrayStruct* %0, i32 0, i32 2
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8**
	%7 = getelementptr i8*, i8** %6, i64 %index
	%8 = load i8*, i8** %7
	ret i8* %8

error:
	ret i8* null
}

define void @Array_set(%ObjectStruct* %self, i64 %index, i8* %value) {
entry:
	%0 = bitcast %ObjectStruct* %self to %ArrayStruct*
	%1 = getelementptr %ArrayStruct, %ArrayStruct* %0, i32 0, i32 1
	%2 = load i64, i64* %1
	%3 = icmp ult i64 %index, %2
	br i1 %3, label %valid, label %error

valid:
	%4 = getelementptr %ArrayStruct, %ArrayStruct* %0, i32 0, i32 2
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8**
	%7 = getelementptr i8*, i8** %6, i64 %index
	store i8* %value, i8** %7
	ret void

error:
	ret void
}

define %ArrayStruct* @Array_resize(%ObjectStruct* %self, i64 %new_size) {
entry:
	%0 = bitcast %ObjectStruct* %self to %ArrayStruct*
	%1 = mul i64 %new_size, 8
	%2 = call i8* @malloc(i64 %1)
	call void @llvm.memset.p0i8.i64(i8* %2, i8 0, i64 %1, i32 8, i1 false)
	%3 = getelementptr %ArrayStruct, %ArrayStruct* %0, i32 0, i32 2
	%4 = load i8*, i8** %3
	%5 = getelementptr %ArrayStruct, %ArrayStruct* %0, i32 0, i32 1
	%6 = load i64, i64* %5
	%7 = icmp ult i64 %6, %new_size
	%8 = select i1 %7, i64 %6, i64 %new_size
	%9 = mul i64 %8, 8
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* %2, i8* %4, i64 %9, i32 8, i1 false)
	store i8* %2, i8** %3
	store i64 %new_size, i64* %5
	ret %ArrayStruct* %0
}

define %IntStruct* @Array_length(%ObjectStruct* %self) {
entry:
	%0 = bitcast %ObjectStruct* %self to %ArrayStruct*
	%1 = getelementptr %ArrayStruct, %ArrayStruct* %0, i32 0, i32 1
	%2 = load i64, i64* %1
	%3 = trunc i64 %2 to i32
	%4 = call i8* @malloc(i64 16)
	%5 = bitcast i8* %4 to %IntStruct*
	%6 = getelementptr %IntStruct, %IntStruct* %5, i32 0, i32 1
	store i32 %3, i32* %6
	ret %IntStruct* %5
}

define i32 @main() {
entry:
	%0 = call i8* @malloc(i64 8)
	%1 = bitcast i8* %0 to %Main_struct*
	%2 = bitcast [1 x i8*]* @vtable_Main to i8*
	%3 = getelementptr %Main_struct, %Main_struct* %1, i32 0, i32 0
	store i8* %2, i8** %3
	%4 = bitcast %Main_struct* %1 to %ObjectStruct*
	%5 = call %ObjectStruct* @Main_main(%ObjectStruct* %4)
	ret i32 0
}

define %ObjectStruct* @Main_main(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = alloca %IntStruct*
	%5 = bitcast %IntStruct** null to %IntStruct*
	store %IntStruct* %5, %IntStruct** %4
	%6 = alloca %IntStruct*
	%7 = bitcast %IntStruct** null to %IntStruct*
	store %IntStruct* %7, %IntStruct** %6
	%8 = call i8* @malloc(i64 16)
	%9 = bitcast i8* %8 to %IntStruct*
	%10 = getelementptr %IntStruct, %IntStruct* %9, i32 0, i32 1
	store i32 1, i32* %10
	store %IntStruct* %9, %IntStruct** %4
	%11 = load %IntStruct*, %IntStruct** %4
	%12 = bitcast %IntStruct* %11 to %ObjectStruct*
	%13 = call %IntStruct* @Int_copy(%ObjectStruct* %12)
	store %IntStruct* %13, %IntStruct** %6
	%14 = load %IntStruct*, %IntStruct** %6
	%15 = getelementptr %IntStruct, %IntStruct* %14, i32 0, i32 1
	%16 = load i32, i32* %15
	%17 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%18 = call i32 (i8*, ...) @printf(i8* %17, i32 %16)
	%19 = load %Main_struct*, %Main_struct** %3
	%20 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%21 = load i8*, i8** %20
	%22 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%23 = call i32 (i8*, ...) @printf(i8* %22, i8* %21)
	%24 = load %Main_struct*, %Main_struct** %3
	%25 = call i8* @malloc(i64 16)
	%26 = bitcast i8* %25 to %IntStruct*
	%27 = getelementptr %IntStruct, %IntStruct* %26, i32 0, i32 1
	store i32 1, i32* %27
	%28 = getelementptr %IntStruct, %IntStruct* %26, i32 0, i32 1
	%29 = load i32, i32* %28
	%30 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%31 = call i32 (i8*, ...) @printf(i8* %30, i32 %29)
	%32 = load %Main_struct*, %Main_struct** %3
	%33 = bitcast %Main_struct* %32 to %ObjectStruct*
	ret %ObjectStruct* %33
}

define %StringStruct* @String_copy(%StringStruct* %self) {
entry:
	%0 = call i8* @malloc(i64 16)
	%1 = bitcast i8* %0 to %StringStruct*
	%2 = bitcast [3 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_String to i8*
	%3 = getelementptr %StringStruct, %StringStruct* %1, i32 0, i32 0
	store i8* %2, i8** %3
	%4 = getelementptr %StringStruct, %StringStruct* %self, i32 0, i32 0
	%5 = load i8*, i8** %4
	%6 = getelementptr %StringStruct, %StringStruct* %1, i32 0, i32 0
	store i8* %5, i8** %6
	ret %StringStruct* %1
}
