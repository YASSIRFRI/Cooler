%ObjectStruct = type { i8* }
%IntStruct = type { i8*, i32 }
%BoolStruct = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct = type { i8* }
%ArrayStruct = type { i8*, i64, i8* }
%Animal_struct = type { i8* }
%Dog_struct = type { i8* }
%Cat_struct = type { i8* }
%Bird_struct = type { i8* }
%Fish_struct = type { i8* }
%Parrot_struct = type { i8* }
%Goldfish_struct = type { i8* }
%Main_struct = type { i8* }

@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"
@str_0 = global [7 x i8] c"String\00"
@str_obj_1 = constant { i8* } { i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_0, i32 0, i32 0) }
@str_2 = global [7 x i8] c"Object\00"
@str_obj_3 = constant { i8* } { i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_2, i32 0, i32 0) }
@vtable_Object = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Int = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null, %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%IntStruct*)* @Int_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_String = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%StringStruct*)* @String_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null]
@vtable_Bool = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* null]
@vtable_IO = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %StringStruct*)* @IO_out_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IOStruct* (%IOStruct*, %IntStruct*)* @IO_out_int to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%IOStruct*)* @IO_in_string to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%IOStruct*)* @IO_in_int to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Array = global [7 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%IntStruct* (%ArrayStruct*)* @Array_length to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (i8* (%ArrayStruct*, i64)* @Array_get to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (void (%ArrayStruct*, i64, i8*)* @Array_set to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ArrayStruct* (%ArrayStruct*, i64)* @Array_resize to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Animal = constant [1 x i8*] [i8* bitcast (%StringStruct* (%Animal_struct*)* @Animal_speak to i8*)]
@vtable_Dog = constant [1 x i8*] [i8* bitcast (%StringStruct* (%Dog_struct*)* @Dog_speak to i8*)]
@vtable_Cat = constant [1 x i8*] [i8* bitcast (%StringStruct* (%Cat_struct*)* @Cat_speak to i8*)]
@vtable_Bird = constant [1 x i8*] [i8* bitcast (%StringStruct* (%Bird_struct*)* @Bird_speak to i8*)]
@vtable_Fish = constant [1 x i8*] [i8* bitcast (%StringStruct* (%Fish_struct*)* @Fish_speak to i8*)]
@vtable_Parrot = constant [1 x i8*] [i8* bitcast (%StringStruct* (%Parrot_struct*)* @Parrot_speak to i8*)]
@vtable_Goldfish = constant [1 x i8*] [i8* bitcast (%StringStruct* (%Goldfish_struct*)* @Goldfish_speak to i8*)]
@vtable_Main = constant [1 x i8*] [i8* bitcast (%ObjectStruct* (%Main_struct*)* @Main_main to i8*)]
@str_4 = global [17 x i8] c"I am an animal.\0A\00"
@str_obj_5 = constant { i8* } { i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str_4, i32 0, i32 0) }
@str_6 = global [7 x i8] c"Woof!\0A\00"
@str_obj_7 = constant { i8* } { i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_6, i32 0, i32 0) }
@str_8 = global [7 x i8] c"Meow!\0A\00"
@str_obj_9 = constant { i8* } { i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_8, i32 0, i32 0) }
@str_10 = global [8 x i8] c"Chirp!\0A\00"
@str_obj_11 = constant { i8* } { i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str_10, i32 0, i32 0) }
@str_12 = global [12 x i8] c"Blub blub!\0A\00"
@str_obj_13 = constant { i8* } { i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str_12, i32 0, i32 0) }
@str_14 = global [24 x i8] c"Polly wants a cracker!\0A\00"
@str_obj_15 = constant { i8* } { i8* getelementptr inbounds ([24 x i8], [24 x i8]* @str_14, i32 0, i32 0) }
@str_16 = global [12 x i8] c"Glub glub!\0A\00"
@str_obj_17 = constant { i8* } { i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str_16, i32 0, i32 0) }

declare i8* @malloc(i64 %size)

declare i32 @printf(i8* nocapture %fmt, ...)

declare i32 @scanf(i8* nocapture %fmt, ...)

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

define %StringStruct* @String_type_name(%StringStruct* %self) {
entry:
	ret %StringStruct* bitcast ({ i8* }* @str_obj_1 to %StringStruct*)
}

declare void @exit(i32 %status)

