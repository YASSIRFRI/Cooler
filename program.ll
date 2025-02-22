%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%CellularAutomaton_struct = type { i8*, %StringStruct* }
%Main_struct = type { i8*, %CellularAutomaton_struct* }

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
@vtable_CellularAutomaton = constant [8 x i8*] [i8* bitcast (%CellularAutomaton_struct* (%CellularAutomaton_struct*, %StringStruct*)* @CellularAutomaton_init to i8*), i8* bitcast (%CellularAutomaton_struct* (%CellularAutomaton_struct*)* @CellularAutomaton_print to i8*), i8* bitcast (%IntStruct* (%CellularAutomaton_struct*)* @CellularAutomaton_num_cells to i8*), i8* bitcast (%StringStruct* (%CellularAutomaton_struct*, %IntStruct*)* @CellularAutomaton_cell to i8*), i8* bitcast (%StringStruct* (%CellularAutomaton_struct*, %IntStruct*)* @CellularAutomaton_cell_left_neighbor to i8*), i8* bitcast (%StringStruct* (%CellularAutomaton_struct*, %IntStruct*)* @CellularAutomaton_cell_right_neighbor to i8*), i8* bitcast (%StringStruct* (%CellularAutomaton_struct*, %IntStruct*)* @CellularAutomaton_cell_at_next_evolution to i8*), i8* bitcast (%CellularAutomaton_struct* (%CellularAutomaton_struct*)* @CellularAutomaton_evolve to i8*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%Main_struct* (%Main_struct*)* @Main_main to i8*)]
@str_2 = global [2 x i8] c"\0A\00"
@str_obj_3 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_2) }
@str_4 = global [2 x i8] c"X\00"
@str_obj_5 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_4) }
@str_6 = global [2 x i8] c"X\00"
@str_obj_7 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_6) }
@str_8 = global [2 x i8] c"X\00"
@str_obj_9 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_8) }
@str_10 = global [2 x i8] c"X\00"
@str_obj_11 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_10) }
@str_12 = global [2 x i8] c".\00"
@str_obj_13 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_12) }
@str_14 = global [1 x i8] c"\00"
@str_obj_15 = constant { i8* } { [1 x i8]* getelementptr inbounds ([1 x i8], [1 x i8]* @str_14) }
@str_16 = global [5 x i8] c"Test\00"
@str_obj_17 = constant { i8* } { [5 x i8]* getelementptr inbounds ([5 x i8], [5 x i8]* @str_16) }
@str_18 = global [5 x i8] c"Test\00"
@str_obj_19 = constant { i8* } { [5 x i8]* getelementptr inbounds ([5 x i8], [5 x i8]* @str_18) }
@str_20 = global [7 x i8] c"XXXXXX\00"
@str_obj_21 = constant { i8* } { [7 x i8]* getelementptr inbounds ([7 x i8], [7 x i8]* @str_20) }
@str_22 = global [5 x i8] c"Test\00"
@str_obj_23 = constant { i8* } { [5 x i8]* getelementptr inbounds ([5 x i8], [5 x i8]* @str_22) }
@str_24 = global [5 x i8] c"Test\00"
@str_obj_25 = constant { i8* } { [5 x i8]* getelementptr inbounds ([5 x i8], [5 x i8]* @str_24) }
@str_26 = global [8 x i8] c"Test 2\0A\00"
@str_obj_27 = constant { i8* } { [8 x i8]* getelementptr inbounds ([8 x i8], [8 x i8]* @str_26) }
@str_28 = global [8 x i8] c"Test 3\0A\00"
@str_obj_29 = constant { i8* } { [8 x i8]* getelementptr inbounds ([8 x i8], [8 x i8]* @str_28) }
@str_30 = global [8 x i8] c"Test 4\0A\00"
@str_obj_31 = constant { i8* } { [8 x i8]* getelementptr inbounds ([8 x i8], [8 x i8]* @str_30) }

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
	%0 = call i8* @malloc(i64 16)
	%1 = bitcast i8* %0 to %Main_struct*
	%2 = bitcast [1 x i8*]* @vtable_Main to i8*
	%3 = getelementptr %Main_struct, %Main_struct* %1, i32 0, i32 0
	store i8* %2, i8** %3
	%4 = call %Main_struct* @Main_main(%Main_struct* %1)
	ret i32 0
}

