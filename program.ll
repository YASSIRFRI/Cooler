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
@vtable_Object = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Int = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_String = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Bool = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_IO = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_CellularAutomaton = constant [8 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%CellularAutomaton_struct* (%ObjectStruct*, %StringStruct*)* @CellularAutomaton_init to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%CellularAutomaton_struct* (%ObjectStruct*)* @CellularAutomaton_print to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%IntStruct* (%ObjectStruct*)* @CellularAutomaton_num_cells to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*, %IntStruct*)* @CellularAutomaton_cell to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*, %IntStruct*)* @CellularAutomaton_cell_left_neighbor to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*, %IntStruct*)* @CellularAutomaton_cell_right_neighbor to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*, %IntStruct*)* @CellularAutomaton_cell_at_next_evolution to i8*) to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%CellularAutomaton_struct* (%ObjectStruct*)* @CellularAutomaton_evolve to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Main = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%Main_struct* (%ObjectStruct*)* @Main_main to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@str_0 = global [8 x i8] c"Test 2\0A\00"
@str_obj_1 = constant { i8* } { [8 x i8]* getelementptr inbounds ([8 x i8], [8 x i8]* @str_0) }
@str_2 = global [8 x i8] c"Test 3\0A\00"
@str_obj_3 = constant { i8* } { [8 x i8]* getelementptr inbounds ([8 x i8], [8 x i8]* @str_2) }
@str_4 = global [8 x i8] c"Test 4\0A\00"
@str_obj_5 = constant { i8* } { [8 x i8]* getelementptr inbounds ([8 x i8], [8 x i8]* @str_4) }
@str_6 = global [2 x i8] c"\0A\00"
@str_obj_7 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_6) }
@str_8 = global [2 x i8] c"X\00"
@str_obj_9 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_8) }
@str_10 = global [2 x i8] c"X\00"
@str_obj_11 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_10) }
@str_12 = global [2 x i8] c"X\00"
@str_obj_13 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_12) }
@str_14 = global [2 x i8] c"X\00"
@str_obj_15 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_14) }
@str_16 = global [2 x i8] c".\00"
@str_obj_17 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_16) }
@str_18 = global [1 x i8] c"\00"
@str_obj_19 = constant { i8* } { [1 x i8]* getelementptr inbounds ([1 x i8], [1 x i8]* @str_18) }
@str_20 = global [7 x i8] c"Test1\0A\00"
@str_obj_21 = constant { i8* } { [7 x i8]* getelementptr inbounds ([7 x i8], [7 x i8]* @str_20) }
@str_22 = global [20 x i8] c"XXXXXXXXXXXXXXXXXXX\00"
@str_obj_23 = constant { i8* } { [20 x i8]* getelementptr inbounds ([20 x i8], [20 x i8]* @str_22) }
@str_24 = global [2 x i8] c"T\00"
@str_obj_25 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_24) }

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
	%0 = call %Main_struct* @Main_main()
	ret i32 0
}

define %CellularAutomaton_struct* @CellularAutomaton_init(%ObjectStruct* %self, %StringStruct* %map) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = alloca %StringStruct*
	store %StringStruct* %map, %StringStruct** %4
	%5 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_1 to %StringStruct*), i32 0, i32 0
	%6 = load i8*, i8** %5
	%7 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%8 = call i32 (i8*, ...) @printf(i8* %7, i8* %6)
	%9 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%10 = load %StringStruct*, %StringStruct** %4
	%11 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%12 = getelementptr %StringStruct*, %CellularAutomaton_struct* %11, i32 1
	store %StringStruct* %10, %StringStruct** %12
	%13 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*), i32 0, i32 0
	%14 = load i8*, i8** %13
	%15 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%16 = call i32 (i8*, ...) @printf(i8* %15, i8* %14)
	%17 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%18 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	ret %CellularAutomaton_struct* %18
}

