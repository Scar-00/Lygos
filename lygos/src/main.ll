; ModuleID = 'src/main.ly'
source_filename = "src/main.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%Token = type { i32, i8* }
%Lexer = type { i8*, i32, i8, i32 }
%Ctx = type { i8*, i8*, i8*, i8* }

@0 = private unnamed_addr constant [11 x i8] c"len -> %d\0A\00", align 1
@1 = private unnamed_addr constant [12 x i8] c"bool -> %d\0A\00", align 1
@2 = private unnamed_addr constant [20 x i8] c"x86_64-pc-linux-gnu\00", align 1
@3 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@4 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@5 = private unnamed_addr constant [4 x i8] c"123\00", align 1
@6 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@7 = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@8 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

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

declare i32 @isdigit(i8)

define dso_local %Token @Token_new(i8* %0, i32 %1) {
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  %4 = alloca i32, align 4
  store i32 %1, i32* %4, align 4
  %5 = alloca %Token, align 8
  %6 = alloca %Token, align 8
  %7 = getelementptr inbounds %Token, %Token* %6, i32 0, i32 1
  %8 = load i8*, i8** %3, align 8
  store i8* %8, i8** %7, align 8
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
  %8 = alloca i32, align 4
  store i32 0, i32* %8, align 4
  %9 = load %Lexer*, %Lexer** %2, align 8
  %10 = getelementptr inbounds %Lexer, %Lexer* %9, i32 0, i32 2
  %11 = load i8, i8* %10, align 1
  %12 = alloca i8, align 1
  store i8 %11, i8* %12, align 1
  %13 = load %Lexer*, %Lexer** %2, align 8
  %14 = getelementptr inbounds %Lexer, %Lexer* %13, i32 0, i32 2
  %15 = load i8, i8* %14, align 1
  %16 = call i32 @isdigit(i8 %15)
  %17 = icmp eq i32 %16, 1
  br i1 %17, label %.preheader, label %28

.preheader:                                       ; preds = %1
  br label %18

18:                                               ; preds = %.preheader, %18
  %19 = load %Lexer*, %Lexer** %2, align 8
  %20 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %20)
  %21 = load i32, i32* %8, align 4
  %22 = add i32 %21, 1
  store i32 %22, i32* %8, align 4
  %23 = load %Lexer*, %Lexer** %2, align 8
  %24 = getelementptr inbounds %Lexer, %Lexer* %23, i32 0, i32 2
  %25 = load i8, i8* %24, align 1
  %26 = call i32 @isdigit(i8 %25)
  %27 = icmp eq i32 %26, 1
  br i1 %27, label %18, label %28

28:                                               ; preds = %18, %1
  %29 = load i32, i32* %8, align 4
  %30 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @0, i32 0, i32 0), i32 %29)
  %31 = load %Lexer*, %Lexer** %2, align 8
  %32 = getelementptr inbounds %Lexer, %Lexer* %31, i32 0, i32 2
  %33 = load i8, i8* %32, align 1
  %34 = call i32 @isdigit(i8 %33)
  %35 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @1, i32 0, i32 0), i32 %34)
  %36 = load %Token, %Token* %3, align 8
  ret %Token %36
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
  store i8* getelementptr inbounds ([20 x i8], [20 x i8]* @2, i32 0, i32 0), i8** %6, align 8
  %7 = call %Ctx @Ctx_init(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @3, i32 0, i32 0))
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
  %20 = call i8* @Ctx_add_function(%Ctx* %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @4, i32 0, i32 0), i8* %19)
  %21 = getelementptr inbounds %Ctx, %Ctx* %8, i32 0, i32 2
  %22 = load i8*, i8** %21, align 8
  call void @LLVMDumpModule(i8* %22)
  %23 = call %Lexer @Lexer_new(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @5, i32 0, i32 0), i32 3)
  %24 = alloca %Lexer, align 8
  store %Lexer %23, %Lexer* %24, align 8
  %25 = call %Token @Lexer_lex_number(%Lexer* %24)
  %26 = bitcast %Lexer* %24 to i8**
  %27 = load i8*, i8** %26, align 8
  %28 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @6, i32 0, i32 0), i8* %27)
  %29 = alloca i32, align 4
  store i32 0, i32* %29, align 4
  %30 = getelementptr inbounds %Lexer, %Lexer* %24, i32 0, i32 1
  %31 = load i32, i32* %29, align 4
  %32 = load i32, i32* %30, align 4
  %33 = icmp slt i32 %31, %32
  br i1 %33, label %.preheader, label %48

.preheader:                                       ; preds = %2
  br label %34

34:                                               ; preds = %.preheader, %34
  %35 = bitcast %Lexer* %24 to i8**
  %36 = load i8*, i8** %35, align 8
  %37 = load i32, i32* %29, align 4
  %38 = getelementptr inbounds i8, i8* %36, i32 %37
  %39 = load i8, i8* %38, align 1
  %40 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @7, i32 0, i32 0), i8 %39)
  %41 = load i32, i32* %29, align 4
  %42 = add i32 %41, 1
  store i32 %42, i32* %29, align 4
  %43 = load i32, i32* %29, align 4
  %44 = bitcast %Lexer* %24 to i8*
  %sunkaddr = getelementptr inbounds i8, i8* %44, i64 8
  %45 = bitcast i8* %sunkaddr to i32*
  %46 = load i32, i32* %45, align 4
  %47 = icmp slt i32 %43, %46
  br i1 %47, label %34, label %48

48:                                               ; preds = %34, %2
  %49 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @8, i32 0, i32 0))
  store i32 0, i32* %5, align 4
  %50 = load i32, i32* %5, align 4
  ret i32 %50
}