define %ObjectStruct* @Object_abort(%ObjectStruct* %self) {
entry:
	call void @exit(i32 1)
	unreachable
}

define %StringStruct* @Object_type_name(%ObjectStruct* %self) {
entry:
	ret %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*)
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

define %IntStruct* @Int_copy(%IntStruct* %self) {
entry:
	%0 = call i8* @malloc(i64 16)
	%1 = bitcast i8* %0 to %IntStruct*
	%2 = getelementptr %IntStruct, %IntStruct* %self, i32 0, i32 0
	%3 = load i8*, i8** %2
	%4 = getelementptr %IntStruct, %IntStruct* %1, i32 0, i32 0
	store i8* %3, i8** %4
	%5 = getelementptr %IntStruct, %IntStruct* %self, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = getelementptr %IntStruct, %IntStruct* %1, i32 0, i32 1
	store i32 %6, i32* %7
	ret %IntStruct* %1
}

define %IOStruct* @IO_out_string(%IOStruct* %self, %StringStruct* %str) {
entry:
	%0 = getelementptr %StringStruct, %StringStruct* %str, i32 0, i32 1
	%1 = load i8*, i8** %0
	%2 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%3 = call i32 (i8*, ...) @printf(i8* %2, i8* %1)
	ret %IOStruct* %self
}

define %IOStruct* @IO_out_int(%IOStruct* %self, %IntStruct* %int) {
entry:
	%0 = getelementptr %IntStruct, %IntStruct* %int, i32 0, i32 1
	%1 = load i32, i32* %0
	%2 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%3 = call i32 (i8*, ...) @printf(i8* %2, i32 %1)
	ret %IOStruct* %self
}

define %StringStruct* @IO_in_string(%IOStruct* %self) {
entry:
	%0 = alloca [1024 x i8]
	%1 = getelementptr [1024 x i8], [1024 x i8]* %0, i32 0, i32 0
	%2 = getelementptr [7 x i8], [7 x i8]* @fmt_str_in_2, i32 0, i32 0
	%3 = call i32 (i8*, ...) @scanf(i8* %2, i8* %1)
	%4 = call i8* @malloc(i64 16)
	%5 = bitcast i8* %4 to %StringStruct*
	%6 = getelementptr %StringStruct, %StringStruct* %5, i32 0, i32 1
	store i8* %1, i8** %6
	ret %StringStruct* %5
}

define %IntStruct* @IO_in_int(%IOStruct* %self) {
entry:
	%0 = alloca i32
	%1 = getelementptr [3 x i8], [3 x i8]* @fmt_int_in_3, i32 0, i32 0
	%2 = call i32 (i8*, ...) @scanf(i8* %1, i32* %0)
	%3 = load i32, i32* %0
	%4 = call i8* @malloc(i64 16)
	%5 = bitcast i8* %4 to %IntStruct*
	%6 = getelementptr %IntStruct, %IntStruct* %5, i32 0, i32 1
	store i32 %3, i32* %6
	ret %IntStruct* %5
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

declare void @llvm.memset.p0i8.i64(i8* %dest, i8 %val, i64 %len, i32 %align, i1 %isvolatile)

define i8* @Array_get(%ArrayStruct* %self, i64 %index) {
entry:
	%0 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 1
	%1 = load i64, i64* %0
	%2 = icmp ult i64 %index, %1
	br i1 %2, label %valid, label %error

valid:
	%3 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 2
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8**
	%6 = getelementptr i8*, i8** %5, i64 %index
	%7 = load i8*, i8** %6
	ret i8* %7

error:
	ret i8* null
}

define void @Array_set(%ArrayStruct* %self, i64 %index, i8* %value) {
entry:
	%0 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 1
	%1 = load i64, i64* %0
	%2 = icmp ult i64 %index, %1
	br i1 %2, label %valid, label %error

valid:
	%3 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 2
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8**
	%6 = getelementptr i8*, i8** %5, i64 %index
	store i8* %value, i8** %6
	ret void

error:
	ret void
}

define %ArrayStruct* @Array_resize(%ArrayStruct* %self, i64 %new_size) {
entry:
	%0 = mul i64 %new_size, 8
	%1 = call i8* @malloc(i64 %0)
	call void @llvm.memset.p0i8.i64(i8* %1, i8 0, i64 %0, i32 8, i1 false)
	%2 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 2
	%3 = load i8*, i8** %2
	%4 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 1
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %new_size
	%7 = select i1 %6, i64 %5, i64 %new_size
	%8 = mul i64 %7, 8
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* %1, i8* %3, i64 %8, i32 8, i1 false)
	store i8* %1, i8** %2
	store i64 %new_size, i64* %4
	ret %ArrayStruct* %self
}

