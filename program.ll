@fmt_str_0 = constant [4 x i8] c"%s\0A\00"
@fmt_int_1 = constant [4 x i8] c"%d\0A\00"
@str_0 = constant [13 x i8] c"Hello World\0A\00"

declare i32 @printf(i8* nocapture %fmt, ...)

declare i32 @scanf(i8* nocapture %fmt, ...)

define i32 @main() {
entry:
	%0 = call i32 @MyIO_main()
	ret i32 0
}

define i32 @MyIO_main() {
entry:
	%0 = getelementptr [13 x i8], [13 x i8]* @str_0, i32 0, i32 0
	ret i32 0
}
