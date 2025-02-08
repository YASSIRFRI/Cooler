@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@str_0 = constant [8 x i8] c"Hello, \00"
@str_1 = constant [7 x i8] c"world!\00"
@str_2 = constant [26 x i8] c"Cool programming language\00"
@str_3 = constant [16 x i8] c"Concatenation: \00"
@str_4 = constant [2 x i8] c"\0A\00"
@str_5 = constant [17 x i8] c"Length of str3: \00"
@str_6 = constant [2 x i8] c"\0A\00"
@str_7 = constant [43 x i8] c"Substring of str3 (start: 5, length: 10): \00"
@str_8 = constant [2 x i8] c"\0A\00"

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

define i32 @Main_main() {
entry:
	%0 = alloca i8*
	%1 = getelementptr [8 x i8], [8 x i8]* @str_0, i32 0, i32 0
	store i8* %1, i8** %0
	%2 = alloca i8*
	%3 = getelementptr [7 x i8], [7 x i8]* @str_1, i32 0, i32 0
	store i8* %3, i8** %2
	%4 = alloca i8*
	%5 = getelementptr [26 x i8], [26 x i8]* @str_2, i32 0, i32 0
	store i8* %5, i8** %4
	%6 = getelementptr [16 x i8], [16 x i8]* @str_3, i32 0, i32 0
	%7 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%8 = call i32 (i8*, ...) @printf(i8* %7, i8* %6)
	%9 = load i8*, i8** %0
	%10 = load i8*, i8** %2
	%11 = call i8* @String_concat(i8* %9, i8* %10)
	%12 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%13 = call i32 (i8*, ...) @printf(i8* %12, i8* %11)
	%14 = getelementptr [2 x i8], [2 x i8]* @str_4, i32 0, i32 0
	%15 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%16 = call i32 (i8*, ...) @printf(i8* %15, i8* %14)
	%17 = getelementptr [17 x i8], [17 x i8]* @str_5, i32 0, i32 0
	%18 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%19 = call i32 (i8*, ...) @printf(i8* %18, i8* %17)
	%20 = load i8*, i8** %4
	%21 = call i32 @String_length(i8* %20)
	%22 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%23 = call i32 (i8*, ...) @printf(i8* %22, i32 %21)
	%24 = getelementptr [2 x i8], [2 x i8]* @str_6, i32 0, i32 0
	%25 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%26 = call i32 (i8*, ...) @printf(i8* %25, i8* %24)
	%27 = getelementptr [43 x i8], [43 x i8]* @str_7, i32 0, i32 0
	%28 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%29 = call i32 (i8*, ...) @printf(i8* %28, i8* %27)
	%30 = load i8*, i8** %4
	%31 = call i8* @String_substr(i8* %30, i32 5, i32 10)
	%32 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%33 = call i32 (i8*, ...) @printf(i8* %32, i8* %31)
	%34 = getelementptr [2 x i8], [2 x i8]* @str_8, i32 0, i32 0
	%35 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%36 = call i32 (i8*, ...) @printf(i8* %35, i8* %34)
	ret i32 %36
}
