; ModuleID = 'src/main.ly'
source_filename = "src/main.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%String = type { i8*, i32, i32 }
%VecString = type { %String*, i32, i32 }
%Token = type { i32, %String }
%VecToken = type { %Token*, i32, i32 }
%Lexer = type { i8*, i32, i8, i32 }
%Ctx = type { i8*, i8*, i8*, i8*, %VecString }

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
@18 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@19 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@20 = private unnamed_addr constant [20 x i8] c"x86_64-pc-linux-gnu\00", align 1
@21 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@22 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@23 = private unnamed_addr constant [12 x i8] c"let x = 10;\00", align 1
@24 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@25 = private unnamed_addr constant [10 x i8] c"tok -> %s\00", align 1
@26 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

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

declare i32 @strlen(i8*)

declare void @exit(i32)

declare i8* @malloc(i32)

declare i8* @realloc(i8*, i32)

declare void @free(i8*)

declare i8* @memcpy(i8*, i8*, i32)

declare i8* @strcpy(i8*, i8*)

define dso_local %String @String_new(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = alloca %String, align 8
  %4 = alloca %String, align 8
  %5 = bitcast %String* %4 to i8**
  %6 = load i32, i32* %2, align 4
  %7 = call i8* @malloc(i32 %6)
  store i8* %7, i8** %5, align 8
  %8 = getelementptr inbounds %String, %String* %4, i32 0, i32 1
  store i32 0, i32* %8, align 4
  %9 = getelementptr inbounds %String, %String* %4, i32 0, i32 2
  %10 = load i32, i32* %2, align 4
  store i32 %10, i32* %9, align 4
  %11 = load %String, %String* %4, align 8
  store %String %11, %String* %3, align 8
  %12 = load %String, %String* %3, align 8
  ret %String %12
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

define dso_local void @String_push(%String* %0, i8 %1) {
  %3 = alloca %String*, align 8
  store %String* %0, %String** %3, align 8
  %4 = alloca i8, align 1
  store i8 %1, i8* %4, align 1
  %5 = load %String*, %String** %3, align 8
  %6 = bitcast %String* %5 to i8**
  %7 = load i8*, i8** %6, align 8
  %8 = load %String*, %String** %3, align 8
  %9 = getelementptr inbounds %String, %String* %8, i32 0, i32 1
  %10 = load i32, i32* %9, align 4
  %11 = getelementptr inbounds i8, i8* %7, i32 %10
  %12 = load i8, i8* %4, align 1
  store i8 %12, i8* %11, align 1
  %13 = load %String*, %String** %3, align 8
  %14 = getelementptr inbounds %String, %String* %13, i32 0, i32 1
  %15 = load %String*, %String** %3, align 8
  %16 = getelementptr inbounds %String, %String* %15, i32 0, i32 1
  %17 = load i32, i32* %16, align 4
  %18 = add i32 %17, 1
  store i32 %18, i32* %14, align 4
  %19 = load %String*, %String** %3, align 8
  %20 = getelementptr inbounds %String, %String* %19, i32 0, i32 1
  %21 = load %String*, %String** %3, align 8
  %22 = getelementptr inbounds %String, %String* %21, i32 0, i32 2
  %23 = load i32, i32* %20, align 4
  %24 = load i32, i32* %22, align 4
  %25 = icmp eq i32 %23, %24
  br i1 %25, label %if.then, label %if.end

if.then:                                          ; preds = %2
  %26 = load %String*, %String** %3, align 8
  %27 = getelementptr inbounds %String, %String* %26, i32 0, i32 2
  %28 = load %String*, %String** %3, align 8
  %29 = getelementptr inbounds %String, %String* %28, i32 0, i32 2
  %30 = load i32, i32* %29, align 4
  %31 = mul i32 %30, 2
  store i32 %31, i32* %27, align 4
  %32 = load %String*, %String** %3, align 8
  %33 = bitcast %String* %32 to i8**
  %34 = load i8*, i8** %33, align 8
  %35 = load %String*, %String** %3, align 8
  %36 = getelementptr inbounds %String, %String* %35, i32 0, i32 2
  %37 = load i32, i32* %36, align 4
  %38 = call i8* @realloc(i8* %34, i32 %37)
  br label %if.end

if.end:                                           ; preds = %if.then, %2
  %39 = load %String*, %String** %3, align 8
  %40 = bitcast %String* %39 to i8**
  %41 = load i8*, i8** %40, align 8
  %42 = load %String*, %String** %3, align 8
  %43 = getelementptr inbounds %String, %String* %42, i32 0, i32 1
  %44 = load i32, i32* %43, align 4
  %45 = getelementptr inbounds i8, i8* %41, i32 %44
  store i8 0, i8* %45, align 1
  ret void
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

define dso_local %VecString @VecString_new() {
  %1 = alloca %VecString, align 8
  %2 = alloca %VecString, align 8
  %3 = getelementptr inbounds %VecString, %VecString* %2, i32 0, i32 1
  store i32 0, i32* %3, align 4
  %4 = getelementptr inbounds %VecString, %VecString* %2, i32 0, i32 2
  store i32 0, i32* %4, align 4
  %5 = load %VecString, %VecString* %2, align 8
  store %VecString %5, %VecString* %1, align 8
  %6 = load %VecString, %VecString* %1, align 8
  ret %VecString %6
}

define dso_local void @VecString_may_grow(%VecString* %0) {
  %2 = alloca %VecString*, align 8
  store %VecString* %0, %VecString** %2, align 8
  %3 = load %VecString*, %VecString** %2, align 8
  %4 = getelementptr inbounds %VecString, %VecString* %3, i32 0, i32 1
  %5 = load %VecString*, %VecString** %2, align 8
  %6 = getelementptr inbounds %VecString, %VecString* %5, i32 0, i32 2
  %7 = load i32, i32* %4, align 4
  %8 = load i32, i32* %6, align 4
  %9 = icmp eq i32 %7, %8
  br i1 %9, label %if.then, label %if.end

if.then:                                          ; preds = %1
  %10 = load %VecString*, %VecString** %2, align 8
  %11 = getelementptr inbounds %VecString, %VecString* %10, i32 0, i32 1
  %12 = load %VecString*, %VecString** %2, align 8
  %13 = getelementptr inbounds %VecString, %VecString* %12, i32 0, i32 1
  %14 = load i32, i32* %13, align 4
  %15 = mul i32 %14, 2
  store i32 %15, i32* %11, align 4
  %16 = alloca i32, align 4
  store i32 0, i32* %16, align 4
  %17 = load %VecString*, %VecString** %2, align 8
  %18 = bitcast %VecString* %17 to %String**
  %19 = load %String*, %String** %18, align 8
  %20 = bitcast %String* %19 to i8*
  %21 = load %VecString*, %VecString** %2, align 8
  %22 = getelementptr inbounds %VecString, %VecString* %21, i32 0, i32 1
  %23 = load i32, i32* %22, align 4
  %24 = load i32, i32* %16, align 4
  %25 = mul i32 %23, %24
  %26 = call i8* @realloc(i8* %20, i32 %25)
  br label %if.end

if.end:                                           ; preds = %if.then, %1
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
  %2 = alloca %VecToken, align 8
  %3 = getelementptr inbounds %VecToken, %VecToken* %2, i32 0, i32 1
  store i32 0, i32* %3, align 4
  %4 = getelementptr inbounds %VecToken, %VecToken* %2, i32 0, i32 2
  store i32 0, i32* %4, align 4
  %5 = load %VecToken, %VecToken* %2, align 8
  store %VecToken %5, %VecToken* %1, align 8
  %6 = load %VecToken, %VecToken* %1, align 8
  ret %VecToken %6
}

define dso_local void @VecToken_may_grow(%VecToken* %0) {
  %2 = alloca %VecToken*, align 8
  store %VecToken* %0, %VecToken** %2, align 8
  %3 = load %VecToken*, %VecToken** %2, align 8
  %4 = getelementptr inbounds %VecToken, %VecToken* %3, i32 0, i32 1
  %5 = load %VecToken*, %VecToken** %2, align 8
  %6 = getelementptr inbounds %VecToken, %VecToken* %5, i32 0, i32 2
  %7 = load i32, i32* %4, align 4
  %8 = load i32, i32* %6, align 4
  %9 = icmp eq i32 %7, %8
  br i1 %9, label %if.then, label %if.end

if.then:                                          ; preds = %1
  %10 = load %VecToken*, %VecToken** %2, align 8
  %11 = getelementptr inbounds %VecToken, %VecToken* %10, i32 0, i32 1
  %12 = load %VecToken*, %VecToken** %2, align 8
  %13 = getelementptr inbounds %VecToken, %VecToken* %12, i32 0, i32 1
  %14 = load i32, i32* %13, align 4
  %15 = mul i32 %14, 2
  store i32 %15, i32* %11, align 4
  %16 = alloca i32, align 4
  store i32 0, i32* %16, align 4
  %17 = load %VecToken*, %VecToken** %2, align 8
  %18 = bitcast %VecToken* %17 to %Token**
  %19 = load %Token*, %Token** %18, align 8
  %20 = bitcast %Token* %19 to i8*
  %21 = load %VecToken*, %VecToken** %2, align 8
  %22 = getelementptr inbounds %VecToken, %VecToken* %21, i32 0, i32 1
  %23 = load i32, i32* %22, align 4
  %24 = load i32, i32* %16, align 4
  %25 = mul i32 %23, %24
  %26 = call i8* @realloc(i8* %20, i32 %25)
  br label %if.end

if.end:                                           ; preds = %if.then, %1
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
  %25 = load %String, %String* %9, align 8
  %26 = call %Token @Token_new(%String %25, i32 1)
  store %Token %26, %Token* %3, align 8
  %27 = load %Token, %Token* %3, align 8
  ret %Token %27
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
  %8 = call %String @String_new(i32 0)
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

for.cond:                                         ; preds = %if.end44, %1
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
  %13 = call %String @String_from(i8* getelementptr inbounds ([1 x i8], [1 x i8]* @19, i32 0, i32 0))
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
  %195 = icmp eq i8 %194, 61
  br i1 %195, label %if.then41, label %if.end42

if.then41:                                        ; preds = %if.end40
  %196 = load %Lexer*, %Lexer** %2, align 8
  %197 = load %Lexer*, %Lexer** %2, align 8
  %198 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @18, i32 0, i32 0))
  %199 = call %Token @Token_new(%String %198, i32 5)
  %200 = call %Token @Lexer_advance_token(%Lexer* %197, %Token %199)
  store %Token %200, %Token* %3, align 8
  br label %ret

if.end42:                                         ; preds = %if.end40
  %201 = load %Lexer*, %Lexer** %2, align 8
  %202 = getelementptr inbounds %Lexer, %Lexer* %201, i32 0, i32 2
  %203 = load i8, i8* %202, align 1
  %204 = sext i8 %203 to i32
  %205 = call i32 @isdigit(i32 %204)
  %206 = icmp ne i32 %205, 0
  br i1 %206, label %if.then43, label %if.end44

if.then43:                                        ; preds = %if.end42
  %207 = load %Lexer*, %Lexer** %2, align 8
  %208 = load %Lexer*, %Lexer** %2, align 8
  %209 = call %Token @Lexer_lex_number(%Lexer* %208)
  store %Token %209, %Token* %3, align 8
  br label %ret

if.end44:                                         ; preds = %if.end42
  %210 = load %Lexer*, %Lexer** %2, align 8
  %211 = getelementptr inbounds %Lexer, %Lexer* %210, i32 0, i32 2
  %212 = load i8, i8* %211, align 1
  %213 = sext i8 %212 to i32
  %214 = call i32 @isalpha(i32 %213)
  %215 = icmp ne i32 %214, 0
  br i1 %215, label %if.then45, label %for.cond

if.then45:                                        ; preds = %if.end44
  %216 = load %Lexer*, %Lexer** %2, align 8
  %217 = load %Lexer*, %Lexer** %2, align 8
  %218 = call %Token @Lexer_lex_id(%Lexer* %217)
  store %Token %218, %Token* %3, align 8
  br label %ret

ret:                                              ; preds = %for.end, %if.then45, %if.then43, %if.then41, %if.then39, %if.then37, %if.then35, %if.then33, %if.then31, %if.then29, %if.then27, %if.then22, %if.then20, %if.end19, %if.then17, %if.then13, %if.end12, %if.then10, %if.then6, %if.then4, %if.then
  %219 = load %Token, %Token* %3, align 8
  ret %Token %219
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
  %18 = getelementptr inbounds %Ctx, %Ctx* %4, i32 0, i32 4
  %19 = call %VecString @VecString_new()
  store %VecString %19, %VecString* %18, align 8
  %20 = load %Ctx, %Ctx* %4, align 8
  store %Ctx %20, %Ctx* %3, align 8
  %21 = load %Ctx, %Ctx* %3, align 8
  ret %Ctx %21
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
  store i8* getelementptr inbounds ([20 x i8], [20 x i8]* @20, i32 0, i32 0), i8** %6, align 8
  %7 = call %Ctx @Ctx_init(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @21, i32 0, i32 0))
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
  %20 = call i8* @Ctx_add_function(%Ctx* %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @22, i32 0, i32 0), i8* %19)
  %21 = call %Lexer @Lexer_new(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @23, i32 0, i32 0), i32 11)
  %22 = alloca %Lexer, align 8
  store %Lexer %21, %Lexer* %22, align 8
  %23 = bitcast %Lexer* %22 to i8**
  %24 = load i8*, i8** %23, align 8
  %25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @24, i32 0, i32 0), i8* %24)
  %26 = call %Token @Lexer_next_token(%Lexer* %22)
  %27 = alloca %Token, align 8
  store %Token %26, %Token* %27, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.block, %2
  %28 = bitcast %Token* %27 to i32*
  %29 = load i32, i32* %28, align 4
  %30 = icmp ne i32 %29, 56
  br i1 %30, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %31 = getelementptr inbounds %Token, %Token* %27, i32 0, i32 1
  %32 = bitcast %String* %31 to i8**
  %33 = load i8*, i8** %32, align 8
  %34 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @25, i32 0, i32 0), i8* %33)
  %35 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @26, i32 0, i32 0))
  %36 = call %Token @Lexer_next_token(%Lexer* %22)
  store %Token %36, %Token* %27, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %5, align 4
  %37 = load i32, i32* %5, align 4
  ret i32 %37
}
