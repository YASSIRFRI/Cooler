%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%ArrayStruct = type { i8*, i64, i8* }
%Node_struct = type { i8*, %IntStruct*, %Node_struct* }
%LinkedList_struct = type { i8*, %Node_struct* }
%SetLL_struct = type { i8*, %LinkedList_struct* }
%Main_struct = type { i8* }

@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@str_0 = global [7 x i8] c"String\00"
@str_obj_1 = constant { i8* } { i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_0, i32 0, i32 0) }
@str_2 = global [7 x i8] c"Object\00"
@str_obj_3 = constant { i8* } { i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_2, i32 0, i32 0) }
@vtable_String = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%StringStruct*)* @String_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null]
@vtable_Bool = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null]
@vtable_IO = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %StringStruct*)* @IO_out_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %IntStruct*)* @IO_out_int to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%IOStruct*)* @IO_in_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%IOStruct*)* @IO_in_int to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Array = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%ObjectStruct*)* @Array_length to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* (%ObjectStruct*, i64)* @Array_get to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (void (%ObjectStruct*, i64, i8*)* @Array_set to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ArrayStruct* (%ObjectStruct*, i64)* @Array_resize to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Object = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Int = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null, %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%ObjectStruct*)* @Int_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Node = constant [5 x i8*] [i8* bitcast (%IntStruct* (%ObjectStruct*)* @Node_get_value to i8*), i8* bitcast (%Node_struct* (%ObjectStruct*, %IntStruct*)* @Node_set_value to i8*), i8* bitcast (%Node_struct* (%ObjectStruct*)* @Node_get_next to i8*), i8* bitcast (%Node_struct* (%ObjectStruct*, %Node_struct*)* @Node_set_next to i8*), i8* bitcast (%Node_struct* (%ObjectStruct*)* @Node_init_node to i8*)]
@vtable_LinkedList = constant [5 x i8*] [i8* bitcast (%LinkedList_struct* (%ObjectStruct*)* @LinkedList_init_list to i8*), i8* bitcast (%LinkedList_struct* (%ObjectStruct*, %IntStruct*)* @LinkedList_insert to i8*), i8* bitcast (%LinkedList_struct* (%ObjectStruct*, %IntStruct*)* @LinkedList_delete to i8*), i8* bitcast (%BoolStruct* (%ObjectStruct*, %IntStruct*)* @LinkedList_search to i8*), i8* bitcast (%LinkedList_struct* (%ObjectStruct*)* @LinkedList_print to i8*)]
@vtable_SetLL = constant [5 x i8*] [i8* bitcast (%SetLL_struct* (%ObjectStruct*)* @SetLL_init_set to i8*), i8* bitcast (%SetLL_struct* (%ObjectStruct*, %IntStruct*)* @SetLL_insert to i8*), i8* bitcast (%BoolStruct* (%ObjectStruct*, %IntStruct*)* @SetLL_contains to i8*), i8* bitcast (%SetLL_struct* (%ObjectStruct*, %IntStruct*)* @SetLL_delete to i8*), i8* bitcast (%SetLL_struct* (%ObjectStruct*)* @SetLL_print_set to i8*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%ObjectStruct* (%ObjectStruct*)* @Main_main to i8*)]
@str_4 = global [2 x i8] c" \00"
@str_obj_5 = constant { i8* } { i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str_4, i32 0, i32 0) }
@str_6 = global [2 x i8] c"\0A\00"
@str_obj_7 = constant { i8* } { i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str_6, i32 0, i32 0) }
@str_8 = global [37 x i8] c"Current set contents (Linked List):\0A\00"
@str_obj_9 = constant { i8* } { i8* getelementptr inbounds ([37 x i8], [37 x i8]* @str_8, i32 0, i32 0) }
@str_10 = global [24 x i8] c"Deleting 2 from set...\0A\00"
@str_obj_11 = constant { i8* } { i8* getelementptr inbounds ([24 x i8], [24 x i8]* @str_10, i32 0, i32 0) }
@str_12 = global [13 x i8] c"Contains 2? \00"
@str_obj_13 = constant { i8* } { i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str_12, i32 0, i32 0) }
@str_14 = global [5 x i8] c"Yes\0A\00"
@str_obj_15 = constant { i8* } { i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str_14, i32 0, i32 0) }
@str_16 = global [4 x i8] c"No\0A\00"
@str_obj_17 = constant { i8* } { i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str_16, i32 0, i32 0) }

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

define %IntStruct* @Node_get_value(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = load %Node_struct*, %Node_struct** %3
	%5 = bitcast %Node_struct* %4 to %Node_struct*
	%6 = getelementptr %Node_struct, %Node_struct* %5, i32 0, i32 1
	%7 = load %IntStruct*, %IntStruct** %6
	ret %IntStruct* %7
}

define %Node_struct* @Node_set_value(%ObjectStruct* %self, %IntStruct* %v) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %v, %IntStruct** %4
	%5 = load %IntStruct*, %IntStruct** %4
	%6 = load %Node_struct*, %Node_struct** %3
	%7 = bitcast %Node_struct* %6 to %Node_struct*
	%8 = getelementptr %Node_struct, %Node_struct* %7, i32 0, i32 1
	store %IntStruct* %5, %IntStruct** %8
	%9 = load %Node_struct*, %Node_struct** %3
	ret %Node_struct* %9
}