define %CellularAutomaton_struct* @CellularAutomaton_print(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%5 = load i8*, i8** %4
	%6 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%7 = call i32 (i8*, ...) @printf(i8* %6, i8* %5)
	%8 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%9 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%10 = bitcast %CellularAutomaton_struct* %9 to %CellularAutomaton_struct*
	%11 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %10, i32 0, i32 1
	%12 = load %StringStruct*, %StringStruct** %11
	%13 = bitcast %StringStruct* %12 to %ObjectStruct*
	%14 = call %StringStruct* @String_concat(%ObjectStruct* %13, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*))
	%15 = getelementptr %StringStruct, %StringStruct* %14, i32 0, i32 0
	%16 = load i8*, i8** %15
	%17 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%18 = call i32 (i8*, ...) @printf(i8* %17, i8* %16)
	%19 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%20 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	ret %CellularAutomaton_struct* %20
}

define %IntStruct* @CellularAutomaton_num_cells(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %CellularAutomaton_struct*
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

define %StringStruct* @CellularAutomaton_cell(%ObjectStruct* %self, %IntStruct* %position) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %CellularAutomaton_struct*
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

define %StringStruct* @CellularAutomaton_cell_left_neighbor(%ObjectStruct* %self, %IntStruct* %position) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %CellularAutomaton_struct*
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

define %StringStruct* @CellularAutomaton_cell_right_neighbor(%ObjectStruct* %self, %IntStruct* %position) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %CellularAutomaton_struct*
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

define %StringStruct* @CellularAutomaton_cell_at_next_evolution(%ObjectStruct* %self, %IntStruct* %position) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = alloca %IntStruct*
	store %IntStruct* %position, %IntStruct** %4
	%5 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%6 = load %IntStruct*, %IntStruct** %4
	%7 = call %StringStruct* @CellularAutomaton_cell(%CellularAutomaton_struct* %5, %IntStruct* %6)
	%8 = getelementptr %StringStruct, %StringStruct* %7, i32 0, i32 1
	%9 = load i8*, i8** %8
	%10 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*), i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = icmp eq i8* %9, %11
	%13 = call i8* @malloc(i64 16)
	%14 = bitcast i8* %13 to %BoolStruct*
	%15 = getelementptr %BoolStruct, %BoolStruct* %14, i32 0, i32 1
	store i1 %12, i1* %15
	%16 = getelementptr %BoolStruct, %BoolStruct* %14, i32 0, i32 1
	%17 = load i1, i1* %16
	%18 = icmp ne i1 %17, false
	br i1 %18, label %if_then_6, label %if_else_7

if_then_6:
	%19 = call i8* @malloc(i64 16)
	%20 = bitcast i8* %19 to %IntStruct*
	%21 = getelementptr %IntStruct, %IntStruct* %20, i32 0, i32 1
	store i32 1, i32* %21
	br label %if_end_8

if_else_7:
	%22 = call i8* @malloc(i64 16)
	%23 = bitcast i8* %22 to %IntStruct*
	%24 = getelementptr %IntStruct, %IntStruct* %23, i32 0, i32 1
	store i32 0, i32* %24
	br label %if_end_8

if_end_8:
	%25 = phi %IntStruct* [ %20, %if_then_6 ], [ %23, %if_else_7 ]
	%26 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%27 = load %IntStruct*, %IntStruct** %4
	%28 = call %StringStruct* @CellularAutomaton_cell_left_neighbor(%CellularAutomaton_struct* %26, %IntStruct* %27)
	%29 = getelementptr %StringStruct, %StringStruct* %28, i32 0, i32 1
	%30 = load i8*, i8** %29
	%31 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_11 to %StringStruct*), i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = icmp eq i8* %30, %32
	%34 = call i8* @malloc(i64 16)
	%35 = bitcast i8* %34 to %BoolStruct*
	%36 = getelementptr %BoolStruct, %BoolStruct* %35, i32 0, i32 1
	store i1 %33, i1* %36
	%37 = getelementptr %BoolStruct, %BoolStruct* %35, i32 0, i32 1
	%38 = load i1, i1* %37
	%39 = icmp ne i1 %38, false
	br i1 %39, label %if_then_9, label %if_else_10

