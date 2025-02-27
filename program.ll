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
@vtable_Int = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null, %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%IntStruct*)* @Int_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_String = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%StringStruct*)* @String_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null]
@vtable_Bool = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null]
@vtable_IO = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %StringStruct*)* @IO_out_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %IntStruct*)* @IO_out_int to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%IOStruct*)* @IO_in_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%IOStruct*)* @IO_in_int to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Array = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%ObjectStruct*)* @Array_length to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* (%ObjectStruct*, i64)* @Array_get to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (void (%ObjectStruct*, i64, i8*)* @Array_set to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ArrayStruct* (%ObjectStruct*, i64)* @Array_resize to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%ObjectStruct* (%Main_struct*)* @Main_main to i8*)]
@str_4 = global [18 x i8] c"Target not found\0A\00"
@str_obj_5 = constant { i8* } { i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str_4, i32 0, i32 0) }
@str_6 = global [23 x i8] c"Target found at index \00"
@str_obj_7 = constant { i8* } { i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str_6, i32 0, i32 0) }
@str_8 = global [2 x i8] c"\0A\00"
@str_obj_9 = constant { i8* } { i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str_8, i32 0, i32 0) }

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

define %IntStruct* @Int_copy(%IntStruct* %self) {
entry:
	%0 = call i8* @malloc(i64 16)
	%1 = bitcast i8* %0 to %IntStruct*
	%2 = getelementptr %IntStruct, %IntStruct* %self, i32 0, i32 0
	%3 = load i8*, i8** %2
	%4 = getelementptr %IntStruct, %IntStruct* %1, i32 0, i32 0
	store i8* %3, i8** %4
	%5 = getelementptr %IntStruct, %IntStruct* %self, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = getelementptr %IntStruct, %IntStruct* %1, i32 0, i32 1
	store i32 %6, i32* %7
	ret %IntStruct* %1
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
	%14 = bitcast %ArrayStruct* %13 to %ObjectStruct*
	%15 = call i8* @malloc(i64 16)
	%16 = bitcast i8* %15 to %IntStruct*
	%17 = getelementptr %IntStruct, %IntStruct* %16, i32 0, i32 1
	store i32 7, i32* %17
	%18 = call i8* @malloc(i64 16)
	%19 = bitcast i8* %18 to %IntStruct*
	%20 = getelementptr %IntStruct, %IntStruct* %19, i32 0, i32 1
	store i32 7, i32* %20
	%21 = getelementptr %IntStruct, %IntStruct* %19, i32 0, i32 1
	%22 = load i32, i32* %21
	%23 = sext i32 %22 to i64
	%24 = call %ArrayStruct* @Array_resize(%ObjectStruct* %14, i64 %23)
	%25 = load %ArrayStruct*, %ArrayStruct** %4
	%26 = bitcast %ArrayStruct* %25 to %ObjectStruct*
	%27 = call i8* @malloc(i64 16)
	%28 = bitcast i8* %27 to %IntStruct*
	%29 = getelementptr %IntStruct, %IntStruct* %28, i32 0, i32 1
	store i32 0, i32* %29
	%30 = call i8* @malloc(i64 16)
	%31 = bitcast i8* %30 to %IntStruct*
	%32 = getelementptr %IntStruct, %IntStruct* %31, i32 0, i32 1
	store i32 1, i32* %32
	%33 = call i8* @malloc(i64 16)
	%34 = bitcast i8* %33 to %IntStruct*
	%35 = getelementptr %IntStruct, %IntStruct* %34, i32 0, i32 1
	store i32 0, i32* %35
	%36 = getelementptr %IntStruct, %IntStruct* %34, i32 0, i32 1
	%37 = load i32, i32* %36
	%38 = sext i32 %37 to i64
	%39 = call i8* @malloc(i64 16)
	%40 = bitcast i8* %39 to %IntStruct*
	%41 = getelementptr %IntStruct, %IntStruct* %40, i32 0, i32 1
	store i32 1, i32* %41
	%42 = bitcast %IntStruct* %40 to i8*
	call void @Array_set(%ObjectStruct* %26, i64 %38, i8* %42)
	%43 = load %ArrayStruct*, %ArrayStruct** %4
	%44 = bitcast %ArrayStruct* %43 to %ObjectStruct*
	%45 = call i8* @malloc(i64 16)
	%46 = bitcast i8* %45 to %IntStruct*
	%47 = getelementptr %IntStruct, %IntStruct* %46, i32 0, i32 1
	store i32 1, i32* %47
	%48 = call i8* @malloc(i64 16)
	%49 = bitcast i8* %48 to %IntStruct*
	%50 = getelementptr %IntStruct, %IntStruct* %49, i32 0, i32 1
	store i32 3, i32* %50
	%51 = call i8* @malloc(i64 16)
	%52 = bitcast i8* %51 to %IntStruct*
	%53 = getelementptr %IntStruct, %IntStruct* %52, i32 0, i32 1
	store i32 1, i32* %53
	%54 = getelementptr %IntStruct, %IntStruct* %52, i32 0, i32 1
	%55 = load i32, i32* %54
	%56 = sext i32 %55 to i64
	%57 = call i8* @malloc(i64 16)
	%58 = bitcast i8* %57 to %IntStruct*
	%59 = getelementptr %IntStruct, %IntStruct* %58, i32 0, i32 1
	store i32 3, i32* %59
	%60 = bitcast %IntStruct* %58 to i8*
	call void @Array_set(%ObjectStruct* %44, i64 %56, i8* %60)
	%61 = load %ArrayStruct*, %ArrayStruct** %4
	%62 = bitcast %ArrayStruct* %61 to %ObjectStruct*
	%63 = call i8* @malloc(i64 16)
	%64 = bitcast i8* %63 to %IntStruct*
	%65 = getelementptr %IntStruct, %IntStruct* %64, i32 0, i32 1
	store i32 2, i32* %65
	%66 = call i8* @malloc(i64 16)
	%67 = bitcast i8* %66 to %IntStruct*
	%68 = getelementptr %IntStruct, %IntStruct* %67, i32 0, i32 1
	store i32 5, i32* %68
	%69 = call i8* @malloc(i64 16)
	%70 = bitcast i8* %69 to %IntStruct*
	%71 = getelementptr %IntStruct, %IntStruct* %70, i32 0, i32 1
	store i32 2, i32* %71
	%72 = getelementptr %IntStruct, %IntStruct* %70, i32 0, i32 1
	%73 = load i32, i32* %72
	%74 = sext i32 %73 to i64
	%75 = call i8* @malloc(i64 16)
	%76 = bitcast i8* %75 to %IntStruct*
	%77 = getelementptr %IntStruct, %IntStruct* %76, i32 0, i32 1
	store i32 5, i32* %77
	%78 = bitcast %IntStruct* %76 to i8*
	call void @Array_set(%ObjectStruct* %62, i64 %74, i8* %78)
	%79 = load %ArrayStruct*, %ArrayStruct** %4
	%80 = bitcast %ArrayStruct* %79 to %ObjectStruct*
	%81 = call i8* @malloc(i64 16)
	%82 = bitcast i8* %81 to %IntStruct*
	%83 = getelementptr %IntStruct, %IntStruct* %82, i32 0, i32 1
	store i32 3, i32* %83
	%84 = call i8* @malloc(i64 16)
	%85 = bitcast i8* %84 to %IntStruct*
	%86 = getelementptr %IntStruct, %IntStruct* %85, i32 0, i32 1
	store i32 7, i32* %86
	%87 = call i8* @malloc(i64 16)
	%88 = bitcast i8* %87 to %IntStruct*
	%89 = getelementptr %IntStruct, %IntStruct* %88, i32 0, i32 1
	store i32 3, i32* %89
	%90 = getelementptr %IntStruct, %IntStruct* %88, i32 0, i32 1
	%91 = load i32, i32* %90
	%92 = sext i32 %91 to i64
	%93 = call i8* @malloc(i64 16)
	%94 = bitcast i8* %93 to %IntStruct*
	%95 = getelementptr %IntStruct, %IntStruct* %94, i32 0, i32 1
	store i32 7, i32* %95
	%96 = bitcast %IntStruct* %94 to i8*
	call void @Array_set(%ObjectStruct* %80, i64 %92, i8* %96)
	%97 = load %ArrayStruct*, %ArrayStruct** %4
	%98 = bitcast %ArrayStruct* %97 to %ObjectStruct*
	%99 = call i8* @malloc(i64 16)
	%100 = bitcast i8* %99 to %IntStruct*
	%101 = getelementptr %IntStruct, %IntStruct* %100, i32 0, i32 1
	store i32 4, i32* %101
	%102 = call i8* @malloc(i64 16)
	%103 = bitcast i8* %102 to %IntStruct*
	%104 = getelementptr %IntStruct, %IntStruct* %103, i32 0, i32 1
	store i32 9, i32* %104
	%105 = call i8* @malloc(i64 16)
	%106 = bitcast i8* %105 to %IntStruct*
	%107 = getelementptr %IntStruct, %IntStruct* %106, i32 0, i32 1
	store i32 4, i32* %107
	%108 = getelementptr %IntStruct, %IntStruct* %106, i32 0, i32 1
	%109 = load i32, i32* %108
	%110 = sext i32 %109 to i64
	%111 = call i8* @malloc(i64 16)
	%112 = bitcast i8* %111 to %IntStruct*
	%113 = getelementptr %IntStruct, %IntStruct* %112, i32 0, i32 1
	store i32 9, i32* %113
	%114 = bitcast %IntStruct* %112 to i8*
	call void @Array_set(%ObjectStruct* %98, i64 %110, i8* %114)
	%115 = load %ArrayStruct*, %ArrayStruct** %4
	%116 = bitcast %ArrayStruct* %115 to %ObjectStruct*
	%117 = call i8* @malloc(i64 16)
	%118 = bitcast i8* %117 to %IntStruct*
	%119 = getelementptr %IntStruct, %IntStruct* %118, i32 0, i32 1
	store i32 5, i32* %119
	%120 = call i8* @malloc(i64 16)
	%121 = bitcast i8* %120 to %IntStruct*
	%122 = getelementptr %IntStruct, %IntStruct* %121, i32 0, i32 1
	store i32 11, i32* %122
	%123 = call i8* @malloc(i64 16)
	%124 = bitcast i8* %123 to %IntStruct*
	%125 = getelementptr %IntStruct, %IntStruct* %124, i32 0, i32 1
	store i32 5, i32* %125
	%126 = getelementptr %IntStruct, %IntStruct* %124, i32 0, i32 1
	%127 = load i32, i32* %126
	%128 = sext i32 %127 to i64
	%129 = call i8* @malloc(i64 16)
	%130 = bitcast i8* %129 to %IntStruct*
	%131 = getelementptr %IntStruct, %IntStruct* %130, i32 0, i32 1
	store i32 11, i32* %131
	%132 = bitcast %IntStruct* %130 to i8*
	call void @Array_set(%ObjectStruct* %116, i64 %128, i8* %132)
	%133 = load %ArrayStruct*, %ArrayStruct** %4
	%134 = bitcast %ArrayStruct* %133 to %ObjectStruct*
	%135 = call i8* @malloc(i64 16)
	%136 = bitcast i8* %135 to %IntStruct*
	%137 = getelementptr %IntStruct, %IntStruct* %136, i32 0, i32 1
	store i32 6, i32* %137
	%138 = call i8* @malloc(i64 16)
	%139 = bitcast i8* %138 to %IntStruct*
	%140 = getelementptr %IntStruct, %IntStruct* %139, i32 0, i32 1
	store i32 13, i32* %140
	%141 = call i8* @malloc(i64 16)
	%142 = bitcast i8* %141 to %IntStruct*
	%143 = getelementptr %IntStruct, %IntStruct* %142, i32 0, i32 1
	store i32 6, i32* %143
	%144 = getelementptr %IntStruct, %IntStruct* %142, i32 0, i32 1
	%145 = load i32, i32* %144
	%146 = sext i32 %145 to i64
	%147 = call i8* @malloc(i64 16)
	%148 = bitcast i8* %147 to %IntStruct*
	%149 = getelementptr %IntStruct, %IntStruct* %148, i32 0, i32 1
	store i32 13, i32* %149
	%150 = bitcast %IntStruct* %148 to i8*
	call void @Array_set(%ObjectStruct* %134, i64 %146, i8* %150)
	%151 = alloca %IntStruct*
	%152 = call i8* @malloc(i64 16)
	%153 = bitcast i8* %152 to %IntStruct*
	%154 = getelementptr %IntStruct, %IntStruct* %153, i32 0, i32 1
	store i32 7, i32* %154
	store %IntStruct* %153, %IntStruct** %151
	%155 = alloca %IntStruct*
	%156 = call i8* @malloc(i64 16)
	%157 = bitcast i8* %156 to %IntStruct*
	%158 = getelementptr %IntStruct, %IntStruct* %157, i32 0, i32 1
	store i32 0, i32* %158
	store %IntStruct* %157, %IntStruct** %155
	%159 = alloca %IntStruct*
	%160 = load %ArrayStruct*, %ArrayStruct** %4
	%161 = bitcast %ArrayStruct* %160 to %ObjectStruct*
	%162 = call %IntStruct* @Array_length(%ObjectStruct* %161)
	%163 = call i8* @malloc(i64 16)
	%164 = bitcast i8* %163 to %IntStruct*
	%165 = getelementptr %IntStruct, %IntStruct* %164, i32 0, i32 1
	store i32 1, i32* %165
	%166 = getelementptr %IntStruct, %IntStruct* %162, i32 0, i32 1
	%167 = load i32, i32* %166
	%168 = getelementptr %IntStruct, %IntStruct* %164, i32 0, i32 1
	%169 = load i32, i32* %168
	%170 = sub i32 %167, %169
	%171 = call i8* @malloc(i64 16)
	%172 = bitcast i8* %171 to %IntStruct*
	%173 = getelementptr %IntStruct, %IntStruct* %172, i32 0, i32 1
	store i32 %170, i32* %173
	store %IntStruct* %172, %IntStruct** %159
	%174 = alloca %IntStruct*
	%175 = call i8* @malloc(i64 16)
	%176 = bitcast i8* %175 to %IntStruct*
	%177 = getelementptr %IntStruct, %IntStruct* %176, i32 0, i32 1
	store i32 0, i32* %177
	%178 = call i8* @malloc(i64 16)
	%179 = bitcast i8* %178 to %IntStruct*
	%180 = getelementptr %IntStruct, %IntStruct* %179, i32 0, i32 1
	store i32 1, i32* %180
	%181 = getelementptr %IntStruct, %IntStruct* %176, i32 0, i32 1
	%182 = load i32, i32* %181
	%183 = getelementptr %IntStruct, %IntStruct* %179, i32 0, i32 1
	%184 = load i32, i32* %183
	%185 = sub i32 %182, %184
	%186 = call i8* @malloc(i64 16)
	%187 = bitcast i8* %186 to %IntStruct*
	%188 = getelementptr %IntStruct, %IntStruct* %187, i32 0, i32 1
	store i32 %185, i32* %188
	store %IntStruct* %187, %IntStruct** %174
	br label %while_cond_0

while_cond_0:
	%189 = load %IntStruct*, %IntStruct** %155
	%190 = load %IntStruct*, %IntStruct** %159
	%191 = getelementptr %IntStruct, %IntStruct* %189, i32 0, i32 1
	%192 = load i32, i32* %191
	%193 = getelementptr %IntStruct, %IntStruct* %190, i32 0, i32 1
	%194 = load i32, i32* %193
	%195 = icmp sle i32 %192, %194
	%196 = call i8* @malloc(i64 16)
	%197 = bitcast i8* %196 to %BoolStruct*
	%198 = getelementptr %BoolStruct, %BoolStruct* %197, i32 0, i32 1
	store i1 %195, i1* %198
	%199 = getelementptr %BoolStruct, %BoolStruct* %197, i32 0, i32 1
	%200 = load i1, i1* %199
	%201 = icmp ne i1 %200, false
	br i1 %201, label %while_body_1, label %while_end_2

while_body_1:
	%202 = alloca %IntStruct*
	%203 = load %IntStruct*, %IntStruct** %155
	%204 = load %IntStruct*, %IntStruct** %159
	%205 = getelementptr %IntStruct, %IntStruct* %203, i32 0, i32 1
	%206 = load i32, i32* %205
	%207 = getelementptr %IntStruct, %IntStruct* %204, i32 0, i32 1
	%208 = load i32, i32* %207
	%209 = add i32 %206, %208
	%210 = call i8* @malloc(i64 16)
	%211 = bitcast i8* %210 to %IntStruct*
	%212 = getelementptr %IntStruct, %IntStruct* %211, i32 0, i32 1
	store i32 %209, i32* %212
	%213 = call i8* @malloc(i64 16)
	%214 = bitcast i8* %213 to %IntStruct*
	%215 = getelementptr %IntStruct, %IntStruct* %214, i32 0, i32 1
	store i32 2, i32* %215
	%216 = getelementptr %IntStruct, %IntStruct* %211, i32 0, i32 1
	%217 = load i32, i32* %216
	%218 = getelementptr %IntStruct, %IntStruct* %214, i32 0, i32 1
	%219 = load i32, i32* %218
	%220 = sdiv i32 %217, %219
	%221 = call i8* @malloc(i64 16)
	%222 = bitcast i8* %221 to %IntStruct*
	%223 = getelementptr %IntStruct, %IntStruct* %222, i32 0, i32 1
	store i32 %220, i32* %223
	store %IntStruct* %222, %IntStruct** %202
	%224 = load %ArrayStruct*, %ArrayStruct** %4
	%225 = bitcast %ArrayStruct* %224 to %ObjectStruct*
	%226 = load %IntStruct*, %IntStruct** %202
	%227 = load %IntStruct*, %IntStruct** %202
	%228 = getelementptr %IntStruct, %IntStruct* %227, i32 0, i32 1
	%229 = load i32, i32* %228
	%230 = sext i32 %229 to i64
	%231 = call i8* @Array_get(%ObjectStruct* %225, i64 %230)
	%232 = bitcast i8* %231 to %IntStruct*
	%233 = load %IntStruct*, %IntStruct** %151
	%234 = getelementptr %IntStruct, %IntStruct* %232, i32 0, i32 1
	%235 = load i32, i32* %234
	%236 = getelementptr %IntStruct, %IntStruct* %233, i32 0, i32 1
	%237 = load i32, i32* %236
	%238 = icmp eq i32 %235, %237
	%239 = call i8* @malloc(i64 16)
	%240 = bitcast i8* %239 to %BoolStruct*
	%241 = getelementptr %BoolStruct, %BoolStruct* %240, i32 0, i32 1
	store i1 %238, i1* %241
	%242 = getelementptr %BoolStruct, %BoolStruct* %240, i32 0, i32 1
	%243 = load i1, i1* %242
	%244 = icmp ne i1 %243, false
	br i1 %244, label %if_then_3, label %if_else_4

while_end_2:
	%245 = load %IntStruct*, %IntStruct** %174
	%246 = call i8* @malloc(i64 16)
	%247 = bitcast i8* %246 to %IntStruct*
	%248 = getelementptr %IntStruct, %IntStruct* %247, i32 0, i32 1
	store i32 0, i32* %248
	%249 = call i8* @malloc(i64 16)
	%250 = bitcast i8* %249 to %IntStruct*
	%251 = getelementptr %IntStruct, %IntStruct* %250, i32 0, i32 1
	store i32 1, i32* %251
	%252 = getelementptr %IntStruct, %IntStruct* %247, i32 0, i32 1
	%253 = load i32, i32* %252
	%254 = getelementptr %IntStruct, %IntStruct* %250, i32 0, i32 1
	%255 = load i32, i32* %254
	%256 = sub i32 %253, %255
	%257 = call i8* @malloc(i64 16)
	%258 = bitcast i8* %257 to %IntStruct*
	%259 = getelementptr %IntStruct, %IntStruct* %258, i32 0, i32 1
	store i32 %256, i32* %259
	%260 = getelementptr %IntStruct, %IntStruct* %245, i32 0, i32 1
	%261 = load i32, i32* %260
	%262 = getelementptr %IntStruct, %IntStruct* %258, i32 0, i32 1
	%263 = load i32, i32* %262
	%264 = icmp eq i32 %261, %263
	%265 = call i8* @malloc(i64 16)
	%266 = bitcast i8* %265 to %BoolStruct*
	%267 = getelementptr %BoolStruct, %BoolStruct* %266, i32 0, i32 1
	store i1 %264, i1* %267
	%268 = getelementptr %BoolStruct, %BoolStruct* %266, i32 0, i32 1
	%269 = load i1, i1* %268
	%270 = icmp ne i1 %269, false
	br i1 %270, label %if_then_9, label %if_else_10

if_then_3:
	%271 = load %IntStruct*, %IntStruct** %202
	store %IntStruct* %271, %IntStruct** %174
	%272 = load %IntStruct*, %IntStruct** %159
	%273 = call i8* @malloc(i64 16)
	%274 = bitcast i8* %273 to %IntStruct*
	%275 = getelementptr %IntStruct, %IntStruct* %274, i32 0, i32 1
	store i32 1, i32* %275
	%276 = getelementptr %IntStruct, %IntStruct* %272, i32 0, i32 1
	%277 = load i32, i32* %276
	%278 = getelementptr %IntStruct, %IntStruct* %274, i32 0, i32 1
	%279 = load i32, i32* %278
	%280 = add i32 %277, %279
	%281 = call i8* @malloc(i64 16)
	%282 = bitcast i8* %281 to %IntStruct*
	%283 = getelementptr %IntStruct, %IntStruct* %282, i32 0, i32 1
	store i32 %280, i32* %283
	store %IntStruct* %282, %IntStruct** %155
	br label %if_end_5

if_else_4:
	%284 = load %ArrayStruct*, %ArrayStruct** %4
	%285 = bitcast %ArrayStruct* %284 to %ObjectStruct*
	%286 = load %IntStruct*, %IntStruct** %202
	%287 = load %IntStruct*, %IntStruct** %202
	%288 = getelementptr %IntStruct, %IntStruct* %287, i32 0, i32 1
	%289 = load i32, i32* %288
	%290 = sext i32 %289 to i64
	%291 = call i8* @Array_get(%ObjectStruct* %285, i64 %290)
	%292 = bitcast i8* %291 to %IntStruct*
	%293 = load %IntStruct*, %IntStruct** %151
	%294 = getelementptr %IntStruct, %IntStruct* %292, i32 0, i32 1
	%295 = load i32, i32* %294
	%296 = getelementptr %IntStruct, %IntStruct* %293, i32 0, i32 1
	%297 = load i32, i32* %296
	%298 = icmp slt i32 %295, %297
	%299 = call i8* @malloc(i64 16)
	%300 = bitcast i8* %299 to %BoolStruct*
	%301 = getelementptr %BoolStruct, %BoolStruct* %300, i32 0, i32 1
	store i1 %298, i1* %301
	%302 = getelementptr %BoolStruct, %BoolStruct* %300, i32 0, i32 1
	%303 = load i1, i1* %302
	%304 = icmp ne i1 %303, false
	br i1 %304, label %if_then_6, label %if_else_7

if_end_5:
	%305 = phi %IntStruct* [ %282, %if_then_3 ], [ %330, %if_else_4 ]
	br label %while_cond_0

if_then_6:
	%306 = load %IntStruct*, %IntStruct** %202
	%307 = call i8* @malloc(i64 16)
	%308 = bitcast i8* %307 to %IntStruct*
	%309 = getelementptr %IntStruct, %IntStruct* %308, i32 0, i32 1
	store i32 1, i32* %309
	%310 = getelementptr %IntStruct, %IntStruct* %306, i32 0, i32 1
	%311 = load i32, i32* %310
	%312 = getelementptr %IntStruct, %IntStruct* %308, i32 0, i32 1
	%313 = load i32, i32* %312
	%314 = add i32 %311, %313
	%315 = call i8* @malloc(i64 16)
	%316 = bitcast i8* %315 to %IntStruct*
	%317 = getelementptr %IntStruct, %IntStruct* %316, i32 0, i32 1
	store i32 %314, i32* %317
	store %IntStruct* %316, %IntStruct** %155
	br label %if_end_8

if_else_7:
	%318 = load %IntStruct*, %IntStruct** %202
	%319 = call i8* @malloc(i64 16)
	%320 = bitcast i8* %319 to %IntStruct*
	%321 = getelementptr %IntStruct, %IntStruct* %320, i32 0, i32 1
	store i32 1, i32* %321
	%322 = getelementptr %IntStruct, %IntStruct* %318, i32 0, i32 1
	%323 = load i32, i32* %322
	%324 = getelementptr %IntStruct, %IntStruct* %320, i32 0, i32 1
	%325 = load i32, i32* %324
	%326 = sub i32 %323, %325
	%327 = call i8* @malloc(i64 16)
	%328 = bitcast i8* %327 to %IntStruct*
	%329 = getelementptr %IntStruct, %IntStruct* %328, i32 0, i32 1
	store i32 %326, i32* %329
	store %IntStruct* %328, %IntStruct** %159
	br label %if_end_8

if_end_8:
	%330 = phi %IntStruct* [ %316, %if_then_6 ], [ %328, %if_else_7 ]
	br label %if_end_5

if_then_9:
	%331 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%332 = load i8*, i8** %331
	%333 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%334 = call i32 (i8*, ...) @printf(i8* %333, i8* %332)
	%335 = load %Main_struct*, %Main_struct** %3
	br label %if_end_11

if_else_10:
	%336 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%337 = load i8*, i8** %336
	%338 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%339 = call i32 (i8*, ...) @printf(i8* %338, i8* %337)
	%340 = load %Main_struct*, %Main_struct** %3
	%341 = load %IntStruct*, %IntStruct** %174
	%342 = getelementptr %IntStruct, %IntStruct* %341, i32 0, i32 1
	%343 = load i32, i32* %342
	%344 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%345 = call i32 (i8*, ...) @printf(i8* %344, i32 %343)
	%346 = load %Main_struct*, %Main_struct** %3
	%347 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*), i32 0, i32 0
	%348 = load i8*, i8** %347
	%349 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%350 = call i32 (i8*, ...) @printf(i8* %349, i8* %348)
	%351 = load %Main_struct*, %Main_struct** %3
	br label %if_end_11

if_end_11:
	%352 = phi %Main_struct* [ %335, %if_then_9 ], [ %351, %if_else_10 ]
	%353 = load %Main_struct*, %Main_struct** %3
	%354 = bitcast %Main_struct* %353 to %ObjectStruct*
	ret %ObjectStruct* %354
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
