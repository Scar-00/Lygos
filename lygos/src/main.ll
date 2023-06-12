; ModuleID = 'src/main.ly'
source_filename = "src/main.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%String = type { i8*, i32, i32 }
%VecString = type { %String*, i32, i32 }
%Token = type { i32, %String }
%VecToken = type { %Token*, i32, i32 }
%Loc = type { %String*, i64, i64, i64 }
%Lexer = type { i8*, i32, i8, i32 }
%Ctx = type { i8*, i8*, i8*, i8* }

@0 = private unnamed_addr constant [29 x i8] c"unimplemented [`lex_char()`]\00", align 1
@1 = private unnamed_addr constant [2 x i8] c".\00", align 1
@2 = private unnamed_addr constant [2 x i8] c",\00", align 1
@3 = private unnamed_addr constant [2 x i8] c";\00", align 1
@4 = private unnamed_addr constant [3 x i8] c"::\00", align 1
@5 = private unnamed_addr constant [2 x i8] c":\00", align 1
@6 = private unnamed_addr constant [2 x i8] c"+\00", align 1
@7 = private unnamed_addr constant [3 x i8] c"->\00", align 1
@8 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@9 = private unnamed_addr constant [2 x i8] c"*\00", align 1
@10 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@11 = private unnamed_addr constant [2 x i8] c"%\00", align 1
@12 = private unnamed_addr constant [2 x i8] c"[\00", align 1
@13 = private unnamed_addr constant [2 x i8] c"]\00", align 1
@14 = private unnamed_addr constant [2 x i8] c"{\00", align 1
@15 = private unnamed_addr constant [2 x i8] c"}\00", align 1
@16 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@17 = private unnamed_addr constant [2 x i8] c")\00", align 1
@18 = private unnamed_addr constant [2 x i8] c"#\00", align 1
@19 = private unnamed_addr constant [2 x i8] c"$\00", align 1
@20 = private unnamed_addr constant [3 x i8] c"<=\00", align 1
@21 = private unnamed_addr constant [2 x i8] c"<\00", align 1
@22 = private unnamed_addr constant [3 x i8] c">=\00", align 1
@23 = private unnamed_addr constant [2 x i8] c">\00", align 1
@24 = private unnamed_addr constant [3 x i8] c"&&\00", align 1
@25 = private unnamed_addr constant [2 x i8] c"&\00", align 1
@26 = private unnamed_addr constant [3 x i8] c"||\00", align 1
@27 = private unnamed_addr constant [2 x i8] c"|\00", align 1
@28 = private unnamed_addr constant [3 x i8] c"!=\00", align 1
@29 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@30 = private unnamed_addr constant [3 x i8] c"==\00", align 1
@31 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@32 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@33 = private unnamed_addr constant [4 x i8] c"EOF\00", align 1
@34 = private unnamed_addr constant [20 x i8] c"x86_64-pc-linux-gnu\00", align 1
@35 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@36 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@37 = private unnamed_addr constant [12 x i8] c"let x = 10;\00", align 1
@38 = private unnamed_addr constant [10 x i8] c"src -> %s\00", align 1
@39 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@40 = private unnamed_addr constant [10 x i8] c"tok -> %s\00", align 1
@41 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @printf(i8*, ...)

declare i8* @LLVMContextCreate()

declare i8* @LLVMModuleCreateWithNameInContext(i8*, i8*)

declare i8* @LLVMCreateBuilderInContext(i8*)

declare i8* @LLVMInt8Type()

declare i8* @LLVMInt32Type()

declare i8* @LLVMPointerType(i8*, i32)

declare i8* @LLVMFunctionType(i8*, i8*, i32, i8)

declare i8* @LLVMAddFunction(i8*, i8*, i8*)

declare void @LLVMDumpModule(i8*)

declare i32 @isdigit(i32)

declare i32 @isalpha(i32)

declare i32 @isspace(i32)

declare void @exit(i32)

declare i8* @malloc(i32)

declare i8* @realloc(i8*, i32)

declare void @free(i8*)

declare i8* @memcpy(i8*, i8*, i32)

declare i32 @strlen(i8*)

declare i8* @strcpy(i8*, i8*)

define dso_local %String @String_new(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = alloca %String, align 8
  %4 = alloca i32, align 4
  store i32 1, i32* %4, align 4
  %5 = alloca %String, align 8
  %6 = bitcast %String* %5 to i8**
  %7 = load i32, i32* %2, align 4
  %8 = load i32, i32* %4, align 4
  %9 = mul i32 %7, %8
  %10 = call i8* @malloc(i32 %9)
  store i8* %10, i8** %6, align 8
  %11 = getelementptr inbounds %String, %String* %5, i32 0, i32 1
  store i32 0, i32* %11, align 4
  %12 = getelementptr inbounds %String, %String* %5, i32 0, i32 2
  %13 = load i32, i32* %2, align 4
  store i32 %13, i32* %12, align 4
  %14 = load %String, %String* %5, align 8
  store %String %14, %String* %3, align 8
  %15 = load %String, %String* %3, align 8
  ret %String %15
}

define dso_local %String @String_from(i8* %0) {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  %3 = alloca %String, align 8
  %4 = load i8*, i8** %2, align 8
  %5 = call i32 @strlen(i8* %4)
  %6 = alloca i32, align 4
  store i32 %5, i32* %6, align 4
  %7 = load i32, i32* %6, align 4
  %8 = call %String @String_new(i32 %7)
  %9 = alloca %String, align 8
  store %String %8, %String* %9, align 8
  %10 = bitcast %String* %9 to i8**
  %11 = load i8*, i8** %10, align 8
  %12 = load i8*, i8** %2, align 8
  %13 = call i8* @strcpy(i8* %11, i8* %12)
  %14 = getelementptr inbounds %String, %String* %9, i32 0, i32 1
  %15 = load i32, i32* %6, align 4
  store i32 %15, i32* %14, align 4
  %16 = load %String, %String* %9, align 8
  store %String %16, %String* %3, align 8
  %17 = load %String, %String* %3, align 8
  ret %String %17
}

define dso_local void @String_grow(%String* %0) {
  %2 = alloca %String*, align 8
  store %String* %0, %String** %2, align 8
  %3 = load %String*, %String** %2, align 8
  %4 = getelementptr inbounds %String, %String* %3, i32 0, i32 2
  %5 = load i32, i32* %4, align 4
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %if.then, label %if.end

if.then:                                          ; preds = %1
  %7 = load %String*, %String** %2, align 8
  %8 = getelementptr inbounds %String, %String* %7, i32 0, i32 2
  store i32 1, i32* %8, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %1
  %9 = load %String*, %String** %2, align 8
  %10 = getelementptr inbounds %String, %String* %9, i32 0, i32 2
  %11 = load %String*, %String** %2, align 8
  %12 = getelementptr inbounds %String, %String* %11, i32 0, i32 2
  %13 = load i32, i32* %12, align 4
  %14 = mul i32 %13, 2
  store i32 %14, i32* %10, align 4
  %15 = alloca i32, align 4
  store i32 1, i32* %15, align 4
  %16 = load %String*, %String** %2, align 8
  %17 = bitcast %String* %16 to i8**
  %18 = load %String*, %String** %2, align 8
  %19 = bitcast %String* %18 to i8**
  %20 = load i8*, i8** %19, align 8
  %21 = load %String*, %String** %2, align 8
  %22 = getelementptr inbounds %String, %String* %21, i32 0, i32 2
  %23 = load i32, i32* %22, align 4
  %24 = load i32, i32* %15, align 4
  %25 = mul i32 %23, %24
  %26 = call i8* @realloc(i8* %20, i32 %25)
  store i8* %26, i8** %17, align 8
  ret void
}

define dso_local void @String_push(%String* %0, i8 %1) {
  %3 = alloca %String*, align 8
  store %String* %0, %String** %3, align 8
  %4 = alloca i8, align 1
  store i8 %1, i8* %4, align 1
  %5 = load %String*, %String** %3, align 8
  %6 = getelementptr inbounds %String, %String* %5, i32 0, i32 1
  %7 = load %String*, %String** %3, align 8
  %8 = getelementptr inbounds %String, %String* %7, i32 0, i32 2
  %9 = load i32, i32* %6, align 4
  %10 = load i32, i32* %8, align 4
  %11 = icmp eq i32 %9, %10
  br i1 %11, label %if.then, label %if.end

if.then:                                          ; preds = %2
  %12 = load %String*, %String** %3, align 8
  %13 = load %String*, %String** %3, align 8
  call void @String_grow(%String* %13)
  br label %if.end

if.end:                                           ; preds = %if.then, %2
  %14 = load %String*, %String** %3, align 8
  %15 = bitcast %String* %14 to i8**
  %16 = load i8*, i8** %15, align 8
  %17 = load %String*, %String** %3, align 8
  %18 = getelementptr inbounds %String, %String* %17, i32 0, i32 1
  %19 = load i32, i32* %18, align 4
  %20 = getelementptr inbounds i8, i8* %16, i32 %19
  %21 = load i8, i8* %4, align 1
  store i8 %21, i8* %20, align 1
  %22 = load %String*, %String** %3, align 8
  %23 = getelementptr inbounds %String, %String* %22, i32 0, i32 1
  %24 = load %String*, %String** %3, align 8
  %25 = getelementptr inbounds %String, %String* %24, i32 0, i32 1
  %26 = load i32, i32* %25, align 4
  %27 = add i32 %26, 1
  store i32 %27, i32* %23, align 4
  %28 = load %String*, %String** %3, align 8
  %29 = bitcast %String* %28 to i8**
  %30 = load i8*, i8** %29, align 8
  %31 = load %String*, %String** %3, align 8
  %32 = getelementptr inbounds %String, %String* %31, i32 0, i32 1
  %33 = load i32, i32* %32, align 4
  %34 = getelementptr inbounds i8, i8* %30, i32 %33
  store i8 0, i8* %34, align 1
  ret void
}