define %IntStruct* @Array_length(%ArrayStruct* %self) {
entry:
	%0 = getelementptr %ArrayStruct, %ArrayStruct* %self, i32 0, i32 1
	%1 = load i64, i64* %0
	%2 = trunc i64 %1 to i32
	%3 = call i8* @malloc(i64 16)
	%4 = bitcast i8* %3 to %IntStruct*
	%5 = getelementptr %IntStruct, %IntStruct* %4, i32 0, i32 1
	store i32 %2, i32* %5
	ret %IntStruct* %4
}

define i32 @main() {
entry:
	%0 = call i8* @malloc(i64 8)
	%1 = bitcast i8* %0 to %Main_struct*
	%2 = bitcast [1 x i8*]* @vtable_Main to i8*
	%3 = getelementptr %Main_struct, %Main_struct* %1, i32 0, i32 0
	store i8* %2, i8** %3
	%4 = call %ObjectStruct* @Main_main(%Main_struct* %1)
	ret i32 0
}

define %StringStruct* @Animal_speak(%Animal_struct* %self) {
entry:
	%0 = alloca %Animal_struct*
	store %Animal_struct* %self, %Animal_struct** %0
	%1 = load %Animal_struct*, %Animal_struct** %0
	%2 = bitcast %Animal_struct* %1 to %Animal_struct*
	%3 = alloca %Animal_struct*
	store %Animal_struct* %2, %Animal_struct** %3
	ret %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*)
}

define %StringStruct* @Dog_speak(%Dog_struct* %self) {
entry:
	%0 = alloca %Dog_struct*
	store %Dog_struct* %self, %Dog_struct** %0
	%1 = load %Dog_struct*, %Dog_struct** %0
	%2 = bitcast %Dog_struct* %1 to %Dog_struct*
	%3 = alloca %Dog_struct*
	store %Dog_struct* %2, %Dog_struct** %3
	ret %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*)
}

define %StringStruct* @Cat_speak(%Cat_struct* %self) {
entry:
	%0 = alloca %Cat_struct*
	store %Cat_struct* %self, %Cat_struct** %0
	%1 = load %Cat_struct*, %Cat_struct** %0
	%2 = bitcast %Cat_struct* %1 to %Cat_struct*
	%3 = alloca %Cat_struct*
	store %Cat_struct* %2, %Cat_struct** %3
	ret %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*)
}

define %StringStruct* @Bird_speak(%Bird_struct* %self) {
entry:
	%0 = alloca %Bird_struct*
	store %Bird_struct* %self, %Bird_struct** %0
	%1 = load %Bird_struct*, %Bird_struct** %0
	%2 = bitcast %Bird_struct* %1 to %Bird_struct*
	%3 = alloca %Bird_struct*
	store %Bird_struct* %2, %Bird_struct** %3
	ret %StringStruct* bitcast ({ i8* }* @str_obj_11 to %StringStruct*)
}

define %StringStruct* @Fish_speak(%Fish_struct* %self) {
entry:
	%0 = alloca %Fish_struct*
	store %Fish_struct* %self, %Fish_struct** %0
	%1 = load %Fish_struct*, %Fish_struct** %0
	%2 = bitcast %Fish_struct* %1 to %Fish_struct*
	%3 = alloca %Fish_struct*
	store %Fish_struct* %2, %Fish_struct** %3
	ret %StringStruct* bitcast ({ i8* }* @str_obj_13 to %StringStruct*)
}

define %StringStruct* @Parrot_speak(%Parrot_struct* %self) {
entry:
	%0 = alloca %Parrot_struct*
	store %Parrot_struct* %self, %Parrot_struct** %0
	%1 = load %Parrot_struct*, %Parrot_struct** %0
	%2 = bitcast %Parrot_struct* %1 to %Parrot_struct*
	%3 = alloca %Parrot_struct*
	store %Parrot_struct* %2, %Parrot_struct** %3
	ret %StringStruct* bitcast ({ i8* }* @str_obj_15 to %StringStruct*)
}