if_then_9:
	%40 = call i8* @malloc(i64 16)
	%41 = bitcast i8* %40 to %IntStruct*
	%42 = getelementptr %IntStruct, %IntStruct* %41, i32 0, i32 1
	store i32 1, i32* %42
	br label %if_end_11

if_else_10:
	%43 = call i8* @malloc(i64 16)
	%44 = bitcast i8* %43 to %IntStruct*
	%45 = getelementptr %IntStruct, %IntStruct* %44, i32 0, i32 1
	store i32 0, i32* %45
	br label %if_end_11

if_end_11:
	%46 = phi %IntStruct* [ %41, %if_then_9 ], [ %44, %if_else_10 ]
	%47 = getelementptr %IntStruct, %IntStruct* %25, i32 0, i32 1
	%48 = load i32, i32* %47
	%49 = getelementptr %IntStruct, %IntStruct* %46, i32 0, i32 1
	%50 = load i32, i32* %49
	%51 = add i32 %48, %50
	%52 = call i8* @malloc(i64 16)
	%53 = bitcast i8* %52 to %IntStruct*
	%54 = getelementptr %IntStruct, %IntStruct* %53, i32 0, i32 1
	store i32 %51, i32* %54
	%55 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%56 = load %IntStruct*, %IntStruct** %4
	%57 = call %StringStruct* @CellularAutomaton_cell_right_neighbor(%CellularAutomaton_struct* %55, %IntStruct* %56)
	%58 = getelementptr %StringStruct, %StringStruct* %57, i32 0, i32 1
	%59 = load i8*, i8** %58
	%60 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_13 to %StringStruct*), i32 0, i32 1
	%61 = load i8*, i8** %60
	%62 = icmp eq i8* %59, %61
	%63 = call i8* @malloc(i64 16)
	%64 = bitcast i8* %63 to %BoolStruct*
	%65 = getelementptr %BoolStruct, %BoolStruct* %64, i32 0, i32 1
	store i1 %62, i1* %65
	%66 = getelementptr %BoolStruct, %BoolStruct* %64, i32 0, i32 1
	%67 = load i1, i1* %66
	%68 = icmp ne i1 %67, false
	br i1 %68, label %if_then_12, label %if_else_13

if_then_12:
	%69 = call i8* @malloc(i64 16)
	%70 = bitcast i8* %69 to %IntStruct*
	%71 = getelementptr %IntStruct, %IntStruct* %70, i32 0, i32 1
	store i32 1, i32* %71
	br label %if_end_14

if_else_13:
	%72 = call i8* @malloc(i64 16)
	%73 = bitcast i8* %72 to %IntStruct*
	%74 = getelementptr %IntStruct, %IntStruct* %73, i32 0, i32 1
	store i32 0, i32* %74
	br label %if_end_14

if_end_14:
	%75 = phi %IntStruct* [ %70, %if_then_12 ], [ %73, %if_else_13 ]
	%76 = getelementptr %IntStruct, %IntStruct* %53, i32 0, i32 1
	%77 = load i32, i32* %76
	%78 = getelementptr %IntStruct, %IntStruct* %75, i32 0, i32 1
	%79 = load i32, i32* %78
	%80 = add i32 %77, %79
	%81 = call i8* @malloc(i64 16)
	%82 = bitcast i8* %81 to %IntStruct*
	%83 = getelementptr %IntStruct, %IntStruct* %82, i32 0, i32 1
	store i32 %80, i32* %83
	%84 = call i8* @malloc(i64 16)
	%85 = bitcast i8* %84 to %IntStruct*
	%86 = getelementptr %IntStruct, %IntStruct* %85, i32 0, i32 1
	store i32 1, i32* %86
	%87 = getelementptr %IntStruct, %IntStruct* %82, i32 0, i32 1
	%88 = load i32, i32* %87
	%89 = getelementptr %IntStruct, %IntStruct* %85, i32 0, i32 1
	%90 = load i32, i32* %89
	%91 = icmp eq i32 %88, %90
	%92 = call i8* @malloc(i64 16)
	%93 = bitcast i8* %92 to %BoolStruct*
	%94 = getelementptr %BoolStruct, %BoolStruct* %93, i32 0, i32 1
	store i1 %91, i1* %94
	%95 = getelementptr %BoolStruct, %BoolStruct* %93, i32 0, i32 1
	%96 = load i1, i1* %95
	%97 = icmp ne i1 %96, false
	br i1 %97, label %if_then_15, label %if_else_16

