%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%Animal_struct = type { i8* }
%Dog_struct = type { i8* }
%Cat_struct = type { i8* }
%Bird_struct = type { i8* }
%Fish_struct = type { i8* }
%Parrot_struct = type { i8* }
%Main_struct = type { i8*, %Animal_struct*, %Animal_struct*, %Animal_struct*, %Animal_struct* }

@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@vtable_Object = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Int = global [0 x %IntStruct* (%IntStruct*)*] []
@vtable_String = global [0 x %StringStruct* (%StringStruct*)*] []
@vtable_Bool = global [0 x %BoolStruct* (%BoolStruct*)*] []
@vtable_IO = global [0 x %IOStruct* (%IOStruct*)*] []
@vtable_Animal = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Animal_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Dog = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Dog_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Cat = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Cat_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Bird = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Bird_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Fish = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Fish_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Parrot = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Parrot_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Main = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%IOStruct* (%ObjectStruct*)* @Main_main to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@str_0 = global [17 x i8] c"I am an animal.\0A\00"
@str_obj_1 = constant %StringStruct { i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str_0, i32 0, i32 0) }
@str_2 = global [7 x i8] c"Woof!\0A\00"
@str_obj_3 = constant %StringStruct { i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_2, i32 0, i32 0) }
@str_4 = global [7 x i8] c"Meow!\0A\00"
@str_obj_5 = constant %StringStruct { i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_4, i32 0, i32 0) }
@str_6 = global [8 x i8] c"Chirp!\0A\00"
@str_obj_7 = constant %StringStruct { i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str_6, i32 0, i32 0) }
@str_8 = global [12 x i8] c"Blub blub!\0A\00"
@str_obj_9 = constant %StringStruct { i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str_8, i32 0, i32 0) }
@str_10 = global [24 x i8] c"Polly wants a cracker!\0A\00"
@str_obj_11 = constant %StringStruct { i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), i8* getelementptr inbounds ([24 x i8], [24 x i8]* @str_10, i32 0, i32 0) }
@str_12 = global [5 x i8] c"test\00"
@str_obj_13 = constant %StringStruct { i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str_12, i32 0, i32 0) }

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
	%0 = getelementptr %StringStruct, %StringStruct* %str, i32 0, i32 1
	%1 = load i8*, i8** %0
	%2 = getelementptr %StringStruct, %StringStruct* %other, i32 0, i32 1
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
	%16 = getelementptr %StringStruct, %StringStruct* %15, i32 0, i32 1
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
	%16 = getelementptr %StringStruct, %StringStruct* %15, i32 0, i32 1
	store i8* %4, i8** %16
	ret %StringStruct* %15
}

define i32 @main() {
entry:
	%0 = call %IOStruct* @Main_main()
	ret i32 0
}

define %StringStruct* @Animal_speak(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Animal_struct*
	%3 = alloca %Animal_struct*
	store %Animal_struct* %2, %Animal_struct** %3
	ret %StringStruct* bitcast (%StringStruct* @str_obj_1 to %StringStruct*)
}

define %StringStruct* @Dog_speak(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Dog_struct*
	%3 = alloca %Dog_struct*
	store %Dog_struct* %2, %Dog_struct** %3
	ret %StringStruct* bitcast (%StringStruct* @str_obj_3 to %StringStruct*)
}

define %StringStruct* @Cat_speak(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Cat_struct*
	%3 = alloca %Cat_struct*
	store %Cat_struct* %2, %Cat_struct** %3
	ret %StringStruct* bitcast (%StringStruct* @str_obj_5 to %StringStruct*)
}

define %StringStruct* @Bird_speak(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Bird_struct*
	%3 = alloca %Bird_struct*
	store %Bird_struct* %2, %Bird_struct** %3
	ret %StringStruct* bitcast (%StringStruct* @str_obj_7 to %StringStruct*)
}

define %StringStruct* @Fish_speak(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Fish_struct*
	%3 = alloca %Fish_struct*
	store %Fish_struct* %2, %Fish_struct** %3
	ret %StringStruct* bitcast (%StringStruct* @str_obj_9 to %StringStruct*)
}

define %StringStruct* @Parrot_speak(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Parrot_struct*
	%3 = alloca %Parrot_struct*
	store %Parrot_struct* %2, %Parrot_struct** %3
	ret %StringStruct* bitcast (%StringStruct* @str_obj_11 to %StringStruct*)
}