define %Node_struct* @Node_get_next(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = load %Node_struct*, %Node_struct** %3
	%5 = bitcast %Node_struct* %4 to %Node_struct*
	%6 = getelementptr %Node_struct, %Node_struct* %5, i32 0, i32 2
	%7 = load %Node_struct*, %Node_struct** %6
	ret %Node_struct* %7
}

define %Node_struct* @Node_set_next(%ObjectStruct* %self, %Node_struct* %n) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = alloca %Node_struct*
	store %Node_struct* %n, %Node_struct** %4
	%5 = load %Node_struct*, %Node_struct** %4
	%6 = load %Node_struct*, %Node_struct** %3
	%7 = bitcast %Node_struct* %6 to %Node_struct*
	%8 = getelementptr %Node_struct, %Node_struct* %7, i32 0, i32 2
	store %Node_struct* %5, %Node_struct** %8
	%9 = load %Node_struct*, %Node_struct** %3
	ret %Node_struct* %9
}

define %Node_struct* @Node_init_node(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = call i8* @malloc(i64 16)
	%5 = bitcast i8* %4 to %IntStruct*
	%6 = getelementptr %IntStruct, %IntStruct* %5, i32 0, i32 1
	store i32 0, i32* %6
	%7 = load %Node_struct*, %Node_struct** %3
	%8 = bitcast %Node_struct* %7 to %Node_struct*
	%9 = getelementptr %Node_struct, %Node_struct* %8, i32 0, i32 1
	store %IntStruct* %5, %IntStruct** %9
	%10 = load %Node_struct*, %Node_struct** %3
	%11 = load %Node_struct*, %Node_struct** %3
	%12 = bitcast %Node_struct* %11 to %Node_struct*
	%13 = getelementptr %Node_struct, %Node_struct* %12, i32 0, i32 2
	store %Node_struct* %10, %Node_struct** %13
	%14 = load %Node_struct*, %Node_struct** %3
	ret %Node_struct* %14
}

define %LinkedList_struct* @LinkedList_init_list(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %LinkedList_struct*
	%3 = alloca %LinkedList_struct*
	store %LinkedList_struct* %2, %LinkedList_struct** %3
	%4 = call i8* @malloc(i64 24)
	%5 = bitcast i8* %4 to %Node_struct*
	%6 = getelementptr %Node_struct, %Node_struct* %5, i32 0, i32 0
	store i8* bitcast ([5 x i8*]* bitcast ([5 x i8*]* @vtable_Node to [5 x i8*]*) to i8*), i8** %6
	%7 = load %LinkedList_struct*, %LinkedList_struct** %3
	%8 = bitcast %LinkedList_struct* %7 to %LinkedList_struct*
	%9 = getelementptr %LinkedList_struct, %LinkedList_struct* %8, i32 0, i32 1
	store %Node_struct* %5, %Node_struct** %9
	%10 = load %LinkedList_struct*, %LinkedList_struct** %3
	%11 = bitcast %LinkedList_struct* %10 to %LinkedList_struct*
	%12 = getelementptr %LinkedList_struct, %LinkedList_struct* %11, i32 0, i32 1
	%13 = load %Node_struct*, %Node_struct** %12
	%14 = bitcast %Node_struct* %13 to %ObjectStruct*
	%15 = bitcast %ObjectStruct* %14 to %Node_struct*
	%16 = getelementptr %Node_struct, %Node_struct* %15, i32 0, i32 0
	%17 = load i8*, i8** %16
	%18 = bitcast i8* %17 to [5 x i8*]*
	%19 = getelementptr [5 x i8*], [5 x i8*]* %18, i32 0, i32 4
	%20 = load i8*, i8** %19
	%21 = bitcast i8* %20 to %Node_struct* (%ObjectStruct*)*
	%22 = call %Node_struct* %21(%ObjectStruct* %14)
	%23 = load %LinkedList_struct*, %LinkedList_struct** %3
	ret %LinkedList_struct* %23
}

define %LinkedList_struct* @LinkedList_insert(%ObjectStruct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %LinkedList_struct*
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
	%15 = bitcast i8* %14 to [5 x i8*]*
	%16 = getelementptr [5 x i8*], [5 x i8*]* %15, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = bitcast i8* %17 to %Node_struct* (%ObjectStruct*, %IntStruct*)*
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
	%30 = bitcast i8* %29 to [5 x i8*]*
	%31 = getelementptr [5 x i8*], [5 x i8*]* %30, i32 0, i32 2
	%32 = load i8*, i8** %31
	%33 = bitcast i8* %32 to %Node_struct* (%ObjectStruct*)*
	%34 = call %Node_struct* %33(%ObjectStruct* %26)
	%35 = bitcast %ObjectStruct* %21 to %Node_struct*
	%36 = getelementptr %Node_struct, %Node_struct* %35, i32 0, i32 0
	%37 = load i8*, i8** %36
	%38 = bitcast i8* %37 to [5 x i8*]*
	%39 = getelementptr [5 x i8*], [5 x i8*]* %38, i32 0, i32 3
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to %Node_struct* (%ObjectStruct*, %Node_struct*)*
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
	%52 = bitcast i8* %51 to [5 x i8*]*
	%53 = getelementptr [5 x i8*], [5 x i8*]* %52, i32 0, i32 3
	%54 = load i8*, i8** %53
	%55 = bitcast i8* %54 to %Node_struct* (%ObjectStruct*, %Node_struct*)*
	%56 = call %Node_struct* %55(%ObjectStruct* %47, %Node_struct* %48)
	%57 = load %LinkedList_struct*, %LinkedList_struct** %3
	ret %LinkedList_struct* %57
}

