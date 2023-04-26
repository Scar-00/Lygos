; ModuleID = 'src/main.ly'
source_filename = "src/main.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%String = type { i8*, i32, i32 }
%Token = type { i32, %String }
%Lexer = type { i8*, i32, i8, i32 }
%Ctx = type { i8*, i8*, i8*, i8* }

@0 = private unnamed_addr constant [29 x i8] c"unimplemented [`lex_char()`]\00", align 1
@1 = private unnamed_addr constant [20 x i8] c"x86_64-pc-linux-gnu\00", align 1
@2 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@3 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@4 = private unnamed_addr constant [4 x i8] c"123\00", align 1
@5 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@6 = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@7 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

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
  br i1 %25, label %26, label %40

26:                                               ; preds = %2
  %27 = load %String*, %String** %3, align 8
  %28 = getelementptr inbounds %String, %String* %27, i32 0, i32 2
  %29 = load %String*, %String** %3, align 8
  %30 = getelementptr inbounds %String, %String* %29, i32 0, i32 2
  %31 = load i32, i32* %30, align 4
  %32 = mul i32 %31, 2
  store i32 %32, i32* %28, align 4
  %33 = load %String*, %String** %3, align 8
  %34 = bitcast %String* %33 to i8**
  %35 = load i8*, i8** %34, align 8
  %36 = load %String*, %String** %3, align 8
  %37 = getelementptr inbounds %String, %String* %36, i32 0, i32 2
  %38 = load i32, i32* %37, align 4
  %39 = call i8* @realloc(i8* %35, i32 %38)
  br label %40

40:                                               ; preds = %2, %26
  %41 = load %String*, %String** %3, align 8
  %42 = bitcast %String* %41 to i8**
  %43 = load i8*, i8** %42, align 8
  %44 = load %String*, %String** %3, align 8
  %45 = getelementptr inbounds %String, %String* %44, i32 0, i32 1
  %46 = load i32, i32* %45, align 4
  %47 = getelementptr inbounds i8, i8* %43, i32 %46
  store i8 0, i8* %47, align 1
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
  %14 = load %Lexer*, %Lexer** %2, align 8
  %15 = getelementptr inbounds %Lexer, %Lexer* %14, i32 0, i32 2
  %16 = load i8, i8* %15, align 1
  %17 = sext i8 %16 to i32
  %18 = call i32 @isdigit(i32 %17)
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %.preheader, label %32

.preheader:                                       ; preds = %1
  br label %20

20:                                               ; preds = %.preheader, %20
  %21 = load %Lexer*, %Lexer** %2, align 8
  %22 = getelementptr inbounds %Lexer, %Lexer* %21, i32 0, i32 2
  %23 = load i8, i8* %22, align 1
  call void @String_push(%String* %9, i8 %23)
  %24 = load %Lexer*, %Lexer** %2, align 8
  %25 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %25)
  %26 = load %Lexer*, %Lexer** %2, align 8
  %27 = getelementptr inbounds %Lexer, %Lexer* %26, i32 0, i32 2
  %28 = load i8, i8* %27, align 1
  %29 = sext i8 %28 to i32
  %30 = call i32 @isdigit(i32 %29)
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %20, label %32

32:                                               ; preds = %20, %1
  %33 = load %String, %String* %9, align 8
  %34 = call %Token @Token_new(%String %33, i32 1)
  store %Token %34, %Token* %3, align 8
  %35 = load %Token, %Token* %3, align 8
  ret %Token %35
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
  %14 = load %Lexer*, %Lexer** %2, align 8
  %15 = getelementptr inbounds %Lexer, %Lexer* %14, i32 0, i32 2
  %16 = load i8, i8* %15, align 1
  %17 = icmp ne i8 %16, 34
  br i1 %17, label %.preheader, label %28

.preheader:                                       ; preds = %1
  br label %18

18:                                               ; preds = %.preheader, %18
  %19 = load %Lexer*, %Lexer** %2, align 8
  %20 = getelementptr inbounds %Lexer, %Lexer* %19, i32 0, i32 2
  %21 = load i8, i8* %20, align 1
  call void @String_push(%String* %9, i8 %21)
  %22 = load %Lexer*, %Lexer** %2, align 8
  %23 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %23)
  %24 = load %Lexer*, %Lexer** %2, align 8
  %25 = getelementptr inbounds %Lexer, %Lexer* %24, i32 0, i32 2
  %26 = load i8, i8* %25, align 1
  %27 = icmp ne i8 %26, 34
  br i1 %27, label %18, label %28

