%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%ArrayStruct = type { i8*, i64, i8* }
%Node_struct = type { i8*, %IntStruct*, %Node_struct* }
%LinkedList_struct = type { i8*, %Node_struct* }
%Set_struct = type { i8*, %LinkedList_struct* }
%Main_struct = type { i8* }

@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@str_0 = global [7 x i8] c"String\00"
@str_obj_1 = constant { i8* } { [7 x i8]* getelementptr inbounds ([7 x i8], [7 x i8]* @str_0) }
@str_2 = global [7 x i8] c"Object\00"
@str_obj_3 = constant { i8* } { [7 x i8]* getelementptr inbounds ([7 x i8], [7 x i8]* @str_2) }
@vtable_Object = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Int = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null, %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%IntStruct*)* @Int_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_String = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%StringStruct*)* @String_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null]
@vtable_Bool = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null]
@vtable_IO = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %StringStruct*)* @IO_out_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %IntStruct*)* @IO_out_int to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%IOStruct*)* @IO_in_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%IOStruct*)* @IO_in_int to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Array = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%ArrayStruct*)* @Array_length to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* (%ArrayStruct*, i64)* @Array_get to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (void (%ArrayStruct*, i64, i8*)* @Array_set to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ArrayStruct* (%ArrayStruct*, i64)* @Array_resize to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Node = constant [5 x i8*] [i8* bitcast (%IntStruct* (%Node_struct*)* @Node_get_value to i8*), i8* bitcast (%Node_struct* (%Node_struct*, %IntStruct*)* @Node_set_value to i8*), i8* bitcast (%Node_struct* (%Node_struct*)* @Node_get_next to i8*), i8* bitcast (%Node_struct* (%Node_struct*, %Node_struct*)* @Node_set_next to i8*), i8* bitcast (%Node_struct* (%Node_struct*)* @Node_init_node to i8*)]
@vtable_LinkedList = constant [4 x i8*] [i8* bitcast (%LinkedList_struct* (%LinkedList_struct*)* @LinkedList_init_list to i8*), i8* bitcast (%LinkedList_struct* (%LinkedList_struct*, %IntStruct*)* @LinkedList_insert to i8*), i8* bitcast (%LinkedList_struct* (%LinkedList_struct*)* @LinkedList_print to i8*), i8* bitcast (%BoolStruct* (%LinkedList_struct*, %IntStruct*)* @LinkedList_search to i8*)]
@vtable_Set = constant [4 x i8*] [i8* bitcast (%Set_struct* (%Set_struct*)* @Set_init_set to i8*), i8* bitcast (%Set_struct* (%Set_struct*, %IntStruct*)* @Set_insert to i8*), i8* bitcast (%BoolStruct* (%Set_struct*, %IntStruct*)* @Set_has to i8*), i8* bitcast (%Set_struct* (%Set_struct*)* @Set_print_set to i8*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%ObjectStruct* (%Main_struct*)* @Main_main to i8*)]
@str_4 = global [2 x i8] c" \00"
@str_obj_5 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_4) }
@str_6 = global [2 x i8] c"\0A\00"
@str_obj_7 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_6) }
@str_8 = global [23 x i8] c"Current set contents:\0A\00"
@str_obj_9 = constant { i8* } { [23 x i8]* getelementptr inbounds ([23 x i8], [23 x i8]* @str_8) }
@str_10 = global [27 x i8] c"Check if 2 is in the set: \00"
@str_obj_11 = constant { i8* } { [27 x i8]* getelementptr inbounds ([27 x i8], [27 x i8]* @str_10) }
@str_12 = global [5 x i8] c"Yes\0A\00"
@str_obj_13 = constant { i8* } { [5 x i8]* getelementptr inbounds ([5 x i8], [5 x i8]* @str_12) }
@str_14 = global [4 x i8] c"No\0A\00"
@str_obj_15 = constant { i8* } { [4 x i8]* getelementptr inbounds ([4 x i8], [4 x i8]* @str_14) }
@str_16 = global [28 x i8] c"Check if 99 is in the set: \00"
@str_obj_17 = constant { i8* } { [28 x i8]* getelementptr inbounds ([28 x i8], [28 x i8]* @str_16) }
@str_18 = global [5 x i8] c"Yes\0A\00"
@str_obj_19 = constant { i8* } { [5 x i8]* getelementptr inbounds ([5 x i8], [5 x i8]* @str_18) }
@str_20 = global [4 x i8] c"No\0A\00"
@str_obj_21 = constant { i8* } { [4 x i8]* getelementptr inbounds ([4 x i8], [4 x i8]* @str_20) }

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

define %IntStruct* @Node_get_value(%Node_struct* %self) {
entry:
	%0 = alloca %Node_struct*
	store %Node_struct* %self, %Node_struct** %0
	%1 = load %Node_struct*, %Node_struct** %0
	%2 = bitcast %Node_struct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = load %Node_struct*, %Node_struct** %3
	%5 = bitcast %Node_struct* %4 to %Node_struct*
	%6 = getelementptr %Node_struct, %Node_struct* %5, i32 0, i32 1
	%7 = load %IntStruct*, %IntStruct** %6
	ret %IntStruct* %7
}

define %Node_struct* @Node_set_value(%Node_struct* %self, %IntStruct* %v) {
entry:
	%0 = alloca %Node_struct*
	store %Node_struct* %self, %Node_struct** %0
	%1 = load %Node_struct*, %Node_struct** %0
	%2 = bitcast %Node_struct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %v, %IntStruct** %4
	%5 = load %IntStruct*, %IntStruct** %4
	%6 = load %Node_struct*, %Node_struct** %3
	%7 = getelementptr %IntStruct*, %Node_struct* %6, i32 1
	store %IntStruct* %5, %IntStruct** %7
	%8 = load %Node_struct*, %Node_struct** %3
	ret %Node_struct* %8
}