define %LinkedList_struct* @LinkedList_delete(%ObjectStruct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %LinkedList_struct*
	%3 = alloca %LinkedList_struct*
	store %LinkedList_struct* %2, %LinkedList_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = alloca %Node_struct*
	%6 = load %LinkedList_struct*, %LinkedList_struct** %3
	%7 = bitcast %LinkedList_struct* %6 to %LinkedList_struct*
	%8 = getelementptr %LinkedList_struct, %LinkedList_struct* %7, i32 0, i32 1
	%9 = load %Node_struct*, %Node_struct** %8
	store %Node_struct* %9, %Node_struct** %5
	%10 = alloca %Node_struct*
	%11 = load %LinkedList_struct*, %LinkedList_struct** %3
	%12 = bitcast %LinkedList_struct* %11 to %LinkedList_struct*
	%13 = getelementptr %LinkedList_struct, %LinkedList_struct* %12, i32 0, i32 1
	%14 = load %Node_struct*, %Node_struct** %13
	%15 = bitcast %Node_struct* %14 to %ObjectStruct*
	%16 = bitcast %ObjectStruct* %15 to %Node_struct*
	%17 = getelementptr %Node_struct, %Node_struct* %16, i32 0, i32 0
	%18 = load i8*, i8** %17
	%19 = bitcast i8* %18 to [5 x i8*]*
	%20 = getelementptr [5 x i8*], [5 x i8*]* %19, i32 0, i32 2
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to %Node_struct* (%ObjectStruct*)*
	%23 = call %Node_struct* %22(%ObjectStruct* %15)
	store %Node_struct* %23, %Node_struct** %10
	br label %while_cond_0

while_cond_0:
	%24 = load %Node_struct*, %Node_struct** %10
	%25 = load %LinkedList_struct*, %LinkedList_struct** %3
	%26 = bitcast %LinkedList_struct* %25 to %LinkedList_struct*
	%27 = getelementptr %LinkedList_struct, %LinkedList_struct* %26, i32 0, i32 1
	%28 = load %Node_struct*, %Node_struct** %27
	%29 = icmp eq %Node_struct* %24, %28
	%30 = call i8* @malloc(i64 16)
	%31 = bitcast i8* %30 to %BoolStruct*
	%32 = getelementptr %BoolStruct, %BoolStruct* %31, i32 0, i32 1
	store i1 %29, i1* %32
	%33 = getelementptr %BoolStruct, %BoolStruct* %31, i32 0, i32 1
	%34 = load i1, i1* %33
	%35 = xor i1 %34, true
	%36 = call i8* @malloc(i64 16)
	%37 = bitcast i8* %36 to %BoolStruct*
	%38 = getelementptr %BoolStruct, %BoolStruct* %37, i32 0, i32 1
	store i1 %35, i1* %38
	%39 = getelementptr %BoolStruct, %BoolStruct* %37, i32 0, i32 1
	%40 = load i1, i1* %39
	%41 = icmp ne i1 %40, false
	br i1 %41, label %while_body_1, label %while_end_2

while_body_1:
	%42 = load %Node_struct*, %Node_struct** %10
	%43 = bitcast %Node_struct* %42 to %ObjectStruct*
	%44 = bitcast %ObjectStruct* %43 to %Node_struct*
	%45 = getelementptr %Node_struct, %Node_struct* %44, i32 0, i32 0
	%46 = load i8*, i8** %45
	%47 = bitcast i8* %46 to [5 x i8*]*
	%48 = getelementptr [5 x i8*], [5 x i8*]* %47, i32 0, i32 0
	%49 = load i8*, i8** %48
	%50 = bitcast i8* %49 to %IntStruct* (%ObjectStruct*)*
	%51 = call %IntStruct* %50(%ObjectStruct* %43)
	%52 = load %IntStruct*, %IntStruct** %4
	%53 = getelementptr %IntStruct, %IntStruct* %51, i32 0, i32 1
	%54 = load i32, i32* %53
	%55 = getelementptr %IntStruct, %IntStruct* %52, i32 0, i32 1
	%56 = load i32, i32* %55
	%57 = icmp eq i32 %54, %56
	%58 = call i8* @malloc(i64 16)
	%59 = bitcast i8* %58 to %BoolStruct*
	%60 = getelementptr %BoolStruct, %BoolStruct* %59, i32 0, i32 1
	store i1 %57, i1* %60
	%61 = getelementptr %BoolStruct, %BoolStruct* %59, i32 0, i32 1
	%62 = load i1, i1* %61
	%63 = icmp ne i1 %62, false
	br i1 %63, label %if_then_3, label %if_else_4

while_end_2:
	%64 = load %LinkedList_struct*, %LinkedList_struct** %3
	ret %LinkedList_struct* %64

if_then_3:
	%65 = load %Node_struct*, %Node_struct** %5
	%66 = bitcast %Node_struct* %65 to %ObjectStruct*
	%67 = load %Node_struct*, %Node_struct** %10
	%68 = bitcast %Node_struct* %67 to %ObjectStruct*
	%69 = bitcast %ObjectStruct* %68 to %Node_struct*
	%70 = getelementptr %Node_struct, %Node_struct* %69, i32 0, i32 0
	%71 = load i8*, i8** %70
	%72 = bitcast i8* %71 to [5 x i8*]*
	%73 = getelementptr [5 x i8*], [5 x i8*]* %72, i32 0, i32 2
	%74 = load i8*, i8** %73
	%75 = bitcast i8* %74 to %Node_struct* (%ObjectStruct*)*
	%76 = call %Node_struct* %75(%ObjectStruct* %68)
	%77 = bitcast %ObjectStruct* %66 to %Node_struct*
	%78 = getelementptr %Node_struct, %Node_struct* %77, i32 0, i32 0
	%79 = load i8*, i8** %78
	%80 = bitcast i8* %79 to [5 x i8*]*
	%81 = getelementptr [5 x i8*], [5 x i8*]* %80, i32 0, i32 3
	%82 = load i8*, i8** %81
	%83 = bitcast i8* %82 to %Node_struct* (%ObjectStruct*, %Node_struct*)*
	%84 = call %Node_struct* %83(%ObjectStruct* %66, %Node_struct* %76)
	%85 = load %LinkedList_struct*, %LinkedList_struct** %3
	%86 = bitcast %LinkedList_struct* %85 to %LinkedList_struct*
	%87 = getelementptr %LinkedList_struct, %LinkedList_struct* %86, i32 0, i32 1
	%88 = load %Node_struct*, %Node_struct** %87
	store %Node_struct* %88, %Node_struct** %10
	br label %if_end_5

if_else_4:
	%89 = load %Node_struct*, %Node_struct** %10
	store %Node_struct* %89, %Node_struct** %5
	%90 = load %Node_struct*, %Node_struct** %10
	%91 = bitcast %Node_struct* %90 to %ObjectStruct*
	%92 = bitcast %ObjectStruct* %91 to %Node_struct*
	%93 = getelementptr %Node_struct, %Node_struct* %92, i32 0, i32 0
	%94 = load i8*, i8** %93
	%95 = bitcast i8* %94 to [5 x i8*]*
	%96 = getelementptr [5 x i8*], [5 x i8*]* %95, i32 0, i32 2
	%97 = load i8*, i8** %96
	%98 = bitcast i8* %97 to %Node_struct* (%ObjectStruct*)*
	%99 = call %Node_struct* %98(%ObjectStruct* %91)
	store %Node_struct* %99, %Node_struct** %10
	br label %if_end_5

if_end_5:
	%100 = phi %Node_struct* [ %88, %if_then_3 ], [ %99, %if_else_4 ]
	br label %while_cond_0
}

