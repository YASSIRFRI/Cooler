%ObjectStruct = type {}
%IntStruct = type { i32 }
%BoolStruct = type { i1 }
%StringStruct = type { i8* }
%IOStruct = type {}
%Animal_struct = type {}
%Dog_struct = type {}
%Cat_struct = type {}
%Bird_struct = type {}
%Fish_struct = type {}
%Parrot_struct = type {}
%Main_struct = type { %Animal_struct*, %Animal_struct*, %Animal_struct*, %Animal_struct* }

@global_fmt_str = constant [3 x i8] c"%s\00"
@global_fmt_int = constant [3 x i8] c"%d\00"
@global_fmt_str_in = constant [7 x i8] c"%1023s\00"
@global_fmt_int_in = constant [3 x i8] c"%d\00"
@const_str_0 = constant [17 x i8] c"I am an animal.\0A\00"
@const_str_1 = constant [7 x i8] c"Woof!\0A\00"
@const_str_2 = constant [7 x i8] c"Meow!\0A\00"
@const_str_3 = constant [8 x i8] c"Chirp!\0A\00"
@const_str_4 = constant [12 x i8] c"Blub blub!\0A\00"
@const_str_5 = constant [24 x i8] c"Polly wants a cracker!\0A\00"
@const_str_6 = constant [5 x i8] c"test\00"

declare i32 @printf(i8* nocapture %fmt, ...)

declare i32 @scanf(i8* nocapture %fmt, ...)

declare i8* @malloc(i64 %size)

define i32 @String_length(%StringStruct* %str) {
entry:
	%0 = getelementptr %StringStruct, %StringStruct* %str, i32 0, i32 0
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
	%14 = call i8* @malloc(i64 8)
	%15 = bitcast i8* %14 to %StringStruct*
	%16 = getelementptr %StringStruct, %StringStruct* %15, i32 0, i32 0
	store i8* %9, i8** %16
	ret %StringStruct* %15
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest, i8* %src, i64 %size, i32 %align, i1 %isvolatile)

define %StringStruct* @String_substr(%StringStruct* %str, i32 %start, i32 %len) {
entry:
	%0 = getelementptr %StringStruct, %StringStruct* %str, i32 0, i32 0
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
	%14 = call i8* @malloc(i64 8)
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

define %StringStruct* @Animal_speak(%Animal_struct* %self) {
entry:
	%0 = alloca %Animal_struct*
	store %Animal_struct* %self, %Animal_struct** %0
	%1 = call i8* @malloc(i64 8)
	%2 = bitcast i8* %1 to %StringStruct*
	%3 = getelementptr %StringStruct, %StringStruct* %2, i32 0, i32 0
	store i8* getelementptr inbounds ([17 x i8], [17 x i8]* @const_str_0, i32 0, i32 0), i8** %3
	ret %StringStruct* %2
}

define %StringStruct* @Dog_speak(%Dog_struct* %self) {
entry:
	%0 = alloca %Dog_struct*
	store %Dog_struct* %self, %Dog_struct** %0
	%1 = call i8* @malloc(i64 8)
	%2 = bitcast i8* %1 to %StringStruct*
	%3 = getelementptr %StringStruct, %StringStruct* %2, i32 0, i32 0
	store i8* getelementptr inbounds ([7 x i8], [7 x i8]* @const_str_1, i32 0, i32 0), i8** %3
	ret %StringStruct* %2
}

define %StringStruct* @Cat_speak(%Cat_struct* %self) {
entry:
	%0 = alloca %Cat_struct*
	store %Cat_struct* %self, %Cat_struct** %0
	%1 = call i8* @malloc(i64 8)
	%2 = bitcast i8* %1 to %StringStruct*
	%3 = getelementptr %StringStruct, %StringStruct* %2, i32 0, i32 0
	store i8* getelementptr inbounds ([7 x i8], [7 x i8]* @const_str_2, i32 0, i32 0), i8** %3
	ret %StringStruct* %2
}

define %StringStruct* @Bird_speak(%Bird_struct* %self) {
entry:
	%0 = alloca %Bird_struct*
	store %Bird_struct* %self, %Bird_struct** %0
	%1 = call i8* @malloc(i64 8)
	%2 = bitcast i8* %1 to %StringStruct*
	%3 = getelementptr %StringStruct, %StringStruct* %2, i32 0, i32 0
	store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @const_str_3, i32 0, i32 0), i8** %3
	ret %StringStruct* %2
}