if_then_15:
	br label %if_end_17

if_else_16:
	br label %if_end_17

if_end_17:
	%98 = phi %StringStruct* [ bitcast ({ i8* }* @str_obj_15 to %StringStruct*), %if_then_15 ], [ bitcast ({ i8* }* @str_obj_17 to %StringStruct*), %if_else_16 ]
	ret %StringStruct* %98
}

define %CellularAutomaton_struct* @CellularAutomaton_evolve(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %CellularAutomaton_struct*
	%3 = alloca %CellularAutomaton_struct*
	store %CellularAutomaton_struct* %2, %CellularAutomaton_struct** %3
	%4 = alloca %IntStruct*
	%5 = call i8* @malloc(i64 16)
	%6 = bitcast i8* %5 to %IntStruct*
	%7 = getelementptr %IntStruct, %IntStruct* %6, i32 0, i32 1
	store i32 0, i32* %7
	store %IntStruct* %6, %IntStruct** %4
	%8 = alloca %IntStruct*
	%9 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%10 = call %IntStruct* @CellularAutomaton_num_cells(%CellularAutomaton_struct* %9)
	store %IntStruct* %10, %IntStruct** %8
	%11 = alloca %StringStruct*
	store %StringStruct* bitcast ({ i8* }* @str_obj_19 to %StringStruct*), %StringStruct** %11
	br label %while_cond

while_cond:
	%12 = load %IntStruct*, %IntStruct** %4
	%13 = load %IntStruct*, %IntStruct** %8
	%14 = getelementptr %IntStruct, %IntStruct* %12, i32 0, i32 1
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
	br i1 %24, label %while_body, label %while_end

while_body:
	%25 = load %StringStruct*, %StringStruct** %11
	%26 = bitcast %StringStruct* %25 to %ObjectStruct*
	%27 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%28 = load %IntStruct*, %IntStruct** %4
	%29 = call %StringStruct* @CellularAutomaton_cell_at_next_evolution(%CellularAutomaton_struct* %27, %IntStruct* %28)
	%30 = call %StringStruct* @String_concat(%ObjectStruct* %26, %StringStruct* %29)
	store %StringStruct* %30, %StringStruct** %11
	%31 = load %IntStruct*, %IntStruct** %4
	%32 = call i8* @malloc(i64 16)
	%33 = bitcast i8* %32 to %IntStruct*
	%34 = getelementptr %IntStruct, %IntStruct* %33, i32 0, i32 1
	store i32 1, i32* %34
	%35 = getelementptr %IntStruct, %IntStruct* %31, i32 0, i32 1
	%36 = load i32, i32* %35
	%37 = getelementptr %IntStruct, %IntStruct* %33, i32 0, i32 1
	%38 = load i32, i32* %37
	%39 = add i32 %36, %38
	%40 = call i8* @malloc(i64 16)
	%41 = bitcast i8* %40 to %IntStruct*
	%42 = getelementptr %IntStruct, %IntStruct* %41, i32 0, i32 1
	store i32 %39, i32* %42
	store %IntStruct* %41, %IntStruct** %4
	br label %while_cond

while_end:
	%43 = load %StringStruct*, %StringStruct** %11
	%44 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	%45 = getelementptr %StringStruct*, %CellularAutomaton_struct* %44, i32 1
	store %StringStruct* %43, %StringStruct** %45
	%46 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %3
	ret %CellularAutomaton_struct* %46
}

