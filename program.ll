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
@str_0 = global [7 x i8] c"Object\00"
@str_obj_1 = constant { i8* } { [7 x i8]* getelementptr inbounds ([7 x i8], [7 x i8]* @str_0) }
@vtable_Object = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Int = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_String = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Bool = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_IO = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %StringStruct*)* @IO_out_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %IntStruct*)* @IO_out_int to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%IOStruct*)* @IO_in_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%IOStruct*)* @IO_in_int to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Array = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%ArrayStruct*)* @Array_length to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* (%ArrayStruct*, i64)* @Array_get to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (void (%ArrayStruct*, i64, i8*)* @Array_set to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ArrayStruct* (%ArrayStruct*, i64)* @Array_resize to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%ObjectStruct* (%Main_struct*)* @Main_main to i8*)]
@str_2 = global [17 x i8] c"Enter the size: \00"
@str_obj_3 = constant { i8* } { [17 x i8]* getelementptr inbounds ([17 x i8], [17 x i8]* @str_2) }
@str_4 = global [24 x i8] c"Enter number for index \00"
@str_obj_5 = constant { i8* } { [24 x i8]* getelementptr inbounds ([24 x i8], [24 x i8]* @str_4) }
@str_6 = global [3 x i8] c": \00"
@str_obj_7 = constant { i8* } { [3 x i8]* getelementptr inbounds ([3 x i8], [3 x i8]* @str_6) }
@str_8 = global [15 x i8] c"Sorted array: \00"
@str_obj_9 = constant { i8* } { [15 x i8]* getelementptr inbounds ([15 x i8], [15 x i8]* @str_8) }
@str_10 = global [2 x i8] c" \00"
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
	%0 = call i8* @malloc(i64 8)
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
	%4 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*), i32 0, i32 0
	%5 = load i8*, i8** %4
	%6 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%7 = call i32 (i8*, ...) @printf(i8* %6, i8* %5)
	%8 = load %Main_struct*, %Main_struct** %3
	%9 = alloca %IntStruct*
	%10 = alloca i32
	%11 = getelementptr [3 x i8], [3 x i8]* @fmt_int_in_3, i32 0, i32 0
	%12 = call i32 (i8*, ...) @scanf(i8* %11, i32* %10)
	%13 = load i32, i32* %10
	%14 = call i8* @malloc(i64 16)
	%15 = bitcast i8* %14 to %IntStruct*
	%16 = getelementptr %IntStruct, %IntStruct* %15, i32 0, i32 1
	store i32 %13, i32* %16
	store %IntStruct* %15, %IntStruct** %9
	%17 = alloca %ArrayStruct*
	%18 = call i8* @malloc(i64 24)
	%19 = bitcast i8* %18 to %ArrayStruct*
	%20 = mul i64 8, 8
	%21 = call i8* @malloc(i64 %20)
	%22 = getelementptr %ArrayStruct, %ArrayStruct* %19, i32 0, i32 1
	store i64 0, i64* %22
	%23 = getelementptr %ArrayStruct, %ArrayStruct* %19, i32 0, i32 2
	store i8* %21, i8** %23
	%24 = bitcast [7 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_Array to i8*
	%25 = getelementptr %ArrayStruct, %ArrayStruct* %19, i32 0, i32 0
	store i8* %24, i8** %25
	store %ArrayStruct* %19, %ArrayStruct** %17
	%26 = load %ArrayStruct*, %ArrayStruct** %17
	%27 = bitcast %ArrayStruct* %26 to %ObjectStruct*
	%28 = load %IntStruct*, %IntStruct** %9
	%29 = load %IntStruct*, %IntStruct** %9
	%30 = getelementptr %IntStruct, %IntStruct* %29, i32 0, i32 1
	%31 = load i32, i32* %30
	%32 = sext i32 %31 to i64
	%33 = call %ArrayStruct* @Array_resize(%ObjectStruct* %27, i64 %32)
	%34 = alloca %IntStruct*
	%35 = call i8* @malloc(i64 16)
	%36 = bitcast i8* %35 to %IntStruct*
	%37 = getelementptr %IntStruct, %IntStruct* %36, i32 0, i32 1
	store i32 0, i32* %37
	store %IntStruct* %36, %IntStruct** %34
	br label %while_cond_0

while_cond_0:
	%38 = load %IntStruct*, %IntStruct** %34
	%39 = load %IntStruct*, %IntStruct** %9
	%40 = getelementptr %IntStruct, %IntStruct* %38, i32 0, i32 1
	%41 = load i32, i32* %40
	%42 = getelementptr %IntStruct, %IntStruct* %39, i32 0, i32 1
	%43 = load i32, i32* %42
	%44 = icmp slt i32 %41, %43
	%45 = call i8* @malloc(i64 16)
	%46 = bitcast i8* %45 to %BoolStruct*
	%47 = getelementptr %BoolStruct, %BoolStruct* %46, i32 0, i32 1
	store i1 %44, i1* %47
	%48 = getelementptr %BoolStruct, %BoolStruct* %46, i32 0, i32 1
	%49 = load i1, i1* %48
	%50 = icmp ne i1 %49, false
	br i1 %50, label %while_body_1, label %while_end_2

while_body_1:
	%51 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%52 = load i8*, i8** %51
	%53 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%54 = call i32 (i8*, ...) @printf(i8* %53, i8* %52)
	%55 = load %Main_struct*, %Main_struct** %3
	%56 = load %IntStruct*, %IntStruct** %34
	%57 = getelementptr %IntStruct, %IntStruct* %56, i32 0, i32 1
	%58 = load i32, i32* %57
	%59 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%60 = call i32 (i8*, ...) @printf(i8* %59, i32 %58)
	%61 = load %Main_struct*, %Main_struct** %3
	%62 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%63 = load i8*, i8** %62
	%64 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%65 = call i32 (i8*, ...) @printf(i8* %64, i8* %63)
	%66 = load %Main_struct*, %Main_struct** %3
	%67 = alloca %IntStruct*
	%68 = alloca i32
	%69 = getelementptr [3 x i8], [3 x i8]* @fmt_int_in_3, i32 0, i32 0
	%70 = call i32 (i8*, ...) @scanf(i8* %69, i32* %68)
	%71 = load i32, i32* %68
	%72 = call i8* @malloc(i64 16)
	%73 = bitcast i8* %72 to %IntStruct*
	%74 = getelementptr %IntStruct, %IntStruct* %73, i32 0, i32 1
	store i32 %71, i32* %74
	store %IntStruct* %73, %IntStruct** %67
	%75 = load %ArrayStruct*, %ArrayStruct** %17
	%76 = bitcast %ArrayStruct* %75 to %ObjectStruct*
	%77 = load %IntStruct*, %IntStruct** %34
	%78 = load %IntStruct*, %IntStruct** %67
	%79 = load %IntStruct*, %IntStruct** %34
	%80 = getelementptr %IntStruct, %IntStruct* %79, i32 0, i32 1
	%81 = load i32, i32* %80
	%82 = sext i32 %81 to i64
	%83 = load %IntStruct*, %IntStruct** %67
	%84 = bitcast %IntStruct* %83 to i8*
	call void @Array_set(%ObjectStruct* %76, i64 %82, i8* %84)
	%85 = load %IntStruct*, %IntStruct** %34
	%86 = call i8* @malloc(i64 16)
	%87 = bitcast i8* %86 to %IntStruct*
	%88 = getelementptr %IntStruct, %IntStruct* %87, i32 0, i32 1
	store i32 1, i32* %88
	%89 = getelementptr %IntStruct, %IntStruct* %85, i32 0, i32 1
	%90 = load i32, i32* %89
	%91 = getelementptr %IntStruct, %IntStruct* %87, i32 0, i32 1
	%92 = load i32, i32* %91
	%93 = add i32 %90, %92
	%94 = call i8* @malloc(i64 16)
	%95 = bitcast i8* %94 to %IntStruct*
	%96 = getelementptr %IntStruct, %IntStruct* %95, i32 0, i32 1
	store i32 %93, i32* %96
	store %IntStruct* %95, %IntStruct** %34
	br label %while_cond_0

while_end_2:
	%97 = alloca %IntStruct*
	%98 = call i8* @malloc(i64 16)
	%99 = bitcast i8* %98 to %IntStruct*
	%100 = getelementptr %IntStruct, %IntStruct* %99, i32 0, i32 1
	store i32 0, i32* %100
	store %IntStruct* %99, %IntStruct** %97
	br label %while_cond_3

while_cond_3:
	%101 = load %IntStruct*, %IntStruct** %97
	%102 = load %IntStruct*, %IntStruct** %9
	%103 = call i8* @malloc(i64 16)
	%104 = bitcast i8* %103 to %IntStruct*
	%105 = getelementptr %IntStruct, %IntStruct* %104, i32 0, i32 1
	store i32 1, i32* %105
	%106 = getelementptr %IntStruct, %IntStruct* %102, i32 0, i32 1
	%107 = load i32, i32* %106
	%108 = getelementptr %IntStruct, %IntStruct* %104, i32 0, i32 1
	%109 = load i32, i32* %108
	%110 = sub i32 %107, %109
	%111 = call i8* @malloc(i64 16)
	%112 = bitcast i8* %111 to %IntStruct*
	%113 = getelementptr %IntStruct, %IntStruct* %112, i32 0, i32 1
	store i32 %110, i32* %113
	%114 = getelementptr %IntStruct, %IntStruct* %101, i32 0, i32 1
	%115 = load i32, i32* %114
	%116 = getelementptr %IntStruct, %IntStruct* %112, i32 0, i32 1
	%117 = load i32, i32* %116
	%118 = icmp slt i32 %115, %117
	%119 = call i8* @malloc(i64 16)
	%120 = bitcast i8* %119 to %BoolStruct*
	%121 = getelementptr %BoolStruct, %BoolStruct* %120, i32 0, i32 1
	store i1 %118, i1* %121
	%122 = getelementptr %BoolStruct, %BoolStruct* %120, i32 0, i32 1
	%123 = load i1, i1* %122
	%124 = icmp ne i1 %123, false
	br i1 %124, label %while_body_4, label %while_end_5

while_body_4:
	%125 = alloca %IntStruct*
	%126 = call i8* @malloc(i64 16)
	%127 = bitcast i8* %126 to %IntStruct*
	%128 = getelementptr %IntStruct, %IntStruct* %127, i32 0, i32 1
	store i32 0, i32* %128
	store %IntStruct* %127, %IntStruct** %125
	br label %while_cond_6

while_end_5:
	%129 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*), i32 0, i32 0
	%130 = load i8*, i8** %129
	%131 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%132 = call i32 (i8*, ...) @printf(i8* %131, i8* %130)
	%133 = load %Main_struct*, %Main_struct** %3
	%134 = alloca %IntStruct*
	%135 = call i8* @malloc(i64 16)
	%136 = bitcast i8* %135 to %IntStruct*
	%137 = getelementptr %IntStruct, %IntStruct* %136, i32 0, i32 1
	store i32 0, i32* %137
	store %IntStruct* %136, %IntStruct** %134
	br label %while_cond_12

