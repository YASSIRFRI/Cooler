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
@str_0 = global [7 x i8] c"Object\00"
@str_obj_1 = constant { i8* } { [7 x i8]* getelementptr inbounds ([7 x i8], [7 x i8]* @str_0) }
@vtable_Object = global [3 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_abort to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%StringStruct* (%ObjectStruct*)* @Object_type_name to %ObjectStruct* (%ObjectStruct*)*), %ObjectStruct* (%ObjectStruct*)* bitcast (%ObjectStruct* (%ObjectStruct*)* @Object_copy to %ObjectStruct* (%ObjectStruct*)*)]
@vtable_Int = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_String = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Bool = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_IO = global [0 x %ObjectStruct* (%ObjectStruct*)*] []
@vtable_Main = constant [1 x %ObjectStruct* (%ObjectStruct*)*] [%ObjectStruct* (%ObjectStruct*)* bitcast (i8* bitcast (%ObjectStruct* (%ObjectStruct*)* @Main_main to i8*) to %ObjectStruct* (%ObjectStruct*)*)]
@str_2 = global [23 x i8] c"First loop iteration: \00"
@str_obj_3 = constant { i8* } { [23 x i8]* getelementptr inbounds ([23 x i8], [23 x i8]* @str_2) }
@str_4 = global [2 x i8] c"\0A\00"
@str_obj_5 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_4) }
@str_6 = global [24 x i8] c"Second loop iteration: \00"
@str_obj_7 = constant { i8* } { [24 x i8]* getelementptr inbounds ([24 x i8], [24 x i8]* @str_6) }
@str_8 = global [2 x i8] c"\0A\00"
@str_obj_9 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_8) }
@str_10 = global [23 x i8] c"Third loop iteration: \00"
@str_obj_11 = constant { i8* } { [23 x i8]* getelementptr inbounds ([23 x i8], [23 x i8]* @str_10) }
@str_12 = global [2 x i8] c"\0A\00"
@str_obj_13 = constant { i8* } { [2 x i8]* getelementptr inbounds ([2 x i8], [2 x i8]* @str_12) }

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

declare void @exit(i32 %status)

define %ObjectStruct* @Object_abort(%ObjectStruct* %self) {
entry:
	call void @exit(i32 1)
	unreachable
}

define %StringStruct* @Object_type_name(%ObjectStruct* %self) {
entry:
	ret %StringStruct* bitcast ({ i8* }* @str_obj_1 to %StringStruct*)
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
	%4 = alloca %IntStruct*
	%5 = call i8* @malloc(i64 16)
	%6 = bitcast i8* %5 to %IntStruct*
	%7 = getelementptr %IntStruct, %IntStruct* %6, i32 0, i32 1
	store i32 0, i32* %7
	store %IntStruct* %6, %IntStruct** %4
	br label %while_cond_0

while_cond_0:
	%8 = load %IntStruct*, %IntStruct** %4
	%9 = call i8* @malloc(i64 16)
	%10 = bitcast i8* %9 to %IntStruct*
	%11 = getelementptr %IntStruct, %IntStruct* %10, i32 0, i32 1
	store i32 5, i32* %11
	%12 = getelementptr %IntStruct, %IntStruct* %8, i32 0, i32 1
	%13 = load i32, i32* %12
	%14 = getelementptr %IntStruct, %IntStruct* %10, i32 0, i32 1
	%15 = load i32, i32* %14
	%16 = icmp slt i32 %13, %15
	%17 = call i8* @malloc(i64 16)
	%18 = bitcast i8* %17 to %BoolStruct*
	%19 = getelementptr %BoolStruct, %BoolStruct* %18, i32 0, i32 1
	store i1 %16, i1* %19
	%20 = getelementptr %BoolStruct, %BoolStruct* %18, i32 0, i32 1
	%21 = load i1, i1* %20
	%22 = icmp ne i1 %21, false
	br i1 %22, label %while_body_1, label %while_end_2

while_body_1:
	%23 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_3 to %StringStruct*), i32 0, i32 0
	%24 = load i8*, i8** %23
	%25 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%26 = call i32 (i8*, ...) @printf(i8* %25, i8* %24)
	%27 = load %Main_struct*, %Main_struct** %3
	%28 = load %IntStruct*, %IntStruct** %4
	%29 = getelementptr %IntStruct, %IntStruct* %28, i32 0, i32 1
	%30 = load i32, i32* %29
	%31 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%32 = call i32 (i8*, ...) @printf(i8* %31, i32 %30)
	%33 = load %Main_struct*, %Main_struct** %3
	%34 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_5 to %StringStruct*), i32 0, i32 0
	%35 = load i8*, i8** %34
	%36 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%37 = call i32 (i8*, ...) @printf(i8* %36, i8* %35)
	%38 = load %Main_struct*, %Main_struct** %3
	%39 = load %IntStruct*, %IntStruct** %4
	%40 = call i8* @malloc(i64 16)
	%41 = bitcast i8* %40 to %IntStruct*
	%42 = getelementptr %IntStruct, %IntStruct* %41, i32 0, i32 1
	store i32 1, i32* %42
	%43 = getelementptr %IntStruct, %IntStruct* %39, i32 0, i32 1
	%44 = load i32, i32* %43
	%45 = getelementptr %IntStruct, %IntStruct* %41, i32 0, i32 1
	%46 = load i32, i32* %45
	%47 = add i32 %44, %46
	%48 = call i8* @malloc(i64 16)
	%49 = bitcast i8* %48 to %IntStruct*
	%50 = getelementptr %IntStruct, %IntStruct* %49, i32 0, i32 1
	store i32 %47, i32* %50
	store %IntStruct* %49, %IntStruct** %4
	br label %while_cond_0

