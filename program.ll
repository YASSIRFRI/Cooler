@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@str_0 = constant [1 x i8] c"\00"
@CellularAutomaton_population_map = global i8* getelementptr ([1 x i8], [1 x i8]* @str_0, i32 0, i32 0)
@str_1 = constant [2 x i8] c"\0A\00"
@str_2 = constant [2 x i8] c"X\00"
@str_3 = constant [2 x i8] c"X\00"
@str_4 = constant [2 x i8] c"X\00"
@str_5 = constant [2 x i8] c"X\00"
@str_6 = constant [2 x i8] c".\00"
@Main_cells = global i32 0
@str_7 = constant [20 x i8] c"         X         \00"

declare i32 @printf(i8* nocapture %fmt, ...)

declare i32 @scanf(i8* nocapture %fmt, ...)

declare i8* @malloc(i64 %size)

define i32 @String_length(i8* %str) {
entry:
	%0 = alloca i32
	store i32 0, i32* %0
	br label %loop

loop:
	%1 = load i32, i32* %0
	%2 = getelementptr i8, i8* %str, i32 %1
	%3 = load i8, i8* %2
	%4 = icmp eq i8 %3, 0
	br i1 %4, label %exit, label %inc

inc:
	%5 = add i32 %1, 1
	store i32 %5, i32* %0
	br label %loop

exit:
	%6 = load i32, i32* %0
	ret i32 %6
}

define i8* @String_concat(i8* %str, i8* %other) {
entry:
	%0 = call i32 @String_length(i8* %str)
	%1 = call i32 @String_length(i8* %other)
	%2 = add i32 %0, %1
	%3 = add i32 %2, 1
	%4 = sext i32 %3 to i64
	%5 = call i8* @malloc(i64 %4)
	%6 = sext i32 %0 to i64
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* %5, i8* %str, i64 %6, i32 1, i1 false)
	%7 = getelementptr i8, i8* %5, i32 %0
	%8 = sext i32 %1 to i64
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* %7, i8* %other, i64 %8, i32 1, i1 false)
	%9 = getelementptr i8, i8* %5, i32 %2
	store i8 0, i8* %9
	ret i8* %5
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest, i8* %src, i64 %size, i32 %align, i1 %isvolatile)

define i8* @String_substr(i8* %str, i32 %start, i32 %len) {
entry:
	%0 = add i32 %len, 1
	%1 = sext i32 %0 to i64
	%2 = call i8* @malloc(i64 %1)
	%3 = alloca i32
	store i32 0, i32* %3
	br label %loop

loop:
	%4 = load i32, i32* %3
	%5 = icmp slt i32 %4, %len
	br i1 %5, label %body, label %finish

body:
	%6 = add i32 %start, %4
	%7 = getelementptr i8, i8* %str, i32 %6
	%8 = load i8, i8* %7
	%9 = getelementptr i8, i8* %2, i32 %4
	store i8 %8, i8* %9
	%10 = add i32 %4, 1
	store i32 %10, i32* %3
	br label %loop

finish:
	%11 = getelementptr i8, i8* %2, i32 %len
	store i8 0, i8* %11
	ret i8* %2
}

define i32 @main() {
entry:
	%0 = call i32 @Main_main()
	ret i32 %0
}

define i32 @CellularAutomaton_init(i32 %self, i8* %map) {
entry:
	%0 = alloca i32
	store i32 %self, i32* %0
	%1 = alloca i8*
	store i8* %map, i8** %1
	%2 = load i8*, i8** %1
	%3 = alloca i8*
	store i8* %2, i8** %3
	ret i32 0
}

define i32 @CellularAutomaton_print(i32 %self) {
entry:
	%0 = alloca i32
	store i32 %self, i32* %0
	%1 = load i8*, i8** @CellularAutomaton_population_map
	%2 = getelementptr [2 x i8], [2 x i8]* @str_1, i32 0, i32 0
	%3 = call i8* @String_concat(i8* %1, i8* %2)
	%4 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%5 = call i32 (i8*, ...) @printf(i8* %4, i8* %3)
	ret i32 0
}