define %CellularAutomaton_struct* @CellularAutomaton_init(%CellularAutomaton_struct* %self, %StringStruct* %map) {
entry:
	%0 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %self, %CellularAutomaton_struct** %0
	%1 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %0
	%2 = bitcast %CellularAutomaton_struct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = alloca %StringStruct*
	store %StringStruct* %map, %StringStruct** %4
	%5 = load %StringStruct*, %StringStruct** %4
	%6 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%7 = getelementptr %StringStruct*, %CellularAutomaton_struct* %6, i32 1
	store %StringStruct* %5, %StringStruct** %7
	%8 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	ret %CellularAutomaton_struct* %8
}

define %CellularAutomaton_struct* @CellularAutomaton_print(%CellularAutomaton_struct* %self) {
entry:
	%0 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %self, %CellularAutomaton_struct** %0
	%1 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %0
	%2 = bitcast %CellularAutomaton_struct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%5 = bitcast %CellularAutomaton_struct* %4 to %CellularAutomaton_struct*
	%6 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %5, i32 0, i32 1
	%7 = load %StringStruct*, %StringStruct** %6
	%8 = bitcast %StringStruct* %7 to %ObjectStruct*
	%9 = call %StringStruct* @String_concat(%ObjectStruct* %8, %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*))
	%10 = getelementptr %StringStruct, %StringStruct* %9, i32 0, i32 0
	%11 = load i8*, i8** %10
	%12 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%13 = call i32 (i8*, ...) @printf(i8* %12, i8* %11)
	%14 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%15 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	ret %CellularAutomaton_struct* %15
}

define %IntStruct* @CellularAutomaton_num_cells(%CellularAutomaton_struct* %self) {
entry:
	%0 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %self, %CellularAutomaton_struct** %0
	%1 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %0
	%2 = bitcast %CellularAutomaton_struct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%5 = bitcast %CellularAutomaton_struct* %4 to %CellularAutomaton_struct*
	%6 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %5, i32 0, i32 1
	%7 = load %StringStruct*, %StringStruct** %6
	%8 = bitcast %StringStruct* %7 to %ObjectStruct*
	%9 = call i32 @String_length(%ObjectStruct* %8)
	%10 = call i8* @malloc(i64 16)
	%11 = bitcast i8* %10 to %IntStruct*
	%12 = getelementptr %IntStruct, %IntStruct* %11, i32 0, i32 1
	store i32 %9, i32* %12
	ret %IntStruct* %11
}

define %StringStruct* @CellularAutomaton_cell(%CellularAutomaton_struct* %self, %IntStruct* %position) {
entry:
	%0 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %self, %CellularAutomaton_struct** %0
	%1 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %0
	%2 = bitcast %CellularAutomaton_struct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %position, %IntStruct** %4
	%5 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%6 = bitcast %CellularAutomaton_struct* %5 to %CellularAutomaton_struct*
	%7 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %6, i32 0, i32 1
	%8 = load %StringStruct*, %StringStruct** %7
	%9 = bitcast %StringStruct* %8 to %ObjectStruct*
	%10 = load %IntStruct*, %IntStruct** %4
	%11 = call i8* @malloc(i64 16)
	%12 = bitcast i8* %11 to %IntStruct*
	%13 = getelementptr %IntStruct, %IntStruct* %12, i32 0, i32 1
	store i32 1, i32* %13
	%14 = call %StringStruct* @String_substr(%ObjectStruct* %9, %IntStruct* %10, %IntStruct* %12)
	ret %StringStruct* %14
}