28:                                               ; preds = %18, %1
  %29 = load %String, %String* %9, align 8
  %30 = call %Token @Token_new(%String %29, i32 0)
  store %Token %30, %Token* %3, align 8
  %31 = load %Token, %Token* %3, align 8
  ret %Token %31
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
  %14 = load %Lexer*, %Lexer** %2, align 8
  %15 = getelementptr inbounds %Lexer, %Lexer* %14, i32 0, i32 2
  %16 = load i8, i8* %15, align 1
  %17 = sext i8 %16 to i32
  %18 = call i32 @isalpha(i32 %17)
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %.preheader, label %32

.preheader:                                       ; preds = %1
  br label %20

20:                                               ; preds = %.preheader, %20
  %21 = load %Lexer*, %Lexer** %2, align 8
  %22 = getelementptr inbounds %Lexer, %Lexer* %21, i32 0, i32 2
  %23 = load i8, i8* %22, align 1
  call void @String_push(%String* %9, i8 %23)
  %24 = load %Lexer*, %Lexer** %2, align 8
  %25 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %25)
  %26 = load %Lexer*, %Lexer** %2, align 8
  %27 = getelementptr inbounds %Lexer, %Lexer* %26, i32 0, i32 2
  %28 = load i8, i8* %27, align 1
  %29 = sext i8 %28 to i32
  %30 = call i32 @isalpha(i32 %29)
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %20, label %32

32:                                               ; preds = %20, %1
  %33 = load %String, %String* %9, align 8
  %34 = call %Token @Token_new(%String %33, i32 4)
  store %Token %34, %Token* %3, align 8
  %35 = load %Token, %Token* %3, align 8
  ret %Token %35
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
  store i8* getelementptr inbounds ([20 x i8], [20 x i8]* @1, i32 0, i32 0), i8** %6, align 8
  %7 = call %Ctx @Ctx_init(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @2, i32 0, i32 0))
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
  %20 = call i8* @Ctx_add_function(%Ctx* %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @3, i32 0, i32 0), i8* %19)
  %21 = call %Lexer @Lexer_new(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @4, i32 0, i32 0), i32 3)
  %22 = alloca %Lexer, align 8
  store %Lexer %21, %Lexer* %22, align 8
  %23 = bitcast %Lexer* %22 to i8**
  %24 = load i8*, i8** %23, align 8
  %25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @5, i32 0, i32 0), i8* %24)
  %26 = alloca i32, align 4
  store i32 0, i32* %26, align 4
  %27 = getelementptr inbounds %Lexer, %Lexer* %22, i32 0, i32 1
  %28 = load i32, i32* %26, align 4
  %29 = load i32, i32* %27, align 4
  %30 = icmp slt i32 %28, %29
  br i1 %30, label %.preheader, label %45

.preheader:                                       ; preds = %2
  br label %31

31:                                               ; preds = %.preheader, %31
  %32 = bitcast %Lexer* %22 to i8**
  %33 = load i8*, i8** %32, align 8
  %34 = load i32, i32* %26, align 4
  %35 = getelementptr inbounds i8, i8* %33, i32 %34
  %36 = load i8, i8* %35, align 1
  %37 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @6, i32 0, i32 0), i8 %36)
  %38 = load i32, i32* %26, align 4
  %39 = add i32 %38, 1
  store i32 %39, i32* %26, align 4
  %40 = load i32, i32* %26, align 4
  %41 = bitcast %Lexer* %22 to i8*
  %sunkaddr = getelementptr inbounds i8, i8* %41, i64 8
  %42 = bitcast i8* %sunkaddr to i32*
  %43 = load i32, i32* %42, align 4
  %44 = icmp slt i32 %40, %43
  br i1 %44, label %31, label %45

45:                                               ; preds = %31, %2
  %46 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @7, i32 0, i32 0))
  store i32 0, i32* %5, align 4
  %47 = load i32, i32* %5, align 4
  ret i32 %47
}