define %BoolStruct* @LinkedList_search(%ObjectStruct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %LinkedList_struct*
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
	%14 = bitcast i8* %13 to [5 x i8*]*
	%15 = getelementptr [5 x i8*], [5 x i8*]* %14, i32 0, i32 2
	%16 = load i8*, i8** %15
	%17 = bitcast i8* %16 to %Node_struct* (%ObjectStruct*)*
	%18 = call %Node_struct* %17(%ObjectStruct* %10)
	store %Node_struct* %18, %Node_struct** %5
	%19 = alloca %BoolStruct*
	%20 = call i8* @malloc(i64 16)
	%21 = bitcast i8* %20 to %BoolStruct*
	%22 = getelementptr %BoolStruct, %BoolStruct* %21, i32 0, i32 1
	store i1 false, i1* %22
	store %BoolStruct* %21, %BoolStruct** %19
	br label %while_cond_6

while_cond_6:
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
	br i1 %40, label %while_body_7, label %while_end_8

while_body_7:
	%41 = load %Node_struct*, %Node_struct** %5
	%42 = bitcast %Node_struct* %41 to %ObjectStruct*
	%43 = bitcast %ObjectStruct* %42 to %Node_struct*
	%44 = getelementptr %Node_struct, %Node_struct* %43, i32 0, i32 0
	%45 = load i8*, i8** %44
	%46 = bitcast i8* %45 to [5 x i8*]*
	%47 = getelementptr [5 x i8*], [5 x i8*]* %46, i32 0, i32 0
	%48 = load i8*, i8** %47
	%49 = bitcast i8* %48 to %IntStruct* (%ObjectStruct*)*
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
	br i1 %62, label %if_then_9, label %if_else_10

while_end_8:
	%63 = load %BoolStruct*, %BoolStruct** %19
	ret %BoolStruct* %63

if_then_9:
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
	br label %if_end_11

if_else_10:
	%71 = load %Node_struct*, %Node_struct** %5
	%72 = bitcast %Node_struct* %71 to %ObjectStruct*
	%73 = bitcast %ObjectStruct* %72 to %Node_struct*
	%74 = getelementptr %Node_struct, %Node_struct* %73, i32 0, i32 0
	%75 = load i8*, i8** %74
	%76 = bitcast i8* %75 to [5 x i8*]*
	%77 = getelementptr [5 x i8*], [5 x i8*]* %76, i32 0, i32 2
	%78 = load i8*, i8** %77
	%79 = bitcast i8* %78 to %Node_struct* (%ObjectStruct*)*
	%80 = call %Node_struct* %79(%ObjectStruct* %72)
	store %Node_struct* %80, %Node_struct** %5
	br label %if_end_11

if_end_11:
	%81 = phi %Node_struct* [ %70, %if_then_9 ], [ %80, %if_else_10 ]
	br label %while_cond_6
}

