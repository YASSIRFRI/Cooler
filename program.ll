%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%Node_struct = type { i8*, %StringStruct*, %Node_struct* }
%LinkedList_struct = type { i8*, %Node_struct* }
%Main_struct = type { i8* }

@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@vtable_Object = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Int = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_String = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Bool = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_IO = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Node = constant [5 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Node_get_value to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%Node_struct* (%ObjectStruct*, %StringStruct*)* @Node_set_value to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%Node_struct* (%ObjectStruct*)* @Node_get_next to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%Node_struct* (%ObjectStruct*, %Node_struct*)* @Node_set_next to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%Node_struct* (%ObjectStruct*)* @Node_init_node to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_LinkedList = constant [4 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%LinkedList_struct* (%ObjectStruct*)* @LinkedList_init_list to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%LinkedList_struct* (%ObjectStruct*, %StringStruct*)* @LinkedList_insert to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%LinkedList_struct* (%ObjectStruct*)* @LinkedList_print to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%BoolStruct* (%ObjectStruct*, %StringStruct*)* @LinkedList_search to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Main = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%ObjectStruct* (%ObjectStruct*)* @Main_main to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@str_0 = global [1 x i8] c"\00"
@str_obj_1 = constant { i8* } { [1 x i8]* getelementptr inbounds ([1 x i8], [1 x i8]* @str_0) }
@str_2 = global [2 x i8] c" \00"
@str_obj_3 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_2) }
@str_4 = global [2 x i8] c"\0A\00"
@str_obj_5 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_4) }
@str_6 = global [6 x i8] c"Hello\00"
@str_obj_7 = constant { i8* } { [6 x i8]* getelementptr inbounds ([6 x i8], [6 x i8]* @str_6) }
@str_8 = global [6 x i8] c"World\00"
@str_obj_9 = constant { i8* } { [6 x i8]* getelementptr inbounds ([6 x i8], [6 x i8]* @str_8) }
@str_10 = global [11 x i8] c"LinkedList\00"
@str_obj_11 = constant { i8* } { [11 x i8]* getelementptr inbounds ([11 x i8], [11 x i8]* @str_10) }
@str_12 = global [5 x i8] c"Test\00"
@str_obj_13 = constant { i8* } { [5 x i8]* getelementptr inbounds ([5 x i8], [5 x i8]* @str_12) }
@str_14 = global [27 x i8] c"Enter a string to search: \00"
@str_obj_15 = constant { i8* } { [27 x i8]* getelementptr inbounds ([27 x i8], [27 x i8]* @str_14) }
@str_16 = global [14 x i8] c"Value found.\0A\00"
@str_obj_17 = constant { i8* } { [14 x i8]* getelementptr inbounds ([14 x i8], [14 x i8]* @str_16) }
@str_18 = global [18 x i8] c"Value not found.\0A\00"
@str_obj_19 = constant { i8* } { [18 x i8]* getelementptr inbounds ([18 x i8], [18 x i8]* @str_18) }

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
	%0 = call %ObjectStruct* @Main_main()
	ret i32 0
}

define %StringStruct* @Node_get_value(%ObjectStruct* %self) {
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
	%7 = load %StringStruct*, %StringStruct** %6
	ret %StringStruct* %7
}

define %Node_struct* @Node_set_value(%ObjectStruct* %self, %StringStruct* %v) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = alloca %StringStruct*
	store %StringStruct* %v, %StringStruct** %4
	%5 = load %StringStruct*, %StringStruct** %4
	%6 = load %Node_struct*, %Node_struct** %3
	%7 = getelementptr %StringStruct*, %Node_struct* %6, i32 1
	store %StringStruct* %5, %StringStruct** %7
	%8 = load %Node_struct*, %Node_struct** %3
	ret %Node_struct* %8
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
	%7 = getelementptr %Node_struct*, %Node_struct* %6, i32 2
	store %Node_struct* %5, %Node_struct** %7
	%8 = load %Node_struct*, %Node_struct** %3
	ret %Node_struct* %8
}