define %Node_struct* @Node_get_next(%Node_struct* %self) {
entry:
	%0 = alloca %Node_struct*
	store %Node_struct* %self, %Node_struct** %0
	%1 = load %Node_struct*, %Node_struct** %0
	%2 = bitcast %Node_struct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = load %Node_struct*, %Node_struct** %3
	%5 = bitcast %Node_struct* %4 to %Node_struct*
	%6 = getelementptr %Node_struct, %Node_struct* %5, i32 0, i32 2
	%7 = load %Node_struct*, %Node_struct** %6
	ret %Node_struct* %7
}

define %Node_struct* @Node_set_next(%Node_struct* %self, %Node_struct* %n) {
entry:
	%0 = alloca %Node_struct*
	store %Node_struct* %self, %Node_struct** %0
	%1 = load %Node_struct*, %Node_struct** %0
	%2 = bitcast %Node_struct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = alloca %Node_struct*
	store %Node_struct* %n, %Node_struct** %4
	%5 = load %Node_struct*, %Node_struct** %4
	%6 = load %Node_struct*, %Node_struct** %3
	%7 = getelementptr %Node_struct*, %Node_struct* %6, i32 2
	store %Node_struct* %5, %Node_struct** %7
	%8 = load %Node_struct*, %Node_struct** %3
	ret %Node_struct* %8
}

define %Node_struct* @Node_init_node(%Node_struct* %self) {
entry:
	%0 = alloca %Node_struct*
	store %Node_struct* %self, %Node_struct** %0
	%1 = load %Node_struct*, %Node_struct** %0
	%2 = bitcast %Node_struct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = call i8* @malloc(i64 16)
	%5 = bitcast i8* %4 to %IntStruct*
	%6 = getelementptr %IntStruct, %IntStruct* %5, i32 0, i32 1
	store i32 0, i32* %6
	%7 = load %Node_struct*, %Node_struct** %3
	%8 = getelementptr %IntStruct*, %Node_struct* %7, i32 1
	store %IntStruct* %5, %IntStruct** %8
	%9 = load %Node_struct*, %Node_struct** %3
	%10 = load %Node_struct*, %Node_struct** %3
	%11 = getelementptr %Node_struct*, %Node_struct* %10, i32 2
	store %Node_struct* %9, %Node_struct** %11
	%12 = load %Node_struct*, %Node_struct** %3
	ret %Node_struct* %12
}

define %LinkedList_struct* @LinkedList_init_list(%LinkedList_struct* %self) {
entry:
	%0 = alloca %LinkedList_struct*
	store %LinkedList_struct* %self, %LinkedList_struct** %0
	%1 = load %LinkedList_struct*, %LinkedList_struct** %0
	%2 = bitcast %LinkedList_struct* %1 to %LinkedList_struct*
	%3 = alloca %LinkedList_struct*
	store %LinkedList_struct* %2, %LinkedList_struct** %3
	%4 = call i8* @malloc(i64 24)
	%5 = bitcast i8* %4 to %Node_struct*
	%6 = getelementptr %Node_struct, %Node_struct* %5, i32 0, i32 0
	store i8* bitcast ([5 x i8*]* bitcast ([5 x i8*]* @vtable_Node to [5 x i8*]*) to i8*), i8** %6
	%7 = load %LinkedList_struct*, %LinkedList_struct** %3
	%8 = getelementptr %Node_struct*, %LinkedList_struct* %7, i32 1
	store %Node_struct* %5, %Node_struct** %8
	%9 = load %LinkedList_struct*, %LinkedList_struct** %3
	%10 = bitcast %LinkedList_struct* %9 to %LinkedList_struct*
	%11 = getelementptr %LinkedList_struct, %LinkedList_struct* %10, i32 0, i32 1
	%12 = load %Node_struct*, %Node_struct** %11
	%13 = bitcast %Node_struct* %12 to %ObjectStruct*
	%14 = bitcast %ObjectStruct* %13 to %Node_struct*
	%15 = getelementptr %Node_struct, %Node_struct* %14, i32 0, i32 0
	%16 = load i8*, i8** %15
	%17 = bitcast i8* %16 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%18 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %17, i32 0, i32 4
	%19 = load i8*, %ObjectStruct* (%ObjectStruct*)** %18
	%20 = bitcast i8* %19 to %Node_struct* (%Node_struct*)*
	%21 = call %Node_struct* %20(%ObjectStruct* %13)
	%22 = load %LinkedList_struct*, %LinkedList_struct** %3
	ret %LinkedList_struct* %22
}