define %LinkedList_struct* @LinkedList_print(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %LinkedList_struct*
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
	%13 = bitcast i8* %12 to [5 x i8*]*
	%14 = getelementptr [5 x i8*], [5 x i8*]* %13, i32 0, i32 2
	%15 = load i8*, i8** %14
	%16 = bitcast i8* %15 to %Node_struct* (%ObjectStruct*)*
	%17 = call %Node_struct* %16(%ObjectStruct* %9)
	store %Node_struct* %17, %Node_struct** %4
	br label %while_cond_12

while_cond_12:
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
	br i1 %35, label %while_body_13, label %while_end_14

while_body_13:
	%36 = load %Node_struct*, %Node_struct** %4
	%37 = bitcast %Node_struct* %36 to %ObjectStruct*
	%38 = bitcast %ObjectStruct* %37 to %Node_struct*
	%39 = getelementptr %Node_struct, %Node_struct* %38, i32 0, i32 0
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to [5 x i8*]*
	%42 = getelementptr [5 x i8*], [5 x i8*]* %41, i32 0, i32 0
	%43 = load i8*, i8** %42
	%44 = bitcast i8* %43 to %IntStruct* (%ObjectStruct*)*
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
	%61 = bitcast i8* %60 to [5 x i8*]*
	%62 = getelementptr [5 x i8*], [5 x i8*]* %61, i32 0, i32 2
	%63 = load i8*, i8** %62
	%64 = bitcast i8* %63 to %Node_struct* (%ObjectStruct*)*
	%65 = call %Node_struct* %64(%ObjectStruct* %57)
	store %Node_struct* %65, %Node_struct** %4
	br label %while_cond_12

while_end_14:
	%66 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%67 = load i8*, i8** %66
	%68 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%69 = call i32 (i8*, ...) @printf(i8* %68, i8* %67)
	%70 = load %LinkedList_struct*, %LinkedList_struct** %3
	%71 = load %LinkedList_struct*, %LinkedList_struct** %3
	ret %LinkedList_struct* %71
}

define %SetLL_struct* @SetLL_init_set(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %SetLL_struct*
	%3 = alloca %SetLL_struct*
	store %SetLL_struct* %2, %SetLL_struct** %3
	%4 = call i8* @malloc(i64 16)
	%5 = bitcast i8* %4 to %LinkedList_struct*
	%6 = getelementptr %LinkedList_struct, %LinkedList_struct* %5, i32 0, i32 0
	store i8* bitcast ([5 x i8*]* bitcast ([5 x i8*]* @vtable_LinkedList to [5 x i8*]*) to i8*), i8** %6
	%7 = load %SetLL_struct*, %SetLL_struct** %3
	%8 = bitcast %SetLL_struct* %7 to %SetLL_struct*
	%9 = getelementptr %SetLL_struct, %SetLL_struct* %8, i32 0, i32 1
	store %LinkedList_struct* %5, %LinkedList_struct** %9
	%10 = load %SetLL_struct*, %SetLL_struct** %3
	%11 = bitcast %SetLL_struct* %10 to %SetLL_struct*
	%12 = getelementptr %SetLL_struct, %SetLL_struct* %11, i32 0, i32 1
	%13 = load %LinkedList_struct*, %LinkedList_struct** %12
	%14 = bitcast %LinkedList_struct* %13 to %ObjectStruct*
	%15 = bitcast %ObjectStruct* %14 to %LinkedList_struct*
	%16 = getelementptr %LinkedList_struct, %LinkedList_struct* %15, i32 0, i32 0
	%17 = load i8*, i8** %16
	%18 = bitcast i8* %17 to [5 x i8*]*
	%19 = getelementptr [5 x i8*], [5 x i8*]* %18, i32 0, i32 0
	%20 = load i8*, i8** %19
	%21 = bitcast i8* %20 to %LinkedList_struct* (%ObjectStruct*)*
	%22 = call %LinkedList_struct* %21(%ObjectStruct* %14)
	%23 = load %SetLL_struct*, %SetLL_struct** %3
	ret %SetLL_struct* %23
}