define dso_local void @String_push_str(%String* %0, %String %1) {
  %3 = alloca %String*, align 8
  store %String* %0, %String** %3, align 8
  %4 = alloca %String, align 8
  store %String %1, %String* %4, align 8
  %5 = alloca i32, align 4
  store i32 0, i32* %5, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.block, %2
  %6 = getelementptr inbounds %String, %String* %4, i32 0, i32 1
  %7 = load i32, i32* %5, align 4
  %8 = load i32, i32* %6, align 4
  %9 = icmp slt i32 %7, %8
  br i1 %9, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %10 = load %String*, %String** %3, align 8
  %11 = load %String*, %String** %3, align 8
  %12 = bitcast %String* %4 to i8**
  %13 = load i8*, i8** %12, align 8
  %14 = load i32, i32* %5, align 4
  %15 = getelementptr inbounds i8, i8* %13, i32 %14
  %16 = load i8, i8* %15, align 1
  call void @String_push(%String* %11, i8 %16)
  %17 = load i32, i32* %5, align 4
  %18 = add i32 %17, 1
  store i32 %18, i32* %5, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

define dso_local %String @String_copy(%String* %0) {
  %2 = alloca %String*, align 8
  store %String* %0, %String** %2, align 8
  %3 = alloca %String, align 8
  %4 = load %String*, %String** %2, align 8
  %5 = getelementptr inbounds %String, %String* %4, i32 0, i32 2
  %6 = load i32, i32* %5, align 4
  %7 = call %String @String_new(i32 %6)
  %8 = alloca %String, align 8
  store %String %7, %String* %8, align 8
  %9 = alloca i32, align 4
  store i32 1, i32* %9, align 4
  %10 = getelementptr inbounds %String, %String* %8, i32 0, i32 1
  %11 = load %String*, %String** %2, align 8
  %12 = getelementptr inbounds %String, %String* %11, i32 0, i32 1
  %13 = load i32, i32* %12, align 4
  store i32 %13, i32* %10, align 4
  %14 = bitcast %String* %8 to i8**
  %15 = load i8*, i8** %14, align 8
  %16 = load %String*, %String** %2, align 8
  %17 = bitcast %String* %16 to i8**
  %18 = load i8*, i8** %17, align 8
  %19 = load %String*, %String** %2, align 8
  %20 = getelementptr inbounds %String, %String* %19, i32 0, i32 1
  %21 = load i32, i32* %9, align 4
  %22 = load i32, i32* %20, align 4
  %23 = mul i32 %21, %22
  %24 = call i8* @memcpy(i8* %15, i8* %18, i32 %23)
  %25 = load %String, %String* %8, align 8
  store %String %25, %String* %3, align 8
  %26 = load %String, %String* %3, align 8
  ret %String %26
}

define dso_local i1 @String_eq(%String* %0, %String %1) {
  %3 = alloca %String*, align 8
  store %String* %0, %String** %3, align 8
  %4 = alloca %String, align 8
  store %String %1, %String* %4, align 8
  %5 = alloca i1, align 1
  %6 = load %String*, %String** %3, align 8
  %7 = getelementptr inbounds %String, %String* %6, i32 0, i32 1
  %8 = getelementptr inbounds %String, %String* %4, i32 0, i32 1
  %9 = load i32, i32* %7, align 4
  %10 = load i32, i32* %8, align 4
  %11 = icmp ne i32 %9, %10
  br i1 %11, label %if.then, label %if.end

if.then:                                          ; preds = %2
  store i1 false, i1* %5, align 1
  br label %ret

if.end:                                           ; preds = %2
  %12 = alloca i32, align 4
  store i32 0, i32* %12, align 4
  br label %for.cond

if.then1:                                         ; preds = %for.block
  store i1 false, i1* %5, align 1
  br label %ret

ret:                                              ; preds = %for.end, %if.then1, %if.then
  %13 = load i1, i1* %5, align 1
  ret i1 %13

for.cond:                                         ; preds = %for.block, %if.end
  %14 = load %String*, %String** %3, align 8
  %15 = getelementptr inbounds %String, %String* %14, i32 0, i32 1
  %16 = load i32, i32* %12, align 4
  %17 = load i32, i32* %15, align 4
  %18 = icmp slt i32 %16, %17
  br i1 %18, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %19 = load %String*, %String** %3, align 8
  %20 = bitcast %String* %19 to i8**
  %21 = load i8*, i8** %20, align 8
  %22 = load i32, i32* %12, align 4
  %23 = getelementptr inbounds i8, i8* %21, i32 %22
  %24 = bitcast %String* %4 to i8**
  %25 = load i8*, i8** %24, align 8
  %26 = load i32, i32* %12, align 4
  %27 = getelementptr inbounds i8, i8* %25, i32 %26
  %28 = load i8, i8* %23, align 1
  %29 = load i8, i8* %27, align 1
  %30 = icmp ne i8 %28, %29
  br i1 %30, label %if.then1, label %for.cond

for.end:                                          ; preds = %for.cond
  store i1 true, i1* %5, align 1
  br label %ret
}

define dso_local i1 @String_contains(%String* %0, i8 %1) {
  %3 = alloca %String*, align 8
  store %String* %0, %String** %3, align 8
  %4 = alloca i8, align 1
  store i8 %1, i8* %4, align 1
  %5 = alloca i1, align 1
  %6 = alloca i32, align 4
  store i32 0, i32* %6, align 4
  br label %for.cond

for.cond:                                         ; preds = %if.end, %2
  %7 = load %String*, %String** %3, align 8
  %8 = getelementptr inbounds %String, %String* %7, i32 0, i32 1
  %9 = load i32, i32* %6, align 4
  %10 = load i32, i32* %8, align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %12 = load %String*, %String** %3, align 8
  %13 = bitcast %String* %12 to i8**
  %14 = load i8*, i8** %13, align 8
  %15 = load i32, i32* %6, align 4
  %16 = getelementptr inbounds i8, i8* %14, i32 %15
  %17 = load i8, i8* %16, align 1
  %18 = load i8, i8* %4, align 1
  %19 = icmp eq i8 %17, %18
  br i1 %19, label %if.then, label %if.end

for.end:                                          ; preds = %for.cond
  store i1 false, i1* %5, align 1
  br label %ret

if.then:                                          ; preds = %for.block
  store i1 true, i1* %5, align 1
  br label %ret

if.end:                                           ; preds = %for.block
  %20 = load i32, i32* %6, align 4
  %21 = add i32 %20, 1
  store i32 %21, i32* %6, align 4
  br label %for.cond

ret:                                              ; preds = %for.end, %if.then
  %22 = load i1, i1* %5, align 1
  ret i1 %22
}

define dso_local void @String_drop(%String* %0) {
  %2 = alloca %String*, align 8
  store %String* %0, %String** %2, align 8
  %3 = load %String*, %String** %2, align 8
  %4 = bitcast %String* %3 to i8**
  %5 = load i8*, i8** %4, align 8
  %6 = icmp ne i8* %5, null
  br i1 %6, label %if.then, label %if.end

if.then:                                          ; preds = %1
  %7 = load %String*, %String** %2, align 8
  %8 = bitcast %String* %7 to i8**
  %9 = load i8*, i8** %8, align 8
  call void @free(i8* %9)
  br label %if.end

if.end:                                           ; preds = %if.then, %1
  ret void
}

define dso_local %VecString @VecString_new() {
  %1 = alloca %VecString, align 8
  %2 = alloca i32, align 4
  store i32 16, i32* %2, align 4
  %3 = alloca %VecString, align 8
  %4 = bitcast %VecString* %3 to %String**
  store %String* null, %String** %4, align 8
  %5 = getelementptr inbounds %VecString, %VecString* %3, i32 0, i32 1
  store i32 0, i32* %5, align 4
  %6 = getelementptr inbounds %VecString, %VecString* %3, i32 0, i32 2
  store i32 0, i32* %6, align 4
  %7 = load %VecString, %VecString* %3, align 8
  store %VecString %7, %VecString* %1, align 8
  %8 = load %VecString, %VecString* %1, align 8
  ret %VecString %8
}

define dso_local %VecString @VecString_with_size(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = alloca %VecString, align 8
  %4 = alloca i32, align 4
  store i32 16, i32* %4, align 4
  %5 = alloca %VecString, align 8
  %6 = bitcast %VecString* %5 to %String**
  %7 = load i32, i32* %2, align 4
  %8 = load i32, i32* %4, align 4
  %9 = mul i32 %7, %8
  %10 = call i8* @malloc(i32 %9)
  %11 = bitcast i8* %10 to %String*
  store %String* %11, %String** %6, align 8
  %12 = getelementptr inbounds %VecString, %VecString* %5, i32 0, i32 1
  %13 = load i32, i32* %2, align 4
  store i32 %13, i32* %12, align 4
  %14 = getelementptr inbounds %VecString, %VecString* %5, i32 0, i32 2
  store i32 0, i32* %14, align 4
  %15 = load %VecString, %VecString* %5, align 8
  store %VecString %15, %VecString* %3, align 8
  %16 = load %VecString, %VecString* %3, align 8
  ret %VecString %16
}

define dso_local void @VecString_may_grow(%VecString* %0) {
  %2 = alloca %VecString*, align 8
  store %VecString* %0, %VecString** %2, align 8
  %3 = alloca i32, align 4
  store i32 16, i32* %3, align 4
  %4 = load %VecString*, %VecString** %2, align 8
  %5 = getelementptr inbounds %VecString, %VecString* %4, i32 0, i32 1
  %6 = load i32, i32* %5, align 4
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %1
  %8 = load %VecString*, %VecString** %2, align 8
  %9 = getelementptr inbounds %VecString, %VecString* %8, i32 0, i32 1
  store i32 1, i32* %9, align 4
  %10 = load %VecString*, %VecString** %2, align 8
  %11 = bitcast %VecString* %10 to %String**
  %12 = load %VecString*, %VecString** %2, align 8
  %13 = bitcast %VecString* %12 to %String**
  %14 = load %String*, %String** %13, align 8
  %15 = bitcast %String* %14 to i8*
  %16 = load %VecString*, %VecString** %2, align 8
  %17 = getelementptr inbounds %VecString, %VecString* %16, i32 0, i32 1
  %18 = load i32, i32* %17, align 4
  %19 = load i32, i32* %3, align 4
  %20 = mul i32 %18, %19
  %21 = call i8* @realloc(i8* %15, i32 %20)
  %22 = bitcast i8* %21 to %String*
  store %String* %22, %String** %11, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %1
  %23 = load %VecString*, %VecString** %2, align 8
  %24 = getelementptr inbounds %VecString, %VecString* %23, i32 0, i32 1
  %25 = load %VecString*, %VecString** %2, align 8
  %26 = getelementptr inbounds %VecString, %VecString* %25, i32 0, i32 2
  %27 = load i32, i32* %24, align 4
  %28 = load i32, i32* %26, align 4
  %29 = icmp eq i32 %27, %28
  br i1 %29, label %if.then1, label %if.end2

if.then1:                                         ; preds = %if.end
  %30 = load %VecString*, %VecString** %2, align 8
  %31 = getelementptr inbounds %VecString, %VecString* %30, i32 0, i32 1
  %32 = load %VecString*, %VecString** %2, align 8
  %33 = getelementptr inbounds %VecString, %VecString* %32, i32 0, i32 1
  %34 = load i32, i32* %33, align 4
  %35 = mul i32 %34, 2
  store i32 %35, i32* %31, align 4
  %36 = load %VecString*, %VecString** %2, align 8
  %37 = bitcast %VecString* %36 to %String**
  %38 = load %VecString*, %VecString** %2, align 8
  %39 = bitcast %VecString* %38 to %String**
  %40 = load %String*, %String** %39, align 8
  %41 = bitcast %String* %40 to i8*
  %42 = load %VecString*, %VecString** %2, align 8
  %43 = getelementptr inbounds %VecString, %VecString* %42, i32 0, i32 1
  %44 = load i32, i32* %43, align 4
  %45 = load i32, i32* %3, align 4
  %46 = mul i32 %44, %45
  %47 = call i8* @realloc(i8* %41, i32 %46)
  %48 = bitcast i8* %47 to %String*
  store %String* %48, %String** %37, align 8
  br label %if.end2

if.end2:                                          ; preds = %if.then1, %if.end
  ret void
}

define dso_local void @VecString_push(%VecString* %0, %String %1) {
  %3 = alloca %VecString*, align 8
  store %VecString* %0, %VecString** %3, align 8
  %4 = alloca %String, align 8
  store %String %1, %String* %4, align 8
  %5 = load %VecString*, %VecString** %3, align 8
  %6 = load %VecString*, %VecString** %3, align 8
  call void @VecString_may_grow(%VecString* %6)
  %7 = load %VecString*, %VecString** %3, align 8
  %8 = bitcast %VecString* %7 to %String**
  %9 = load %String*, %String** %8, align 8
  %10 = load %VecString*, %VecString** %3, align 8
  %11 = getelementptr inbounds %VecString, %VecString* %10, i32 0, i32 2
  %12 = load i32, i32* %11, align 4
  %13 = getelementptr inbounds %String, %String* %9, i32 %12
  %14 = load %String, %String* %4, align 8
  store %String %14, %String* %13, align 8
  %15 = load %VecString*, %VecString** %3, align 8
  %16 = getelementptr inbounds %VecString, %VecString* %15, i32 0, i32 2
  %17 = load %VecString*, %VecString** %3, align 8
  %18 = getelementptr inbounds %VecString, %VecString* %17, i32 0, i32 2
  %19 = load i32, i32* %18, align 4
  %20 = add i32 %19, 1
  store i32 %20, i32* %16, align 4
  ret void
}

define dso_local %String @VecString_pop(%VecString* %0) {
  %2 = alloca %VecString*, align 8
  store %VecString* %0, %VecString** %2, align 8
  %3 = alloca %String, align 8
  %4 = load %VecString*, %VecString** %2, align 8
  %5 = getelementptr inbounds %VecString, %VecString* %4, i32 0, i32 2
  %6 = load %VecString*, %VecString** %2, align 8
  %7 = getelementptr inbounds %VecString, %VecString* %6, i32 0, i32 2
  %8 = load i32, i32* %7, align 4
  %9 = sub i32 %8, 1
  store i32 %9, i32* %5, align 4
  %10 = load %VecString*, %VecString** %2, align 8
  %11 = bitcast %VecString* %10 to %String**
  %12 = load %String*, %String** %11, align 8
  %13 = load %VecString*, %VecString** %2, align 8
  %14 = getelementptr inbounds %VecString, %VecString* %13, i32 0, i32 2
  %15 = load i32, i32* %14, align 4
  %16 = getelementptr inbounds %String, %String* %12, i32 %15
  %17 = load %String, %String* %16, align 8
  store %String %17, %String* %3, align 8
  %18 = load %String, %String* %3, align 8
  ret %String %18
}

define dso_local void @VecString_drop(%VecString* %0) {
  %2 = alloca %VecString*, align 8
  store %VecString* %0, %VecString** %2, align 8
  %3 = load %VecString*, %VecString** %2, align 8
  %4 = bitcast %VecString* %3 to %String**
  %5 = load %String*, %String** %4, align 8
  %6 = icmp ne %String* %5, null
  br i1 %6, label %if.then, label %if.end

if.then:                                          ; preds = %1
  %7 = load %VecString*, %VecString** %2, align 8
  %8 = bitcast %VecString* %7 to %String**
  %9 = load %String*, %String** %8, align 8
  %10 = bitcast %String* %9 to i8*
  call void @free(i8* %10)
  br label %if.end

if.end:                                           ; preds = %if.then, %1
  ret void
}

define dso_local %VecString @VecString_copy(%VecString* %0) {
  %2 = alloca %VecString*, align 8
  store %VecString* %0, %VecString** %2, align 8
  %3 = alloca %VecString, align 8
  %4 = alloca i32, align 4
  store i32 16, i32* %4, align 4
  %5 = load %VecString*, %VecString** %2, align 8
  %6 = getelementptr inbounds %VecString, %VecString* %5, i32 0, i32 1
  %7 = load i32, i32* %6, align 4
  %8 = call %VecString @VecString_with_size(i32 %7)
  %9 = alloca %VecString, align 8
  store %VecString %8, %VecString* %9, align 8
  %10 = bitcast %VecString* %9 to %String**
  %11 = bitcast %VecString* %9 to %String**
  %12 = load %String*, %String** %11, align 8
  %13 = bitcast %String* %12 to i8*
  %14 = load %VecString*, %VecString** %2, align 8
  %15 = bitcast %VecString* %14 to %String**
  %16 = load %String*, %String** %15, align 8
  %17 = bitcast %String* %16 to i8*
  %18 = load %VecString*, %VecString** %2, align 8
  %19 = getelementptr inbounds %VecString, %VecString* %18, i32 0, i32 1
  %20 = load i32, i32* %19, align 4
  %21 = load i32, i32* %4, align 4
  %22 = mul i32 %20, %21
  %23 = call i8* @memcpy(i8* %13, i8* %17, i32 %22)
  %24 = bitcast i8* %23 to %String*
  store %String* %24, %String** %10, align 8
  %25 = load %VecString, %VecString* %3, align 8
  ret %VecString %25
}

define dso_local %Token @Token_new(%String %0, i32 %1) {
  %3 = alloca %String, align 8
  store %String %0, %String* %3, align 8
  %4 = alloca i32, align 4
  store i32 %1, i32* %4, align 4
  %5 = alloca %Token, align 8
  %6 = alloca %Token, align 8
  %7 = getelementptr inbounds %Token, %Token* %6, i32 0, i32 1
  %8 = load %String, %String* %3, align 8
  store %String %8, %String* %7, align 8
  %9 = bitcast %Token* %6 to i32*
  %10 = load i32, i32* %4, align 4
  store i32 %10, i32* %9, align 4
  %11 = load %Token, %Token* %6, align 8
  store %Token %11, %Token* %5, align 8
  %12 = load %Token, %Token* %5, align 8
  ret %Token %12
}

define dso_local %VecToken @VecToken_new() {
  %1 = alloca %VecToken, align 8
  %2 = alloca i32, align 4
  store i32 24, i32* %2, align 4
  %3 = alloca %VecToken, align 8
  %4 = bitcast %VecToken* %3 to %Token**
  store %Token* null, %Token** %4, align 8
  %5 = getelementptr inbounds %VecToken, %VecToken* %3, i32 0, i32 1
  store i32 0, i32* %5, align 4
  %6 = getelementptr inbounds %VecToken, %VecToken* %3, i32 0, i32 2
  store i32 0, i32* %6, align 4
  %7 = load %VecToken, %VecToken* %3, align 8
  store %VecToken %7, %VecToken* %1, align 8
  %8 = load %VecToken, %VecToken* %1, align 8
  ret %VecToken %8
}

define dso_local %VecToken @VecToken_with_size(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = alloca %VecToken, align 8
  %4 = alloca i32, align 4
  store i32 24, i32* %4, align 4
  %5 = alloca %VecToken, align 8
  %6 = bitcast %VecToken* %5 to %Token**
  %7 = load i32, i32* %2, align 4
  %8 = load i32, i32* %4, align 4
  %9 = mul i32 %7, %8
  %10 = call i8* @malloc(i32 %9)
  %11 = bitcast i8* %10 to %Token*
  store %Token* %11, %Token** %6, align 8
  %12 = getelementptr inbounds %VecToken, %VecToken* %5, i32 0, i32 1
  %13 = load i32, i32* %2, align 4
  store i32 %13, i32* %12, align 4
  %14 = getelementptr inbounds %VecToken, %VecToken* %5, i32 0, i32 2
  store i32 0, i32* %14, align 4
  %15 = load %VecToken, %VecToken* %5, align 8
  store %VecToken %15, %VecToken* %3, align 8
  %16 = load %VecToken, %VecToken* %3, align 8
  ret %VecToken %16
}

define dso_local void @VecToken_may_grow(%VecToken* %0) {
  %2 = alloca %VecToken*, align 8
  store %VecToken* %0, %VecToken** %2, align 8
  %3 = alloca i32, align 4
  store i32 24, i32* %3, align 4
  %4 = load %VecToken*, %VecToken** %2, align 8
  %5 = getelementptr inbounds %VecToken, %VecToken* %4, i32 0, i32 1
  %6 = load i32, i32* %5, align 4
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %1
  %8 = load %VecToken*, %VecToken** %2, align 8
  %9 = getelementptr inbounds %VecToken, %VecToken* %8, i32 0, i32 1
  store i32 1, i32* %9, align 4
  %10 = load %VecToken*, %VecToken** %2, align 8
  %11 = bitcast %VecToken* %10 to %Token**
  %12 = load %VecToken*, %VecToken** %2, align 8
  %13 = bitcast %VecToken* %12 to %Token**
  %14 = load %Token*, %Token** %13, align 8
  %15 = bitcast %Token* %14 to i8*
  %16 = load %VecToken*, %VecToken** %2, align 8
  %17 = getelementptr inbounds %VecToken, %VecToken* %16, i32 0, i32 1
  %18 = load i32, i32* %17, align 4
  %19 = load i32, i32* %3, align 4
  %20 = mul i32 %18, %19
  %21 = call i8* @realloc(i8* %15, i32 %20)
  %22 = bitcast i8* %21 to %Token*
  store %Token* %22, %Token** %11, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %1
  %23 = load %VecToken*, %VecToken** %2, align 8
  %24 = getelementptr inbounds %VecToken, %VecToken* %23, i32 0, i32 1
  %25 = load %VecToken*, %VecToken** %2, align 8
  %26 = getelementptr inbounds %VecToken, %VecToken* %25, i32 0, i32 2
  %27 = load i32, i32* %24, align 4
  %28 = load i32, i32* %26, align 4
  %29 = icmp eq i32 %27, %28
  br i1 %29, label %if.then1, label %if.end2

if.then1:                                         ; preds = %if.end
  %30 = load %VecToken*, %VecToken** %2, align 8
  %31 = getelementptr inbounds %VecToken, %VecToken* %30, i32 0, i32 1
  %32 = load %VecToken*, %VecToken** %2, align 8
  %33 = getelementptr inbounds %VecToken, %VecToken* %32, i32 0, i32 1
  %34 = load i32, i32* %33, align 4
  %35 = mul i32 %34, 2
  store i32 %35, i32* %31, align 4
  %36 = load %VecToken*, %VecToken** %2, align 8
  %37 = bitcast %VecToken* %36 to %Token**
  %38 = load %VecToken*, %VecToken** %2, align 8
  %39 = bitcast %VecToken* %38 to %Token**
  %40 = load %Token*, %Token** %39, align 8
  %41 = bitcast %Token* %40 to i8*
  %42 = load %VecToken*, %VecToken** %2, align 8
  %43 = getelementptr inbounds %VecToken, %VecToken* %42, i32 0, i32 1
  %44 = load i32, i32* %43, align 4
  %45 = load i32, i32* %3, align 4
  %46 = mul i32 %44, %45
  %47 = call i8* @realloc(i8* %41, i32 %46)
  %48 = bitcast i8* %47 to %Token*
  store %Token* %48, %Token** %37, align 8
  br label %if.end2

if.end2:                                          ; preds = %if.then1, %if.end
  ret void
}

define dso_local void @VecToken_push(%VecToken* %0, %Token %1) {
  %3 = alloca %VecToken*, align 8
  store %VecToken* %0, %VecToken** %3, align 8
  %4 = alloca %Token, align 8
  store %Token %1, %Token* %4, align 8
  %5 = load %VecToken*, %VecToken** %3, align 8
  %6 = load %VecToken*, %VecToken** %3, align 8
  call void @VecToken_may_grow(%VecToken* %6)
  %7 = load %VecToken*, %VecToken** %3, align 8
  %8 = bitcast %VecToken* %7 to %Token**
  %9 = load %Token*, %Token** %8, align 8
  %10 = load %VecToken*, %VecToken** %3, align 8
  %11 = getelementptr inbounds %VecToken, %VecToken* %10, i32 0, i32 2
  %12 = load i32, i32* %11, align 4
  %13 = getelementptr inbounds %Token, %Token* %9, i32 %12
  %14 = load %Token, %Token* %4, align 8
  store %Token %14, %Token* %13, align 8
  %15 = load %VecToken*, %VecToken** %3, align 8
  %16 = getelementptr inbounds %VecToken, %VecToken* %15, i32 0, i32 2
  %17 = load %VecToken*, %VecToken** %3, align 8
  %18 = getelementptr inbounds %VecToken, %VecToken* %17, i32 0, i32 2
  %19 = load i32, i32* %18, align 4
  %20 = add i32 %19, 1
  store i32 %20, i32* %16, align 4
  ret void
}

define dso_local %Token @VecToken_pop(%VecToken* %0) {
  %2 = alloca %VecToken*, align 8
  store %VecToken* %0, %VecToken** %2, align 8
  %3 = alloca %Token, align 8
  %4 = load %VecToken*, %VecToken** %2, align 8
  %5 = getelementptr inbounds %VecToken, %VecToken* %4, i32 0, i32 2
  %6 = load %VecToken*, %VecToken** %2, align 8
  %7 = getelementptr inbounds %VecToken, %VecToken* %6, i32 0, i32 2
  %8 = load i32, i32* %7, align 4
  %9 = sub i32 %8, 1
  store i32 %9, i32* %5, align 4
  %10 = load %VecToken*, %VecToken** %2, align 8
  %11 = bitcast %VecToken* %10 to %Token**
  %12 = load %Token*, %Token** %11, align 8
  %13 = load %VecToken*, %VecToken** %2, align 8
  %14 = getelementptr inbounds %VecToken, %VecToken* %13, i32 0, i32 2
  %15 = load i32, i32* %14, align 4
  %16 = getelementptr inbounds %Token, %Token* %12, i32 %15
  %17 = load %Token, %Token* %16, align 8
  store %Token %17, %Token* %3, align 8
  %18 = load %Token, %Token* %3, align 8
  ret %Token %18
}

define dso_local void @VecToken_drop(%VecToken* %0) {
  %2 = alloca %VecToken*, align 8
  store %VecToken* %0, %VecToken** %2, align 8
  %3 = load %VecToken*, %VecToken** %2, align 8
  %4 = bitcast %VecToken* %3 to %Token**
  %5 = load %Token*, %Token** %4, align 8
  %6 = icmp ne %Token* %5, null
  br i1 %6, label %if.then, label %if.end

if.then:                                          ; preds = %1
  %7 = load %VecToken*, %VecToken** %2, align 8
  %8 = bitcast %VecToken* %7 to %Token**
  %9 = load %Token*, %Token** %8, align 8
  %10 = bitcast %Token* %9 to i8*
  call void @free(i8* %10)
  br label %if.end

if.end:                                           ; preds = %if.then, %1
  ret void
}

define dso_local %VecToken @VecToken_copy(%VecToken* %0) {
  %2 = alloca %VecToken*, align 8
  store %VecToken* %0, %VecToken** %2, align 8
  %3 = alloca %VecToken, align 8
  %4 = alloca i32, align 4
  store i32 24, i32* %4, align 4
  %5 = load %VecToken*, %VecToken** %2, align 8
  %6 = getelementptr inbounds %VecToken, %VecToken* %5, i32 0, i32 1
  %7 = load i32, i32* %6, align 4
  %8 = call %VecToken @VecToken_with_size(i32 %7)
  %9 = alloca %VecToken, align 8
  store %VecToken %8, %VecToken* %9, align 8
  %10 = bitcast %VecToken* %9 to %Token**
  %11 = bitcast %VecToken* %9 to %Token**
  %12 = load %Token*, %Token** %11, align 8
  %13 = bitcast %Token* %12 to i8*
  %14 = load %VecToken*, %VecToken** %2, align 8
  %15 = bitcast %VecToken* %14 to %Token**
  %16 = load %Token*, %Token** %15, align 8
  %17 = bitcast %Token* %16 to i8*
  %18 = load %VecToken*, %VecToken** %2, align 8
  %19 = getelementptr inbounds %VecToken, %VecToken* %18, i32 0, i32 1
  %20 = load i32, i32* %19, align 4
  %21 = load i32, i32* %4, align 4
  %22 = mul i32 %20, %21
  %23 = call i8* @memcpy(i8* %13, i8* %17, i32 %22)
  %24 = bitcast i8* %23 to %Token*
  store %Token* %24, %Token** %10, align 8
  %25 = load %VecToken, %VecToken* %3, align 8
  ret %VecToken %25
}

define dso_local %Loc @Loc_new(%String* %0, i64 %1, i64 %2, i64 %3) {
  %5 = alloca %String*, align 8
  store %String* %0, %String** %5, align 8
  %6 = alloca i64, align 8
  store i64 %1, i64* %6, align 8
  %7 = alloca i64, align 8
  store i64 %2, i64* %7, align 8
  %8 = alloca i64, align 8
  store i64 %3, i64* %8, align 8
  %9 = alloca %Loc, align 8
  %10 = alloca %Loc, align 8
  %11 = bitcast %Loc* %10 to %String**
  %12 = load %String*, %String** %5, align 8
  store %String* %12, %String** %11, align 8
  %13 = getelementptr inbounds %Loc, %Loc* %10, i32 0, i32 1
  %14 = load i64, i64* %6, align 8
  store i64 %14, i64* %13, align 8
  %15 = getelementptr inbounds %Loc, %Loc* %10, i32 0, i32 2
  %16 = load i64, i64* %7, align 8
  store i64 %16, i64* %15, align 8
  %17 = getelementptr inbounds %Loc, %Loc* %10, i32 0, i32 3
  %18 = load i64, i64* %8, align 8
  store i64 %18, i64* %17, align 8
  %19 = load %Loc, %Loc* %10, align 8
  store %Loc %19, %Loc* %9, align 8
  %20 = load %Loc, %Loc* %9, align 8
  ret %Loc %20
}

define dso_local %Lexer @Lexer_new(i8* %0, i32 %1) {
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  %4 = alloca i32, align 4
  store i32 %1, i32* %4, align 4
  %5 = alloca %Lexer, align 8
  %6 = alloca %Lexer, align 8
  %7 = bitcast %Lexer* %6 to i8**
  %8 = load i8*, i8** %3, align 8
  store i8* %8, i8** %7, align 8
  %9 = getelementptr inbounds %Lexer, %Lexer* %6, i32 0, i32 1
  %10 = load i32, i32* %4, align 4
  store i32 %10, i32* %9, align 4
  %11 = getelementptr inbounds %Lexer, %Lexer* %6, i32 0, i32 3
  store i32 0, i32* %11, align 4
  %12 = getelementptr inbounds %Lexer, %Lexer* %6, i32 0, i32 2
  %13 = load i8*, i8** %3, align 8
  %14 = bitcast i8* %13 to i8*
  %15 = load i8, i8* %14, align 1
  store i8 %15, i8* %12, align 1
  %16 = load %Lexer, %Lexer* %6, align 8
  store %Lexer %16, %Lexer* %5, align 8
  %17 = load %Lexer, %Lexer* %5, align 8
  ret %Lexer %17
}

define dso_local void @Lexer_advance(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = load %Lexer*, %Lexer** %2, align 8
  %4 = getelementptr inbounds %Lexer, %Lexer* %3, i32 0, i32 3
  %5 = load %Lexer*, %Lexer** %2, align 8
  %6 = getelementptr inbounds %Lexer, %Lexer* %5, i32 0, i32 3
  %7 = load i32, i32* %6, align 4
  %8 = add i32 %7, 1
  store i32 %8, i32* %4, align 4
  %9 = load %Lexer*, %Lexer** %2, align 8
  %10 = getelementptr inbounds %Lexer, %Lexer* %9, i32 0, i32 2
  %11 = load %Lexer*, %Lexer** %2, align 8
  %12 = bitcast %Lexer* %11 to i8**
  %13 = load i8*, i8** %12, align 8
  %14 = load %Lexer*, %Lexer** %2, align 8
  %15 = getelementptr inbounds %Lexer, %Lexer* %14, i32 0, i32 3
  %16 = load i32, i32* %15, align 4
  %17 = getelementptr inbounds i8, i8* %13, i32 %16
  %18 = load i8, i8* %17, align 1
  store i8 %18, i8* %10, align 1
  ret void
}

define dso_local %Token @Lexer_advance_token(%Lexer* %0, %Token %1) {
  %3 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %3, align 8
  %4 = alloca %Token, align 8
  store %Token %1, %Token* %4, align 8
  %5 = alloca %Token, align 8
  %6 = load %Lexer*, %Lexer** %3, align 8
  %7 = load %Lexer*, %Lexer** %3, align 8
  call void @Lexer_advance(%Lexer* %7)
  %8 = load %Token, %Token* %4, align 8
  store %Token %8, %Token* %5, align 8
  %9 = load %Token, %Token* %5, align 8
  ret %Token %9
}

define dso_local %Token @Lexer_lex_number(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = alloca %Token, align 8
  %4 = load %Lexer*, %Lexer** %2, align 8
  %5 = getelementptr inbounds %Lexer, %Lexer* %4, i32 0, i32 3
  %6 = load i32, i32* %5, align 4
  %7 = alloca i32, align 4
  store i32 %6, i32* %7, align 4
  %8 = call %String @String_new(i32 2)
  %9 = alloca %String, align 8
  store %String %8, %String* %9, align 8
  %10 = load %Lexer*, %Lexer** %2, align 8
  %11 = getelementptr inbounds %Lexer, %Lexer* %10, i32 0, i32 2
  %12 = load i8, i8* %11, align 1
  %13 = alloca i8, align 1
  store i8 %12, i8* %13, align 1
  br label %for.cond

for.cond:                                         ; preds = %for.block, %1
  %14 = load %Lexer*, %Lexer** %2, align 8
  %15 = getelementptr inbounds %Lexer, %Lexer* %14, i32 0, i32 2
  %16 = load i8, i8* %15, align 1
  %17 = sext i8 %16 to i32
  %18 = call i32 @isdigit(i32 %17)
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %20 = load %Lexer*, %Lexer** %2, align 8
  %21 = getelementptr inbounds %Lexer, %Lexer* %20, i32 0, i32 2
  %22 = load i8, i8* %21, align 1
  call void @String_push(%String* %9, i8 %22)
  %23 = load %Lexer*, %Lexer** %2, align 8
  %24 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %24)
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %25 = call i1 @String_contains(%String* %9, i8 46)
  br i1 %25, label %if.then, label %if.end

if.then:                                          ; preds = %for.end
  %26 = load %String, %String* %9, align 8
  %27 = call %Token @Token_new(%String %26, i32 2)
  store %Token %27, %Token* %3, align 8
  br label %ret

if.end:                                           ; preds = %for.end
  %28 = load %String, %String* %9, align 8
  %29 = call %Token @Token_new(%String %28, i32 1)
  store %Token %29, %Token* %3, align 8
  br label %ret

ret:                                              ; preds = %if.end, %if.then
  %30 = load %Token, %Token* %3, align 8
  ret %Token %30
}