define %Node_struct* @Node_init_node(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Node_struct*
	%3 = alloca %Node_struct*
	store %Node_struct* %2, %Node_struct** %3
	%4 = load %Node_struct*, %Node_struct** %3
	%5 = getelementptr %StringStruct*, %Node_struct* %4, i32 1
	store %StringStruct* bitcast ({ i8* }* @str_obj_1 to %StringStruct*), %StringStruct** %5
	%6 = load %Node_struct*, %Node_struct** %3
	%7 = load %Node_struct*, %Node_struct** %3
	%8 = getelementptr %Node_struct*, %Node_struct* %7, i32 2
	store %Node_struct* %6, %Node_struct** %8
	%9 = load %Node_struct*, %Node_struct** %3
	ret %Node_struct* %9
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
	store i8* bitcast ([5 x %ObjectStruct* (%ObjectStruct*)*]* bitcast ([5 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_Node to [5 x %ObjectStruct* (%ObjectStruct*)*]*) to i8*), i8** %6
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
	%19 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %18
	%20 = bitcast %ObjectStruct* (%ObjectStruct*)* %19 to %Node_struct* (%ObjectStruct*)*
	%21 = call %Node_struct* %20(%ObjectStruct* %13)
	%22 = load %LinkedList_struct*, %LinkedList_struct** %3
	ret %LinkedList_struct* %22
}

define %LinkedList_struct* @LinkedList_insert(%ObjectStruct* %self, %StringStruct* %val) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %LinkedList_struct*
	%3 = alloca %LinkedList_struct*
	store %LinkedList_struct* %2, %LinkedList_struct** %3
	%4 = alloca %StringStruct*
	store %StringStruct* %val, %StringStruct** %4
	%5 = alloca %Node_struct*
	%6 = call i8* @malloc(i64 24)
	%7 = bitcast i8* %6 to %Node_struct*
	%8 = getelementptr %Node_struct, %Node_struct* %7, i32 0, i32 0
	store i8* bitcast ([5 x %ObjectStruct* (%ObjectStruct*)*]* bitcast ([5 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_Node to [5 x %ObjectStruct* (%ObjectStruct*)*]*) to i8*), i8** %8
	store %Node_struct* %7, %Node_struct** %5
	%9 = load %Node_struct*, %Node_struct** %5
	%10 = bitcast %Node_struct* %9 to %ObjectStruct*
	%11 = load %StringStruct*, %StringStruct** %4
	%12 = bitcast %ObjectStruct* %10 to %Node_struct*
	%13 = getelementptr %Node_struct, %Node_struct* %12, i32 0, i32 0
	%14 = load i8*, i8** %13
	%15 = bitcast i8* %14 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%16 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %15, i32 0, i32 1
	%17 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %16
	%18 = bitcast %ObjectStruct* (%ObjectStruct*)* %17 to %Node_struct* (%ObjectStruct*, %StringStruct*)*
	%19 = call %Node_struct* %18(%ObjectStruct* %10, %StringStruct* %11)
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
	%32 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %31
	%33 = bitcast %ObjectStruct* (%ObjectStruct*)* %32 to %Node_struct* (%ObjectStruct*)*
	%34 = call %Node_struct* %33(%ObjectStruct* %26)
	%35 = bitcast %ObjectStruct* %21 to %Node_struct*
	%36 = getelementptr %Node_struct, %Node_struct* %35, i32 0, i32 0
	%37 = load i8*, i8** %36
	%38 = bitcast i8* %37 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%39 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %38, i32 0, i32 3
	%40 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %39
	%41 = bitcast %ObjectStruct* (%ObjectStruct*)* %40 to %Node_struct* (%ObjectStruct*, %Node_struct*)*
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
	%54 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %53
	%55 = bitcast %ObjectStruct* (%ObjectStruct*)* %54 to %Node_struct* (%ObjectStruct*, %Node_struct*)*
	%56 = call %Node_struct* %55(%ObjectStruct* %47, %Node_struct* %48)
	%57 = load %LinkedList_struct*, %LinkedList_struct** %3
	ret %LinkedList_struct* %57
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
	%13 = bitcast i8* %12 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%14 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %13, i32 0, i32 2
	%15 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %14
	%16 = bitcast %ObjectStruct* (%ObjectStruct*)* %15 to %Node_struct* (%ObjectStruct*)*
	%17 = call %Node_struct* %16(%ObjectStruct* %9)
	store %Node_struct* %17, %Node_struct** %4
	br label %while_cond

while_cond:
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
	br i1 %35, label %while_body, label %while_end

while_body:
	%36 = load %Node_struct*, %Node_struct** %4
	%37 = bitcast %Node_struct* %36 to %ObjectStruct*
	%38 = bitcast %ObjectStruct* %37 to %Node_struct*
	%39 = getelementptr %Node_struct, %Node_struct* %38, i32 0, i32 0
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%42 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %41, i32 0, i32 0
	%43 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %42
	%44 = bitcast %ObjectStruct* (%ObjectStruct*)* %43 to %StringStruct* (%ObjectStruct*)*
	%45 = call %StringStruct* %44(%ObjectStruct* %37)
	%46 = getelementptr %StringStruct, %StringStruct* %45, i32 0, i32 0
	%47 = load i8*, i8** %46
	%48 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%49 = call i32 (i8*, ...) @printf(i8* %48, i8* %47)
	%50 = load %LinkedList_struct*, %LinkedList_struct** %3
	%51 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*), i32 0, i32 0
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
	%63 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %62
	%64 = bitcast %ObjectStruct* (%ObjectStruct*)* %63 to %Node_struct* (%ObjectStruct*)*
	%65 = call %Node_struct* %64(%ObjectStruct* %57)
	store %Node_struct* %65, %Node_struct** %4
	br label %while_cond

while_end:
	%66 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%67 = load i8*, i8** %66
	%68 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%69 = call i32 (i8*, ...) @printf(i8* %68, i8* %67)
	%70 = load %LinkedList_struct*, %LinkedList_struct** %3
	%71 = load %LinkedList_struct*, %LinkedList_struct** %3
	ret %LinkedList_struct* %71
}

