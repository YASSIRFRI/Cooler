; ======== Types ========
%ObjectStruct = type { i8* }
%IntStruct    = type { i8*, i32 }
%BoolStruct   = type { i8*, i1 }
%StringStruct = type { i8*, i8* }
%IOStruct     = type { i8* }
%Animal_struct= type { i8* }
%Dog_struct   = type { i8* }
%Cat_struct   = type { i8* }
%Bird_struct  = type { i8* }
%Fish_struct  = type { i8* }
%Parrot_struct= type { i8* }
; Main contains: [vtable pointer, animal, dog, cat, bird]
%Main_struct  = type { i8*, %Animal_struct*, %Animal_struct*, %Animal_struct*, %Animal_struct* }

; ======== Global Constants and Vtables ========
@fmt_str_0 = constant [3 x i8] c"%s\00"
@fmt_int_1 = constant [3 x i8] c"%d\00"
@fmt_str_in_2 = constant [7 x i8] c"%1023s\00"
@fmt_int_in_3 = constant [3 x i8] c"%d\00"

@vtable_Object = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Int    = global [0 x %IntStruct* (%IntStruct*)*] []
@vtable_String = global [0 x %StringStruct* (%StringStruct*)*] []
@vtable_Bool   = global [0 x %BoolStruct* (%BoolStruct*)*] []
@vtable_IO     = global [0 x %IOStruct* (%IOStruct*)*] []

@vtable_Animal = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [
    %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Animal_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)
]
@vtable_Dog = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [
    %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Dog_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)
]
@vtable_Cat = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [
    %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Cat_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)
]
@vtable_Bird = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [
    %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Bird_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)
]
@vtable_Fish = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [
    %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Fish_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)
]
@vtable_Parrot = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [
    %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%StringStruct* (%ObjectStruct*)* @Parrot_speak to i8*) to %ObjectStruct* (%ObjectStruct*)*)
]
@vtable_Main = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [
    %ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%ObjectStruct* (%ObjectStruct*)* @Main_main to i8*) to %ObjectStruct* (%ObjectStruct*)*)
]

@str_0 = global [17 x i8] c"I am an animal.\0A\00"
@str_obj_1 = constant %StringStruct { 
    i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), 
    i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str_0, i32 0, i32 0)
}
@str_2 = global [7 x i8] c"Woof!\0A\00"
@str_obj_3 = constant %StringStruct { 
    i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), 
    i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_2, i32 0, i32 0)
}
@str_4 = global [7 x i8] c"Meow!\0A\00"
@str_obj_5 = constant %StringStruct { 
    i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), 
    i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_4, i32 0, i32 0)
}
@str_6 = global [8 x i8] c"Chirp!\0A\00"
@str_obj_7 = constant %StringStruct { 
    i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), 
    i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str_6, i32 0, i32 0)
}
@str_8 = global [12 x i8] c"Blub blub!\0A\00"
@str_obj_9 = constant %StringStruct { 
    i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), 
    i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str_8, i32 0, i32 0)
}
@str_10 = global [24 x i8] c"Polly wants a cracker!\0A\00"
@str_obj_11 = constant %StringStruct { 
    i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), 
    i8* getelementptr inbounds ([24 x i8], [24 x i8]* @str_10, i32 0, i32 0)
}
@str_12 = global [5 x i8] c"test\00"
@str_obj_13 = constant %StringStruct { 
    i8* bitcast ([0 x %StringStruct* (%StringStruct*)*]* @vtable_String to i8*), 
    i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str_12, i32 0, i32 0)
}

; ======== External Declarations ========
declare i32 @printf(i8* nocapture, ...)
declare i32 @scanf(i8* nocapture, ...)
declare i8* @malloc(i64)

; ======== String Operation Definitions ========
define i32 @String_length(%StringStruct* %str) {
entry:
  %ptr = getelementptr %StringStruct, %StringStruct* %str, i32 0, i32 1
  %s = load i8*, i8** %ptr
  %i = alloca i32
  store i32 0, i32* %i
  br label %loop

loop:
  %index = load i32, i32* %i
  %char_ptr = getelementptr i8, i8* %s, i32 %index
  %char = load i8, i8* %char_ptr
  %is_zero = icmp eq i8 %char, 0
  br i1 %is_zero, label %exit, label %inc

inc:
  %next = add i32 %index, 1
  store i32 %next, i32* %i
  br label %loop

exit:
  %len = load i32, i32* %i
  ret i32 %len
}