define dso_local %Token @Lexer_lex_string(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = alloca %Token, align 8
  %4 = load %Lexer*, %Lexer** %2, align 8
  %5 = getelementptr inbounds %Lexer, %Lexer* %4, i32 0, i32 3
  %6 = load i32, i32* %5, align 4
  %7 = alloca i32, align 4
  store i32 %6, i32* %7, align 4
  %8 = call %String @String_new(i32 2)
  %9 = alloca %String, align 8
  store %String %8, %String* %9, align 8
  %10 = load %Lexer*, %Lexer** %2, align 8
  %11 = getelementptr inbounds %Lexer, %Lexer* %10, i32 0, i32 2
  %12 = load i8, i8* %11, align 1
  %13 = alloca i8, align 1
  store i8 %12, i8* %13, align 1
  br label %for.cond

for.cond:                                         ; preds = %for.block, %1
  %14 = load %Lexer*, %Lexer** %2, align 8
  %15 = getelementptr inbounds %Lexer, %Lexer* %14, i32 0, i32 2
  %16 = load i8, i8* %15, align 1
  %17 = icmp ne i8 %16, 34
  br i1 %17, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %18 = load %Lexer*, %Lexer** %2, align 8
  %19 = getelementptr inbounds %Lexer, %Lexer* %18, i32 0, i32 2
  %20 = load i8, i8* %19, align 1
  call void @String_push(%String* %9, i8 %20)
  %21 = load %Lexer*, %Lexer** %2, align 8
  %22 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %22)
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %23 = load %String, %String* %9, align 8
  %24 = call %Token @Token_new(%String %23, i32 0)
  store %Token %24, %Token* %3, align 8
  %25 = load %Token, %Token* %3, align 8
  ret %Token %25
}