define %BoolStruct* @LinkedList_search(%ObjectStruct* %self, %StringStruct* %val) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %LinkedList_struct*
	%3 = alloca %LinkedList_struct*
	store %LinkedList_struct* %2, %LinkedList_struct** %3
	%4 = alloca %StringStruct*
	store %StringStruct* %val, %StringStruct** %4
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
	%16 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %15
	%17 = bitcast %ObjectStruct* (%ObjectStruct*)* %16 to %Node_struct* (%ObjectStruct*)*
	%18 = call %Node_struct* %17(%ObjectStruct* %10)
	store %Node_struct* %18, %Node_struct** %5
	%19 = alloca %BoolStruct*
	%20 = call i8* @malloc(i64 16)
	%21 = bitcast i8* %20 to %BoolStruct*
	%22 = getelementptr %BoolStruct, %BoolStruct* %21, i32 0, i32 1
	store i1 false, i1* %22
	store %BoolStruct* %21, %BoolStruct** %19
	br label %while_cond

while_cond:
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
	br i1 %40, label %while_body, label %while_end

while_body:
	%41 = load %Node_struct*, %Node_struct** %5
	%42 = bitcast %Node_struct* %41 to %ObjectStruct*
	%43 = bitcast %ObjectStruct* %42 to %Node_struct*
	%44 = getelementptr %Node_struct, %Node_struct* %43, i32 0, i32 0
	%45 = load i8*, i8** %44
	%46 = bitcast i8* %45 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%47 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %46, i32 0, i32 0
	%48 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %47
	%49 = bitcast %ObjectStruct* (%ObjectStruct*)* %48 to %StringStruct* (%ObjectStruct*)*
	%50 = call %StringStruct* %49(%ObjectStruct* %42)
	%51 = load %StringStruct*, %StringStruct** %4
	%52 = getelementptr %StringStruct, %StringStruct* %50, i32 0, i32 0
	%53 = load i8*, i8** %52
	%54 = getelementptr %StringStruct, %StringStruct* %51, i32 0, i32 0
	%55 = load i8*, i8** %54
	%56 = call i32 @strcmp(i8* %53, i8* %55)
	%57 = icmp eq i32 %56, 0
	%58 = call i8* @malloc(i64 16)
	%59 = bitcast i8* %58 to %BoolStruct*
	%60 = getelementptr %BoolStruct, %BoolStruct* %59, i32 0, i32 1
	store i1 %57, i1* %60
	%61 = getelementptr %BoolStruct, %BoolStruct* %59, i32 0, i32 1
	%62 = load i1, i1* %61
	%63 = icmp ne i1 %62, false
	br i1 %63, label %if_then_0, label %if_else_1