define %StringStruct* @CellularAutomaton_cell_left_neighbor(%CellularAutomaton_struct* %self, %IntStruct* %position) {
entry:
	%0 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %self, %CellularAutomaton_struct** %0
	%1 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %0
	%2 = bitcast %CellularAutomaton_struct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %position, %IntStruct** %4
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
	%20 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%21 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%22 = call %IntStruct* @CellularAutomaton_num_cells(%CellularAutomaton_struct* %21)
	%23 = call i8* @malloc(i64 16)
	%24 = bitcast i8* %23 to %IntStruct*
	%25 = getelementptr %IntStruct, %IntStruct* %24, i32 0, i32 1
	store i32 1, i32* %25
	%26 = getelementptr %IntStruct, %IntStruct* %22, i32 0, i32 1
	%27 = load i32, i32* %26
	%28 = getelementptr %IntStruct, %IntStruct* %24, i32 0, i32 1
	%29 = load i32, i32* %28
	%30 = sub i32 %27, %29
	%31 = call i8* @malloc(i64 16)
	%32 = bitcast i8* %31 to %IntStruct*
	%33 = getelementptr %IntStruct, %IntStruct* %32, i32 0, i32 1
	store i32 %30, i32* %33
	%34 = call %StringStruct* @CellularAutomaton_cell(%CellularAutomaton_struct* %20, %IntStruct* %32)
	br label %if_end_2

if_else_1:
	%35 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%36 = load %IntStruct*, %IntStruct** %4
	%37 = call i8* @malloc(i64 16)
	%38 = bitcast i8* %37 to %IntStruct*
	%39 = getelementptr %IntStruct, %IntStruct* %38, i32 0, i32 1
	store i32 1, i32* %39
	%40 = getelementptr %IntStruct, %IntStruct* %36, i32 0, i32 1
	%41 = load i32, i32* %40
	%42 = getelementptr %IntStruct, %IntStruct* %38, i32 0, i32 1
	%43 = load i32, i32* %42
	%44 = sub i32 %41, %43
	%45 = call i8* @malloc(i64 16)
	%46 = bitcast i8* %45 to %IntStruct*
	%47 = getelementptr %IntStruct, %IntStruct* %46, i32 0, i32 1
	store i32 %44, i32* %47
	%48 = call %StringStruct* @CellularAutomaton_cell(%CellularAutomaton_struct* %35, %IntStruct* %46)
	br label %if_end_2

if_end_2:
	%49 = phi %StringStruct* [ %34, %if_then_0 ], [ %48, %if_else_1 ]
	ret %StringStruct* %49
}

define %StringStruct* @CellularAutomaton_cell_right_neighbor(%CellularAutomaton_struct* %self, %IntStruct* %position) {
entry:
	%0 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %self, %CellularAutomaton_struct** %0
	%1 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %0
	%2 = bitcast %CellularAutomaton_struct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %position, %IntStruct** %4
	%5 = load %IntStruct*, %IntStruct** %4
	%6 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%7 = call %IntStruct* @CellularAutomaton_num_cells(%CellularAutomaton_struct* %6)
	%8 = call i8* @malloc(i64 16)
	%9 = bitcast i8* %8 to %IntStruct*
	%10 = getelementptr %IntStruct, %IntStruct* %9, i32 0, i32 1
	store i32 1, i32* %10
	%11 = getelementptr %IntStruct, %IntStruct* %7, i32 0, i32 1
	%12 = load i32, i32* %11
	%13 = getelementptr %IntStruct, %IntStruct* %9, i32 0, i32 1
	%14 = load i32, i32* %13
	%15 = sub i32 %12, %14
	%16 = call i8* @malloc(i64 16)
	%17 = bitcast i8* %16 to %IntStruct*
	%18 = getelementptr %IntStruct, %IntStruct* %17, i32 0, i32 1
	store i32 %15, i32* %18
	%19 = getelementptr %IntStruct, %IntStruct* %5, i32 0, i32 1
	%20 = load i32, i32* %19
	%21 = getelementptr %IntStruct, %IntStruct* %17, i32 0, i32 1
	%22 = load i32, i32* %21
	%23 = icmp eq i32 %20, %22
	%24 = call i8* @malloc(i64 16)
	%25 = bitcast i8* %24 to %BoolStruct*
	%26 = getelementptr %BoolStruct, %BoolStruct* %25, i32 0, i32 1
	store i1 %23, i1* %26
	%27 = getelementptr %BoolStruct, %BoolStruct* %25, i32 0, i32 1
	%28 = load i1, i1* %27
	%29 = icmp ne i1 %28, false
	br i1 %29, label %if_then_3, label %if_else_4

if_then_3:
	%30 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%31 = call i8* @malloc(i64 16)
	%32 = bitcast i8* %31 to %IntStruct*
	%33 = getelementptr %IntStruct, %IntStruct* %32, i32 0, i32 1
	store i32 0, i32* %33
	%34 = call %StringStruct* @CellularAutomaton_cell(%CellularAutomaton_struct* %30, %IntStruct* %32)
	br label %if_end_5

if_else_4:
	%35 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%36 = load %IntStruct*, %IntStruct** %4
	%37 = call i8* @malloc(i64 16)
	%38 = bitcast i8* %37 to %IntStruct*
	%39 = getelementptr %IntStruct, %IntStruct* %38, i32 0, i32 1
	store i32 1, i32* %39
	%40 = getelementptr %IntStruct, %IntStruct* %36, i32 0, i32 1
	%41 = load i32, i32* %40
	%42 = getelementptr %IntStruct, %IntStruct* %38, i32 0, i32 1
	%43 = load i32, i32* %42
	%44 = add i32 %41, %43
	%45 = call i8* @malloc(i64 16)
	%46 = bitcast i8* %45 to %IntStruct*
	%47 = getelementptr %IntStruct, %IntStruct* %46, i32 0, i32 1
	store i32 %44, i32* %47
	%48 = call %StringStruct* @CellularAutomaton_cell(%CellularAutomaton_struct* %35, %IntStruct* %46)
	br label %if_end_5

if_end_5:
	%49 = phi %StringStruct* [ %34, %if_then_3 ], [ %48, %if_else_4 ]
	ret %StringStruct* %49
}