define dso_local %Token @Lexer_lex_char(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = alloca %Token, align 8
  %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([29 x i8], [29 x i8]* @0, i32 0, i32 0))
  call void @exit(i32 1)
  %5 = load %Token, %Token* %3, align 8
  ret %Token %5
}

define dso_local %Token @Lexer_lex_id(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = alloca %Token, align 8
  %4 = load %Lexer*, %Lexer** %2, align 8
  %5 = getelementptr inbounds %Lexer, %Lexer* %4, i32 0, i32 3
  %6 = load i32, i32* %5, align 4
  %7 = alloca i32, align 4
  store i32 %6, i32* %7, align 4
  %8 = call %String @String_new(i32 2)
  %9 = alloca %String, align 8
  store %String %8, %String* %9, align 8
  %10 = load %Lexer*, %Lexer** %2, align 8
  %11 = getelementptr inbounds %Lexer, %Lexer* %10, i32 0, i32 2
  %12 = load i8, i8* %11, align 1
  %13 = alloca i8, align 1
  store i8 %12, i8* %13, align 1
  br label %for.cond

for.cond:                                         ; preds = %for.block, %1
  %14 = load %Lexer*, %Lexer** %2, align 8
  %15 = getelementptr inbounds %Lexer, %Lexer* %14, i32 0, i32 2
  %16 = load i8, i8* %15, align 1
  %17 = sext i8 %16 to i32
  %18 = call i32 @isalpha(i32 %17)
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %20 = load %Lexer*, %Lexer** %2, align 8
  %21 = getelementptr inbounds %Lexer, %Lexer* %20, i32 0, i32 2
  %22 = load i8, i8* %21, align 1
  call void @String_push(%String* %9, i8 %22)
  %23 = load %Lexer*, %Lexer** %2, align 8
  %24 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %24)
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %25 = load %String, %String* %9, align 8
  %26 = call %Token @Token_new(%String %25, i32 3)
  store %Token %26, %Token* %3, align 8
  %27 = load %Token, %Token* %3, align 8
  ret %Token %27
}