define %Main_struct* @Main_main(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_21 to %StringStruct*), i32 0, i32 0
	%5 = load i8*, i8** %4
	%6 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%7 = call i32 (i8*, ...) @printf(i8* %6, i8* %5)
	%8 = load %Main_struct*, %Main_struct** %3
	%9 = call i8* @malloc(i64 16)
	%10 = bitcast i8* %9 to %CellularAutomaton_struct*
	%11 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %10, i32 0, i32 0
	store i8* bitcast ([8 x %ObjectStruct* (%ObjectStruct*)*]* bitcast ([8 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_CellularAutomaton to [8 x %ObjectStruct* (%ObjectStruct*)*]*) to i8*), i8** %11
	%12 = bitcast %CellularAutomaton_struct* %10 to %ObjectStruct*
	%13 = bitcast %ObjectStruct* %12 to %CellularAutomaton_struct*
	%14 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %13, i32 0, i32 0
	%15 = load i8*, i8** %14
	%16 = bitcast i8* %15 to [8 x %ObjectStruct* (%ObjectStruct*)*]*
	%17 = getelementptr [8 x %ObjectStruct* (%ObjectStruct*)*], [8 x %ObjectStruct* (%ObjectStruct*)*]* %16, i32 0, i32 0
	%18 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %17
	%19 = bitcast %ObjectStruct* (%ObjectStruct*)* %18 to %CellularAutomaton_struct* (%ObjectStruct*, %StringStruct*)*
	%20 = call %CellularAutomaton_struct* %19(%ObjectStruct* %12, %StringStruct* bitcast ({ i8* }* @str_obj_23 to %StringStruct*))
	%21 = load %Main_struct*, %Main_struct** %3
	%22 = getelementptr %CellularAutomaton_struct*, %Main_struct* %21, i32 1
	store %CellularAutomaton_struct* %20, %CellularAutomaton_struct** %22
	%23 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_25 to %StringStruct*), i32 0, i32 0
	%24 = load i8*, i8** %23
	%25 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%26 = call i32 (i8*, ...) @printf(i8* %25, i8* %24)
	%27 = load %Main_struct*, %Main_struct** %3
	%28 = load %Main_struct*, %Main_struct** %3
	%29 = bitcast %Main_struct* %28 to %Main_struct*
	%30 = getelementptr %Main_struct, %Main_struct* %29, i32 0, i32 1
	%31 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %30
	%32 = bitcast %CellularAutomaton_struct* %31 to %ObjectStruct*
	%33 = bitcast %ObjectStruct* %32 to %CellularAutomaton_struct*
	%34 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %33, i32 0, i32 0
	%35 = load i8*, i8** %34
	%36 = bitcast i8* %35 to [8 x %ObjectStruct* (%ObjectStruct*)*]*
	%37 = getelementptr [8 x %ObjectStruct* (%ObjectStruct*)*], [8 x %ObjectStruct* (%ObjectStruct*)*]* %36, i32 0, i32 1
	%38 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %37
	%39 = bitcast %ObjectStruct* (%ObjectStruct*)* %38 to %CellularAutomaton_struct* (%ObjectStruct*)*
	%40 = call %CellularAutomaton_struct* %39(%ObjectStruct* %32)
	%41 = alloca %IntStruct*
	%42 = call i8* @malloc(i64 16)
	%43 = bitcast i8* %42 to %IntStruct*
	%44 = getelementptr %IntStruct, %IntStruct* %43, i32 0, i32 1
	store i32 20, i32* %44
	store %IntStruct* %43, %IntStruct** %41
	br label %while_cond