define %StringStruct* @CellularAutomaton_cell_at_next_evolution(%CellularAutomaton_struct* %self, %IntStruct* %position) {
entry:
	%0 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %self, %CellularAutomaton_struct** %0
	%1 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %0
	%2 = bitcast %CellularAutomaton_struct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %position, %IntStruct** %4
	%5 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%6 = load %IntStruct*, %IntStruct** %4
	%7 = call %StringStruct* @CellularAutomaton_cell(%CellularAutomaton_struct* %5, %IntStruct* %6)
	%8 = getelementptr %StringStruct, %StringStruct* %7, i32 0, i32 0
	%9 = load i8*, i8** %8
	%10 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%11 = load i8*, i8** %10
	%12 = call i32 @strcmp(i8* %9, i8* %11)
	%13 = icmp eq i32 %12, 0
	%14 = call i8* @malloc(i64 16)
	%15 = bitcast i8* %14 to %BoolStruct*
	%16 = getelementptr %BoolStruct, %BoolStruct* %15, i32 0, i32 1
	store i1 %13, i1* %16
	%17 = getelementptr %BoolStruct, %BoolStruct* %15, i32 0, i32 1
	%18 = load i1, i1* %17
	%19 = icmp ne i1 %18, false
	br i1 %19, label %if_then_6, label %if_else_7

if_then_6:
	%20 = call i8* @malloc(i64 16)
	%21 = bitcast i8* %20 to %IntStruct*
	%22 = getelementptr %IntStruct, %IntStruct* %21, i32 0, i32 1
	store i32 1, i32* %22
	br label %if_end_8

if_else_7:
	%23 = call i8* @malloc(i64 16)
	%24 = bitcast i8* %23 to %IntStruct*
	%25 = getelementptr %IntStruct, %IntStruct* %24, i32 0, i32 1
	store i32 0, i32* %25
	br label %if_end_8

if_end_8:
	%26 = phi %IntStruct* [ %21, %if_then_6 ], [ %24, %if_else_7 ]
	%27 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%28 = load %IntStruct*, %IntStruct** %4
	%29 = call %StringStruct* @CellularAutomaton_cell_left_neighbor(%CellularAutomaton_struct* %27, %IntStruct* %28)
	%30 = getelementptr %StringStruct, %StringStruct* %29, i32 0, i32 0
	%31 = load i8*, i8** %30
	%32 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%33 = load i8*, i8** %32
	%34 = call i32 @strcmp(i8* %31, i8* %33)
	%35 = icmp eq i32 %34, 0
	%36 = call i8* @malloc(i64 16)
	%37 = bitcast i8* %36 to %BoolStruct*
	%38 = getelementptr %BoolStruct, %BoolStruct* %37, i32 0, i32 1
	store i1 %35, i1* %38
	%39 = getelementptr %BoolStruct, %BoolStruct* %37, i32 0, i32 1
	%40 = load i1, i1* %39
	%41 = icmp ne i1 %40, false
	br i1 %41, label %if_then_9, label %if_else_10

if_then_9:
	%42 = call i8* @malloc(i64 16)
	%43 = bitcast i8* %42 to %IntStruct*
	%44 = getelementptr %IntStruct, %IntStruct* %43, i32 0, i32 1
	store i32 1, i32* %44
	br label %if_end_11

if_else_10:
	%45 = call i8* @malloc(i64 16)
	%46 = bitcast i8* %45 to %IntStruct*
	%47 = getelementptr %IntStruct, %IntStruct* %46, i32 0, i32 1
	store i32 0, i32* %47
	br label %if_end_11

if_end_11:
	%48 = phi %IntStruct* [ %43, %if_then_9 ], [ %46, %if_else_10 ]
	%49 = getelementptr %IntStruct, %IntStruct* %26, i32 0, i32 1
	%50 = load i32, i32* %49
	%51 = getelementptr %IntStruct, %IntStruct* %48, i32 0, i32 1
	%52 = load i32, i32* %51
	%53 = add i32 %50, %52
	%54 = call i8* @malloc(i64 16)
	%55 = bitcast i8* %54 to %IntStruct*
	%56 = getelementptr %IntStruct, %IntStruct* %55, i32 0, i32 1
	store i32 %53, i32* %56
	%57 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%58 = load %IntStruct*, %IntStruct** %4
	%59 = call %StringStruct* @CellularAutomaton_cell_right_neighbor(%CellularAutomaton_struct* %57, %IntStruct* %58)
	%60 = getelementptr %StringStruct, %StringStruct* %59, i32 0, i32 0
	%61 = load i8*, i8** %60
	%62 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*), i32 0, i32 0
	%63 = load i8*, i8** %62
	%64 = call i32 @strcmp(i8* %61, i8* %63)
	%65 = icmp eq i32 %64, 0
	%66 = call i8* @malloc(i64 16)
	%67 = bitcast i8* %66 to %BoolStruct*
	%68 = getelementptr %BoolStruct, %BoolStruct* %67, i32 0, i32 1
	store i1 %65, i1* %68
	%69 = getelementptr %BoolStruct, %BoolStruct* %67, i32 0, i32 1
	%70 = load i1, i1* %69
	%71 = icmp ne i1 %70, false
	br i1 %71, label %if_then_12, label %if_else_13