while_cond_6:
	%138 = load %IntStruct*, %IntStruct** %125
	%139 = load %IntStruct*, %IntStruct** %9
	%140 = call i8* @malloc(i64 16)
	%141 = bitcast i8* %140 to %IntStruct*
	%142 = getelementptr %IntStruct, %IntStruct* %141, i32 0, i32 1
	store i32 1, i32* %142
	%143 = getelementptr %IntStruct, %IntStruct* %139, i32 0, i32 1
	%144 = load i32, i32* %143
	%145 = getelementptr %IntStruct, %IntStruct* %141, i32 0, i32 1
	%146 = load i32, i32* %145
	%147 = sub i32 %144, %146
	%148 = call i8* @malloc(i64 16)
	%149 = bitcast i8* %148 to %IntStruct*
	%150 = getelementptr %IntStruct, %IntStruct* %149, i32 0, i32 1
	store i32 %147, i32* %150
	%151 = load %IntStruct*, %IntStruct** %97
	%152 = getelementptr %IntStruct, %IntStruct* %149, i32 0, i32 1
	%153 = load i32, i32* %152
	%154 = getelementptr %IntStruct, %IntStruct* %151, i32 0, i32 1
	%155 = load i32, i32* %154
	%156 = sub i32 %153, %155
	%157 = call i8* @malloc(i64 16)
	%158 = bitcast i8* %157 to %IntStruct*
	%159 = getelementptr %IntStruct, %IntStruct* %158, i32 0, i32 1
	store i32 %156, i32* %159
	%160 = getelementptr %IntStruct, %IntStruct* %138, i32 0, i32 1
	%161 = load i32, i32* %160
	%162 = getelementptr %IntStruct, %IntStruct* %158, i32 0, i32 1
	%163 = load i32, i32* %162
	%164 = icmp slt i32 %161, %163
	%165 = call i8* @malloc(i64 16)
	%166 = bitcast i8* %165 to %BoolStruct*
	%167 = getelementptr %BoolStruct, %BoolStruct* %166, i32 0, i32 1
	store i1 %164, i1* %167
	%168 = getelementptr %BoolStruct, %BoolStruct* %166, i32 0, i32 1
	%169 = load i1, i1* %168
	%170 = icmp ne i1 %169, false
	br i1 %170, label %while_body_7, label %while_end_8