define %LinkedList_struct* @LinkedList_insert(%LinkedList_struct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %LinkedList_struct*
	store %LinkedList_struct* %self, %LinkedList_struct** %0
	%1 = load %LinkedList_struct*, %LinkedList_struct** %0
	%2 = bitcast %LinkedList_struct* %1 to %LinkedList_struct*
	%3 = alloca %LinkedList_struct*
	store %LinkedList_struct* %2, %LinkedList_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = alloca %Node_struct*
	%6 = call i8* @malloc(i64 24)
	%7 = bitcast i8* %6 to %Node_struct*
	%8 = getelementptr %Node_struct, %Node_struct* %7, i32 0, i32 0
	store i8* bitcast ([5 x i8*]* bitcast ([5 x i8*]* @vtable_Node to [5 x i8*]*) to i8*), i8** %8
	store %Node_struct* %7, %Node_struct** %5
	%9 = load %Node_struct*, %Node_struct** %5
	%10 = bitcast %Node_struct* %9 to %ObjectStruct*
	%11 = load %IntStruct*, %IntStruct** %4
	%12 = bitcast %ObjectStruct* %10 to %Node_struct*
	%13 = getelementptr %Node_struct, %Node_struct* %12, i32 0, i32 0
	%14 = load i8*, i8** %13
	%15 = bitcast i8* %14 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%16 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %15, i32 0, i32 1
	%17 = load i8*, %ObjectStruct* (%ObjectStruct*)** %16
	%18 = bitcast i8* %17 to %Node_struct* (%Node_struct*, %IntStruct*)*
	%19 = call %Node_struct* %18(%ObjectStruct* %10, %IntStruct* %11)
	%20 = load %Node_struct*, %Node_struct** %5
	%21 = bitcast %Node_struct* %20 to %ObjectStruct*
	%22 = load %LinkedList_struct*, %LinkedList_struct** %3
	%23 = bitcast %LinkedList_struct* %22 to %LinkedList_struct*
	%24 = getelementptr %LinkedList_struct, %LinkedList_struct* %23, i32 0, i32 1
	%25 = load %Node_struct*, %Node_struct** %24
	%26 = bitcast %Node_struct* %25 to %ObjectStruct*
	%27 = bitcast %ObjectStruct* %26 to %Node_struct*
	%28 = getelementptr %Node_struct, %Node_struct* %27, i32 0, i32 0
	%29 = load i8*, i8** %28
	%30 = bitcast i8* %29 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%31 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %30, i32 0, i32 2
	%32 = load i8*, %ObjectStruct* (%ObjectStruct*)** %31
	%33 = bitcast i8* %32 to %Node_struct* (%Node_struct*)*
	%34 = call %Node_struct* %33(%ObjectStruct* %26)
	%35 = bitcast %ObjectStruct* %21 to %Node_struct*
	%36 = getelementptr %Node_struct, %Node_struct* %35, i32 0, i32 0
	%37 = load i8*, i8** %36
	%38 = bitcast i8* %37 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%39 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %38, i32 0, i32 3
	%40 = load i8*, %ObjectStruct* (%ObjectStruct*)** %39
	%41 = bitcast i8* %40 to %Node_struct* (%Node_struct*, %Node_struct*)*
	%42 = call %Node_struct* %41(%ObjectStruct* %21, %Node_struct* %34)
	%43 = load %LinkedList_struct*, %LinkedList_struct** %3
	%44 = bitcast %LinkedList_struct* %43 to %LinkedList_struct*
	%45 = getelementptr %LinkedList_struct, %LinkedList_struct* %44, i32 0, i32 1
	%46 = load %Node_struct*, %Node_struct** %45
	%47 = bitcast %Node_struct* %46 to %ObjectStruct*
	%48 = load %Node_struct*, %Node_struct** %5
	%49 = bitcast %ObjectStruct* %47 to %Node_struct*
	%50 = getelementptr %Node_struct, %Node_struct* %49, i32 0, i32 0
	%51 = load i8*, i8** %50
	%52 = bitcast i8* %51 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%53 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %52, i32 0, i32 3
	%54 = load i8*, %ObjectStruct* (%ObjectStruct*)** %53
	%55 = bitcast i8* %54 to %Node_struct* (%Node_struct*, %Node_struct*)*
	%56 = call %Node_struct* %55(%ObjectStruct* %47, %Node_struct* %48)
	%57 = load %LinkedList_struct*, %LinkedList_struct** %3
	ret %LinkedList_struct* %57
}