define %StringStruct* @String_concat(%StringStruct* %str, %StringStruct* %other) {
entry:
  ; (implementation omitted for brevity; see original IR)
  ret %StringStruct* null
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i32, i1)

define %StringStruct* @String_substr(%StringStruct* %str, i32 %start, i32 %len) {
entry:
  ; (implementation omitted for brevity; see original IR)
  ret %StringStruct* null
}

; ======== Speak Method Definitions ========
define %StringStruct* @Animal_speak(%ObjectStruct* %self) {
entry:
  ret %StringStruct* bitcast (%StringStruct* @str_obj_1 to %StringStruct*)
}

define %StringStruct* @Dog_speak(%ObjectStruct* %self) {
entry:
  ret %StringStruct* bitcast (%StringStruct* @str_obj_3 to %StringStruct*)
}

define %StringStruct* @Cat_speak(%ObjectStruct* %self) {
entry:
  ret %StringStruct* bitcast (%StringStruct* @str_obj_5 to %StringStruct*)
}

define %StringStruct* @Bird_speak(%ObjectStruct* %self) {
entry:
  ret %StringStruct* bitcast (%StringStruct* @str_obj_7 to %StringStruct*)
}

define %StringStruct* @Fish_speak(%ObjectStruct* %self) {
entry:
  ret %StringStruct* bitcast (%StringStruct* @str_obj_9 to %StringStruct*)
}

define %StringStruct* @Parrot_speak(%ObjectStruct* %self) {
entry:
  ret %StringStruct* bitcast (%StringStruct* @str_obj_11 to %StringStruct*)
}