while_body_7:
	%171 = alloca %IntStruct*
	%172 = load %ArrayStruct*, %ArrayStruct** %17
	%173 = bitcast %ArrayStruct* %172 to %ObjectStruct*
	%174 = load %IntStruct*, %IntStruct** %125
	%175 = load %IntStruct*, %IntStruct** %125
	%176 = getelementptr %IntStruct, %IntStruct* %175, i32 0, i32 1
	%177 = load i32, i32* %176
	%178 = sext i32 %177 to i64
	%179 = call i8* @Array_get(%ObjectStruct* %173, i64 %178)
	%180 = bitcast i8* %179 to %IntStruct*
	store %IntStruct* %180, %IntStruct** %171
	%181 = alloca %IntStruct*
	%182 = load %ArrayStruct*, %ArrayStruct** %17
	%183 = bitcast %ArrayStruct* %182 to %ObjectStruct*
	%184 = load %IntStruct*, %IntStruct** %125
	%185 = call i8* @malloc(i64 16)
	%186 = bitcast i8* %185 to %IntStruct*
	%187 = getelementptr %IntStruct, %IntStruct* %186, i32 0, i32 1
	store i32 1, i32* %187
	%188 = getelementptr %IntStruct, %IntStruct* %184, i32 0, i32 1
	%189 = load i32, i32* %188
	%190 = getelementptr %IntStruct, %IntStruct* %186, i32 0, i32 1
	%191 = load i32, i32* %190
	%192 = add i32 %189, %191
	%193 = call i8* @malloc(i64 16)
	%194 = bitcast i8* %193 to %IntStruct*
	%195 = getelementptr %IntStruct, %IntStruct* %194, i32 0, i32 1
	store i32 %192, i32* %195
	%196 = load %IntStruct*, %IntStruct** %125
	%197 = call i8* @malloc(i64 16)
	%198 = bitcast i8* %197 to %IntStruct*
	%199 = getelementptr %IntStruct, %IntStruct* %198, i32 0, i32 1
	store i32 1, i32* %199
	%200 = getelementptr %IntStruct, %IntStruct* %196, i32 0, i32 1
	%201 = load i32, i32* %200
	%202 = getelementptr %IntStruct, %IntStruct* %198, i32 0, i32 1
	%203 = load i32, i32* %202
	%204 = add i32 %201, %203
	%205 = call i8* @malloc(i64 16)
	%206 = bitcast i8* %205 to %IntStruct*
	%207 = getelementptr %IntStruct, %IntStruct* %206, i32 0, i32 1
	store i32 %204, i32* %207
	%208 = getelementptr %IntStruct, %IntStruct* %206, i32 0, i32 1
	%209 = load i32, i32* %208
	%210 = sext i32 %209 to i64
	%211 = call i8* @Array_get(%ObjectStruct* %183, i64 %210)
	%212 = bitcast i8* %211 to %IntStruct*
	store %IntStruct* %212, %IntStruct** %181
	%213 = load %IntStruct*, %IntStruct** %181
	%214 = load %IntStruct*, %IntStruct** %171
	%215 = getelementptr %IntStruct, %IntStruct* %213, i32 0, i32 1
	%216 = load i32, i32* %215
	%217 = getelementptr %IntStruct, %IntStruct* %214, i32 0, i32 1
	%218 = load i32, i32* %217
	%219 = icmp slt i32 %216, %218
	%220 = call i8* @malloc(i64 16)
	%221 = bitcast i8* %220 to %BoolStruct*
	%222 = getelementptr %BoolStruct, %BoolStruct* %221, i32 0, i32 1
	store i1 %219, i1* %222
	%223 = getelementptr %BoolStruct, %BoolStruct* %221, i32 0, i32 1
	%224 = load i1, i1* %223
	%225 = icmp ne i1 %224, false
	br i1 %225, label %if_then_9, label %if_else_10