define %LinkedList_struct* @LinkedList_print(%LinkedList_struct* %self) {
entry:
	%0 = alloca %LinkedList_struct*
	store %LinkedList_struct* %self, %LinkedList_struct** %0
	%1 = load %LinkedList_struct*, %LinkedList_struct** %0
	%2 = bitcast %LinkedList_struct* %1 to %LinkedList_struct*
	%3 = alloca %LinkedList_struct*
	store %LinkedList_struct* %2, %LinkedList_struct** %3
	%4 = alloca %Node_struct*
	%5 = load %LinkedList_struct*, %LinkedList_struct** %3
	%6 = bitcast %LinkedList_struct* %5 to %LinkedList_struct*
	%7 = getelementptr %LinkedList_struct, %LinkedList_struct* %6, i32 0, i32 1
	%8 = load %Node_struct*, %Node_struct** %7
	%9 = bitcast %Node_struct* %8 to %ObjectStruct*
	%10 = bitcast %ObjectStruct* %9 to %Node_struct*
	%11 = getelementptr %Node_struct, %Node_struct* %10, i32 0, i32 0
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%14 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %13, i32 0, i32 2
	%15 = load i8*, %ObjectStruct* (%ObjectStruct*)** %14
	%16 = bitcast i8* %15 to %Node_struct* (%Node_struct*)*
	%17 = call %Node_struct* %16(%ObjectStruct* %9)
	store %Node_struct* %17, %Node_struct** %4
	br label %while_cond_0

while_cond_0:
	%18 = load %Node_struct*, %Node_struct** %4
	%19 = load %LinkedList_struct*, %LinkedList_struct** %3
	%20 = bitcast %LinkedList_struct* %19 to %LinkedList_struct*
	%21 = getelementptr %LinkedList_struct, %LinkedList_struct* %20, i32 0, i32 1
	%22 = load %Node_struct*, %Node_struct** %21
	%23 = icmp eq %Node_struct* %18, %22
	%24 = call i8* @malloc(i64 16)
	%25 = bitcast i8* %24 to %BoolStruct*
	%26 = getelementptr %BoolStruct, %BoolStruct* %25, i32 0, i32 1
	store i1 %23, i1* %26
	%27 = getelementptr %BoolStruct, %BoolStruct* %25, i32 0, i32 1
	%28 = load i1, i1* %27
	%29 = xor i1 %28, true
	%30 = call i8* @malloc(i64 16)
	%31 = bitcast i8* %30 to %BoolStruct*
	%32 = getelementptr %BoolStruct, %BoolStruct* %31, i32 0, i32 1
	store i1 %29, i1* %32
	%33 = getelementptr %BoolStruct, %BoolStruct* %31, i32 0, i32 1
	%34 = load i1, i1* %33
	%35 = icmp ne i1 %34, false
	br i1 %35, label %while_body_1, label %while_end_2

while_body_1:
	%36 = load %Node_struct*, %Node_struct** %4
	%37 = bitcast %Node_struct* %36 to %ObjectStruct*
	%38 = bitcast %ObjectStruct* %37 to %Node_struct*
	%39 = getelementptr %Node_struct, %Node_struct* %38, i32 0, i32 0
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%42 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %41, i32 0, i32 0
	%43 = load i8*, %ObjectStruct* (%ObjectStruct*)** %42
	%44 = bitcast i8* %43 to %IntStruct* (%Node_struct*)*
	%45 = call %IntStruct* %44(%ObjectStruct* %37)
	%46 = getelementptr %IntStruct, %IntStruct* %45, i32 0, i32 1
	%47 = load i32, i32* %46
	%48 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%49 = call i32 (i8*, ...) @printf(i8* %48, i32 %47)
	%50 = load %LinkedList_struct*, %LinkedList_struct** %3
	%51 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%52 = load i8*, i8** %51
	%53 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%54 = call i32 (i8*, ...) @printf(i8* %53, i8* %52)
	%55 = load %LinkedList_struct*, %LinkedList_struct** %3
	%56 = load %Node_struct*, %Node_struct** %4
	%57 = bitcast %Node_struct* %56 to %ObjectStruct*
	%58 = bitcast %ObjectStruct* %57 to %Node_struct*
	%59 = getelementptr %Node_struct, %Node_struct* %58, i32 0, i32 0
	%60 = load i8*, i8** %59
	%61 = bitcast i8* %60 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%62 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %61, i32 0, i32 2
	%63 = load i8*, %ObjectStruct* (%ObjectStruct*)** %62
	%64 = bitcast i8* %63 to %Node_struct* (%Node_struct*)*
	%65 = call %Node_struct* %64(%ObjectStruct* %57)
	store %Node_struct* %65, %Node_struct** %4
	br label %while_cond_0

while_end_2:
	%66 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%67 = load i8*, i8** %66
	%68 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%69 = call i32 (i8*, ...) @printf(i8* %68, i8* %67)
	%70 = load %LinkedList_struct*, %LinkedList_struct** %3
	%71 = load %LinkedList_struct*, %LinkedList_struct** %3
	ret %LinkedList_struct* %71
}