define %SetLL_struct* @SetLL_insert(%ObjectStruct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %SetLL_struct*
	%3 = alloca %SetLL_struct*
	store %SetLL_struct* %2, %SetLL_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = load %SetLL_struct*, %SetLL_struct** %3
	%6 = bitcast %SetLL_struct* %5 to %SetLL_struct*
	%7 = getelementptr %SetLL_struct, %SetLL_struct* %6, i32 0, i32 1
	%8 = load %LinkedList_struct*, %LinkedList_struct** %7
	%9 = bitcast %LinkedList_struct* %8 to %ObjectStruct*
	%10 = load %IntStruct*, %IntStruct** %4
	%11 = bitcast %ObjectStruct* %9 to %LinkedList_struct*
	%12 = getelementptr %LinkedList_struct, %LinkedList_struct* %11, i32 0, i32 0
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to [5 x i8*]*
	%15 = getelementptr [5 x i8*], [5 x i8*]* %14, i32 0, i32 3
	%16 = load i8*, i8** %15
	%17 = bitcast i8* %16 to %BoolStruct* (%ObjectStruct*, %IntStruct*)*
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
	br i1 %27, label %if_then_15, label %if_else_16

if_then_15:
	%28 = load %SetLL_struct*, %SetLL_struct** %3
	%29 = bitcast %SetLL_struct* %28 to %SetLL_struct*
	%30 = getelementptr %SetLL_struct, %SetLL_struct* %29, i32 0, i32 1
	%31 = load %LinkedList_struct*, %LinkedList_struct** %30
	%32 = bitcast %LinkedList_struct* %31 to %ObjectStruct*
	%33 = load %IntStruct*, %IntStruct** %4
	%34 = bitcast %ObjectStruct* %32 to %LinkedList_struct*
	%35 = getelementptr %LinkedList_struct, %LinkedList_struct* %34, i32 0, i32 0
	%36 = load i8*, i8** %35
	%37 = bitcast i8* %36 to [5 x i8*]*
	%38 = getelementptr [5 x i8*], [5 x i8*]* %37, i32 0, i32 1
	%39 = load i8*, i8** %38
	%40 = bitcast i8* %39 to %LinkedList_struct* (%ObjectStruct*, %IntStruct*)*
	%41 = call %LinkedList_struct* %40(%ObjectStruct* %32, %IntStruct* %33)
	br label %if_end_17

if_else_16:
	br label %if_end_17

if_end_17:
	%42 = phi %LinkedList_struct* [ %41, %if_then_15 ], [ null, %if_else_16 ]
	%43 = load %SetLL_struct*, %SetLL_struct** %3
	ret %SetLL_struct* %43
}

define %BoolStruct* @SetLL_contains(%ObjectStruct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %SetLL_struct*
	%3 = alloca %SetLL_struct*
	store %SetLL_struct* %2, %SetLL_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = load %SetLL_struct*, %SetLL_struct** %3
	%6 = bitcast %SetLL_struct* %5 to %SetLL_struct*
	%7 = getelementptr %SetLL_struct, %SetLL_struct* %6, i32 0, i32 1
	%8 = load %LinkedList_struct*, %LinkedList_struct** %7
	%9 = bitcast %LinkedList_struct* %8 to %ObjectStruct*
	%10 = load %IntStruct*, %IntStruct** %4
	%11 = bitcast %ObjectStruct* %9 to %LinkedList_struct*
	%12 = getelementptr %LinkedList_struct, %LinkedList_struct* %11, i32 0, i32 0
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to [5 x i8*]*
	%15 = getelementptr [5 x i8*], [5 x i8*]* %14, i32 0, i32 3
	%16 = load i8*, i8** %15
	%17 = bitcast i8* %16 to %BoolStruct* (%ObjectStruct*, %IntStruct*)*
	%18 = call %BoolStruct* %17(%ObjectStruct* %9, %IntStruct* %10)
	ret %BoolStruct* %18
}

define %SetLL_struct* @SetLL_delete(%ObjectStruct* %self, %IntStruct* %val) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %SetLL_struct*
	%3 = alloca %SetLL_struct*
	store %SetLL_struct* %2, %SetLL_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %val, %IntStruct** %4
	%5 = load %SetLL_struct*, %SetLL_struct** %3
	%6 = bitcast %SetLL_struct* %5 to %SetLL_struct*
	%7 = getelementptr %SetLL_struct, %SetLL_struct* %6, i32 0, i32 1
	%8 = load %LinkedList_struct*, %LinkedList_struct** %7
	%9 = bitcast %LinkedList_struct* %8 to %ObjectStruct*
	%10 = load %IntStruct*, %IntStruct** %4
	%11 = bitcast %ObjectStruct* %9 to %LinkedList_struct*
	%12 = getelementptr %LinkedList_struct, %LinkedList_struct* %11, i32 0, i32 0
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to [5 x i8*]*
	%15 = getelementptr [5 x i8*], [5 x i8*]* %14, i32 0, i32 2
	%16 = load i8*, i8** %15
	%17 = bitcast i8* %16 to %LinkedList_struct* (%ObjectStruct*, %IntStruct*)*
	%18 = call %LinkedList_struct* %17(%ObjectStruct* %9, %IntStruct* %10)
	%19 = load %SetLL_struct*, %SetLL_struct** %3
	ret %SetLL_struct* %19
}

define %SetLL_struct* @SetLL_print_set(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %SetLL_struct*
	%3 = alloca %SetLL_struct*
	store %SetLL_struct* %2, %SetLL_struct** %3
	%4 = load %SetLL_struct*, %SetLL_struct** %3
	%5 = bitcast %SetLL_struct* %4 to %SetLL_struct*
	%6 = getelementptr %SetLL_struct, %SetLL_struct* %5, i32 0, i32 1
	%7 = load %LinkedList_struct*, %LinkedList_struct** %6
	%8 = bitcast %LinkedList_struct* %7 to %ObjectStruct*
	%9 = bitcast %ObjectStruct* %8 to %LinkedList_struct*
	%10 = getelementptr %LinkedList_struct, %LinkedList_struct* %9, i32 0, i32 0
	%11 = load i8*, i8** %10
	%12 = bitcast i8* %11 to [5 x i8*]*
	%13 = getelementptr [5 x i8*], [5 x i8*]* %12, i32 0, i32 4
	%14 = load i8*, i8** %13
	%15 = bitcast i8* %14 to %LinkedList_struct* (%ObjectStruct*)*
	%16 = call %LinkedList_struct* %15(%ObjectStruct* %8)
	%17 = load %SetLL_struct*, %SetLL_struct** %3
	ret %SetLL_struct* %17
}