define dso_local %Token @Lexer_next_token(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = alloca %Token, align 8
  %4 = alloca i32, align 4
  store i32 0, i32* %4, align 4
  br label %for.cond

for.cond:                                         ; preds = %if.end76, %1
  %5 = load %Lexer*, %Lexer** %2, align 8
  %6 = getelementptr inbounds %Lexer, %Lexer* %5, i32 0, i32 3
  %7 = load %Lexer*, %Lexer** %2, align 8
  %8 = getelementptr inbounds %Lexer, %Lexer* %7, i32 0, i32 1
  %9 = load i32, i32* %6, align 4
  %10 = load i32, i32* %8, align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %12 = alloca i32, align 4
  store i32 0, i32* %12, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond
  %13 = call %String @String_from(i8* getelementptr inbounds ([1 x i8], [1 x i8]* @32, i32 0, i32 0))
  %14 = call %Token @Token_new(%String %13, i32 56)
  store %Token %14, %Token* %3, align 8
  br label %ret

for.cond1:                                        ; preds = %for.block2, %for.block
  %15 = load %Lexer*, %Lexer** %2, align 8
  %16 = getelementptr inbounds %Lexer, %Lexer* %15, i32 0, i32 2
  %17 = load i8, i8* %16, align 1
  %18 = sext i8 %17 to i32
  %19 = call i32 @isspace(i32 %18)
  %20 = icmp ne i32 %19, 0
  br i1 %20, label %for.block2, label %for.end3

for.block2:                                       ; preds = %for.cond1
  %21 = load %Lexer*, %Lexer** %2, align 8
  %22 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %22)
  br label %for.cond1

for.end3:                                         ; preds = %for.cond1
  %23 = load %Lexer*, %Lexer** %2, align 8
  %24 = getelementptr inbounds %Lexer, %Lexer* %23, i32 0, i32 2
  %25 = load i8, i8* %24, align 1
  %26 = icmp eq i8 %25, 46
  br i1 %26, label %if.then, label %if.end

if.then:                                          ; preds = %for.end3
  %27 = load %Lexer*, %Lexer** %2, align 8
  %28 = load %Lexer*, %Lexer** %2, align 8
  %29 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @1, i32 0, i32 0))
  %30 = call %Token @Token_new(%String %29, i32 7)
  %31 = call %Token @Lexer_advance_token(%Lexer* %28, %Token %30)
  store %Token %31, %Token* %3, align 8
  br label %ret

if.end:                                           ; preds = %for.end3
  %32 = load %Lexer*, %Lexer** %2, align 8
  %33 = getelementptr inbounds %Lexer, %Lexer* %32, i32 0, i32 2
  %34 = load i8, i8* %33, align 1
  %35 = icmp eq i8 %34, 44
  br i1 %35, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  %36 = load %Lexer*, %Lexer** %2, align 8
  %37 = load %Lexer*, %Lexer** %2, align 8
  %38 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @2, i32 0, i32 0))
  %39 = call %Token @Token_new(%String %38, i32 8)
  %40 = call %Token @Lexer_advance_token(%Lexer* %37, %Token %39)
  store %Token %40, %Token* %3, align 8
  br label %ret

if.end5:                                          ; preds = %if.end
  %41 = load %Lexer*, %Lexer** %2, align 8
  %42 = getelementptr inbounds %Lexer, %Lexer* %41, i32 0, i32 2
  %43 = load i8, i8* %42, align 1
  %44 = icmp eq i8 %43, 59
  br i1 %44, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end5
  %45 = load %Lexer*, %Lexer** %2, align 8
  %46 = load %Lexer*, %Lexer** %2, align 8
  %47 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @3, i32 0, i32 0))
  %48 = call %Token @Token_new(%String %47, i32 9)
  %49 = call %Token @Lexer_advance_token(%Lexer* %46, %Token %48)
  store %Token %49, %Token* %3, align 8
  br label %ret

if.end7:                                          ; preds = %if.end5
  %50 = load %Lexer*, %Lexer** %2, align 8
  %51 = getelementptr inbounds %Lexer, %Lexer* %50, i32 0, i32 2
  %52 = load i8, i8* %51, align 1
  %53 = icmp eq i8 %52, 58
  br i1 %53, label %if.then8, label %if.end9

if.then8:                                         ; preds = %if.end7
  %54 = load %Lexer*, %Lexer** %2, align 8
  %55 = bitcast %Lexer* %54 to i8**
  %56 = load i8*, i8** %55, align 8
  %57 = load %Lexer*, %Lexer** %2, align 8
  %58 = getelementptr inbounds %Lexer, %Lexer* %57, i32 0, i32 3
  %59 = load i32, i32* %58, align 4
  %60 = add i32 %59, 1
  %61 = getelementptr inbounds i8, i8* %56, i32 %60
  %62 = load i8, i8* %61, align 1
  %63 = icmp eq i8 %62, 58
  br i1 %63, label %if.then10, label %if.end12

if.end9:                                          ; preds = %if.end7
  %64 = load %Lexer*, %Lexer** %2, align 8
  %65 = getelementptr inbounds %Lexer, %Lexer* %64, i32 0, i32 2
  %66 = load i8, i8* %65, align 1
  %67 = icmp eq i8 %66, 43
  br i1 %67, label %if.then13, label %if.end14

if.then10:                                        ; preds = %if.then8
  %68 = load %Lexer*, %Lexer** %2, align 8
  %69 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %69)
  %70 = load %Lexer*, %Lexer** %2, align 8
  %71 = load %Lexer*, %Lexer** %2, align 8
  %72 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @4, i32 0, i32 0))
  %73 = call %Token @Token_new(%String %72, i32 27)
  %74 = call %Token @Lexer_advance_token(%Lexer* %71, %Token %73)
  store %Token %74, %Token* %3, align 8
  br label %ret