while_end_2:
	%51 = alloca %IntStruct*
	%52 = call i8* @malloc(i64 16)
	%53 = bitcast i8* %52 to %IntStruct*
	%54 = getelementptr %IntStruct, %IntStruct* %53, i32 0, i32 1
	store i32 0, i32* %54
	store %IntStruct* %53, %IntStruct** %51
	br label %while_cond_3

while_cond_3:
	%55 = load %IntStruct*, %IntStruct** %51
	%56 = call i8* @malloc(i64 16)
	%57 = bitcast i8* %56 to %IntStruct*
	%58 = getelementptr %IntStruct, %IntStruct* %57, i32 0, i32 1
	store i32 5, i32* %58
	%59 = getelementptr %IntStruct, %IntStruct* %55, i32 0, i32 1
	%60 = load i32, i32* %59
	%61 = getelementptr %IntStruct, %IntStruct* %57, i32 0, i32 1
	%62 = load i32, i32* %61
	%63 = icmp slt i32 %60, %62
	%64 = call i8* @malloc(i64 16)
	%65 = bitcast i8* %64 to %BoolStruct*
	%66 = getelementptr %BoolStruct, %BoolStruct* %65, i32 0, i32 1
	store i1 %63, i1* %66
	%67 = getelementptr %BoolStruct, %BoolStruct* %65, i32 0, i32 1
	%68 = load i1, i1* %67
	%69 = icmp ne i1 %68, false
	br i1 %69, label %while_body_4, label %while_end_5

while_body_4:
	%70 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_7 to %StringStruct*), i32 0, i32 0
	%71 = load i8*, i8** %70
	%72 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%73 = call i32 (i8*, ...) @printf(i8* %72, i8* %71)
	%74 = load %Main_struct*, %Main_struct** %3
	%75 = load %IntStruct*, %IntStruct** %51
	%76 = getelementptr %IntStruct, %IntStruct* %75, i32 0, i32 1
	%77 = load i32, i32* %76
	%78 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%79 = call i32 (i8*, ...) @printf(i8* %78, i32 %77)
	%80 = load %Main_struct*, %Main_struct** %3
	%81 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_9 to %StringStruct*), i32 0, i32 0
	%82 = load i8*, i8** %81
	%83 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%84 = call i32 (i8*, ...) @printf(i8* %83, i8* %82)
	%85 = load %Main_struct*, %Main_struct** %3
	%86 = load %IntStruct*, %IntStruct** %51
	%87 = call i8* @malloc(i64 16)
	%88 = bitcast i8* %87 to %IntStruct*
	%89 = getelementptr %IntStruct, %IntStruct* %88, i32 0, i32 1
	store i32 1, i32* %89
	%90 = getelementptr %IntStruct, %IntStruct* %86, i32 0, i32 1
	%91 = load i32, i32* %90
	%92 = getelementptr %IntStruct, %IntStruct* %88, i32 0, i32 1
	%93 = load i32, i32* %92
	%94 = add i32 %91, %93
	%95 = call i8* @malloc(i64 16)
	%96 = bitcast i8* %95 to %IntStruct*
	%97 = getelementptr %IntStruct, %IntStruct* %96, i32 0, i32 1
	store i32 %94, i32* %97
	store %IntStruct* %96, %IntStruct** %51
	br label %while_cond_3