define %BoolStruct* @LinkedList_search(%LinkedList_struct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %LinkedList_struct*
	store %LinkedList_struct* %self, %LinkedList_struct** %0
	%1 = load %LinkedList_struct*, %LinkedList_struct** %0
	%2 = bitcast %LinkedList_struct* %1 to %LinkedList_struct*
	%3 = alloca %LinkedList_struct*
	store %LinkedList_struct* %2, %LinkedList_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = alloca %Node_struct*
	%6 = load %LinkedList_struct*, %LinkedList_struct** %3
	%7 = bitcast %LinkedList_struct* %6 to %LinkedList_struct*
	%8 = getelementptr %LinkedList_struct, %LinkedList_struct* %7, i32 0, i32 1
	%9 = load %Node_struct*, %Node_struct** %8
	%10 = bitcast %Node_struct* %9 to %ObjectStruct*
	%11 = bitcast %ObjectStruct* %10 to %Node_struct*
	%12 = getelementptr %Node_struct, %Node_struct* %11, i32 0, i32 0
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%15 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %14, i32 0, i32 2
	%16 = load i8*, %ObjectStruct* (%ObjectStruct*)** %15
	%17 = bitcast i8* %16 to %Node_struct* (%Node_struct*)*
	%18 = call %Node_struct* %17(%ObjectStruct* %10)
	store %Node_struct* %18, %Node_struct** %5
	%19 = alloca %BoolStruct*
	%20 = call i8* @malloc(i64 16)
	%21 = bitcast i8* %20 to %BoolStruct*
	%22 = getelementptr %BoolStruct, %BoolStruct* %21, i32 0, i32 1
	store i1 false, i1* %22
	store %BoolStruct* %21, %BoolStruct** %19
	br label %while_cond_3

while_cond_3:
	%23 = load %Node_struct*, %Node_struct** %5
	%24 = load %LinkedList_struct*, %LinkedList_struct** %3
	%25 = bitcast %LinkedList_struct* %24 to %LinkedList_struct*
	%26 = getelementptr %LinkedList_struct, %LinkedList_struct* %25, i32 0, i32 1
	%27 = load %Node_struct*, %Node_struct** %26
	%28 = icmp eq %Node_struct* %23, %27
	%29 = call i8* @malloc(i64 16)
	%30 = bitcast i8* %29 to %BoolStruct*
	%31 = getelementptr %BoolStruct, %BoolStruct* %30, i32 0, i32 1
	store i1 %28, i1* %31
	%32 = getelementptr %BoolStruct, %BoolStruct* %30, i32 0, i32 1
	%33 = load i1, i1* %32
	%34 = xor i1 %33, true
	%35 = call i8* @malloc(i64 16)
	%36 = bitcast i8* %35 to %BoolStruct*
	%37 = getelementptr %BoolStruct, %BoolStruct* %36, i32 0, i32 1
	store i1 %34, i1* %37
	%38 = getelementptr %BoolStruct, %BoolStruct* %36, i32 0, i32 1
	%39 = load i1, i1* %38
	%40 = icmp ne i1 %39, false
	br i1 %40, label %while_body_4, label %while_end_5

while_body_4:
	%41 = load %Node_struct*, %Node_struct** %5
	%42 = bitcast %Node_struct* %41 to %ObjectStruct*
	%43 = bitcast %ObjectStruct* %42 to %Node_struct*
	%44 = getelementptr %Node_struct, %Node_struct* %43, i32 0, i32 0
	%45 = load i8*, i8** %44
	%46 = bitcast i8* %45 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%47 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %46, i32 0, i32 0
	%48 = load i8*, %ObjectStruct* (%ObjectStruct*)** %47
	%49 = bitcast i8* %48 to %IntStruct* (%Node_struct*)*
	%50 = call %IntStruct* %49(%ObjectStruct* %42)
	%51 = load %IntStruct*, %IntStruct** %4
	%52 = getelementptr %IntStruct, %IntStruct* %50, i32 0, i32 1
	%53 = load i32, i32* %52
	%54 = getelementptr %IntStruct, %IntStruct* %51, i32 0, i32 1
	%55 = load i32, i32* %54
	%56 = icmp eq i32 %53, %55
	%57 = call i8* @malloc(i64 16)
	%58 = bitcast i8* %57 to %BoolStruct*
	%59 = getelementptr %BoolStruct, %BoolStruct* %58, i32 0, i32 1
	store i1 %56, i1* %59
	%60 = getelementptr %BoolStruct, %BoolStruct* %58, i32 0, i32 1
	%61 = load i1, i1* %60
	%62 = icmp ne i1 %61, false
	br i1 %62, label %if_then_6, label %if_else_7

while_end_5:
	%63 = load %BoolStruct*, %BoolStruct** %19
	ret %BoolStruct* %63

if_then_6:
	%64 = call i8* @malloc(i64 16)
	%65 = bitcast i8* %64 to %BoolStruct*
	%66 = getelementptr %BoolStruct, %BoolStruct* %65, i32 0, i32 1
	store i1 true, i1* %66
	store %BoolStruct* %65, %BoolStruct** %19
	%67 = load %LinkedList_struct*, %LinkedList_struct** %3
	%68 = bitcast %LinkedList_struct* %67 to %LinkedList_struct*
	%69 = getelementptr %LinkedList_struct, %LinkedList_struct* %68, i32 0, i32 1
	%70 = load %Node_struct*, %Node_struct** %69
	store %Node_struct* %70, %Node_struct** %5
	br label %if_end_8

if_else_7:
	%71 = load %Node_struct*, %Node_struct** %5
	%72 = bitcast %Node_struct* %71 to %ObjectStruct*
	%73 = bitcast %ObjectStruct* %72 to %Node_struct*
	%74 = getelementptr %Node_struct, %Node_struct* %73, i32 0, i32 0
	%75 = load i8*, i8** %74
	%76 = bitcast i8* %75 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%77 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %76, i32 0, i32 2
	%78 = load i8*, %ObjectStruct* (%ObjectStruct*)** %77
	%79 = bitcast i8* %78 to %Node_struct* (%Node_struct*)*
	%80 = call %Node_struct* %79(%ObjectStruct* %72)
	store %Node_struct* %80, %Node_struct** %5
	br label %if_end_8

if_end_8:
	%81 = phi %Node_struct* [ %70, %if_then_6 ], [ %80, %if_else_7 ]
	br label %while_cond_3
}

define %Set_struct* @Set_init_set(%Set_struct* %self) {
entry:
	%0 = alloca %Set_struct*
	store %Set_struct* %self, %Set_struct** %0
	%1 = load %Set_struct*, %Set_struct** %0
	%2 = bitcast %Set_struct* %1 to %Set_struct*
	%3 = alloca %Set_struct*
	store %Set_struct* %2, %Set_struct** %3
	%4 = call i8* @malloc(i64 16)
	%5 = bitcast i8* %4 to %LinkedList_struct*
	%6 = getelementptr %LinkedList_struct, %LinkedList_struct* %5, i32 0, i32 0
	store i8* bitcast ([4 x i8*]* bitcast ([4 x i8*]* @vtable_LinkedList to [4 x i8*]*) to i8*), i8** %6
	%7 = load %Set_struct*, %Set_struct** %3
	%8 = getelementptr %LinkedList_struct*, %Set_struct* %7, i32 1
	store %LinkedList_struct* %5, %LinkedList_struct** %8
	%9 = load %Set_struct*, %Set_struct** %3
	%10 = bitcast %Set_struct* %9 to %Set_struct*
	%11 = getelementptr %Set_struct, %Set_struct* %10, i32 0, i32 1
	%12 = load %LinkedList_struct*, %LinkedList_struct** %11
	%13 = bitcast %LinkedList_struct* %12 to %ObjectStruct*
	%14 = bitcast %ObjectStruct* %13 to %LinkedList_struct*
	%15 = getelementptr %LinkedList_struct, %LinkedList_struct* %14, i32 0, i32 0
	%16 = load i8*, i8** %15
	%17 = bitcast i8* %16 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%18 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %17, i32 0, i32 0
	%19 = load i8*, %ObjectStruct* (%ObjectStruct*)** %18
	%20 = bitcast i8* %19 to %LinkedList_struct* (%LinkedList_struct*)*
	%21 = call %LinkedList_struct* %20(%ObjectStruct* %13)
	%22 = load %Set_struct*, %Set_struct** %3
	ret %Set_struct* %22
}