if.end12:                                         ; preds = %if.then8
  %75 = load %Lexer*, %Lexer** %2, align 8
  %76 = load %Lexer*, %Lexer** %2, align 8
  %77 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @5, i32 0, i32 0))
  %78 = call %Token @Token_new(%String %77, i32 10)
  %79 = call %Token @Lexer_advance_token(%Lexer* %76, %Token %78)
  store %Token %79, %Token* %3, align 8
  br label %ret

if.then13:                                        ; preds = %if.end9
  %80 = load %Lexer*, %Lexer** %2, align 8
  %81 = load %Lexer*, %Lexer** %2, align 8
  %82 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @6, i32 0, i32 0))
  %83 = call %Token @Token_new(%String %82, i32 16)
  %84 = call %Token @Lexer_advance_token(%Lexer* %81, %Token %83)
  store %Token %84, %Token* %3, align 8
  br label %ret

if.end14:                                         ; preds = %if.end9
  %85 = load %Lexer*, %Lexer** %2, align 8
  %86 = getelementptr inbounds %Lexer, %Lexer* %85, i32 0, i32 2
  %87 = load i8, i8* %86, align 1
  %88 = icmp eq i8 %87, 45
  br i1 %88, label %if.then15, label %if.end16

if.then15:                                        ; preds = %if.end14
  %89 = load %Lexer*, %Lexer** %2, align 8
  %90 = bitcast %Lexer* %89 to i8**
  %91 = load i8*, i8** %90, align 8
  %92 = load %Lexer*, %Lexer** %2, align 8
  %93 = getelementptr inbounds %Lexer, %Lexer* %92, i32 0, i32 3
  %94 = load i32, i32* %93, align 4
  %95 = add i32 %94, 1
  %96 = getelementptr inbounds i8, i8* %91, i32 %95
  %97 = load i8, i8* %96, align 1
  %98 = icmp eq i8 %97, 62
  br i1 %98, label %if.then17, label %if.end19

if.end16:                                         ; preds = %if.end14
  %99 = load %Lexer*, %Lexer** %2, align 8
  %100 = getelementptr inbounds %Lexer, %Lexer* %99, i32 0, i32 2
  %101 = load i8, i8* %100, align 1
  %102 = icmp eq i8 %101, 42
  br i1 %102, label %if.then20, label %if.end21

if.then17:                                        ; preds = %if.then15
  %103 = load %Lexer*, %Lexer** %2, align 8
  %104 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %104)
  %105 = load %Lexer*, %Lexer** %2, align 8
  %106 = load %Lexer*, %Lexer** %2, align 8
  %107 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @7, i32 0, i32 0))
  %108 = call %Token @Token_new(%String %107, i32 6)
  %109 = call %Token @Lexer_advance_token(%Lexer* %106, %Token %108)
  store %Token %109, %Token* %3, align 8
  br label %ret

if.end19:                                         ; preds = %if.then15
  %110 = load %Lexer*, %Lexer** %2, align 8
  %111 = load %Lexer*, %Lexer** %2, align 8
  %112 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @8, i32 0, i32 0))
  %113 = call %Token @Token_new(%String %112, i32 17)
  %114 = call %Token @Lexer_advance_token(%Lexer* %111, %Token %113)
  store %Token %114, %Token* %3, align 8
  br label %ret

if.then20:                                        ; preds = %if.end16
  %115 = load %Lexer*, %Lexer** %2, align 8
  %116 = load %Lexer*, %Lexer** %2, align 8
  %117 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @9, i32 0, i32 0))
  %118 = call %Token @Token_new(%String %117, i32 18)
  %119 = call %Token @Lexer_advance_token(%Lexer* %116, %Token %118)
  store %Token %119, %Token* %3, align 8
  br label %ret

if.end21:                                         ; preds = %if.end16
  %120 = load %Lexer*, %Lexer** %2, align 8
  %121 = getelementptr inbounds %Lexer, %Lexer* %120, i32 0, i32 2
  %122 = load i8, i8* %121, align 1
  %123 = icmp eq i8 %122, 47
  br i1 %123, label %if.then22, label %if.end23

if.then22:                                        ; preds = %if.end21
  %124 = load %Lexer*, %Lexer** %2, align 8
  %125 = load %Lexer*, %Lexer** %2, align 8
  %126 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @10, i32 0, i32 0))
  %127 = call %Token @Token_new(%String %126, i32 19)
  %128 = call %Token @Lexer_advance_token(%Lexer* %125, %Token %127)
  store %Token %128, %Token* %3, align 8
  br label %ret

if.end23:                                         ; preds = %if.end21
  %129 = load %Lexer*, %Lexer** %2, align 8
  %130 = getelementptr inbounds %Lexer, %Lexer* %129, i32 0, i32 2
  %131 = load i8, i8* %130, align 1
  %132 = icmp eq i8 %131, 37
  br i1 %132, label %if.then27, label %if.end28

if.then27:                                        ; preds = %if.end23
  %133 = load %Lexer*, %Lexer** %2, align 8
  %134 = load %Lexer*, %Lexer** %2, align 8
  %135 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @11, i32 0, i32 0))
  %136 = call %Token @Token_new(%String %135, i32 20)
  %137 = call %Token @Lexer_advance_token(%Lexer* %134, %Token %136)
  store %Token %137, %Token* %3, align 8
  br label %ret

if.end28:                                         ; preds = %if.end23
  %138 = load %Lexer*, %Lexer** %2, align 8
  %139 = getelementptr inbounds %Lexer, %Lexer* %138, i32 0, i32 2
  %140 = load i8, i8* %139, align 1
  %141 = icmp eq i8 %140, 91
  br i1 %141, label %if.then29, label %if.end30

if.then29:                                        ; preds = %if.end28
  %142 = load %Lexer*, %Lexer** %2, align 8
  %143 = load %Lexer*, %Lexer** %2, align 8
  %144 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @12, i32 0, i32 0))
  %145 = call %Token @Token_new(%String %144, i32 29)
  %146 = call %Token @Lexer_advance_token(%Lexer* %143, %Token %145)
  store %Token %146, %Token* %3, align 8
  br label %ret

if.end30:                                         ; preds = %if.end28
  %147 = load %Lexer*, %Lexer** %2, align 8
  %148 = getelementptr inbounds %Lexer, %Lexer* %147, i32 0, i32 2
  %149 = load i8, i8* %148, align 1
  %150 = icmp eq i8 %149, 93
  br i1 %150, label %if.then31, label %if.end32

if.then31:                                        ; preds = %if.end30
  %151 = load %Lexer*, %Lexer** %2, align 8
  %152 = load %Lexer*, %Lexer** %2, align 8
  %153 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @13, i32 0, i32 0))
  %154 = call %Token @Token_new(%String %153, i32 30)
  %155 = call %Token @Lexer_advance_token(%Lexer* %152, %Token %154)
  store %Token %155, %Token* %3, align 8
  br label %ret

if.end32:                                         ; preds = %if.end30
  %156 = load %Lexer*, %Lexer** %2, align 8
  %157 = getelementptr inbounds %Lexer, %Lexer* %156, i32 0, i32 2
  %158 = load i8, i8* %157, align 1
  %159 = icmp eq i8 %158, 123
  br i1 %159, label %if.then33, label %if.end34

if.then33:                                        ; preds = %if.end32
  %160 = load %Lexer*, %Lexer** %2, align 8
  %161 = load %Lexer*, %Lexer** %2, align 8
  %162 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @14, i32 0, i32 0))
  %163 = call %Token @Token_new(%String %162, i32 31)
  %164 = call %Token @Lexer_advance_token(%Lexer* %161, %Token %163)
  store %Token %164, %Token* %3, align 8
  br label %ret

if.end34:                                         ; preds = %if.end32
  %165 = load %Lexer*, %Lexer** %2, align 8
  %166 = getelementptr inbounds %Lexer, %Lexer* %165, i32 0, i32 2
  %167 = load i8, i8* %166, align 1
  %168 = icmp eq i8 %167, 125
  br i1 %168, label %if.then35, label %if.end36

if.then35:                                        ; preds = %if.end34
  %169 = load %Lexer*, %Lexer** %2, align 8
  %170 = load %Lexer*, %Lexer** %2, align 8
  %171 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @15, i32 0, i32 0))
  %172 = call %Token @Token_new(%String %171, i32 32)
  %173 = call %Token @Lexer_advance_token(%Lexer* %170, %Token %172)
  store %Token %173, %Token* %3, align 8
  br label %ret

if.end36:                                         ; preds = %if.end34
  %174 = load %Lexer*, %Lexer** %2, align 8
  %175 = getelementptr inbounds %Lexer, %Lexer* %174, i32 0, i32 2
  %176 = load i8, i8* %175, align 1
  %177 = icmp eq i8 %176, 40
  br i1 %177, label %if.then37, label %if.end38

if.then37:                                        ; preds = %if.end36
  %178 = load %Lexer*, %Lexer** %2, align 8
  %179 = load %Lexer*, %Lexer** %2, align 8
  %180 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @16, i32 0, i32 0))
  %181 = call %Token @Token_new(%String %180, i32 35)
  %182 = call %Token @Lexer_advance_token(%Lexer* %179, %Token %181)
  store %Token %182, %Token* %3, align 8
  br label %ret

if.end38:                                         ; preds = %if.end36
  %183 = load %Lexer*, %Lexer** %2, align 8
  %184 = getelementptr inbounds %Lexer, %Lexer* %183, i32 0, i32 2
  %185 = load i8, i8* %184, align 1
  %186 = icmp eq i8 %185, 41
  br i1 %186, label %if.then39, label %if.end40

if.then39:                                        ; preds = %if.end38
  %187 = load %Lexer*, %Lexer** %2, align 8
  %188 = load %Lexer*, %Lexer** %2, align 8
  %189 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @17, i32 0, i32 0))
  %190 = call %Token @Token_new(%String %189, i32 36)
  %191 = call %Token @Lexer_advance_token(%Lexer* %188, %Token %190)
  store %Token %191, %Token* %3, align 8
  br label %ret

if.end40:                                         ; preds = %if.end38
  %192 = load %Lexer*, %Lexer** %2, align 8
  %193 = getelementptr inbounds %Lexer, %Lexer* %192, i32 0, i32 2
  %194 = load i8, i8* %193, align 1
  %195 = icmp eq i8 %194, 35
  br i1 %195, label %if.then41, label %if.end42

if.then41:                                        ; preds = %if.end40
  %196 = load %Lexer*, %Lexer** %2, align 8
  %197 = load %Lexer*, %Lexer** %2, align 8
  %198 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @18, i32 0, i32 0))
  %199 = call %Token @Token_new(%String %198, i32 12)
  %200 = call %Token @Lexer_advance_token(%Lexer* %197, %Token %199)
  store %Token %200, %Token* %3, align 8
  br label %ret