define i32 @CellularAutomaton_num_cells(i32 %self) {
entry:
	%0 = alloca i32
	store i32 %self, i32* %0
	%1 = load i8*, i8** @CellularAutomaton_population_map
	%2 = call i32 @String_length(i8* %1)
	ret i32 %2
}

define i8* @CellularAutomaton_cell(i32 %self, i32 %position) {
entry:
	%0 = alloca i32
	store i32 %self, i32* %0
	%1 = alloca i32
	store i32 %position, i32* %1
	%2 = load i8*, i8** @CellularAutomaton_population_map
	%3 = load i32, i32* %1
	%4 = call i8* @String_substr(i8* %2, i32 %3, i32 1)
	ret i8* %4
}

define i8* @CellularAutomaton_cell_left_neighbor(i32 %self, i32 %position) {
entry:
	%0 = alloca i32
	store i32 %self, i32* %0
	%1 = alloca i32
	store i32 %position, i32* %1
	%2 = load i32, i32* %1
	%3 = icmp eq i32 %2, 0
	%4 = zext i1 %3 to i32
	%5 = icmp ne i32 %4, 0
	br i1 %5, label %if_then_0, label %if_else_1

if_then_0:
	%6 = call i32 @CellularAutomaton_num_cells()
	%7 = sub i32 %6, 1
	%8 = call i8* @CellularAutomaton_cell(i32 %7)
	br label %if_end_2

if_else_1:
	%9 = load i32, i32* %1
	%10 = sub i32 %9, 1
	%11 = call i8* @CellularAutomaton_cell(i32 %10)
	br label %if_end_2

if_end_2:
	%12 = phi i8* [ %8, %if_then_0 ], [ %11, %if_else_1 ]
	ret i8* %12
}

define i8* @CellularAutomaton_cell_right_neighbor(i32 %self, i32 %position) {
entry:
	%0 = alloca i32
	store i32 %self, i32* %0
	%1 = alloca i32
	store i32 %position, i32* %1
	%2 = load i32, i32* %1
	%3 = call i32 @CellularAutomaton_num_cells()
	%4 = sub i32 %3, 1
	%5 = icmp eq i32 %2, %4
	%6 = zext i1 %5 to i32
	%7 = icmp ne i32 %6, 0
	br i1 %7, label %if_then_3, label %if_else_4

if_then_3:
	%8 = call i8* @CellularAutomaton_cell(i32 0)
	br label %if_end_5

if_else_4:
	%9 = load i32, i32* %1
	%10 = add i32 %9, 1
	%11 = call i8* @CellularAutomaton_cell(i32 %10)
	br label %if_end_5

if_end_5:
	%12 = phi i8* [ %8, %if_then_3 ], [ %11, %if_else_4 ]
	ret i8* %12
}

