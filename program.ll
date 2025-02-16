%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
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
@vtable_Main = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%ObjectStruct* (%ObjectStruct*)* @Main_main to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@str_0 = global [14 x i8] c"You entered: \00"
@str_obj_1 = constant { i8* } { [14 x i8]* getelementptr inbounds ([14 x i8], [14 x i8]* @str_0) }
@str_2 = global [2 x i8] c"\0A\00"
@str_obj_3 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_2) }
@str_4 = global [26 x i8] c"You entered the integer: \00"
@str_obj_5 = constant { i8* } { [26 x i8]* getelementptr inbounds ([26 x i8], [26 x i8]* @str_4) }
@str_6 = global [2 x i8] c"\0A\00"
@str_obj_7 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_6) }

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

define %ObjectStruct* @Main_main(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = alloca %StringStruct*
	%5 = alloca [1024 x i8]
	%6 = getelementptr [1024 x i8], [1024 x i8]* %5, i32 0, i32 0
	%7 = getelementptr [7 x i8], [7 x i8]* @fmt_str_in_2, i32 0, i32 0
	%8 = call i32 (i8*, ...) @scanf(i8* %7, i8* %6)
	%9 = call i8* @malloc(i64 16)
	%10 = bitcast i8* %9 to %StringStruct*
	%11 = getelementptr %StringStruct, %StringStruct* %10, i32 0, i32 0
	store i8* %6, i8** %11
	store %StringStruct* %10, %StringStruct** %4
	%12 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_1 to %StringStruct*), i32 0, i32 0
	%13 = load i8*, i8** %12
	%14 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%15 = call i32 (i8*, ...) @printf(i8* %14, i8* %13)
	%16 = load %Main_struct*, %Main_struct** %3
	%17 = load %StringStruct*, %StringStruct** %4
	%18 = getelementptr %StringStruct, %StringStruct* %17, i32 0, i32 0
	%19 = load i8*, i8** %18
	%20 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%21 = call i32 (i8*, ...) @printf(i8* %20, i8* %19)
	%22 = load %Main_struct*, %Main_struct** %3
	%23 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*), i32 0, i32 0
	%24 = load i8*, i8** %23
	%25 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%26 = call i32 (i8*, ...) @printf(i8* %25, i8* %24)
	%27 = load %Main_struct*, %Main_struct** %3
	%28 = alloca %IntStruct*
	%29 = alloca i32
	%30 = getelementptr [3 x i8], [3 x i8]* @fmt_int_in_3, i32 0, i32 0
	%31 = call i32 (i8*, ...) @scanf(i8* %30, i32* %29)
	%32 = load i32, i32* %29
	%33 = call i8* @malloc(i64 16)
	%34 = bitcast i8* %33 to %IntStruct*
	%35 = getelementptr %IntStruct, %IntStruct* %34, i32 0, i32 1
	store i32 %32, i32* %35
	store %IntStruct* %34, %IntStruct** %28
	%36 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%37 = load i8*, i8** %36
	%38 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%39 = call i32 (i8*, ...) @printf(i8* %38, i8* %37)
	%40 = load %Main_struct*, %Main_struct** %3
	%41 = load %IntStruct*, %IntStruct** %28
	%42 = call i8* @malloc(i64 16)
	%43 = bitcast i8* %42 to %IntStruct*
	%44 = getelementptr %IntStruct, %IntStruct* %43, i32 0, i32 1
	store i32 1, i32* %44
	%45 = getelementptr %IntStruct, %IntStruct* %41, i32 0, i32 1
	%46 = load i32, i32* %45
	%47 = getelementptr %IntStruct, %IntStruct* %43, i32 0, i32 1
	%48 = load i32, i32* %47
	%49 = sub i32 %46, %48
	%50 = call i8* @malloc(i64 16)
	%51 = bitcast i8* %50 to %IntStruct*
	%52 = getelementptr %IntStruct, %IntStruct* %51, i32 0, i32 1
	store i32 %49, i32* %52
	%53 = getelementptr %IntStruct, %IntStruct* %51, i32 0, i32 1
	%54 = load i32, i32* %53
	%55 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%56 = call i32 (i8*, ...) @printf(i8* %55, i32 %54)
	%57 = load %Main_struct*, %Main_struct** %3
	%58 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%59 = load i8*, i8** %58
	%60 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%61 = call i32 (i8*, ...) @printf(i8* %60, i8* %59)
	%62 = load %Main_struct*, %Main_struct** %3
	%63 = bitcast %Main_struct* %62 to %ObjectStruct*
	ret %ObjectStruct* %63
}