define %IOStruct* @Main_main(%ObjectStruct* %self) {
entry:
	%0 = alloca %ObjectStruct*
	store %ObjectStruct* %self, %ObjectStruct** %0
	%1 = load %ObjectStruct*, %ObjectStruct** %0
	%2 = bitcast %ObjectStruct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = bitcast i8* null to %Main_struct*
	%5 = bitcast %Main_struct* %4 to %Animal_struct*
	%6 = getelementptr %Animal_struct, %Animal_struct* %5, i32 1
	%7 = load i8*, %Animal_struct* %6
	%8 = bitcast i8* %7 to [1 x %ObjectStruct* (%ObjectStruct*)*]*
	%9 = getelementptr [1 x %ObjectStruct* (%ObjectStruct*)*], [1 x %ObjectStruct* (%ObjectStruct*)*]* %8, i32 0, i32 0
	%10 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %9
	%11 = bitcast %ObjectStruct* (%ObjectStruct*)* %10 to %StringStruct* (%ObjectStruct*)*
	%12 = call %StringStruct* %11(%Main_struct* %4)
	%13 = getelementptr %StringStruct, %StringStruct* %12, i32 0, i32 1
	%14 = load i8*, i8** %13
	%15 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%16 = call i32 (i8*, ...) @printf(i8* %15, i8* %14)
	%17 = load %Main_struct*, %Main_struct** %3
	%18 = bitcast i8* null to %Main_struct*
	%19 = bitcast %Main_struct* %18 to %Animal_struct*
	%20 = getelementptr %Animal_struct, %Animal_struct* %19, i32 1
	%21 = load i8*, %Animal_struct* %20
	%22 = bitcast i8* %21 to [1 x %ObjectStruct* (%ObjectStruct*)*]*
	%23 = getelementptr [1 x %ObjectStruct* (%ObjectStruct*)*], [1 x %ObjectStruct* (%ObjectStruct*)*]* %22, i32 0, i32 0
	%24 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %23
	%25 = bitcast %ObjectStruct* (%ObjectStruct*)* %24 to %StringStruct* (%ObjectStruct*)*
	%26 = call %StringStruct* %25(%Main_struct* %18)
	%27 = getelementptr %StringStruct, %StringStruct* %26, i32 0, i32 1
	%28 = load i8*, i8** %27
	%29 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%30 = call i32 (i8*, ...) @printf(i8* %29, i8* %28)
	%31 = load %Main_struct*, %Main_struct** %3
	%32 = bitcast i8* null to %Main_struct*
	%33 = bitcast %Main_struct* %32 to %Animal_struct*
	%34 = getelementptr %Animal_struct, %Animal_struct* %33, i32 1
	%35 = load i8*, %Animal_struct* %34
	%36 = bitcast i8* %35 to [1 x %ObjectStruct* (%ObjectStruct*)*]*
	%37 = getelementptr [1 x %ObjectStruct* (%ObjectStruct*)*], [1 x %ObjectStruct* (%ObjectStruct*)*]* %36, i32 0, i32 0
	%38 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %37
	%39 = bitcast %ObjectStruct* (%ObjectStruct*)* %38 to %StringStruct* (%ObjectStruct*)*
	%40 = call %StringStruct* %39(%Main_struct* %32)
	%41 = getelementptr %StringStruct, %StringStruct* %40, i32 0, i32 1
	%42 = load i8*, i8** %41
	%43 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%44 = call i32 (i8*, ...) @printf(i8* %43, i8* %42)
	%45 = load %Main_struct*, %Main_struct** %3
	%46 = bitcast i8* null to %Main_struct*
	%47 = bitcast %Main_struct* %46 to %Animal_struct*
	%48 = getelementptr %Animal_struct, %Animal_struct* %47, i32 1
	%49 = load i8*, %Animal_struct* %48
	%50 = bitcast i8* %49 to [1 x %ObjectStruct* (%ObjectStruct*)*]*
	%51 = getelementptr [1 x %ObjectStruct* (%ObjectStruct*)*], [1 x %ObjectStruct* (%ObjectStruct*)*]* %50, i32 0, i32 0
	%52 = load %ObjectStruct* (%ObjectStruct*)*, %ObjectStruct* (%ObjectStruct*)** %51
	%53 = bitcast %ObjectStruct* (%ObjectStruct*)* %52 to %StringStruct* (%ObjectStruct*)*
	%54 = call %StringStruct* %53(%Main_struct* %46)
	%55 = getelementptr %StringStruct, %StringStruct* %54, i32 0, i32 1
	%56 = load i8*, i8** %55
	%57 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%58 = call i32 (i8*, ...) @printf(i8* %57, i8* %56)
	%59 = load %Main_struct*, %Main_struct** %3
	%60 = getelementptr %StringStruct, %StringStruct* bitcast (%StringStruct* @str_obj_13 to %StringStruct*), i32 0, i32 1
	%61 = load i8*, i8** %60
	%62 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%63 = call i32 (i8*, ...) @printf(i8* %62, i8* %61)
	%64 = load %Main_struct*, %Main_struct** %3
	%65 = bitcast %Main_struct* %64 to %IOStruct*
	ret %IOStruct* %65
}