while_end_8:
	%226 = load %IntStruct*, %IntStruct** %97
	%227 = call i8* @malloc(i64 16)
	%228 = bitcast i8* %227 to %IntStruct*
	%229 = getelementptr %IntStruct, %IntStruct* %228, i32 0, i32 1
	store i32 1, i32* %229
	%230 = getelementptr %IntStruct, %IntStruct* %226, i32 0, i32 1
	%231 = load i32, i32* %230
	%232 = getelementptr %IntStruct, %IntStruct* %228, i32 0, i32 1
	%233 = load i32, i32* %232
	%234 = add i32 %231, %233
	%235 = call i8* @malloc(i64 16)
	%236 = bitcast i8* %235 to %IntStruct*
	%237 = getelementptr %IntStruct, %IntStruct* %236, i32 0, i32 1
	store i32 %234, i32* %237
	store %IntStruct* %236, %IntStruct** %97
	br label %while_cond_3

if_then_9:
	%238 = load %ArrayStruct*, %ArrayStruct** %17
	%239 = bitcast %ArrayStruct* %238 to %ObjectStruct*
	%240 = load %IntStruct*, %IntStruct** %125
	%241 = load %IntStruct*, %IntStruct** %181
	%242 = load %IntStruct*, %IntStruct** %125
	%243 = getelementptr %IntStruct, %IntStruct* %242, i32 0, i32 1
	%244 = load i32, i32* %243
	%245 = sext i32 %244 to i64
	%246 = load %IntStruct*, %IntStruct** %181
	%247 = bitcast %IntStruct* %246 to i8*
	call void @Array_set(%ObjectStruct* %239, i64 %245, i8* %247)
	%248 = load %ArrayStruct*, %ArrayStruct** %17
	%249 = bitcast %ArrayStruct* %248 to %ObjectStruct*
	%250 = load %IntStruct*, %IntStruct** %125
	%251 = call i8* @malloc(i64 16)
	%252 = bitcast i8* %251 to %IntStruct*
	%253 = getelementptr %IntStruct, %IntStruct* %252, i32 0, i32 1
	store i32 1, i32* %253
	%254 = getelementptr %IntStruct, %IntStruct* %250, i32 0, i32 1
	%255 = load i32, i32* %254
	%256 = getelementptr %IntStruct, %IntStruct* %252, i32 0, i32 1
	%257 = load i32, i32* %256
	%258 = add i32 %255, %257
	%259 = call i8* @malloc(i64 16)
	%260 = bitcast i8* %259 to %IntStruct*
	%261 = getelementptr %IntStruct, %IntStruct* %260, i32 0, i32 1
	store i32 %258, i32* %261
	%262 = load %IntStruct*, %IntStruct** %171
	%263 = load %IntStruct*, %IntStruct** %125
	%264 = call i8* @malloc(i64 16)
	%265 = bitcast i8* %264 to %IntStruct*
	%266 = getelementptr %IntStruct, %IntStruct* %265, i32 0, i32 1
	store i32 1, i32* %266
	%267 = getelementptr %IntStruct, %IntStruct* %263, i32 0, i32 1
	%268 = load i32, i32* %267
	%269 = getelementptr %IntStruct, %IntStruct* %265, i32 0, i32 1
	%270 = load i32, i32* %269
	%271 = add i32 %268, %270
	%272 = call i8* @malloc(i64 16)
	%273 = bitcast i8* %272 to %IntStruct*
	%274 = getelementptr %IntStruct, %IntStruct* %273, i32 0, i32 1
	store i32 %271, i32* %274
	%275 = getelementptr %IntStruct, %IntStruct* %273, i32 0, i32 1
	%276 = load i32, i32* %275
	%277 = sext i32 %276 to i64
	%278 = load %IntStruct*, %IntStruct** %171
	%279 = bitcast %IntStruct* %278 to i8*
	call void @Array_set(%ObjectStruct* %249, i64 %277, i8* %279)
	br label %if_end_11