while_end:
	%64 = load %BoolStruct*, %BoolStruct** %19
	ret %BoolStruct* %64

if_then_0:
	%65 = call i8* @malloc(i64 16)
	%66 = bitcast i8* %65 to %BoolStruct*
	%67 = getelementptr %BoolStruct, %BoolStruct* %66, i32 0, i32 1
	store i1 true, i1* %67
	store %BoolStruct* %66, %BoolStruct** %19
	%68 = load %LinkedList_struct*, %LinkedList_struct** %3
	%69 = bitcast %LinkedList_struct* %68 to %LinkedList_struct*
	%70 = getelementptr %LinkedList_struct, %LinkedList_struct* %69, i32 0, i32 1
	%71 = load %Node_struct*, %Node_struct** %70
	store %Node_struct* %71, %Node_struct** %5
	br label %if_end_2

if_else_1:
	%72 = load %Node_struct*, %Node_struct** %5
	%73 = bitcast %Node_struct* %72 to %ObjectStruct*
	%74 = bitcast %ObjectStruct* %73 to %Node_struct*
	%75 = getelementptr %Node_struct, %Node_struct* %74, i32 0, i32 0
	%76 = load i8*, i8** %75
	%77 = bitcast i8* %76 to [5 x %ObjectStruct* (%ObjectStruct*)*]*
	%78 = getelementptr [5 x %ObjectStruct* (%ObjectStruct*)*], [5 x %ObjectStruct* (%ObjectStruct*)*]* %77, i32 0, i32 2
	%79 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %78
	%80 = bitcast %ObjectStruct* (%ObjectStruct*)* %79 to %Node_struct* (%ObjectStruct*)*
	%81 = call %Node_struct* %80(%ObjectStruct* %73)
	store %Node_struct* %81, %Node_struct** %5
	br label %if_end_2

if_end_2:
	%82 = phi %Node_struct* [ %71, %if_then_0 ], [ %81, %if_else_1 ]
	br label %while_cond
}

