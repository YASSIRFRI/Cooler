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
@str_0 = global [8 x i8] c"Hello, \00"
@str_obj_1 = constant { i8* } { [8 x i8]* getelementptr inbounds ([8 x i8], [8 x i8]* @str_0) }
@str_2 = global [7 x i8] c"world!\00"
@str_obj_3 = constant { i8* } { [7 x i8]* getelementptr inbounds ([7 x i8], [7 x i8]* @str_2) }
@str_4 = global [26 x i8] c"Cool programming language\00"
@str_obj_5 = constant { i8* } { [26 x i8]* getelementptr inbounds ([26 x i8], [26 x i8]* @str_4) }
@str_6 = global [16 x i8] c"Concatenation: \00"
@str_obj_7 = constant { i8* } { [16 x i8]* getelementptr inbounds ([16 x i8], [16 x i8]* @str_6) }
@str_8 = global [2 x i8] c"\0A\00"
@str_obj_9 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_8) }
@str_10 = global [17 x i8] c"Length of str3: \00"
@str_obj_11 = constant { i8* } { [17 x i8]* getelementptr inbounds ([17 x i8], [17 x i8]* @str_10) }
@str_12 = global [2 x i8] c"\0A\00"
@str_obj_13 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_12) }
@str_14 = global [43 x i8] c"Substring of str3 (start: 5, length: 10): \00"
@str_obj_15 = constant { i8* } { [43 x i8]* getelementptr inbounds ([43 x i8], [43 x i8]* @str_14) }
@str_16 = global [2 x i8] c"\0A\00"
@str_obj_17 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_16) }

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
	store %StringStruct* bitcast ({ i8* }* @str_obj_1 to %StringStruct*), %StringStruct** %4
	%5 = alloca %StringStruct*
	store %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*), %StringStruct** %5
	%6 = alloca %StringStruct*
	store %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), %StringStruct** %6
	%7 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%8 = load i8*, i8** %7
	%9 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%10 = call i32 (i8*, ...) @printf(i8* %9, i8* %8)
	%11 = load %Main_struct*, %Main_struct** %3
	%12 = load %StringStruct*, %StringStruct** %4
	%13 = bitcast %StringStruct* %12 to %ObjectStruct*
	%14 = load %StringStruct*, %StringStruct** %5
	%15 = call %StringStruct* @String_concat(%ObjectStruct* %13, %StringStruct* %14)
	%16 = getelementptr %StringStruct, %StringStruct* %15, i32 0, i32 0
	%17 = load i8*, i8** %16
	%18 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%19 = call i32 (i8*, ...) @printf(i8* %18, i8* %17)
	%20 = load %Main_struct*, %Main_struct** %3
	%21 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*), i32 0, i32 0
	%22 = load i8*, i8** %21
	%23 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%24 = call i32 (i8*, ...) @printf(i8* %23, i8* %22)
	%25 = load %Main_struct*, %Main_struct** %3
	%26 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_11 to %StringStruct*), i32 0, i32 0
	%27 = load i8*, i8** %26
	%28 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%29 = call i32 (i8*, ...) @printf(i8* %28, i8* %27)
	%30 = load %Main_struct*, %Main_struct** %3
	%31 = load %StringStruct*, %StringStruct** %6
	%32 = bitcast %StringStruct* %31 to %ObjectStruct*
	%33 = call i32 @String_length(%ObjectStruct* %32)
	%34 = bitcast i32 %33 to %IntStruct*
	%35 = getelementptr %IntStruct, %IntStruct* %34, i32 0, i32 1
	%36 = load i32, i32* %35
	%37 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%38 = call i32 (i8*, ...) @printf(i8* %37, i32 %36)
	%39 = load %Main_struct*, %Main_struct** %3
	%40 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_13 to %StringStruct*), i32 0, i32 0
	%41 = load i8*, i8** %40
	%42 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%43 = call i32 (i8*, ...) @printf(i8* %42, i8* %41)
	%44 = load %Main_struct*, %Main_struct** %3
	%45 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_15 to %StringStruct*), i32 0, i32 0
	%46 = load i8*, i8** %45
	%47 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%48 = call i32 (i8*, ...) @printf(i8* %47, i8* %46)
	%49 = load %Main_struct*, %Main_struct** %3
	%50 = load %StringStruct*, %StringStruct** %6
	%51 = bitcast %StringStruct* %50 to %ObjectStruct*
	%52 = call i8* @malloc(i64 16)
	%53 = bitcast i8* %52 to %IntStruct*
	%54 = getelementptr %IntStruct, %IntStruct* %53, i32 0, i32 1
	store i32 5, i32* %54
	%55 = call i8* @malloc(i64 16)
	%56 = bitcast i8* %55 to %IntStruct*
	%57 = getelementptr %IntStruct, %IntStruct* %56, i32 0, i32 1
	store i32 10, i32* %57
	%58 = call %StringStruct* @String_substr(%ObjectStruct* %51, %IntStruct* %53, %IntStruct* %56)
	%59 = getelementptr %StringStruct, %StringStruct* %58, i32 0, i32 0
	%60 = load i8*, i8** %59
	%61 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%62 = call i32 (i8*, ...) @printf(i8* %61, i8* %60)
	%63 = load %Main_struct*, %Main_struct** %3
	%64 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_17 to %StringStruct*), i32 0, i32 0
	%65 = load i8*, i8** %64
	%66 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%67 = call i32 (i8*, ...) @printf(i8* %66, i8* %65)
	%68 = load %Main_struct*, %Main_struct** %3
	%69 = bitcast %Main_struct* %68 to %ObjectStruct*
	ret %ObjectStruct* %69
}