if_then_12:
	%72 = call i8* @malloc(i64 16)
	%73 = bitcast i8* %72 to %IntStruct*
	%74 = getelementptr %IntStruct, %IntStruct* %73, i32 0, i32 1
	store i32 1, i32* %74
	br label %if_end_14

if_else_13:
	%75 = call i8* @malloc(i64 16)
	%76 = bitcast i8* %75 to %IntStruct*
	%77 = getelementptr %IntStruct, %IntStruct* %76, i32 0, i32 1
	store i32 0, i32* %77
	br label %if_end_14

if_end_14:
	%78 = phi %IntStruct* [ %73, %if_then_12 ], [ %76, %if_else_13 ]
	%79 = getelementptr %IntStruct, %IntStruct* %55, i32 0, i32 1
	%80 = load i32, i32* %79
	%81 = getelementptr %IntStruct, %IntStruct* %78, i32 0, i32 1
	%82 = load i32, i32* %81
	%83 = add i32 %80, %82
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
	%94 = icmp eq i32 %91, %93
	%95 = call i8* @malloc(i64 16)
	%96 = bitcast i8* %95 to %BoolStruct*
	%97 = getelementptr %BoolStruct, %BoolStruct* %96, i32 0, i32 1
	store i1 %94, i1* %97
	%98 = getelementptr %BoolStruct, %BoolStruct* %96, i32 0, i32 1
	%99 = load i1, i1* %98
	%100 = icmp ne i1 %99, false
	br i1 %100, label %if_then_15, label %if_else_16

if_then_15:
	br label %if_end_17

if_else_16:
	br label %if_end_17

if_end_17:
	%101 = phi %StringStruct* [ bitcast ({ i8* }* @str_obj_11 to %StringStruct*), %if_then_15 ], [ bitcast ({ i8* }* @str_obj_13 to %StringStruct*), %if_else_16 ]
	ret %StringStruct* %101
}