while_cond:
	%45 = call i8* @malloc(i64 16)
	%46 = bitcast i8* %45 to %IntStruct*
	%47 = getelementptr %IntStruct, %IntStruct* %46, i32 0, i32 1
	store i32 0, i32* %47
	%48 = load %IntStruct*, %IntStruct** %41
	%49 = getelementptr %IntStruct, %IntStruct* %46, i32 0, i32 1
	%50 = load i32, i32* %49
	%51 = getelementptr %IntStruct, %IntStruct* %48, i32 0, i32 1
	%52 = load i32, i32* %51
	%53 = icmp slt i32 %50, %52
	%54 = call i8* @malloc(i64 16)
	%55 = bitcast i8* %54 to %BoolStruct*
	%56 = getelementptr %BoolStruct, %BoolStruct* %55, i32 0, i32 1
	store i1 %53, i1* %56
	%57 = getelementptr %BoolStruct, %BoolStruct* %55, i32 0, i32 1
	%58 = load i1, i1* %57
	%59 = icmp ne i1 %58, false
	br i1 %59, label %while_body, label %while_end

while_body:
	%60 = load %Main_struct*, %Main_struct** %3
	%61 = bitcast %Main_struct* %60 to %Main_struct*
	%62 = getelementptr %Main_struct, %Main_struct* %61, i32 0, i32 1
	%63 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %62
	%64 = bitcast %CellularAutomaton_struct* %63 to %ObjectStruct*
	%65 = bitcast %ObjectStruct* %64 to %CellularAutomaton_struct*
	%66 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %65, i32 0, i32 0
	%67 = load i8*, i8** %66
	%68 = bitcast i8* %67 to [8 x %ObjectStruct* (%ObjectStruct*)*]*
	%69 = getelementptr [8 x %ObjectStruct* (%ObjectStruct*)*], [8 x %ObjectStruct* (%ObjectStruct*)*]* %68, i32 0, i32 7
	%70 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %69
	%71 = bitcast %ObjectStruct* (%ObjectStruct*)* %70 to %CellularAutomaton_struct* (%ObjectStruct*)*
	%72 = call %CellularAutomaton_struct* %71(%ObjectStruct* %64)
	%73 = load %Main_struct*, %Main_struct** %3
	%74 = bitcast %Main_struct* %73 to %Main_struct*
	%75 = getelementptr %Main_struct, %Main_struct* %74, i32 0, i32 1
	%76 = load %CellularAutomaton_struct*, %CellularAutomaton_struct** %75
	%77 = bitcast %CellularAutomaton_struct* %76 to %ObjectStruct*
	%78 = bitcast %ObjectStruct* %77 to %CellularAutomaton_struct*
	%79 = getelementptr %CellularAutomaton_struct, %CellularAutomaton_struct* %78, i32 0, i32 0
	%80 = load i8*, i8** %79
	%81 = bitcast i8* %80 to [8 x %ObjectStruct* (%ObjectStruct*)*]*
	%82 = getelementptr [8 x %ObjectStruct* (%ObjectStruct*)*], [8 x %ObjectStruct* (%ObjectStruct*)*]* %81, i32 0, i32 1
	%83 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %82
	%84 = bitcast %ObjectStruct* (%ObjectStruct*)* %83 to %CellularAutomaton_struct* (%ObjectStruct*)*
	%85 = call %CellularAutomaton_struct* %84(%ObjectStruct* %77)
	%86 = load %IntStruct*, %IntStruct** %41
	%87 = call i8* @malloc(i64 16)
	%88 = bitcast i8* %87 to %IntStruct*
	%89 = getelementptr %IntStruct, %IntStruct* %88, i32 0, i32 1
	store i32 1, i32* %89
	%90 = getelementptr %IntStruct, %IntStruct* %86, i32 0, i32 1
	%91 = load i32, i32* %90
	%92 = getelementptr %IntStruct, %IntStruct* %88, i32 0, i32 1
	%93 = load i32, i32* %92
	%94 = sub i32 %91, %93
	%95 = call i8* @malloc(i64 16)
	%96 = bitcast i8* %95 to %IntStruct*
	%97 = getelementptr %IntStruct, %IntStruct* %96, i32 0, i32 1
	store i32 %94, i32* %97
	store %IntStruct* %96, %IntStruct** %41
	br label %while_cond

while_end:
	%98 = load %Main_struct*, %Main_struct** %3
	ret %Main_struct* %98
}