if.end42:                                         ; preds = %if.end40
  %201 = load %Lexer*, %Lexer** %2, align 8
  %202 = getelementptr inbounds %Lexer, %Lexer* %201, i32 0, i32 2
  %203 = load i8, i8* %202, align 1
  %204 = icmp eq i8 %203, 36
  br i1 %204, label %if.then43, label %if.end44

if.then43:                                        ; preds = %if.end42
  %205 = load %Lexer*, %Lexer** %2, align 8
  %206 = load %Lexer*, %Lexer** %2, align 8
  %207 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @19, i32 0, i32 0))
  %208 = call %Token @Token_new(%String %207, i32 13)
  %209 = call %Token @Lexer_advance_token(%Lexer* %206, %Token %208)
  store %Token %209, %Token* %3, align 8
  br label %ret

if.end44:                                         ; preds = %if.end42
  %210 = load %Lexer*, %Lexer** %2, align 8
  %211 = getelementptr inbounds %Lexer, %Lexer* %210, i32 0, i32 2
  %212 = load i8, i8* %211, align 1
  %213 = icmp eq i8 %212, 60
  br i1 %213, label %if.then45, label %if.end46

if.then45:                                        ; preds = %if.end44
  %214 = load %Lexer*, %Lexer** %2, align 8
  %215 = bitcast %Lexer* %214 to i8**
  %216 = load i8*, i8** %215, align 8
  %217 = load %Lexer*, %Lexer** %2, align 8
  %218 = getelementptr inbounds %Lexer, %Lexer* %217, i32 0, i32 3
  %219 = load i32, i32* %218, align 4
  %220 = add i32 %219, 1
  %221 = getelementptr inbounds i8, i8* %216, i32 %220
  %222 = load i8, i8* %221, align 1
  %223 = icmp eq i8 %222, 61
  br i1 %223, label %if.then47, label %if.end49

if.end46:                                         ; preds = %if.end44
  %224 = load %Lexer*, %Lexer** %2, align 8
  %225 = getelementptr inbounds %Lexer, %Lexer* %224, i32 0, i32 2
  %226 = load i8, i8* %225, align 1
  %227 = icmp eq i8 %226, 62
  br i1 %227, label %if.then50, label %if.end51

if.then47:                                        ; preds = %if.then45
  %228 = load %Lexer*, %Lexer** %2, align 8
  %229 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %229)
  %230 = load %Lexer*, %Lexer** %2, align 8
  %231 = load %Lexer*, %Lexer** %2, align 8
  %232 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @20, i32 0, i32 0))
  %233 = call %Token @Token_new(%String %232, i32 23)
  %234 = call %Token @Lexer_advance_token(%Lexer* %231, %Token %233)
  store %Token %234, %Token* %3, align 8
  br label %ret

if.end49:                                         ; preds = %if.then45
  %235 = load %Lexer*, %Lexer** %2, align 8
  %236 = load %Lexer*, %Lexer** %2, align 8
  %237 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @21, i32 0, i32 0))
  %238 = call %Token @Token_new(%String %237, i32 33)
  %239 = call %Token @Lexer_advance_token(%Lexer* %236, %Token %238)
  store %Token %239, %Token* %3, align 8
  br label %ret

if.then50:                                        ; preds = %if.end46
  %240 = load %Lexer*, %Lexer** %2, align 8
  %241 = bitcast %Lexer* %240 to i8**
  %242 = load i8*, i8** %241, align 8
  %243 = load %Lexer*, %Lexer** %2, align 8
  %244 = getelementptr inbounds %Lexer, %Lexer* %243, i32 0, i32 3
  %245 = load i32, i32* %244, align 4
  %246 = add i32 %245, 1
  %247 = getelementptr inbounds i8, i8* %242, i32 %246
  %248 = load i8, i8* %247, align 1
  %249 = icmp eq i8 %248, 61
  br i1 %249, label %if.then52, label %if.end54

if.end51:                                         ; preds = %if.end46
  %250 = load %Lexer*, %Lexer** %2, align 8
  %251 = getelementptr inbounds %Lexer, %Lexer* %250, i32 0, i32 2
  %252 = load i8, i8* %251, align 1
  %253 = icmp eq i8 %252, 38
  br i1 %253, label %if.then55, label %if.end56

if.then52:                                        ; preds = %if.then50
  %254 = load %Lexer*, %Lexer** %2, align 8
  %255 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %255)
  %256 = load %Lexer*, %Lexer** %2, align 8
  %257 = load %Lexer*, %Lexer** %2, align 8
  %258 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @22, i32 0, i32 0))
  %259 = call %Token @Token_new(%String %258, i32 24)
  %260 = call %Token @Lexer_advance_token(%Lexer* %257, %Token %259)
  store %Token %260, %Token* %3, align 8
  br label %ret

if.end54:                                         ; preds = %if.then50
  %261 = load %Lexer*, %Lexer** %2, align 8
  %262 = load %Lexer*, %Lexer** %2, align 8
  %263 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @23, i32 0, i32 0))
  %264 = call %Token @Token_new(%String %263, i32 34)
  %265 = call %Token @Lexer_advance_token(%Lexer* %262, %Token %264)
  store %Token %265, %Token* %3, align 8
  br label %ret

if.then55:                                        ; preds = %if.end51
  %266 = load %Lexer*, %Lexer** %2, align 8
  %267 = bitcast %Lexer* %266 to i8**
  %268 = load i8*, i8** %267, align 8
  %269 = load %Lexer*, %Lexer** %2, align 8
  %270 = getelementptr inbounds %Lexer, %Lexer* %269, i32 0, i32 3
  %271 = load i32, i32* %270, align 4
  %272 = add i32 %271, 1
  %273 = getelementptr inbounds i8, i8* %268, i32 %272
  %274 = load i8, i8* %273, align 1
  %275 = icmp eq i8 %274, 38
  br i1 %275, label %if.then57, label %if.end59

if.end56:                                         ; preds = %if.end51
  %276 = load %Lexer*, %Lexer** %2, align 8
  %277 = getelementptr inbounds %Lexer, %Lexer* %276, i32 0, i32 2
  %278 = load i8, i8* %277, align 1
  %279 = icmp eq i8 %278, 124
  br i1 %279, label %if.then60, label %if.end61

if.then57:                                        ; preds = %if.then55
  %280 = load %Lexer*, %Lexer** %2, align 8
  %281 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %281)
  %282 = load %Lexer*, %Lexer** %2, align 8
  %283 = load %Lexer*, %Lexer** %2, align 8
  %284 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @24, i32 0, i32 0))
  %285 = call %Token @Token_new(%String %284, i32 26)
  %286 = call %Token @Lexer_advance_token(%Lexer* %283, %Token %285)
  store %Token %286, %Token* %3, align 8
  br label %ret

if.end59:                                         ; preds = %if.then55
  %287 = load %Lexer*, %Lexer** %2, align 8
  %288 = load %Lexer*, %Lexer** %2, align 8
  %289 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @25, i32 0, i32 0))
  %290 = call %Token @Token_new(%String %289, i32 11)
  %291 = call %Token @Lexer_advance_token(%Lexer* %288, %Token %290)
  store %Token %291, %Token* %3, align 8
  br label %ret

if.then60:                                        ; preds = %if.end56
  %292 = load %Lexer*, %Lexer** %2, align 8
  %293 = bitcast %Lexer* %292 to i8**
  %294 = load i8*, i8** %293, align 8
  %295 = load %Lexer*, %Lexer** %2, align 8
  %296 = getelementptr inbounds %Lexer, %Lexer* %295, i32 0, i32 3
  %297 = load i32, i32* %296, align 4
  %298 = add i32 %297, 1
  %299 = getelementptr inbounds i8, i8* %294, i32 %298
  %300 = load i8, i8* %299, align 1
  %301 = icmp eq i8 %300, 124
  br i1 %301, label %if.then62, label %if.end64

if.end61:                                         ; preds = %if.end56
  %302 = load %Lexer*, %Lexer** %2, align 8
  %303 = getelementptr inbounds %Lexer, %Lexer* %302, i32 0, i32 2
  %304 = load i8, i8* %303, align 1
  %305 = icmp eq i8 %304, 33
  br i1 %305, label %if.then65, label %if.end66

if.then62:                                        ; preds = %if.then60
  %306 = load %Lexer*, %Lexer** %2, align 8
  %307 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %307)
  %308 = load %Lexer*, %Lexer** %2, align 8
  %309 = load %Lexer*, %Lexer** %2, align 8
  %310 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @26, i32 0, i32 0))
  %311 = call %Token @Token_new(%String %310, i32 25)
  %312 = call %Token @Lexer_advance_token(%Lexer* %309, %Token %311)
  store %Token %312, %Token* %3, align 8
  br label %ret

if.end64:                                         ; preds = %if.then60
  %313 = load %Lexer*, %Lexer** %2, align 8
  %314 = load %Lexer*, %Lexer** %2, align 8
  %315 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @27, i32 0, i32 0))
  %316 = call %Token @Token_new(%String %315, i32 14)
  %317 = call %Token @Lexer_advance_token(%Lexer* %314, %Token %316)
  store %Token %317, %Token* %3, align 8
  br label %ret

if.then65:                                        ; preds = %if.end61
  %318 = load %Lexer*, %Lexer** %2, align 8
  %319 = bitcast %Lexer* %318 to i8**
  %320 = load i8*, i8** %319, align 8
  %321 = load %Lexer*, %Lexer** %2, align 8
  %322 = getelementptr inbounds %Lexer, %Lexer* %321, i32 0, i32 3
  %323 = load i32, i32* %322, align 4
  %324 = add i32 %323, 1
  %325 = getelementptr inbounds i8, i8* %320, i32 %324
  %326 = load i8, i8* %325, align 1
  %327 = icmp eq i8 %326, 61
  br i1 %327, label %if.then67, label %if.end69

if.end66:                                         ; preds = %if.end61
  %328 = load %Lexer*, %Lexer** %2, align 8
  %329 = getelementptr inbounds %Lexer, %Lexer* %328, i32 0, i32 2
  %330 = load i8, i8* %329, align 1
  %331 = icmp eq i8 %330, 61
  br i1 %331, label %if.then70, label %if.end71

if.then67:                                        ; preds = %if.then65
  %332 = load %Lexer*, %Lexer** %2, align 8
  %333 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %333)
  %334 = load %Lexer*, %Lexer** %2, align 8
  %335 = load %Lexer*, %Lexer** %2, align 8
  %336 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @28, i32 0, i32 0))
  %337 = call %Token @Token_new(%String %336, i32 22)
  %338 = call %Token @Lexer_advance_token(%Lexer* %335, %Token %337)
  store %Token %338, %Token* %3, align 8
  br label %ret

if.end69:                                         ; preds = %if.then65
  %339 = load %Lexer*, %Lexer** %2, align 8
  %340 = load %Lexer*, %Lexer** %2, align 8
  %341 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @29, i32 0, i32 0))
  %342 = call %Token @Token_new(%String %341, i32 15)
  %343 = call %Token @Lexer_advance_token(%Lexer* %340, %Token %342)
  store %Token %343, %Token* %3, align 8
  br label %ret

