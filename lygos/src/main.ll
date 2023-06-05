; ModuleID = 'src/main.ly'
source_filename = "src/main.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%String = type { i8*, i32, i32 }
%Token = type { i32, %String }
%Lexer = type { i8*, i32, i8, i32 }
%Ctx = type { i8*, i8*, i8*, i8* }

@0 = private unnamed_addr constant [29 x i8] c"unimplemented [`lex_char()`]\00", align 1
@1 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@2 = private unnamed_addr constant [19 x i8] c"[info]: lexing id\0A\00", align 1
@3 = private unnamed_addr constant [21 x i8] c"[info]: token -> %s\0A\00", align 1
@4 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@5 = private unnamed_addr constant [20 x i8] c"x86_64-pc-linux-gnu\00", align 1
@6 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@7 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@8 = private unnamed_addr constant [12 x i8] c"let x = 10;\00", align 1
@9 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@10 = private unnamed_addr constant [11 x i8] c"tok -> %s\0A\00", align 1

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

declare i8* @memcpy(i8*, i8*, i32)

declare i8* @strcpy(i8*, i8*)

declare i8* @realloc(i8*, i32)

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
  %26 = call %Token @Token_new(%String %25, i32 4)
  store %Token %26, %Token* %3, align 8
  %27 = load %Token, %Token* %3, align 8
  ret %Token %27
}

define dso_local %Token @Lexer_next_token(%Lexer* %0) {
for.cond:
  %1 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %1, align 8
  %2 = alloca %Token, align 8
  %3 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  %4 = load %Lexer*, %Lexer** %1, align 8
  %5 = getelementptr inbounds %Lexer, %Lexer* %4, i32 0, i32 3
  %6 = load %Lexer*, %Lexer** %1, align 8
  %7 = getelementptr inbounds %Lexer, %Lexer* %6, i32 0, i32 1
  %8 = load i32, i32* %5, align 4
  %9 = load i32, i32* %7, align 4
  %10 = icmp slt i32 %8, %9
  br i1 %10, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %11 = alloca i32, align 4
  store i32 0, i32* %11, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond
  %12 = call %String @String_from(i8* getelementptr inbounds ([1 x i8], [1 x i8]* @4, i32 0, i32 0))
  %13 = call %Token @Token_new(%String %12, i32 0)
  store %Token %13, %Token* %2, align 8
  br label %ret

for.cond1:                                        ; preds = %for.block2, %for.block
  %14 = load %Lexer*, %Lexer** %1, align 8
  %15 = getelementptr inbounds %Lexer, %Lexer* %14, i32 0, i32 2
  %16 = load i8, i8* %15, align 1
  %17 = sext i8 %16 to i32
  %18 = call i32 @isspace(i32 %17)
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %for.block2, label %for.end3

for.block2:                                       ; preds = %for.cond1
  %20 = load %Lexer*, %Lexer** %1, align 8
  %21 = load %Lexer*, %Lexer** %1, align 8
  call void @Lexer_advance(%Lexer* %21)
  br label %for.cond1

for.end3:                                         ; preds = %for.cond1
  %22 = alloca %Token, align 8
  %23 = load %Lexer*, %Lexer** %1, align 8
  %24 = getelementptr inbounds %Lexer, %Lexer* %23, i32 0, i32 2
  %25 = load i8, i8* %24, align 1
  %26 = icmp eq i8 %25, 61
  br i1 %26, label %if.then, label %if.end

if.then:                                          ; preds = %for.end3
  %27 = load %Lexer*, %Lexer** %1, align 8
  %28 = load %Lexer*, %Lexer** %1, align 8
  %29 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @1, i32 0, i32 0))
  %30 = call %Token @Token_new(%String %29, i32 5)
  %31 = call %Token @Lexer_advance_token(%Lexer* %28, %Token %30)
  store %Token %31, %Token* %22, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %for.end3
  %32 = load %Lexer*, %Lexer** %1, align 8
  %33 = getelementptr inbounds %Lexer, %Lexer* %32, i32 0, i32 2
  %34 = load i8, i8* %33, align 1
  %35 = sext i8 %34 to i32
  %36 = call i32 @isdigit(i32 %35)
  %37 = icmp ne i32 %36, 0
  br i1 %37, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  %38 = load %Lexer*, %Lexer** %1, align 8
  %39 = load %Lexer*, %Lexer** %1, align 8
  %40 = call %Token @Lexer_lex_number(%Lexer* %39)
  store %Token %40, %Token* %22, align 8
  br label %if.end5

if.end5:                                          ; preds = %if.then4, %if.end
  %41 = load %Lexer*, %Lexer** %1, align 8
  %42 = getelementptr inbounds %Lexer, %Lexer* %41, i32 0, i32 2
  %43 = load i8, i8* %42, align 1
  %44 = sext i8 %43 to i32
  %45 = call i32 @isalpha(i32 %44)
  %46 = icmp ne i32 %45, 0
  br i1 %46, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end5
  %47 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @2, i32 0, i32 0))
  %48 = load %Lexer*, %Lexer** %1, align 8
  %49 = load %Lexer*, %Lexer** %1, align 8
  %50 = call %Token @Lexer_lex_id(%Lexer* %49)
  store %Token %50, %Token* %22, align 8
  %51 = getelementptr inbounds %Token, %Token* %22, i32 0, i32 1
  %52 = bitcast %String* %51 to i8**
  %53 = load i8*, i8** %52, align 8
  %54 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @3, i32 0, i32 0), i8* %53)
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %if.end5
  %55 = load %Token, %Token* %22, align 8
  store %Token %55, %Token* %2, align 8
  br label %ret

ret:                                              ; preds = %for.end, %if.end7
  %56 = load %Token, %Token* %2, align 8
  ret %Token %56
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
  store i8* getelementptr inbounds ([20 x i8], [20 x i8]* @5, i32 0, i32 0), i8** %6, align 8
  %7 = call %Ctx @Ctx_init(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @6, i32 0, i32 0))
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
  %20 = call i8* @Ctx_add_function(%Ctx* %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @7, i32 0, i32 0), i8* %19)
  %21 = call %Lexer @Lexer_new(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @8, i32 0, i32 0), i32 11)
  %22 = alloca %Lexer, align 8
  store %Lexer %21, %Lexer* %22, align 8
  %23 = bitcast %Lexer* %22 to i8**
  %24 = load i8*, i8** %23, align 8
  %25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @9, i32 0, i32 0), i8* %24)
  %26 = call %Token @Lexer_next_token(%Lexer* %22)
  %27 = alloca %Token, align 8
  store %Token %26, %Token* %27, align 8
  %28 = getelementptr inbounds %Token, %Token* %27, i32 0, i32 1
  %29 = bitcast %String* %28 to i8**
  %30 = load i8*, i8** %29, align 8
  %31 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @10, i32 0, i32 0), i8* %30)
  store i32 0, i32* %5, align 4
  %32 = load i32, i32* %5, align 4
  ret i32 %32
}