define %Set_struct* @Set_insert(%Set_struct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %Set_struct*
	store %Set_struct* %self, %Set_struct** %0
	%1 = load %Set_struct*, %Set_struct** %0
	%2 = bitcast %Set_struct* %1 to %Set_struct*
	%3 = alloca %Set_struct*
	store %Set_struct* %2, %Set_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = load %Set_struct*, %Set_struct** %3
	%6 = bitcast %Set_struct* %5 to %Set_struct*
	%7 = getelementptr %Set_struct, %Set_struct* %6, i32 0, i32 1
	%8 = load %LinkedList_struct*, %LinkedList_struct** %7
	%9 = bitcast %LinkedList_struct* %8 to %ObjectStruct*
	%10 = load %IntStruct*, %IntStruct** %4
	%11 = bitcast %ObjectStruct* %9 to %LinkedList_struct*
	%12 = getelementptr %LinkedList_struct, %LinkedList_struct* %11, i32 0, i32 0
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%15 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %14, i32 0, i32 3
	%16 = load i8*, %ObjectStruct* (%ObjectStruct*)** %15
	%17 = bitcast i8* %16 to %BoolStruct* (%LinkedList_struct*, %IntStruct*)*
	%18 = call %BoolStruct* %17(%ObjectStruct* %9, %IntStruct* %10)
	%19 = getelementptr %BoolStruct, %BoolStruct* %18, i32 0, i32 1
	%20 = load i1, i1* %19
	%21 = xor i1 %20, true
	%22 = call i8* @malloc(i64 16)
	%23 = bitcast i8* %22 to %BoolStruct*
	%24 = getelementptr %BoolStruct, %BoolStruct* %23, i32 0, i32 1
	store i1 %21, i1* %24
	%25 = getelementptr %BoolStruct, %BoolStruct* %23, i32 0, i32 1
	%26 = load i1, i1* %25
	%27 = icmp ne i1 %26, false
	br i1 %27, label %if_then_9, label %if_else_10

if_then_9:
	%28 = load %Set_struct*, %Set_struct** %3
	%29 = bitcast %Set_struct* %28 to %Set_struct*
	%30 = getelementptr %Set_struct, %Set_struct* %29, i32 0, i32 1
	%31 = load %LinkedList_struct*, %LinkedList_struct** %30
	%32 = bitcast %LinkedList_struct* %31 to %ObjectStruct*
	%33 = load %IntStruct*, %IntStruct** %4
	%34 = bitcast %ObjectStruct* %32 to %LinkedList_struct*
	%35 = getelementptr %LinkedList_struct, %LinkedList_struct* %34, i32 0, i32 0
	%36 = load i8*, i8** %35
	%37 = bitcast i8* %36 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%38 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %37, i32 0, i32 1
	%39 = load i8*, %ObjectStruct* (%ObjectStruct*)** %38
	%40 = bitcast i8* %39 to %LinkedList_struct* (%LinkedList_struct*, %IntStruct*)*
	%41 = call %LinkedList_struct* %40(%ObjectStruct* %32, %IntStruct* %33)
	br label %if_end_11

if_else_10:
	br label %if_end_11

if_end_11:
	%42 = phi %LinkedList_struct* [ %41, %if_then_9 ], [ null, %if_else_10 ]
	%43 = load %Set_struct*, %Set_struct** %3
	ret %Set_struct* %43
}

define %BoolStruct* @Set_has(%Set_struct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %Set_struct*
	store %Set_struct* %self, %Set_struct** %0
	%1 = load %Set_struct*, %Set_struct** %0
	%2 = bitcast %Set_struct* %1 to %Set_struct*
	%3 = alloca %Set_struct*
	store %Set_struct* %2, %Set_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = load %Set_struct*, %Set_struct** %3
	%6 = bitcast %Set_struct* %5 to %Set_struct*
	%7 = getelementptr %Set_struct, %Set_struct* %6, i32 0, i32 1
	%8 = load %LinkedList_struct*, %LinkedList_struct** %7
	%9 = bitcast %LinkedList_struct* %8 to %ObjectStruct*
	%10 = load %IntStruct*, %IntStruct** %4
	%11 = bitcast %ObjectStruct* %9 to %LinkedList_struct*
	%12 = getelementptr %LinkedList_struct, %LinkedList_struct* %11, i32 0, i32 0
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%15 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %14, i32 0, i32 3
	%16 = load i8*, %ObjectStruct* (%ObjectStruct*)** %15
	%17 = bitcast i8* %16 to %BoolStruct* (%LinkedList_struct*, %IntStruct*)*
	%18 = call %BoolStruct* %17(%ObjectStruct* %9, %IntStruct* %10)
	ret %BoolStruct* %18
}