if_else_10:
	br label %if_end_11

if_end_11:
	%280 = phi %ObjectStruct* [ %249, %if_then_9 ], [ null, %if_else_10 ]
	%281 = load %IntStruct*, %IntStruct** %125
	%282 = call i8* @malloc(i64 16)
	%283 = bitcast i8* %282 to %IntStruct*
	%284 = getelementptr %IntStruct, %IntStruct* %283, i32 0, i32 1
	store i32 1, i32* %284
	%285 = getelementptr %IntStruct, %IntStruct* %281, i32 0, i32 1
	%286 = load i32, i32* %285
	%287 = getelementptr %IntStruct, %IntStruct* %283, i32 0, i32 1
	%288 = load i32, i32* %287
	%289 = add i32 %286, %288
	%290 = call i8* @malloc(i64 16)
	%291 = bitcast i8* %290 to %IntStruct*
	%292 = getelementptr %IntStruct, %IntStruct* %291, i32 0, i32 1
	store i32 %289, i32* %292
	store %IntStruct* %291, %IntStruct** %125
	br label %while_cond_6

while_cond_12:
	%293 = load %IntStruct*, %IntStruct** %134
	%294 = load %IntStruct*, %IntStruct** %9
	%295 = getelementptr %IntStruct, %IntStruct* %293, i32 0, i32 1
	%296 = load i32, i32* %295
	%297 = getelementptr %IntStruct, %IntStruct* %294, i32 0, i32 1
	%298 = load i32, i32* %297
	%299 = icmp slt i32 %296, %298
	%300 = call i8* @malloc(i64 16)
	%301 = bitcast i8* %300 to %BoolStruct*
	%302 = getelementptr %BoolStruct, %BoolStruct* %301, i32 0, i32 1
	store i1 %299, i1* %302
	%303 = getelementptr %BoolStruct, %BoolStruct* %301, i32 0, i32 1
	%304 = load i1, i1* %303
	%305 = icmp ne i1 %304, false
	br i1 %305, label %while_body_13, label %while_end_14