; ======== Fixed Main_main Function ========
define %ObjectStruct* @Main_main(%ObjectStruct* %self) {
entry:
  ; Allocate Main object (5 pointer-sized fields)
  %main_size_ptr = getelementptr %Main_struct, %Main_struct* null, i32 1
  %main_size = ptrtoint %Main_struct* %main_size_ptr to i64
  %main_mem = call i8* @malloc(i64 %main_size)
  %main_obj = bitcast i8* %main_mem to %Main_struct*

  ; Initialize Main object's vtable pointer (field 0)
  %vtable_field = getelementptr %Main_struct, %Main_struct* %main_obj, i32 0, i32 0
  %main_vtable = bitcast [1 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_Main to i8*
  store i8* %main_vtable, i8** %vtable_field

  ; Allocate and initialize Animal attribute (new Animal)
  %animal_size_ptr = getelementptr %Animal_struct, %Animal_struct* null, i32 1
  %animal_size = ptrtoint %Animal_struct* %animal_size_ptr to i64
  %animal_mem = call i8* @malloc(i64 %animal_size)
  %animal_obj = bitcast i8* %animal_mem to %Animal_struct*
  %animal_vtable_field = getelementptr %Animal_struct, %Animal_struct* %animal_obj, i32 0, i32 0
  %animal_vtable = bitcast [1 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_Animal to i8*
  store i8* %animal_vtable, i8** %animal_vtable_field

  ; Allocate and initialize Dog attribute (new Dog)
  %dog_size_ptr = getelementptr %Dog_struct, %Dog_struct* null, i32 1
  %dog_size = ptrtoint %Dog_struct* %dog_size_ptr to i64
  %dog_mem = call i8* @malloc(i64 %dog_size)
  %dog_obj = bitcast i8* %dog_mem to %Dog_struct*
  %dog_vtable_field = getelementptr %Dog_struct, %Dog_struct* %dog_obj, i32 0, i32 0
  %dog_vtable = bitcast [1 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_Dog to i8*
  store i8* %dog_vtable, i8** %dog_vtable_field
  %dog_as_animal = bitcast %Dog_struct* %dog_obj to %Animal_struct*

  ; Allocate and initialize Cat attribute (new Cat)
  %cat_size_ptr = getelementptr %Cat_struct, %Cat_struct* null, i32 1
  %cat_size = ptrtoint %Cat_struct* %cat_size_ptr to i64
  %cat_mem = call i8* @malloc(i64 %cat_size)
  %cat_obj = bitcast i8* %cat_mem to %Cat_struct*
  %cat_vtable_field = getelementptr %Cat_struct, %Cat_struct* %cat_obj, i32 0, i32 0
  %cat_vtable = bitcast [1 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_Cat to i8*
  store i8* %cat_vtable, i8** %cat_vtable_field
  %cat_as_animal = bitcast %Cat_struct* %cat_obj to %Animal_struct*

  ; Allocate and initialize Bird attribute (new Bird)
  %bird_size_ptr = getelementptr %Bird_struct, %Bird_struct* null, i32 1
  %bird_size = ptrtoint %Bird_struct* %bird_size_ptr to i64
  %bird_mem = call i8* @malloc(i64 %bird_size)
  %bird_obj = bitcast i8* %bird_mem to %Bird_struct*
  %bird_vtable_field = getelementptr %Bird_struct, %Bird_struct* %bird_obj, i32 0, i32 0
  %bird_vtable = bitcast [1 x %ObjectStruct* (%ObjectStruct*)*]* @vtable_Bird to i8*
  store i8* %bird_vtable, i8** %bird_vtable_field
  %bird_as_animal = bitcast %Bird_struct* %bird_obj to %Animal_struct*

  ; Store attributes into Main object (fields 1..4)
  %animal_attr = getelementptr %Main_struct, %Main_struct* %main_obj, i32 0, i32 1
  store %Animal_struct* %animal_obj, %Animal_struct** %animal_attr
  %dog_attr = getelementptr %Main_struct, %Main_struct* %main_obj, i32 0, i32 2
  store %Animal_struct* %dog_as_animal, %Animal_struct** %dog_attr
  %cat_attr = getelementptr %Main_struct, %Main_struct* %main_obj, i32 0, i32 3
  store %Animal_struct* %cat_as_animal, %Animal_struct** %cat_attr
  %bird_attr = getelementptr %Main_struct, %Main_struct* %main_obj, i32 0, i32 4
  store %Animal_struct* %bird_as_animal, %Animal_struct** %bird_attr

  ; Prepare format string pointer for printf
  %fmt_ptr = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0

  ; Call speak on Animal attribute
  %animal_obj_obj = bitcast %Animal_struct* %animal_obj to %ObjectStruct*
  %animal_speak_str = call %StringStruct* @Animal_speak(%ObjectStruct* %animal_obj_obj)
  %animal_str_field = getelementptr %StringStruct, %StringStruct* %animal_speak_str, i32 0, i32 1
  %animal_msg = load i8*, i8** %animal_str_field
  call i32 (i8*, ...) @printf(i8* %fmt_ptr, i8* %animal_msg)

  ; Call speak on Dog attribute
  %dog_obj_obj = bitcast %Dog_struct* %dog_obj to %ObjectStruct*
  %dog_speak_str = call %StringStruct* @Dog_speak(%ObjectStruct* %dog_obj_obj)
  %dog_str_field = getelementptr %StringStruct, %StringStruct* %dog_speak_str, i32 0, i32 1
  %dog_msg = load i8*, i8** %dog_str_field
  call i32 (i8*, ...) @printf(i8* %fmt_ptr, i8* %dog_msg)

  ; Call speak on Cat attribute
  %cat_obj_obj = bitcast %Cat_struct* %cat_obj to %ObjectStruct*
  %cat_speak_str = call %StringStruct* @Cat_speak(%ObjectStruct* %cat_obj_obj)
  %cat_str_field = getelementptr %StringStruct, %StringStruct* %cat_speak_str, i32 0, i32 1
  %cat_msg = load i8*, i8** %cat_str_field
  call i32 (i8*, ...) @printf(i8* %fmt_ptr, i8* %cat_msg)

  ; Call speak on Bird attribute
  %bird_obj_obj = bitcast %Bird_struct* %bird_obj to %ObjectStruct*
  %bird_speak_str = call %StringStruct* @Bird_speak(%ObjectStruct* %bird_obj_obj)
  %bird_str_field = getelementptr %StringStruct, %StringStruct* %bird_speak_str, i32 0, i32 1
  %bird_msg = load i8*, i8** %bird_str_field
  call i32 (i8*, ...) @printf(i8* %fmt_ptr, i8* %bird_msg)

  ; Print "test" string
  %test_str_field = getelementptr %StringStruct, %StringStruct* bitcast (%StringStruct* @str_obj_13 to %StringStruct*), i32 0, i32 1
  %test_msg = load i8*, i8** %test_str_field
  call i32 (i8*, ...) @printf(i8* %fmt_ptr, i8* %test_msg)

  ; Corrected return: first bitcast the main_obj pointer, then return it
  %tmp = bitcast %Main_struct* %main_obj to %ObjectStruct*
  ret %ObjectStruct* %tmp
}

; ======== Program Entry Point ========
define i32 @main() {
entry:
%main_obj = call %ObjectStruct* @Main_main(%ObjectStruct* null)
  ret i32 0
}