define %Set_struct* @Set_print_set(%Set_struct* %self) {
entry:
	%0 = alloca %Set_struct*
	store %Set_struct* %self, %Set_struct** %0
	%1 = load %Set_struct*, %Set_struct** %0
	%2 = bitcast %Set_struct* %1 to %Set_struct*
	%3 = alloca %Set_struct*
	store %Set_struct* %2, %Set_struct** %3
	%4 = load %Set_struct*, %Set_struct** %3
	%5 = bitcast %Set_struct* %4 to %Set_struct*
	%6 = getelementptr %Set_struct, %Set_struct* %5, i32 0, i32 1
	%7 = load %LinkedList_struct*, %LinkedList_struct** %6
	%8 = bitcast %LinkedList_struct* %7 to %ObjectStruct*
	%9 = bitcast %ObjectStruct* %8 to %LinkedList_struct*
	%10 = getelementptr %LinkedList_struct, %LinkedList_struct* %9, i32 0, i32 0
	%11 = load i8*, i8** %10
	%12 = bitcast i8* %11 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%13 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %12, i32 0, i32 2
	%14 = load i8*, %ObjectStruct* (%ObjectStruct*)** %13
	%15 = bitcast i8* %14 to %LinkedList_struct* (%LinkedList_struct*)*
	%16 = call %LinkedList_struct* %15(%ObjectStruct* %8)
	%17 = load %Set_struct*, %Set_struct** %3
	ret %Set_struct* %17
}

define %ObjectStruct* @Main_main(%Main_struct* %self) {
entry:
	%0 = alloca %Main_struct*
	store %Main_struct* %self, %Main_struct** %0
	%1 = load %Main_struct*, %Main_struct** %0
	%2 = bitcast %Main_struct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = alloca %Set_struct*
	%5 = call i8* @malloc(i64 16)
	%6 = bitcast i8* %5 to %Set_struct*
	%7 = getelementptr %Set_struct, %Set_struct* %6, i32 0, i32 0
	store i8* bitcast ([4 x i8*]* bitcast ([4 x i8*]* @vtable_Set to [4 x i8*]*) to i8*), i8** %7
	store %Set_struct* %6, %Set_struct** %4
	%8 = load %Set_struct*, %Set_struct** %4
	%9 = bitcast %Set_struct* %8 to %ObjectStruct*
	%10 = bitcast %ObjectStruct* %9 to %Set_struct*
	%11 = getelementptr %Set_struct, %Set_struct* %10, i32 0, i32 0
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%14 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %13, i32 0, i32 0
	%15 = load i8*, %ObjectStruct* (%ObjectStruct*)** %14
	%16 = bitcast i8* %15 to %Set_struct* (%Set_struct*)*
	%17 = call %Set_struct* %16(%ObjectStruct* %9)
	%18 = load %Set_struct*, %Set_struct** %4
	%19 = bitcast %Set_struct* %18 to %ObjectStruct*
	%20 = call i8* @malloc(i64 16)
	%21 = bitcast i8* %20 to %IntStruct*
	%22 = getelementptr %IntStruct, %IntStruct* %21, i32 0, i32 1
	store i32 1, i32* %22
	%23 = bitcast %ObjectStruct* %19 to %Set_struct*
	%24 = getelementptr %Set_struct, %Set_struct* %23, i32 0, i32 0
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%27 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %26, i32 0, i32 1
	%28 = load i8*, %ObjectStruct* (%ObjectStruct*)** %27
	%29 = bitcast i8* %28 to %Set_struct* (%Set_struct*, %IntStruct*)*
	%30 = call %Set_struct* %29(%ObjectStruct* %19, %IntStruct* %21)
	%31 = load %Set_struct*, %Set_struct** %4
	%32 = bitcast %Set_struct* %31 to %ObjectStruct*
	%33 = call i8* @malloc(i64 16)
	%34 = bitcast i8* %33 to %IntStruct*
	%35 = getelementptr %IntStruct, %IntStruct* %34, i32 0, i32 1
	store i32 2, i32* %35
	%36 = bitcast %ObjectStruct* %32 to %Set_struct*
	%37 = getelementptr %Set_struct, %Set_struct* %36, i32 0, i32 0
	%38 = load i8*, i8** %37
	%39 = bitcast i8* %38 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%40 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %39, i32 0, i32 1
	%41 = load i8*, %ObjectStruct* (%ObjectStruct*)** %40
	%42 = bitcast i8* %41 to %Set_struct* (%Set_struct*, %IntStruct*)*
	%43 = call %Set_struct* %42(%ObjectStruct* %32, %IntStruct* %34)
	%44 = load %Set_struct*, %Set_struct** %4
	%45 = bitcast %Set_struct* %44 to %ObjectStruct*
	%46 = call i8* @malloc(i64 16)
	%47 = bitcast i8* %46 to %IntStruct*
	%48 = getelementptr %IntStruct, %IntStruct* %47, i32 0, i32 1
	store i32 3, i32* %48
	%49 = bitcast %ObjectStruct* %45 to %Set_struct*
	%50 = getelementptr %Set_struct, %Set_struct* %49, i32 0, i32 0
	%51 = load i8*, i8** %50
	%52 = bitcast i8* %51 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%53 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %52, i32 0, i32 1
	%54 = load i8*, %ObjectStruct* (%ObjectStruct*)** %53
	%55 = bitcast i8* %54 to %Set_struct* (%Set_struct*, %IntStruct*)*
	%56 = call %Set_struct* %55(%ObjectStruct* %45, %IntStruct* %47)
	%57 = load %Set_struct*, %Set_struct** %4
	%58 = bitcast %Set_struct* %57 to %ObjectStruct*
	%59 = call i8* @malloc(i64 16)
	%60 = bitcast i8* %59 to %IntStruct*
	%61 = getelementptr %IntStruct, %IntStruct* %60, i32 0, i32 1
	store i32 2, i32* %61
	%62 = bitcast %ObjectStruct* %58 to %Set_struct*
	%63 = getelementptr %Set_struct, %Set_struct* %62, i32 0, i32 0
	%64 = load i8*, i8** %63
	%65 = bitcast i8* %64 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%66 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %65, i32 0, i32 1
	%67 = load i8*, %ObjectStruct* (%ObjectStruct*)** %66
	%68 = bitcast i8* %67 to %Set_struct* (%Set_struct*, %IntStruct*)*
	%69 = call %Set_struct* %68(%ObjectStruct* %58, %IntStruct* %60)
	%70 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*), i32 0, i32 0
	%71 = load i8*, i8** %70
	%72 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%73 = call i32 (i8*, ...) @printf(i8* %72, i8* %71)
	%74 = load %Main_struct*, %Main_struct** %3
	%75 = load %Set_struct*, %Set_struct** %4
	%76 = bitcast %Set_struct* %75 to %ObjectStruct*
	%77 = bitcast %ObjectStruct* %76 to %Set_struct*
	%78 = getelementptr %Set_struct, %Set_struct* %77, i32 0, i32 0
	%79 = load i8*, i8** %78
	%80 = bitcast i8* %79 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%81 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %80, i32 0, i32 3
	%82 = load i8*, %ObjectStruct* (%ObjectStruct*)** %81
	%83 = bitcast i8* %82 to %Set_struct* (%Set_struct*)*
	%84 = call %Set_struct* %83(%ObjectStruct* %76)
	%85 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_11 to %StringStruct*), i32 0, i32 0
	%86 = load i8*, i8** %85
	%87 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%88 = call i32 (i8*, ...) @printf(i8* %87, i8* %86)
	%89 = load %Main_struct*, %Main_struct** %3
	%90 = load %Set_struct*, %Set_struct** %4
	%91 = bitcast %Set_struct* %90 to %ObjectStruct*
	%92 = call i8* @malloc(i64 16)
	%93 = bitcast i8* %92 to %IntStruct*
	%94 = getelementptr %IntStruct, %IntStruct* %93, i32 0, i32 1
	store i32 2, i32* %94
	%95 = bitcast %ObjectStruct* %91 to %Set_struct*
	%96 = getelementptr %Set_struct, %Set_struct* %95, i32 0, i32 0
	%97 = load i8*, i8** %96
	%98 = bitcast i8* %97 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%99 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %98, i32 0, i32 2
	%100 = load i8*, %ObjectStruct* (%ObjectStruct*)** %99
	%101 = bitcast i8* %100 to %BoolStruct* (%Set_struct*, %IntStruct*)*
	%102 = call %BoolStruct* %101(%ObjectStruct* %91, %IntStruct* %93)
	%103 = getelementptr %BoolStruct, %BoolStruct* %102, i32 0, i32 1
	%104 = load i1, i1* %103
	%105 = icmp ne i1 %104, false
	br i1 %105, label %if_then_12, label %if_else_13