define %CellularAutomaton_struct* @CellularAutomaton_evolve(%CellularAutomaton_struct* %self) {
entry:
	%0 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %self, %CellularAutomaton_struct** %0
	%1 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %0
	%2 = bitcast %CellularAutomaton_struct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = alloca %IntStruct*
	%5 = bitcast %IntStruct** null to %IntStruct*
	store %IntStruct* %5, %IntStruct** %4
	%6 = alloca %IntStruct*
	%7 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%8 = call %IntStruct* @CellularAutomaton_num_cells(%CellularAutomaton_struct* %7)
	store %IntStruct* %8, %IntStruct** %6
	%9 = alloca %StringStruct*
	store %StringStruct* bitcast ({ i8* }* @str_obj_15 to %StringStruct*), %StringStruct** %9
	br label %while_cond_18

while_cond_18:
	%10 = load %IntStruct*, %IntStruct** %4
	%11 = load %IntStruct*, %IntStruct** %6
	%12 = getelementptr %IntStruct, %IntStruct* %10, i32 0, i32 1
	%13 = load i32, i32* %12
	%14 = getelementptr %IntStruct, %IntStruct* %11, i32 0, i32 1
	%15 = load i32, i32* %14
	%16 = icmp slt i32 %13, %15
	%17 = call i8* @malloc(i64 16)
	%18 = bitcast i8* %17 to %BoolStruct*
	%19 = getelementptr %BoolStruct, %BoolStruct* %18, i32 0, i32 1
	store i1 %16, i1* %19
	%20 = getelementptr %BoolStruct, %BoolStruct* %18, i32 0, i32 1
	%21 = load i1, i1* %20
	%22 = icmp ne i1 %21, false
	br i1 %22, label %while_body_19, label %while_end_20

while_body_19:
	%23 = load %StringStruct*, %StringStruct** %9
	%24 = bitcast %StringStruct* %23 to %ObjectStruct*
	%25 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%26 = load %IntStruct*, %IntStruct** %4
	%27 = call %StringStruct* @CellularAutomaton_cell_at_next_evolution(%CellularAutomaton_struct* %25, %IntStruct* %26)
	%28 = call %StringStruct* @String_concat(%ObjectStruct* %24, %StringStruct* %27)
	store %StringStruct* %28, %StringStruct** %9
	%29 = load %IntStruct*, %IntStruct** %4
	%30 = call i8* @malloc(i64 16)
	%31 = bitcast i8* %30 to %IntStruct*
	%32 = getelementptr %IntStruct, %IntStruct* %31, i32 0, i32 1
	store i32 1, i32* %32
	%33 = getelementptr %IntStruct, %IntStruct* %29, i32 0, i32 1
	%34 = load i32, i32* %33
	%35 = getelementptr %IntStruct, %IntStruct* %31, i32 0, i32 1
	%36 = load i32, i32* %35
	%37 = add i32 %34, %36
	%38 = call i8* @malloc(i64 16)
	%39 = bitcast i8* %38 to %IntStruct*
	%40 = getelementptr %IntStruct, %IntStruct* %39, i32 0, i32 1
	store i32 %37, i32* %40
	store %IntStruct* %39, %IntStruct** %4
	br label %while_cond_18

while_end_20:
	%41 = load %StringStruct*, %StringStruct** %9
	%42 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%43 = getelementptr %StringStruct*, %CellularAutomaton_struct* %42, i32 1
	store %StringStruct* %41, %StringStruct** %43
	%44 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	ret %CellularAutomaton_struct* %44
}