define %ObjectStruct* @Main_main(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = alloca %LinkedList_struct*
	%5 = call i8* @malloc(i64 16)
	%6 = bitcast i8* %5 to %LinkedList_struct*
	%7 = getelementptr %LinkedList_struct, %LinkedList_struct* %6, i32 0, i32 0
	store i8* bitcast ([4 x %ObjectStruct* (%ObjectStruct*)*]* bitcast ([4 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_LinkedList to [4 x %ObjectStruct* (%ObjectStruct*)*]*) to i8*), i8** %7
	store %LinkedList_struct* %6, %LinkedList_struct** %4
	%8 = load %LinkedList_struct*, %LinkedList_struct** %4
	%9 = bitcast %LinkedList_struct* %8 to %ObjectStruct*
	%10 = bitcast %ObjectStruct* %9 to %LinkedList_struct*
	%11 = getelementptr %LinkedList_struct, %LinkedList_struct* %10, i32 0, i32 0
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%14 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %13, i32 0, i32 0
	%15 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %14
	%16 = bitcast %ObjectStruct* (%ObjectStruct*)* %15 to %LinkedList_struct* (%ObjectStruct*)*
	%17 = call %LinkedList_struct* %16(%ObjectStruct* %9)
	%18 = load %LinkedList_struct*, %LinkedList_struct** %4
	%19 = bitcast %LinkedList_struct* %18 to %ObjectStruct*
	%20 = bitcast %ObjectStruct* %19 to %LinkedList_struct*
	%21 = getelementptr %LinkedList_struct, %LinkedList_struct* %20, i32 0, i32 0
	%22 = load i8*, i8** %21
	%23 = bitcast i8* %22 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%24 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %23, i32 0, i32 1
	%25 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %24
	%26 = bitcast %ObjectStruct* (%ObjectStruct*)* %25 to %LinkedList_struct* (%ObjectStruct*, %StringStruct*)*
	%27 = call %LinkedList_struct* %26(%ObjectStruct* %19, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*))
	%28 = load %LinkedList_struct*, %LinkedList_struct** %4
	%29 = bitcast %LinkedList_struct* %28 to %ObjectStruct*
	%30 = bitcast %ObjectStruct* %29 to %LinkedList_struct*
	%31 = getelementptr %LinkedList_struct, %LinkedList_struct* %30, i32 0, i32 0
	%32 = load i8*, i8** %31
	%33 = bitcast i8* %32 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%34 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %33, i32 0, i32 1
	%35 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %34
	%36 = bitcast %ObjectStruct* (%ObjectStruct*)* %35 to %LinkedList_struct* (%ObjectStruct*, %StringStruct*)*
	%37 = call %LinkedList_struct* %36(%ObjectStruct* %29, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*))
	%38 = load %LinkedList_struct*, %LinkedList_struct** %4
	%39 = bitcast %LinkedList_struct* %38 to %ObjectStruct*
	%40 = bitcast %ObjectStruct* %39 to %LinkedList_struct*
	%41 = getelementptr %LinkedList_struct, %LinkedList_struct* %40, i32 0, i32 0
	%42 = load i8*, i8** %41
	%43 = bitcast i8* %42 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%44 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %43, i32 0, i32 1
	%45 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %44
	%46 = bitcast %ObjectStruct* (%ObjectStruct*)* %45 to %LinkedList_struct* (%ObjectStruct*, %StringStruct*)*
	%47 = call %LinkedList_struct* %46(%ObjectStruct* %39, %StringStruct* bitcast ({ i8* }* @str_obj_11 to %StringStruct*))
	%48 = load %LinkedList_struct*, %LinkedList_struct** %4
	%49 = bitcast %LinkedList_struct* %48 to %ObjectStruct*
	%50 = bitcast %ObjectStruct* %49 to %LinkedList_struct*
	%51 = getelementptr %LinkedList_struct, %LinkedList_struct* %50, i32 0, i32 0
	%52 = load i8*, i8** %51
	%53 = bitcast i8* %52 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%54 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %53, i32 0, i32 1
	%55 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %54
	%56 = bitcast %ObjectStruct* (%ObjectStruct*)* %55 to %LinkedList_struct* (%ObjectStruct*, %StringStruct*)*
	%57 = call %LinkedList_struct* %56(%ObjectStruct* %49, %StringStruct* bitcast ({ i8* }* @str_obj_13 to %StringStruct*))
	%58 = load %LinkedList_struct*, %LinkedList_struct** %4
	%59 = bitcast %LinkedList_struct* %58 to %ObjectStruct*
	%60 = bitcast %ObjectStruct* %59 to %LinkedList_struct*
	%61 = getelementptr %LinkedList_struct, %LinkedList_struct* %60, i32 0, i32 0
	%62 = load i8*, i8** %61
	%63 = bitcast i8* %62 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%64 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %63, i32 0, i32 2
	%65 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %64
	%66 = bitcast %ObjectStruct* (%ObjectStruct*)* %65 to %LinkedList_struct* (%ObjectStruct*)*
	%67 = call %LinkedList_struct* %66(%ObjectStruct* %59)
	%68 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_15 to %StringStruct*), i32 0, i32 0
	%69 = load i8*, i8** %68
	%70 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%71 = call i32 (i8*, ...) @printf(i8* %70, i8* %69)
	%72 = load %Main_struct*, %Main_struct** %3
	%73 = alloca %StringStruct*
	%74 = alloca [1024 x i8]
	%75 = getelementptr [1024 x i8], [1024 x i8]* %74, i32 0, i32 0
	%76 = getelementptr [7 x i8], [7 x i8]* @fmt_str_in_2, i32 0, i32 0
	%77 = call i32 (i8*, ...) @scanf(i8* %76, i8* %75)
	%78 = call i8* @malloc(i64 16)
	%79 = bitcast i8* %78 to %StringStruct*
	%80 = getelementptr %StringStruct, %StringStruct* %79, i32 0, i32 0
	store i8* %75, i8** %80
	store %StringStruct* %79, %StringStruct** %73
	%81 = load %LinkedList_struct*, %LinkedList_struct** %4
	%82 = bitcast %LinkedList_struct* %81 to %ObjectStruct*
	%83 = load %StringStruct*, %StringStruct** %73
	%84 = bitcast %ObjectStruct* %82 to %LinkedList_struct*
	%85 = getelementptr %LinkedList_struct, %LinkedList_struct* %84, i32 0, i32 0
	%86 = load i8*, i8** %85
	%87 = bitcast i8* %86 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%88 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %87, i32 0, i32 3
	%89 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %88
	%90 = bitcast %ObjectStruct* (%ObjectStruct*)* %89 to %BoolStruct* (%ObjectStruct*, %StringStruct*)*
	%91 = call %BoolStruct* %90(%ObjectStruct* %82, %StringStruct* %83)
	%92 = getelementptr %BoolStruct, %BoolStruct* %91, i32 0, i32 1
	%93 = load i1, i1* %92
	%94 = icmp ne i1 %93, false
	br i1 %94, label %if_then_3, label %if_else_4