define %ObjectStruct* @Main_main(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = alloca %SetLL_struct*
	%5 = call i8* @malloc(i64 16)
	%6 = bitcast i8* %5 to %SetLL_struct*
	%7 = getelementptr %SetLL_struct, %SetLL_struct* %6, i32 0, i32 0
	store i8* bitcast ([5 x i8*]* bitcast ([5 x i8*]* @vtable_SetLL to [5 x i8*]*) to i8*), i8** %7
	store %SetLL_struct* %6, %SetLL_struct** %4
	%8 = load %SetLL_struct*, %SetLL_struct** %4
	%9 = bitcast %SetLL_struct* %8 to %ObjectStruct*
	%10 = bitcast %ObjectStruct* %9 to %SetLL_struct*
	%11 = getelementptr %SetLL_struct, %SetLL_struct* %10, i32 0, i32 0
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to [5 x i8*]*
	%14 = getelementptr [5 x i8*], [5 x i8*]* %13, i32 0, i32 0
	%15 = load i8*, i8** %14
	%16 = bitcast i8* %15 to %SetLL_struct* (%ObjectStruct*)*
	%17 = call %SetLL_struct* %16(%ObjectStruct* %9)
	%18 = load %SetLL_struct*, %SetLL_struct** %4
	%19 = bitcast %SetLL_struct* %18 to %ObjectStruct*
	%20 = call i8* @malloc(i64 16)
	%21 = bitcast i8* %20 to %IntStruct*
	%22 = getelementptr %IntStruct, %IntStruct* %21, i32 0, i32 1
	store i32 1, i32* %22
	%23 = bitcast %ObjectStruct* %19 to %SetLL_struct*
	%24 = getelementptr %SetLL_struct, %SetLL_struct* %23, i32 0, i32 0
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to [5 x i8*]*
	%27 = getelementptr [5 x i8*], [5 x i8*]* %26, i32 0, i32 1
	%28 = load i8*, i8** %27
	%29 = bitcast i8* %28 to %SetLL_struct* (%ObjectStruct*, %IntStruct*)*
	%30 = call %SetLL_struct* %29(%ObjectStruct* %19, %IntStruct* %21)
	%31 = load %SetLL_struct*, %SetLL_struct** %4
	%32 = bitcast %SetLL_struct* %31 to %ObjectStruct*
	%33 = call i8* @malloc(i64 16)
	%34 = bitcast i8* %33 to %IntStruct*
	%35 = getelementptr %IntStruct, %IntStruct* %34, i32 0, i32 1
	store i32 2, i32* %35
	%36 = bitcast %ObjectStruct* %32 to %SetLL_struct*
	%37 = getelementptr %SetLL_struct, %SetLL_struct* %36, i32 0, i32 0
	%38 = load i8*, i8** %37
	%39 = bitcast i8* %38 to [5 x i8*]*
	%40 = getelementptr [5 x i8*], [5 x i8*]* %39, i32 0, i32 1
	%41 = load i8*, i8** %40
	%42 = bitcast i8* %41 to %SetLL_struct* (%ObjectStruct*, %IntStruct*)*
	%43 = call %SetLL_struct* %42(%ObjectStruct* %32, %IntStruct* %34)
	%44 = load %SetLL_struct*, %SetLL_struct** %4
	%45 = bitcast %SetLL_struct* %44 to %ObjectStruct*
	%46 = call i8* @malloc(i64 16)
	%47 = bitcast i8* %46 to %IntStruct*
	%48 = getelementptr %IntStruct, %IntStruct* %47, i32 0, i32 1
	store i32 3, i32* %48
	%49 = bitcast %ObjectStruct* %45 to %SetLL_struct*
	%50 = getelementptr %SetLL_struct, %SetLL_struct* %49, i32 0, i32 0
	%51 = load i8*, i8** %50
	%52 = bitcast i8* %51 to [5 x i8*]*
	%53 = getelementptr [5 x i8*], [5 x i8*]* %52, i32 0, i32 1
	%54 = load i8*, i8** %53
	%55 = bitcast i8* %54 to %SetLL_struct* (%ObjectStruct*, %IntStruct*)*
	%56 = call %SetLL_struct* %55(%ObjectStruct* %45, %IntStruct* %47)
	%57 = load %SetLL_struct*, %SetLL_struct** %4
	%58 = bitcast %SetLL_struct* %57 to %ObjectStruct*
	%59 = call i8* @malloc(i64 16)
	%60 = bitcast i8* %59 to %IntStruct*
	%61 = getelementptr %IntStruct, %IntStruct* %60, i32 0, i32 1
	store i32 2, i32* %61
	%62 = bitcast %ObjectStruct* %58 to %SetLL_struct*
	%63 = getelementptr %SetLL_struct, %SetLL_struct* %62, i32 0, i32 0
	%64 = load i8*, i8** %63
	%65 = bitcast i8* %64 to [5 x i8*]*
	%66 = getelementptr [5 x i8*], [5 x i8*]* %65, i32 0, i32 1
	%67 = load i8*, i8** %66
	%68 = bitcast i8* %67 to %SetLL_struct* (%ObjectStruct*, %IntStruct*)*
	%69 = call %SetLL_struct* %68(%ObjectStruct* %58, %IntStruct* %60)
	%70 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*), i32 0, i32 0
	%71 = load i8*, i8** %70
	%72 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%73 = call i32 (i8*, ...) @printf(i8* %72, i8* %71)
	%74 = load %Main_struct*, %Main_struct** %3
	%75 = load %SetLL_struct*, %SetLL_struct** %4
	%76 = bitcast %SetLL_struct* %75 to %ObjectStruct*
	%77 = bitcast %ObjectStruct* %76 to %SetLL_struct*
	%78 = getelementptr %SetLL_struct, %SetLL_struct* %77, i32 0, i32 0
	%79 = load i8*, i8** %78
	%80 = bitcast i8* %79 to [5 x i8*]*
	%81 = getelementptr [5 x i8*], [5 x i8*]* %80, i32 0, i32 4
	%82 = load i8*, i8** %81
	%83 = bitcast i8* %82 to %SetLL_struct* (%ObjectStruct*)*
	%84 = call %SetLL_struct* %83(%ObjectStruct* %76)
	%85 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_11 to %StringStruct*), i32 0, i32 0
	%86 = load i8*, i8** %85
	%87 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%88 = call i32 (i8*, ...) @printf(i8* %87, i8* %86)
	%89 = load %Main_struct*, %Main_struct** %3
	%90 = load %SetLL_struct*, %SetLL_struct** %4
	%91 = bitcast %SetLL_struct* %90 to %ObjectStruct*
	%92 = call i8* @malloc(i64 16)
	%93 = bitcast i8* %92 to %IntStruct*
	%94 = getelementptr %IntStruct, %IntStruct* %93, i32 0, i32 1
	store i32 2, i32* %94
	%95 = bitcast %ObjectStruct* %91 to %SetLL_struct*
	%96 = getelementptr %SetLL_struct, %SetLL_struct* %95, i32 0, i32 0
	%97 = load i8*, i8** %96
	%98 = bitcast i8* %97 to [5 x i8*]*
	%99 = getelementptr [5 x i8*], [5 x i8*]* %98, i32 0, i32 3
	%100 = load i8*, i8** %99
	%101 = bitcast i8* %100 to %SetLL_struct* (%ObjectStruct*, %IntStruct*)*
	%102 = call %SetLL_struct* %101(%ObjectStruct* %91, %IntStruct* %93)
	%103 = load %SetLL_struct*, %SetLL_struct** %4
	%104 = bitcast %SetLL_struct* %103 to %ObjectStruct*
	%105 = bitcast %ObjectStruct* %104 to %SetLL_struct*
	%106 = getelementptr %SetLL_struct, %SetLL_struct* %105, i32 0, i32 0
	%107 = load i8*, i8** %106
	%108 = bitcast i8* %107 to [5 x i8*]*
	%109 = getelementptr [5 x i8*], [5 x i8*]* %108, i32 0, i32 4
	%110 = load i8*, i8** %109
	%111 = bitcast i8* %110 to %SetLL_struct* (%ObjectStruct*)*
	%112 = call %SetLL_struct* %111(%ObjectStruct* %104)
	%113 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_13 to %StringStruct*), i32 0, i32 0
	%114 = load i8*, i8** %113
	%115 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%116 = call i32 (i8*, ...) @printf(i8* %115, i8* %114)
	%117 = load %Main_struct*, %Main_struct** %3
	%118 = load %SetLL_struct*, %SetLL_struct** %4
	%119 = bitcast %SetLL_struct* %118 to %ObjectStruct*
	%120 = call i8* @malloc(i64 16)
	%121 = bitcast i8* %120 to %IntStruct*
	%122 = getelementptr %IntStruct, %IntStruct* %121, i32 0, i32 1
	store i32 2, i32* %122
	%123 = bitcast %ObjectStruct* %119 to %SetLL_struct*
	%124 = getelementptr %SetLL_struct, %SetLL_struct* %123, i32 0, i32 0
	%125 = load i8*, i8** %124
	%126 = bitcast i8* %125 to [5 x i8*]*
	%127 = getelementptr [5 x i8*], [5 x i8*]* %126, i32 0, i32 2
	%128 = load i8*, i8** %127
	%129 = bitcast i8* %128 to %BoolStruct* (%ObjectStruct*, %IntStruct*)*
	%130 = call %BoolStruct* %129(%ObjectStruct* %119, %IntStruct* %121)
	%131 = getelementptr %BoolStruct, %BoolStruct* %130, i32 0, i32 1
	%132 = load i1, i1* %131
	%133 = icmp ne i1 %132, false
	br i1 %133, label %if_then_18, label %if_else_19

if_then_18:
	%134 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_15 to %StringStruct*), i32 0, i32 0
	%135 = load i8*, i8** %134
	%136 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%137 = call i32 (i8*, ...) @printf(i8* %136, i8* %135)
	%138 = load %Main_struct*, %Main_struct** %3
	br label %if_end_20

if_else_19:
	%139 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_17 to %StringStruct*), i32 0, i32 0
	%140 = load i8*, i8** %139
	%141 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%142 = call i32 (i8*, ...) @printf(i8* %141, i8* %140)
	%143 = load %Main_struct*, %Main_struct** %3
	br label %if_end_20

if_end_20:
	%144 = phi %Main_struct* [ %138, %if_then_18 ], [ %143, %if_else_19 ]
	%145 = load %Main_struct*, %Main_struct** %3
	%146 = bitcast %Main_struct* %145 to %ObjectStruct*
	ret %ObjectStruct* %146
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