define %Main_struct* @Main_main(%Main_struct* %self) {
entry:
	%0 = alloca %Main_struct*
	store %Main_struct* %self, %Main_struct** %0
	%1 = load %Main_struct*, %Main_struct** %0
	%2 = bitcast %Main_struct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_17 to %StringStruct*), i32 0, i32 0
	%5 = load i8*, i8** %4
	%6 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%7 = call i32 (i8*, ...) @printf(i8* %6, i8* %5)
	%8 = load %Main_struct*, %Main_struct** %3
	%9 = call i8* @malloc(i64 16)
	%10 = bitcast i8* %9 to %CellularAutomaton_struct*
	%11 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %10, i32 0, i32 0
	store i8* bitcast ([8 x i8*]* bitcast ([8 x i8*]* @vtable_CellularAutomaton to [8 x i8*]*) to i8*), i8** %11
	%12 = load %Main_struct*, %Main_struct** %3
	%13 = getelementptr %CellularAutomaton_struct*, %Main_struct* %12, i32 1
	store %CellularAutomaton_struct* %10, %CellularAutomaton_struct** %13
	%14 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_19 to %StringStruct*), i32 0, i32 0
	%15 = load i8*, i8** %14
	%16 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%17 = call i32 (i8*, ...) @printf(i8* %16, i8* %15)
	%18 = load %Main_struct*, %Main_struct** %3
	%19 = load %Main_struct*, %Main_struct** %3
	%20 = bitcast %Main_struct* %19 to %Main_struct*
	%21 = getelementptr %Main_struct, %Main_struct* %20, i32 0, i32 1
	%22 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %21
	%23 = bitcast %CellularAutomaton_struct* %22 to %ObjectStruct*
	%24 = bitcast %ObjectStruct* %23 to %CellularAutomaton_struct*
	%25 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %24, i32 0, i32 0
	%26 = load i8*, i8** %25
	%27 = bitcast i8* %26 to [8 x %ObjectStruct* (%ObjectStruct*)*]*
	%28 = getelementptr [8 x %ObjectStruct* (%ObjectStruct*)*], [8 x %ObjectStruct* (%ObjectStruct*)*]* %27, i32 0, i32 0
	%29 = load i8*, %ObjectStruct* (%ObjectStruct*)** %28
	%30 = bitcast i8* %29 to %CellularAutomaton_struct* (%CellularAutomaton_struct*, %StringStruct*)*
	%31 = call %CellularAutomaton_struct* %30(%ObjectStruct* %23, %StringStruct* bitcast ({ i8* }* @str_obj_21 to %StringStruct*))
	%32 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_23 to %StringStruct*), i32 0, i32 0
	%33 = load i8*, i8** %32
	%34 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%35 = call i32 (i8*, ...) @printf(i8* %34, i8* %33)
	%36 = load %Main_struct*, %Main_struct** %3
	%37 = load %Main_struct*, %Main_struct** %3
	%38 = bitcast %Main_struct* %37 to %Main_struct*
	%39 = getelementptr %Main_struct, %Main_struct* %38, i32 0, i32 1
	%40 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %39
	%41 = bitcast %CellularAutomaton_struct* %40 to %ObjectStruct*
	%42 = bitcast %ObjectStruct* %41 to %CellularAutomaton_struct*
	%43 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %42, i32 0, i32 0
	%44 = load i8*, i8** %43
	%45 = bitcast i8* %44 to [8 x %ObjectStruct* (%ObjectStruct*)*]*
	%46 = getelementptr [8 x %ObjectStruct* (%ObjectStruct*)*], [8 x %ObjectStruct* (%ObjectStruct*)*]* %45, i32 0, i32 1
	%47 = load i8*, %ObjectStruct* (%ObjectStruct*)** %46
	%48 = bitcast i8* %47 to %CellularAutomaton_struct* (%CellularAutomaton_struct*)*
	%49 = call %CellularAutomaton_struct* %48(%ObjectStruct* %41)
	%50 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_25 to %StringStruct*), i32 0, i32 0
	%51 = load i8*, i8** %50
	%52 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%53 = call i32 (i8*, ...) @printf(i8* %52, i8* %51)
	%54 = load %Main_struct*, %Main_struct** %3
	%55 = alloca %IntStruct*
	%56 = call i8* @malloc(i64 16)
	%57 = bitcast i8* %56 to %IntStruct*
	%58 = getelementptr %IntStruct, %IntStruct* %57, i32 0, i32 1
	store i32 20, i32* %58
	store %IntStruct* %57, %IntStruct** %55
	br label %while_cond_21

while_cond_21:
	%59 = call i8* @malloc(i64 16)
	%60 = bitcast i8* %59 to %IntStruct*
	%61 = getelementptr %IntStruct, %IntStruct* %60, i32 0, i32 1
	store i32 0, i32* %61
	%62 = load %IntStruct*, %IntStruct** %55
	%63 = getelementptr %IntStruct, %IntStruct* %60, i32 0, i32 1
	%64 = load i32, i32* %63
	%65 = getelementptr %IntStruct, %IntStruct* %62, i32 0, i32 1
	%66 = load i32, i32* %65
	%67 = icmp slt i32 %64, %66
	%68 = call i8* @malloc(i64 16)
	%69 = bitcast i8* %68 to %BoolStruct*
	%70 = getelementptr %BoolStruct, %BoolStruct* %69, i32 0, i32 1
	store i1 %67, i1* %70
	%71 = getelementptr %BoolStruct, %BoolStruct* %69, i32 0, i32 1
	%72 = load i1, i1* %71
	%73 = icmp ne i1 %72, false
	br i1 %73, label %while_body_22, label %while_end_23