if_then_3:
	%95 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_17 to %StringStruct*), i32 0, i32 0
	%96 = load i8*, i8** %95
	%97 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%98 = call i32 (i8*, ...) @printf(i8* %97, i8* %96)
	%99 = load %Main_struct*, %Main_struct** %3
	br label %if_end_5

if_else_4:
	%100 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_19 to %StringStruct*), i32 0, i32 0
	%101 = load i8*, i8** %100
	%102 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%103 = call i32 (i8*, ...) @printf(i8* %102, i8* %101)
	%104 = load %Main_struct*, %Main_struct** %3
	br label %if_end_5

if_end_5:
	%105 = phi %Main_struct* [ %99, %if_then_3 ], [ %104, %if_else_4 ]
	%106 = load %LinkedList_struct*, %LinkedList_struct** %4
	%107 = bitcast %LinkedList_struct* %106 to %ObjectStruct*
	%108 = bitcast %ObjectStruct* %107 to %LinkedList_struct*
	%109 = getelementptr %LinkedList_struct, %LinkedList_struct* %108, i32 0, i32 0
	%110 = load i8*, i8** %109
	%111 = bitcast i8* %110 to [4 x %ObjectStruct* (%ObjectStruct*)*]*
	%112 = getelementptr [4 x %ObjectStruct* (%ObjectStruct*)*], [4 x %ObjectStruct* (%ObjectStruct*)*]* %111, i32 0, i32 2
	%113 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %112
	%114 = bitcast %ObjectStruct* (%ObjectStruct*)* %113 to %LinkedList_struct* (%ObjectStruct*)*
	%115 = call %LinkedList_struct* %114(%ObjectStruct* %107)
	%116 = load %Main_struct*, %Main_struct** %3
	%117 = bitcast %Main_struct* %116 to %ObjectStruct*
	ret %ObjectStruct* %117
}

declare i32 @strcmp(i8* %str1, i8* %str2)