define %StringStruct* @Goldfish_speak(%Goldfish_struct* %self) {
entry:
	%0 = alloca %Goldfish_struct*
	store %Goldfish_struct* %self, %Goldfish_struct** %0
	%1 = load %Goldfish_struct*, %Goldfish_struct** %0
	%2 = bitcast %Goldfish_struct* %1 to %Goldfish_struct*
	%3 = alloca %Goldfish_struct*
	store %Goldfish_struct* %2, %Goldfish_struct** %3
	ret %StringStruct* bitcast ({ i8* }* @str_obj_17 to %StringStruct*)
}

define %ObjectStruct* @Main_main(%Main_struct* %self) {
entry:
	%0 = alloca %Main_struct*
	store %Main_struct* %self, %Main_struct** %0
	%1 = load %Main_struct*, %Main_struct** %0
	%2 = bitcast %Main_struct* %1 to %Main_struct*
	%3 = alloca %Main_struct*
	store %Main_struct* %2, %Main_struct** %3
	%4 = alloca %Animal_struct*
	%5 = call i8* @malloc(i64 8)
	%6 = bitcast i8* %5 to %Animal_struct*
	%7 = getelementptr %Animal_struct, %Animal_struct* %6, i32 0, i32 0
	store i8* bitcast ([1 x i8*]* bitcast ([1 x i8*]* @vtable_Animal to [1 x i8*]*) to i8*), i8** %7
	store %Animal_struct* %6, %Animal_struct** %4
	%8 = alloca %Animal_struct*
	%9 = call i8* @malloc(i64 8)
	%10 = bitcast i8* %9 to %Dog_struct*
	%11 = getelementptr %Dog_struct, %Dog_struct* %10, i32 0, i32 0
	store i8* bitcast ([1 x i8*]* bitcast ([1 x i8*]* @vtable_Dog to [1 x i8*]*) to i8*), i8** %11
	%12 = bitcast %Dog_struct* %10 to %Animal_struct*
	store %Animal_struct* %12, %Animal_struct** %8
	%13 = alloca %Animal_struct*
	%14 = call i8* @malloc(i64 8)
	%15 = bitcast i8* %14 to %Cat_struct*
	%16 = getelementptr %Cat_struct, %Cat_struct* %15, i32 0, i32 0
	store i8* bitcast ([1 x i8*]* bitcast ([1 x i8*]* @vtable_Cat to [1 x i8*]*) to i8*), i8** %16
	%17 = bitcast %Cat_struct* %15 to %Animal_struct*
	store %Animal_struct* %17, %Animal_struct** %13
	%18 = alloca %Bird_struct*
	%19 = call i8* @malloc(i64 8)
	%20 = bitcast i8* %19 to %Bird_struct*
	%21 = getelementptr %Bird_struct, %Bird_struct* %20, i32 0, i32 0
	store i8* bitcast ([1 x i8*]* bitcast ([1 x i8*]* @vtable_Bird to [1 x i8*]*) to i8*), i8** %21
	store %Bird_struct* %20, %Bird_struct** %18
	%22 = load %Animal_struct*, %Animal_struct** %4
	%23 = bitcast %Animal_struct* %22 to %ObjectStruct*
	%24 = bitcast %ObjectStruct* %23 to %Animal_struct*
	%25 = getelementptr %Animal_struct, %Animal_struct* %24, i32 0, i32 0
	%26 = load i8*, i8** %25
	%27 = bitcast i8* %26 to [1 x %ObjectStruct* (%ObjectStruct*)*]*
	%28 = getelementptr [1 x %ObjectStruct* (%ObjectStruct*)*], [1 x %ObjectStruct* (%ObjectStruct*)*]* %27, i32 0, i32 0
	%29 = load i8*, %ObjectStruct* (%ObjectStruct*)** %28
	%30 = bitcast i8* %29 to %StringStruct* (%Animal_struct*)*
	%31 = call %StringStruct* %30(%ObjectStruct* %23)
	%32 = getelementptr %StringStruct, %StringStruct* %31, i32 0, i32 0
	%33 = load i8*, i8** %32
	%34 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%35 = call i32 (i8*, ...) @printf(i8* %34, i8* %33)
	%36 = load %Main_struct*, %Main_struct** %3
	%37 = load %Animal_struct*, %Animal_struct** %8
	%38 = bitcast %Animal_struct* %37 to %ObjectStruct*
	%39 = bitcast %ObjectStruct* %38 to %Animal_struct*
	%40 = getelementptr %Animal_struct, %Animal_struct* %39, i32 0, i32 0
	%41 = load i8*, i8** %40
	%42 = bitcast i8* %41 to [1 x %ObjectStruct* (%ObjectStruct*)*]*
	%43 = getelementptr [1 x %ObjectStruct* (%ObjectStruct*)*], [1 x %ObjectStruct* (%ObjectStruct*)*]* %42, i32 0, i32 0
	%44 = load i8*, %ObjectStruct* (%ObjectStruct*)** %43
	%45 = bitcast i8* %44 to %StringStruct* (%Animal_struct*)*
	%46 = call %StringStruct* %45(%ObjectStruct* %38)
	%47 = getelementptr %StringStruct, %StringStruct* %46, i32 0, i32 0
	%48 = load i8*, i8** %47
	%49 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%50 = call i32 (i8*, ...) @printf(i8* %49, i8* %48)
	%51 = load %Main_struct*, %Main_struct** %3
	%52 = load %Animal_struct*, %Animal_struct** %13
	%53 = bitcast %Animal_struct* %52 to %ObjectStruct*
	%54 = bitcast %ObjectStruct* %53 to %Animal_struct*
	%55 = getelementptr %Animal_struct, %Animal_struct* %54, i32 0, i32 0
	%56 = load i8*, i8** %55
	%57 = bitcast i8* %56 to [1 x %ObjectStruct* (%ObjectStruct*)*]*
	%58 = getelementptr [1 x %ObjectStruct* (%ObjectStruct*)*], [1 x %ObjectStruct* (%ObjectStruct*)*]* %57, i32 0, i32 0
	%59 = load i8*, %ObjectStruct* (%ObjectStruct*)** %58
	%60 = bitcast i8* %59 to %StringStruct* (%Animal_struct*)*
	%61 = call %StringStruct* %60(%ObjectStruct* %53)
	%62 = getelementptr %StringStruct, %StringStruct* %61, i32 0, i32 0
	%63 = load i8*, i8** %62
	%64 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%65 = call i32 (i8*, ...) @printf(i8* %64, i8* %63)
	%66 = load %Main_struct*, %Main_struct** %3
	%67 = load %Bird_struct*, %Bird_struct** %18
	%68 = bitcast %Bird_struct* %67 to %ObjectStruct*
	%69 = bitcast %ObjectStruct* %68 to %Bird_struct*
	%70 = getelementptr %Bird_struct, %Bird_struct* %69, i32 0, i32 0
	%71 = load i8*, i8** %70
	%72 = bitcast i8* %71 to [1 x %ObjectStruct* (%ObjectStruct*)*]*
	%73 = getelementptr [1 x %ObjectStruct* (%ObjectStruct*)*], [1 x %ObjectStruct* (%ObjectStruct*)*]* %72, i32 0, i32 0
	%74 = load i8*, %ObjectStruct* (%ObjectStruct*)** %73
	%75 = bitcast i8* %74 to %StringStruct* (%Bird_struct*)*
	%76 = call %StringStruct* %75(%ObjectStruct* %68)
	%77 = getelementptr %StringStruct, %StringStruct* %76, i32 0, i32 0
	%78 = load i8*, i8** %77
	%79 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%80 = call i32 (i8*, ...) @printf(i8* %79, i8* %78)
	%81 = load %Main_struct*, %Main_struct** %3
	%82 = bitcast %Main_struct* %81 to %ObjectStruct*
	ret %ObjectStruct* %82
}

define %StringStruct* @String_copy(%StringStruct* %self) {
entry:
	%0 = call i8* @malloc(i64 16)
	%1 = bitcast i8* %0 to %StringStruct*
	%2 = bitcast [3 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_String to i8*
	%3 = getelementptr %StringStruct, %StringStruct* %1, i32 0, i32 0
	store i8* %2, i8** %3
	%4 = getelementptr %StringStruct, %StringStruct* %self, i32 0, i32 0
	%5 = load i8*, i8** %4
	%6 = getelementptr %StringStruct, %StringStruct* %1, i32 0, i32 0
	store i8* %5, i8** %6
	ret %StringStruct* %1
}