while_body_22:
	%74 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_27 to %StringStruct*), i32 0, i32 0
	%75 = load i8*, i8** %74
	%76 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%77 = call i32 (i8*, ...) @printf(i8* %76, i8* %75)
	%78 = load %Main_struct*, %Main_struct** %3
	%79 = load %Main_struct*, %Main_struct** %3
	%80 = bitcast %Main_struct* %79 to %Main_struct*
	%81 = getelementptr %Main_struct, %Main_struct* %80, i32 0, i32 1
	%82 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %81
	%83 = bitcast %CellularAutomaton_struct* %82 to %ObjectStruct*
	%84 = bitcast %ObjectStruct* %83 to %CellularAutomaton_struct*
	%85 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %84, i32 0, i32 0
	%86 = load i8*, i8** %85
	%87 = bitcast i8* %86 to [8 x %ObjectStruct* (%ObjectStruct*)*]*
	%88 = getelementptr [8 x %ObjectStruct* (%ObjectStruct*)*], [8 x %ObjectStruct* (%ObjectStruct*)*]* %87, i32 0, i32 7
	%89 = load i8*, %ObjectStruct* (%ObjectStruct*)** %88
	%90 = bitcast i8* %89 to %CellularAutomaton_struct* (%CellularAutomaton_struct*)*
	%91 = call %CellularAutomaton_struct* %90(%ObjectStruct* %83)
	%92 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_29 to %StringStruct*), i32 0, i32 0
	%93 = load i8*, i8** %92
	%94 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%95 = call i32 (i8*, ...) @printf(i8* %94, i8* %93)
	%96 = load %Main_struct*, %Main_struct** %3
	%97 = load %Main_struct*, %Main_struct** %3
	%98 = bitcast %Main_struct* %97 to %Main_struct*
	%99 = getelementptr %Main_struct, %Main_struct* %98, i32 0, i32 1
	%100 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %99
	%101 = bitcast %CellularAutomaton_struct* %100 to %ObjectStruct*
	%102 = bitcast %ObjectStruct* %101 to %CellularAutomaton_struct*
	%103 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %102, i32 0, i32 0
	%104 = load i8*, i8** %103
	%105 = bitcast i8* %104 to [8 x %ObjectStruct* (%ObjectStruct*)*]*
	%106 = getelementptr [8 x %ObjectStruct* (%ObjectStruct*)*], [8 x %ObjectStruct* (%ObjectStruct*)*]* %105, i32 0, i32 1
	%107 = load i8*, %ObjectStruct* (%ObjectStruct*)** %106
	%108 = bitcast i8* %107 to %CellularAutomaton_struct* (%CellularAutomaton_struct*)*
	%109 = call %CellularAutomaton_struct* %108(%ObjectStruct* %101)
	%110 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_31 to %StringStruct*), i32 0, i32 0
	%111 = load i8*, i8** %110
	%112 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%113 = call i32 (i8*, ...) @printf(i8* %112, i8* %111)
	%114 = load %Main_struct*, %Main_struct** %3
	%115 = load %IntStruct*, %IntStruct** %55
	%116 = call i8* @malloc(i64 16)
	%117 = bitcast i8* %116 to %IntStruct*
	%118 = getelementptr %IntStruct, %IntStruct* %117, i32 0, i32 1
	store i32 1, i32* %118
	%119 = getelementptr %IntStruct, %IntStruct* %115, i32 0, i32 1
	%120 = load i32, i32* %119
	%121 = getelementptr %IntStruct, %IntStruct* %117, i32 0, i32 1
	%122 = load i32, i32* %121
	%123 = sub i32 %120, %122
	%124 = call i8* @malloc(i64 16)
	%125 = bitcast i8* %124 to %IntStruct*
	%126 = getelementptr %IntStruct, %IntStruct* %125, i32 0, i32 1
	store i32 %123, i32* %126
	store %IntStruct* %125, %IntStruct** %55
	br label %while_cond_21

while_end_23:
	%127 = load %Main_struct*, %Main_struct** %3
	ret %Main_struct* %127
}

declare i32 @strcmp(i8* %str1, i8* %str2)