while_end_5:
	%98 = alloca %IntStruct*
	%99 = call i8* @malloc(i64 16)
	%100 = bitcast i8* %99 to %IntStruct*
	%101 = getelementptr %IntStruct, %IntStruct* %100, i32 0, i32 1
	store i32 0, i32* %101
	store %IntStruct* %100, %IntStruct** %98
	br label %while_cond_6

while_cond_6:
	%102 = load %IntStruct*, %IntStruct** %98
	%103 = call i8* @malloc(i64 16)
	%104 = bitcast i8* %103 to %IntStruct*
	%105 = getelementptr %IntStruct, %IntStruct* %104, i32 0, i32 1
	store i32 5, i32* %105
	%106 = getelementptr %IntStruct, %IntStruct* %102, i32 0, i32 1
	%107 = load i32, i32* %106
	%108 = getelementptr %IntStruct, %IntStruct* %104, i32 0, i32 1
	%109 = load i32, i32* %108
	%110 = icmp slt i32 %107, %109
	%111 = call i8* @malloc(i64 16)
	%112 = bitcast i8* %111 to %BoolStruct*
	%113 = getelementptr %BoolStruct, %BoolStruct* %112, i32 0, i32 1
	store i1 %110, i1* %113
	%114 = getelementptr %BoolStruct, %BoolStruct* %112, i32 0, i32 1
	%115 = load i1, i1* %114
	%116 = icmp ne i1 %115, false
	br i1 %116, label %while_body_7, label %while_end_8

while_body_7:
	%117 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_11 to %StringStruct*), i32 0, i32 0
	%118 = load i8*, i8** %117
	%119 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%120 = call i32 (i8*, ...) @printf(i8* %119, i8* %118)
	%121 = load %Main_struct*, %Main_struct** %3
	%122 = load %IntStruct*, %IntStruct** %98
	%123 = getelementptr %IntStruct, %IntStruct* %122, i32 0, i32 1
	%124 = load i32, i32* %123
	%125 = getelementptr [3 x i8], [3 x i8]* @fmt_int_1, i32 0, i32 0
	%126 = call i32 (i8*, ...) @printf(i8* %125, i32 %124)
	%127 = load %Main_struct*, %Main_struct** %3
	%128 = getelementptr %StringStruct, %StringStruct* bitcast ({ i8* }* @str_obj_13 to %StringStruct*), i32 0, i32 0
	%129 = load i8*, i8** %128
	%130 = getelementptr [3 x i8], [3 x i8]* @fmt_str_0, i32 0, i32 0
	%131 = call i32 (i8*, ...) @printf(i8* %130, i8* %129)
	%132 = load %Main_struct*, %Main_struct** %3
	%133 = load %IntStruct*, %IntStruct** %98
	%134 = call i8* @malloc(i64 16)
	%135 = bitcast i8* %134 to %IntStruct*
	%136 = getelementptr %IntStruct, %IntStruct* %135, i32 0, i32 1
	store i32 1, i32* %136
	%137 = getelementptr %IntStruct, %IntStruct* %133, i32 0, i32 1
	%138 = load i32, i32* %137
	%139 = getelementptr %IntStruct, %IntStruct* %135, i32 0, i32 1
	%140 = load i32, i32* %139
	%141 = add i32 %138, %140
	%142 = call i8* @malloc(i64 16)
	%143 = bitcast i8* %142 to %IntStruct*
	%144 = getelementptr %IntStruct, %IntStruct* %143, i32 0, i32 1
	store i32 %141, i32* %144
	store %IntStruct* %143, %IntStruct** %98
	br label %while_cond_6

while_end_8:
	%145 = call i8* @malloc(i64 16)
	%146 = bitcast i8* %145 to %IntStruct*
	%147 = getelementptr %IntStruct, %IntStruct* %146, i32 0, i32 1
	store i32 0, i32* %147
	%148 = bitcast %IntStruct* %146 to %ObjectStruct*
	ret %ObjectStruct* %148
}