while_body_13:
	%306 = load %ArrayStruct*, %ArrayStruct** %17
	%307 = bitcast %ArrayStruct* %306 to %ObjectStruct*
	%308 = load %IntStruct*, %IntStruct** %134
	%309 = load %IntStruct*, %IntStruct** %134
	%310 = getelementptr %IntStruct, %IntStruct* %309, i32 0, i32 1
	%311 = load i32, i32* %310
	%312 = sext i32 %311 to i64
	%313 = call i8* @Array_get(%ObjectStruct* %307, i64 %312)
	%314 = bitcast i8* %313 to %IntStruct*
	%315 = getelementptr %IntStruct, %IntStruct* %314, i32 0, i32 1
	%316 = load i32, i32* %315
	%317 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%318 = call i32 (i8*, ...) @printf(i8* %317, i32 %316)
	%319 = load %Main_struct*, %Main_struct** %3
	%320 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_11 to %StringStruct*), i32 0, i32 0
	%321 = load i8*, i8** %320
	%322 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%323 = call i32 (i8*, ...) @printf(i8* %322, i8* %321)
	%324 = load %Main_struct*, %Main_struct** %3
	%325 = load %IntStruct*, %IntStruct** %134
	%326 = call i8* @malloc(i64 16)
	%327 = bitcast i8* %326 to %IntStruct*
	%328 = getelementptr %IntStruct, %IntStruct* %327, i32 0, i32 1
	store i32 1, i32* %328
	%329 = getelementptr %IntStruct, %IntStruct* %325, i32 0, i32 1
	%330 = load i32, i32* %329
	%331 = getelementptr %IntStruct, %IntStruct* %327, i32 0, i32 1
	%332 = load i32, i32* %331
	%333 = add i32 %330, %332
	%334 = call i8* @malloc(i64 16)
	%335 = bitcast i8* %334 to %IntStruct*
	%336 = getelementptr %IntStruct, %IntStruct* %335, i32 0, i32 1
	store i32 %333, i32* %336
	store %IntStruct* %335, %IntStruct** %134
	br label %while_cond_12

while_end_14:
	%337 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_13 to %StringStruct*), i32 0, i32 0
	%338 = load i8*, i8** %337
	%339 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%340 = call i32 (i8*, ...) @printf(i8* %339, i8* %338)
	%341 = load %Main_struct*, %Main_struct** %3
	%342 = load %Main_struct*, %Main_struct** %3
	%343 = bitcast %Main_struct* %342 to %ObjectStruct*
	ret %ObjectStruct* %343
}