if_then_12:
	%106 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_13 to %StringStruct*), i32 0, i32 0
	%107 = load i8*, i8** %106
	%108 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%109 = call i32 (i8*, ...) @printf(i8* %108, i8* %107)
	%110 = load %Main_struct*, %Main_struct** %3
	br label %if_end_14

if_else_13:
	%111 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_15 to %StringStruct*), i32 0, i32 0
	%112 = load i8*, i8** %111
	%113 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%114 = call i32 (i8*, ...) @printf(i8* %113, i8* %112)
	%115 = load %Main_struct*, %Main_struct** %3
	br label %if_end_14

if_end_14:
	%116 = phi %Main_struct* [ %110, %if_then_12 ], [ %115, %if_else_13 ]
	%117 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_17 to %StringStruct*), i32 0, i32 0
	%118 = load i8*, i8** %117
	%119 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%120 = call i32 (i8*, ...) @printf(i8* %119, i8* %118)
	%121 = load %Main_struct*, %Main_struct** %3
	%122 = load %Set_struct*, %Set_struct** %4
	%123 = bitcast %Set_struct* %122 to %ObjectStruct*
	%124 = call i8* @malloc(i64 16)
	%125 = bitcast i8* %124 to %IntStruct*
	%126 = getelementptr %IntStruct, %IntStruct* %125, i32 0, i32 1
	store i32 99, i32* %126
	%127 = bitcast %ObjectStruct* %123 to %Set_struct*
	%128 = getelementptr %Set_struct, %Set_struct* %127, i32 0, i32 0
	%129 = load i8*, i8** %128
	%130 = bitcast i8* %129 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%131 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %130, i32 0, i32 2
	%132 = load i8*, %ObjectStruct* (%ObjectStruct*)** %131
	%133 = bitcast i8* %132 to %BoolStruct* (%Set_struct*, %IntStruct*)*
	%134 = call %BoolStruct* %133(%ObjectStruct* %123, %IntStruct* %125)
	%135 = getelementptr %BoolStruct, %BoolStruct* %134, i32 0, i32 1
	%136 = load i1, i1* %135
	%137 = icmp ne i1 %136, false
	br i1 %137, label %if_then_15, label %if_else_16

if_then_15:
	%138 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_19 to %StringStruct*), i32 0, i32 0
	%139 = load i8*, i8** %138
	%140 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%141 = call i32 (i8*, ...) @printf(i8* %140, i8* %139)
	%142 = load %Main_struct*, %Main_struct** %3
	br label %if_end_17

if_else_16:
	%143 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_21 to %StringStruct*), i32 0, i32 0
	%144 = load i8*, i8** %143
	%145 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%146 = call i32 (i8*, ...) @printf(i8* %145, i8* %144)
	%147 = load %Main_struct*, %Main_struct** %3
	br label %if_end_17

if_end_17:
	%148 = phi %Main_struct* [ %142, %if_then_15 ], [ %147, %if_else_16 ]
	%149 = load %Main_struct*, %Main_struct** %3
	%150 = bitcast %Main_struct* %149 to %ObjectStruct*
	ret %ObjectStruct* %150
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