if.then70:                                        ; preds = %if.end66
  %344 = load %Lexer*, %Lexer** %2, align 8
  %345 = bitcast %Lexer* %344 to i8**
  %346 = load i8*, i8** %345, align 8
  %347 = load %Lexer*, %Lexer** %2, align 8
  %348 = getelementptr inbounds %Lexer, %Lexer* %347, i32 0, i32 3
  %349 = load i32, i32* %348, align 4
  %350 = add i32 %349, 1
  %351 = getelementptr inbounds i8, i8* %346, i32 %350
  %352 = load i8, i8* %351, align 1
  %353 = icmp eq i8 %352, 61
  br i1 %353, label %if.then72, label %if.end74

if.end71:                                         ; preds = %if.end66
  %354 = load %Lexer*, %Lexer** %2, align 8
  %355 = getelementptr inbounds %Lexer, %Lexer* %354, i32 0, i32 2
  %356 = load i8, i8* %355, align 1
  %357 = sext i8 %356 to i32
  %358 = call i32 @isdigit(i32 %357)
  %359 = icmp ne i32 %358, 0
  br i1 %359, label %if.then75, label %if.end76

if.then72:                                        ; preds = %if.then70
  %360 = load %Lexer*, %Lexer** %2, align 8
  %361 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %361)
  %362 = load %Lexer*, %Lexer** %2, align 8
  %363 = load %Lexer*, %Lexer** %2, align 8
  %364 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @30, i32 0, i32 0))
  %365 = call %Token @Token_new(%String %364, i32 21)
  %366 = call %Token @Lexer_advance_token(%Lexer* %363, %Token %365)
  store %Token %366, %Token* %3, align 8
  br label %ret

if.end74:                                         ; preds = %if.then70
  %367 = load %Lexer*, %Lexer** %2, align 8
  %368 = load %Lexer*, %Lexer** %2, align 8
  %369 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @31, i32 0, i32 0))
  %370 = call %Token @Token_new(%String %369, i32 5)
  %371 = call %Token @Lexer_advance_token(%Lexer* %368, %Token %370)
  store %Token %371, %Token* %3, align 8
  br label %ret

if.then75:                                        ; preds = %if.end71
  %372 = load %Lexer*, %Lexer** %2, align 8
  %373 = load %Lexer*, %Lexer** %2, align 8
  %374 = call %Token @Lexer_lex_number(%Lexer* %373)
  store %Token %374, %Token* %3, align 8
  br label %ret

if.end76:                                         ; preds = %if.end71
  %375 = load %Lexer*, %Lexer** %2, align 8
  %376 = getelementptr inbounds %Lexer, %Lexer* %375, i32 0, i32 2
  %377 = load i8, i8* %376, align 1
  %378 = sext i8 %377 to i32
  %379 = call i32 @isalpha(i32 %378)
  %380 = icmp ne i32 %379, 0
  br i1 %380, label %if.then77, label %for.cond

if.then77:                                        ; preds = %if.end76
  %381 = load %Lexer*, %Lexer** %2, align 8
  %382 = load %Lexer*, %Lexer** %2, align 8
  %383 = call %Token @Lexer_lex_id(%Lexer* %382)
  store %Token %383, %Token* %3, align 8
  br label %ret

ret:                                              ; preds = %for.end, %if.then77, %if.then75, %if.end74, %if.then72, %if.end69, %if.then67, %if.end64, %if.then62, %if.end59, %if.then57, %if.end54, %if.then52, %if.end49, %if.then47, %if.then43, %if.then41, %if.then39, %if.then37, %if.then35, %if.then33, %if.then31, %if.then29, %if.then27, %if.then22, %if.then20, %if.end19, %if.then17, %if.then13, %if.end12, %if.then10, %if.then6, %if.then4, %if.then
  %384 = load %Token, %Token* %3, align 8
  ret %Token %384
}

define dso_local %VecToken @Lexer_collect_tokens(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = alloca %VecToken, align 8
  %4 = call %VecToken @VecToken_new()
  %5 = alloca %VecToken, align 8
  store %VecToken %4, %VecToken* %5, align 8
  %6 = load %Lexer*, %Lexer** %2, align 8
  %7 = load %Lexer*, %Lexer** %2, align 8
  %8 = call %Token @Lexer_next_token(%Lexer* %7)
  %9 = alloca %Token, align 8
  store %Token %8, %Token* %9, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.block, %1
  %10 = bitcast %Token* %9 to i32*
  %11 = load i32, i32* %10, align 4
  %12 = icmp ne i32 %11, 56
  br i1 %12, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %13 = load %Token, %Token* %9, align 8
  call void @VecToken_push(%VecToken* %5, %Token %13)
  %14 = load %Lexer*, %Lexer** %2, align 8
  %15 = load %Lexer*, %Lexer** %2, align 8
  %16 = call %Token @Lexer_next_token(%Lexer* %15)
  store %Token %16, %Token* %9, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %17 = call %String @String_from(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @33, i32 0, i32 0))
  %18 = call %Token @Token_new(%String %17, i32 56)
  call void @VecToken_push(%VecToken* %5, %Token %18)
  %19 = load %VecToken, %VecToken* %5, align 8
  store %VecToken %19, %VecToken* %3, align 8
  %20 = load %VecToken, %VecToken* %3, align 8
  ret %VecToken %20
}

define dso_local %Ctx @Ctx_init(i8* %0) {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  %3 = alloca %Ctx, align 8
  %4 = alloca %Ctx, align 8
  %5 = bitcast %Ctx* %4 to i8**
  %6 = load i8*, i8** %2, align 8
  store i8* %6, i8** %5, align 8
  %7 = getelementptr inbounds %Ctx, %Ctx* %4, i32 0, i32 1
  %8 = call i8* @LLVMContextCreate()
  store i8* %8, i8** %7, align 8
  %9 = getelementptr inbounds %Ctx, %Ctx* %4, i32 0, i32 2
  %10 = load i8*, i8** %2, align 8
  %11 = getelementptr inbounds %Ctx, %Ctx* %4, i32 0, i32 1
  %12 = load i8*, i8** %11, align 8
  %13 = call i8* @LLVMModuleCreateWithNameInContext(i8* %10, i8* %12)
  store i8* %13, i8** %9, align 8
  %14 = getelementptr inbounds %Ctx, %Ctx* %4, i32 0, i32 3
  %15 = getelementptr inbounds %Ctx, %Ctx* %4, i32 0, i32 1
  %16 = load i8*, i8** %15, align 8
  %17 = call i8* @LLVMCreateBuilderInContext(i8* %16)
  store i8* %17, i8** %14, align 8
  %18 = load %Ctx, %Ctx* %4, align 8
  store %Ctx %18, %Ctx* %3, align 8
  %19 = load %Ctx, %Ctx* %3, align 8
  ret %Ctx %19
}

define dso_local i8* @Ctx_add_function(%Ctx* %0, i8* %1, i8* %2) {
  %4 = alloca %Ctx*, align 8
  store %Ctx* %0, %Ctx** %4, align 8
  %5 = alloca i8*, align 8
  store i8* %1, i8** %5, align 8
  %6 = alloca i8*, align 8
  store i8* %2, i8** %6, align 8
  %7 = alloca i8*, align 8
  %8 = load %Ctx*, %Ctx** %4, align 8
  %9 = getelementptr inbounds %Ctx, %Ctx* %8, i32 0, i32 2
  %10 = load i8*, i8** %9, align 8
  %11 = load i8*, i8** %5, align 8
  %12 = load i8*, i8** %6, align 8
  %13 = call i8* @LLVMAddFunction(i8* %10, i8* %11, i8* %12)
  store i8* %13, i8** %7, align 8
  %14 = load i8*, i8** %7, align 8
  ret i8* %14
}

define dso_local i32 @main(i32 %0, i8** %1) {
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = alloca i8**, align 8
  store i8** %1, i8*** %4, align 8
  %5 = alloca i32, align 4
  %6 = alloca i8*, align 8
  store i8* getelementptr inbounds ([20 x i8], [20 x i8]* @34, i32 0, i32 0), i8** %6, align 8
  %7 = call %Ctx @Ctx_init(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @35, i32 0, i32 0))
  %8 = alloca %Ctx, align 8
  store %Ctx %7, %Ctx* %8, align 8
  %9 = alloca [1 x i8*], align 8
  %10 = call i8* @LLVMInt8Type()
  %11 = call i8* @LLVMPointerType(i8* %10, i32 0)
  %12 = alloca i8*, align 8
  store i8* %11, i8** %12, align 8
  %13 = alloca i8, align 1
  store i8 0, i8* %13, align 1
  %14 = call i8* @LLVMInt32Type()
  %15 = load i8*, i8** %12, align 8
  %16 = load i8, i8* %13, align 1
  %17 = call i8* @LLVMFunctionType(i8* %14, i8* %15, i32 1, i8 %16)
  %18 = alloca i8*, align 8
  store i8* %17, i8** %18, align 8
  %19 = load i8*, i8** %18, align 8
  %20 = call i8* @Ctx_add_function(%Ctx* %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @36, i32 0, i32 0), i8* %19)
  %21 = call %Lexer @Lexer_new(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @37, i32 0, i32 0), i32 11)
  %22 = alloca %Lexer, align 8
  store %Lexer %21, %Lexer* %22, align 8
  %23 = bitcast %Lexer* %22 to i8**
  %24 = load i8*, i8** %23, align 8
  %25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @38, i32 0, i32 0), i8* %24)
  %26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @39, i32 0, i32 0))
  %27 = call %VecToken @Lexer_collect_tokens(%Lexer* %22)
  %28 = alloca %VecToken, align 8
  store %VecToken %27, %VecToken* %28, align 8
  %29 = alloca i32, align 4
  store i32 0, i32* %29, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.block, %2
  %30 = getelementptr inbounds %VecToken, %VecToken* %28, i32 0, i32 2
  %31 = load i32, i32* %29, align 4
  %32 = load i32, i32* %30, align 4
  %33 = icmp slt i32 %31, %32
  br i1 %33, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %34 = bitcast %VecToken* %28 to %Token**
  %35 = load %Token*, %Token** %34, align 8
  %36 = load i32, i32* %29, align 4
  %37 = getelementptr inbounds %Token, %Token* %35, i32 %36
  %38 = load %Token, %Token* %37, align 8
  %39 = alloca %Token, align 8
  store %Token %38, %Token* %39, align 8
  %40 = getelementptr inbounds %Token, %Token* %39, i32 0, i32 1
  %41 = bitcast %String* %40 to i8**
  %42 = load i8*, i8** %41, align 8
  %43 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @40, i32 0, i32 0), i8* %42)
  %44 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @41, i32 0, i32 0))
  %45 = load i32, i32* %29, align 4
  %46 = add i32 %45, 1
  store i32 %46, i32* %29, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %5, align 4
  %47 = load i32, i32* %5, align 4
  ret i32 %47
}