define i8* @CellularAutomaton_cell_at_next_evolution(i32 %self, i32 %position) {
entry:
	%0 = alloca i32
	store i32 %self, i32* %0
	%1 = alloca i32
	store i32 %position, i32* %1
	%2 = load i32, i32* %1
	%3 = call i8* @CellularAutomaton_cell(i32 %2)
	%4 = getelementptr [2 x i8], [2 x i8]* @str_2, i32 0, i32 0
	%5 = icmp eq i8* %3, %4
	%6 = zext i1 %5 to i32
	%7 = icmp ne i32 %6, 0
	br i1 %7, label %if_then_6, label %if_else_7

if_then_6:
	br label %if_end_8

if_else_7:
	br label %if_end_8

if_end_8:
	%8 = phi i32 [ 1, %if_then_6 ], [ 0, %if_else_7 ]
	%9 = load i32, i32* %1
	%10 = call i8* @CellularAutomaton_cell_left_neighbor(i32 %9)
	%11 = getelementptr [2 x i8], [2 x i8]* @str_3, i32 0, i32 0
	%12 = icmp eq i8* %10, %11
	%13 = zext i1 %12 to i32
	%14 = icmp ne i32 %13, 0
	br i1 %14, label %if_then_9, label %if_else_10

if_then_9:
	br label %if_end_11

if_else_10:
	br label %if_end_11

if_end_11:
	%15 = phi i32 [ 1, %if_then_9 ], [ 0, %if_else_10 ]
	%16 = add i32 %8, %15
	%17 = load i32, i32* %1
	%18 = call i8* @CellularAutomaton_cell_right_neighbor(i32 %17)
	%19 = getelementptr [2 x i8], [2 x i8]* @str_4, i32 0, i32 0
	%20 = icmp eq i8* %18, %19
	%21 = zext i1 %20 to i32
	%22 = icmp ne i32 %21, 0
	br i1 %22, label %if_then_12, label %if_else_13

if_then_12:
	br label %if_end_14

if_else_13:
	br label %if_end_14

if_end_14:
	%23 = phi i32 [ 1, %if_then_12 ], [ 0, %if_else_13 ]
	%24 = add i32 %16, %23
	%25 = icmp eq i32 %24, 1
	%26 = zext i1 %25 to i32
	%27 = icmp ne i32 %26, 0
	br i1 %27, label %if_then_15, label %if_else_16

if_then_15:
	%28 = getelementptr [2 x i8], [2 x i8]* @str_5, i32 0, i32 0
	br label %if_end_17

if_else_16:
	%29 = getelementptr [2 x i8], [2 x i8]* @str_6, i32 0, i32 0
	br label %if_end_17

if_end_17:
	%30 = phi i8* [ %28, %if_then_15 ], [ %29, %if_else_16 ]
	ret i8* %30
}

define i32 @CellularAutomaton_evolve(i32 %self) {
entry:
	%0 = alloca i32
	store i32 %self, i32* %0
	%1 = alloca i32
	store i32 0, i32* %1
	%2 = alloca i32
	%3 = call i32 @CellularAutomaton_num_cells()
	store i32 %3, i32* %2
	%4 = alloca i8*
	store i8* null, i8** %4
	br label %while_cond

while_cond:
	%5 = load i32, i32* %1
	%6 = load i32, i32* %2
	%7 = icmp slt i32 %5, %6
	%8 = zext i1 %7 to i32
	%9 = icmp ne i32 %8, 0
	br i1 %9, label %while_body, label %while_end

while_body:
	%10 = load i8*, i8** %4
	%11 = load i32, i32* %1
	%12 = call i8* @CellularAutomaton_cell_at_next_evolution(i32 %11)
	%13 = call i8* @String_concat(i8* %10, i8* %12)
	store i8* %13, i8** %4
	%14 = load i32, i32* %1
	%15 = add i32 %14, 1
	store i32 %15, i32* %1
	br label %while_cond

while_end:
	%16 = load i8*, i8** %4
	%17 = alloca i8*
	store i8* %16, i8** %17
	ret i32 0
}

define i32 @Main_main(i32 %self) {
entry:
	%0 = alloca i32
	store i32 %self, i32* %0
	%1 = getelementptr [20 x i8], [20 x i8]* @str_7, i32 0, i32 0
	%2 = call i32 @CellularAutomaton_init(i32 0, i8* %1)
	%3 = alloca i32
	store i32 %2, i32* %3
	%4 = load i32, i32* %3
	%5 = call i32 @CellularAutomaton_print(i32 %4)
	%6 = alloca i32
	store i32 20, i32* %6
	br label %while_cond

while_cond:
	%7 = load i32, i32* %6
	%8 = icmp slt i32 0, %7
	%9 = zext i1 %8 to i32
	%10 = icmp ne i32 %9, 0
	br i1 %10, label %while_body, label %while_end

while_body:
	%11 = load i32, i32* %3
	%12 = call i32 @CellularAutomaton_evolve(i32 %11)
	%13 = load i32, i32* %3
	%14 = call i32 @CellularAutomaton_print(i32 %13)
	%15 = load i32, i32* %6
	%16 = sub i32 %15, 1
	store i32 %16, i32* %6
	br label %while_cond

while_end:
	ret i32 0
}