define %StringStruct* @Fish_speak(%Fish_struct* %self) {
entry:
	%0 = alloca %Fish_struct*
	store %Fish_struct* %self, %Fish_struct** %0
	%1 = call i8* @malloc(i64 8)
	%2 = bitcast i8* %1 to %StringStruct*
	%3 = getelementptr %StringStruct, %StringStruct* %2, i32 0, i32 0
	store i8* getelementptr inbounds ([12 x i8], [12 x i8]* @const_str_4, i32 0, i32 0), i8** %3
	ret %StringStruct* %2
}

define %StringStruct* @Parrot_speak(%Parrot_struct* %self) {
entry:
	%0 = alloca %Parrot_struct*
	store %Parrot_struct* %self, %Parrot_struct** %0
	%1 = call i8* @malloc(i64 8)
	%2 = bitcast i8* %1 to %StringStruct*
	%3 = getelementptr %StringStruct, %StringStruct* %2, i32 0, i32 0
	store i8* getelementptr inbounds ([24 x i8], [24 x i8]* @const_str_5, i32 0, i32 0), i8** %3
	ret %StringStruct* %2
}

define %ObjectStruct* @Main_main(%Main_struct* %self) {
entry:
	%0 = alloca %Main_struct*
	store %Main_struct* %self, %Main_struct** %0
	%1 = load %Main_struct*, %Main_struct** %0
	%2 = getelementptr %Main_struct, %Main_struct* %1, i32 0, i32 0
	%3 = load %Main_struct, %Animal_struct** %2
	%4 = bitcast %Main_struct %3 to %ObjectStruct*
	%5 = getelementptr %StringStruct, i8* null, i32 0, i32 0
	%6 = load i8*, i8** %5
	%7 = getelementptr [3 x i8], [3 x i8]* @global_fmt_str, i32 0, i32 0
	%8 = call i32 (i8*, ...) @printf(i8* %7, i8* %6)
	%9 = load %Main_struct*, %Main_struct** %0
	%10 = load %Main_struct*, %Main_struct** %0
	%11 = getelementptr %Main_struct, %Main_struct* %10, i32 0, i32 1
	%12 = load %Main_struct, %Animal_struct** %11
	%13 = bitcast %Main_struct %12 to %ObjectStruct*
	%14 = getelementptr %StringStruct, i8* null, i32 0, i32 0
	%15 = load i8*, i8** %14
	%16 = getelementptr [3 x i8], [3 x i8]* @global_fmt_str, i32 0, i32 0
	%17 = call i32 (i8*, ...) @printf(i8* %16, i8* %15)
	%18 = load %Main_struct*, %Main_struct** %0
	%19 = load %Main_struct*, %Main_struct** %0
	%20 = getelementptr %Main_struct, %Main_struct* %19, i32 0, i32 2
	%21 = load %Main_struct, %Animal_struct** %20
	%22 = bitcast %Main_struct %21 to %ObjectStruct*
	%23 = getelementptr %StringStruct, i8* null, i32 0, i32 0
	%24 = load i8*, i8** %23
	%25 = getelementptr [3 x i8], [3 x i8]* @global_fmt_str, i32 0, i32 0
	%26 = call i32 (i8*, ...) @printf(i8* %25, i8* %24)
	%27 = load %Main_struct*, %Main_struct** %0
	%28 = load %Main_struct*, %Main_struct** %0
	%29 = getelementptr %Main_struct, %Main_struct* %28, i32 0, i32 3
	%30 = load %Main_struct, %Animal_struct** %29
	%31 = bitcast %Main_struct %30 to %ObjectStruct*
	%32 = getelementptr %StringStruct, i8* null, i32 0, i32 0
	%33 = load i8*, i8** %32
	%34 = getelementptr [3 x i8], [3 x i8]* @global_fmt_str, i32 0, i32 0
	%35 = call i32 (i8*, ...) @printf(i8* %34, i8* %33)
	%36 = load %Main_struct*, %Main_struct** %0
	%37 = call i8* @malloc(i64 8)
	%38 = bitcast i8* %37 to %StringStruct*
	%39 = getelementptr %StringStruct, %StringStruct* %38, i32 0, i32 0
	store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @const_str_6, i32 0, i32 0), i8** %39
	%40 = getelementptr %StringStruct, %StringStruct* %38, i32 0, i32 0
	%41 = load i8*, i8** %40
	%42 = getelementptr [3 x i8], [3 x i8]* @global_fmt_str, i32 0, i32 0
	%43 = call i32 (i8*, ...) @printf(i8* %42, i8* %41)
	%44 = load %Main_struct*, %Main_struct** %0
	%45 = bitcast %Main_struct* %44 to %ObjectStruct*
	ret %ObjectStruct* %45
}
