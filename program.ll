@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@vtable_MyIO = constant [1 x i8*] [i8* bitcast ({}* ({ i8** }*)* @MyIO_main to i8*)]
@str_0 = constant [13 x i8] c"Hello World\0A\00"
@str_obj_6 = constant { i8* } { i8* getelementptr ([13 x i8], [13 x i8]* @str_0, i32 0, i32 0) }

declare i32 @printf(i8* nocapture %fmt, ...)

declare i32 @scanf(i8* nocapture %fmt, ...)

declare i8* @malloc(i64 %size)

define i32 @String_length({ i8* }* %str) {
entry:
	%0 = getelementptr { i8* }, { i8* }* %str, i32 0, i32 0
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

define { i8* }* @String_concat({ i8* }* %str, { i8* }* %other) {
entry:
	%0 = getelementptr { i8* }, { i8* }* %str, i32 0, i32 0
	%1 = load i8*, i8** %0
	%2 = getelementptr { i8* }, { i8* }* %other, i32 0, i32 0
	%3 = load i8*, i8** %2
	%4 = call i32 @String_length({ i8* }* %str)
	%5 = call i32 @String_length({ i8* }* %other)
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
	%14 = call i8* @malloc(i64 4)
	%15 = bitcast i8* %14 to { i8* }*
	%16 = getelementptr { i8* }, { i8* }* %15, i32 0, i32 0
	store i8* %9, i8** %16
	ret { i8* }* %15
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest, i8* %src, i64 %size, i32 %align, i1 %isvolatile)

define { i8* }* @String_substr({ i8* }* %str, i32 %start, i32 %len) {
entry:
	%0 = getelementptr { i8* }, { i8* }* %str, i32 0, i32 0
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
	%14 = call i8* @malloc(i64 4)
	%15 = bitcast i8* %14 to { i8* }*
	%16 = getelementptr { i8* }, { i8* }* %15, i32 0, i32 0
	store i8* %4, i8** %16
	ret { i8* }* %15
}

define i32 @main() {
entry:
	%0 = call {}* @MyIO_main()
	ret i32 0
}

define {}* @MyIO_main({ i8** }* %self) {
entry:
	%0 = alloca { i8** }*
	store { i8** }* %self, { i8** }** %0
	%1 = getelementptr { i8* }, { i8* }* bitcast ({ i8* }* @str_obj_6 to { i8* }*), i32 0, i32 0
	%2 = load i8*, i8** %1
	%3 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%4 = call i32 (i8*, ...) @printf(i8* %3, i8* %2)
	%5 = load { i8** }*, { i8** }** %0
	%6 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%7 = call i32 (i8*, ...) @printf(i8* %6, i32 42)
	%8 = load { i8** }*, { i8** }** %0
	%9 = bitcast { i8** }* %8 to {}*
	ret {}* %9
}
