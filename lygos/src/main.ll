; ModuleID = 'src/main.ly'
source_filename = "src/main.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%String = type { i8*, i32, i32 }
%StringView = type { i8*, i32 }
%Loc = type { %String*, i64, i64, i64 }
%Token = type { i32, %String, %Loc }
%VecToken = type { %Token*, i32, i32 }
%Lexer = type { %String, i8*, i32, i8, i32, i64, i64 }
%VecAST = type { %AST**, i32, i32 }
%AST = type { i32, %Loc }
%Block = type { %VecAST, i64, i1 }
%Mod = type { i32, %Loc, %Block, %Block* }
%Parser = type { %VecToken, i64 }
%Ctx = type { i8*, i8*, i8*, i8* }

@0 = private unnamed_addr constant [29 x i8] c"unimplemented [`lex_char()`]\00", align 1
@1 = private unnamed_addr constant [4 x i8] c"let\00", align 1
@2 = private unnamed_addr constant [4 x i8] c"mut\00", align 1
@3 = private unnamed_addr constant [6 x i8] c"const\00", align 1
@4 = private unnamed_addr constant [7 x i8] c"struct\00", align 1
@5 = private unnamed_addr constant [3 x i8] c"if\00", align 1
@6 = private unnamed_addr constant [5 x i8] c"else\00", align 1
@7 = private unnamed_addr constant [4 x i8] c"for\00", align 1
@8 = private unnamed_addr constant [6 x i8] c"while\00", align 1
@9 = private unnamed_addr constant [3 x i8] c"fn\00", align 1
@10 = private unnamed_addr constant [7 x i8] c"return\00", align 1
@11 = private unnamed_addr constant [3 x i8] c"in\00", align 1
@12 = private unnamed_addr constant [8 x i8] c"include\00", align 1
@13 = private unnamed_addr constant [5 x i8] c"impl\00", align 1
@14 = private unnamed_addr constant [5 x i8] c"type\00", align 1
@15 = private unnamed_addr constant [7 x i8] c"static\00", align 1
@16 = private unnamed_addr constant [6 x i8] c"match\00", align 1
@17 = private unnamed_addr constant [6 x i8] c"trait\00", align 1
@18 = private unnamed_addr constant [6 x i8] c"macro\00", align 1
@19 = private unnamed_addr constant [5 x i8] c"enum\00", align 1
@20 = private unnamed_addr constant [7 x i8] c"sizeof\00", align 1
@21 = private unnamed_addr constant [2 x i8] c".\00", align 1
@22 = private unnamed_addr constant [2 x i8] c",\00", align 1
@23 = private unnamed_addr constant [2 x i8] c";\00", align 1
@24 = private unnamed_addr constant [3 x i8] c"::\00", align 1
@25 = private unnamed_addr constant [2 x i8] c":\00", align 1
@26 = private unnamed_addr constant [2 x i8] c"+\00", align 1
@27 = private unnamed_addr constant [3 x i8] c"->\00", align 1
@28 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@29 = private unnamed_addr constant [2 x i8] c"*\00", align 1
@30 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@31 = private unnamed_addr constant [2 x i8] c"%\00", align 1
@32 = private unnamed_addr constant [2 x i8] c"[\00", align 1
@33 = private unnamed_addr constant [2 x i8] c"]\00", align 1
@34 = private unnamed_addr constant [2 x i8] c"{\00", align 1
@35 = private unnamed_addr constant [2 x i8] c"}\00", align 1
@36 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@37 = private unnamed_addr constant [2 x i8] c")\00", align 1
@38 = private unnamed_addr constant [2 x i8] c"#\00", align 1
@39 = private unnamed_addr constant [2 x i8] c"$\00", align 1
@40 = private unnamed_addr constant [3 x i8] c"<=\00", align 1
@41 = private unnamed_addr constant [2 x i8] c"<\00", align 1
@42 = private unnamed_addr constant [3 x i8] c">=\00", align 1
@43 = private unnamed_addr constant [2 x i8] c">\00", align 1
@44 = private unnamed_addr constant [3 x i8] c"&&\00", align 1
@45 = private unnamed_addr constant [2 x i8] c"&\00", align 1
@46 = private unnamed_addr constant [3 x i8] c"||\00", align 1
@47 = private unnamed_addr constant [2 x i8] c"|\00", align 1
@48 = private unnamed_addr constant [3 x i8] c"!=\00", align 1
@49 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@50 = private unnamed_addr constant [3 x i8] c"==\00", align 1
@51 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@52 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@53 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@54 = private unnamed_addr constant [20 x i8] c"x86_64-pc-linux-gnu\00", align 1
@55 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@56 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@57 = private unnamed_addr constant [20 x i8] c"let x = 10;\0Ax = 10;\00", align 1
@58 = private unnamed_addr constant [8 x i8] c"test.ly\00", align 1
@59 = private unnamed_addr constant [10 x i8] c"src -> %s\00", align 1
@60 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@61 = private unnamed_addr constant [27 x i8] c"%s:%.3d:%.2d -> %.2d | %s\0A\00", align 1

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

declare i8* @memmove(i8*, i8*, i32)

declare i32 @strlen(i8*)

declare i8* @strcpy(i8*, i8*)

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
  %4 = alloca i32, align 4
  store i32 1, i32* %4, align 4
  %5 = load i8*, i8** %2, align 8
  %6 = call i32 @strlen(i8* %5)
  %7 = alloca i32, align 4
  store i32 %6, i32* %7, align 4
  %8 = load i32, i32* %7, align 4
  %9 = add i32 %8, 1
  %10 = call %String @String_new(i32 %9)
  %11 = alloca %String, align 8
  store %String %10, %String* %11, align 8
  %12 = bitcast %String* %11 to i8**
  %13 = load i8*, i8** %12, align 8
  %14 = load i8*, i8** %2, align 8
  %15 = load i32, i32* %7, align 4
  %16 = add i32 %15, 1
  %17 = load i32, i32* %4, align 4
  %18 = mul i32 %16, %17
  %19 = call i8* @memcpy(i8* %13, i8* %14, i32 %18)
  %20 = getelementptr inbounds %String, %String* %11, i32 0, i32 1
  %21 = load i32, i32* %7, align 4
  store i32 %21, i32* %20, align 4
  %22 = load %String, %String* %11, align 8
  store %String %22, %String* %3, align 8
  %23 = load %String, %String* %3, align 8
  ret %String %23
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

if.end2:                                          ; preds = %for.block
  %13 = load i32, i32* %12, align 4
  %14 = add i32 %13, 1
  store i32 %14, i32* %12, align 4
  br label %for.cond

ret:                                              ; preds = %for.end, %if.then1, %if.then
  %15 = load i1, i1* %5, align 1
  ret i1 %15

for.cond:                                         ; preds = %if.end2, %if.end
  %16 = load %String*, %String** %3, align 8
  %17 = getelementptr inbounds %String, %String* %16, i32 0, i32 1
  %18 = load i32, i32* %12, align 4
  %19 = load i32, i32* %17, align 4
  %20 = icmp slt i32 %18, %19
  br i1 %20, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %21 = load %String*, %String** %3, align 8
  %22 = bitcast %String* %21 to i8**
  %23 = load i8*, i8** %22, align 8
  %24 = load i32, i32* %12, align 4
  %25 = getelementptr inbounds i8, i8* %23, i32 %24
  %26 = bitcast %String* %4 to i8**
  %27 = load i8*, i8** %26, align 8
  %28 = load i32, i32* %12, align 4
  %29 = getelementptr inbounds i8, i8* %27, i32 %28
  %30 = load i8, i8* %25, align 1
  %31 = load i8, i8* %29, align 1
  %32 = icmp ne i8 %30, %31
  br i1 %32, label %if.then1, label %if.end2

for.end:                                          ; preds = %for.cond
  store i1 true, i1* %5, align 1
  br label %ret
}

define dso_local i1 @String_eq_ptr(%String* %0, i8* %1) {
  %3 = alloca %String*, align 8
  store %String* %0, %String** %3, align 8
  %4 = alloca i8*, align 8
  store i8* %1, i8** %4, align 8
  %5 = alloca i1, align 1
  %6 = load i8*, i8** %4, align 8
  %7 = call %String @String_from(i8* %6)
  %8 = alloca %String, align 8
  store %String %7, %String* %8, align 8
  %9 = load %String*, %String** %3, align 8
  %10 = load %String*, %String** %3, align 8
  %11 = load %String, %String* %8, align 8
  %12 = call i1 @String_eq(%String* %10, %String %11)
  %13 = alloca i1, align 1
  store i1 %12, i1* %13, align 1
  call void @String_drop(%String* %8)
  %14 = load i1, i1* %13, align 1
  store i1 %14, i1* %5, align 1
  %15 = load i1, i1* %5, align 1
  ret i1 %15
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

define dso_local %String @String_clone(%String* %0) {
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
  %19 = call i8* @strcpy(i8* %15, i8* %18)
  %20 = load %String, %String* %8, align 8
  store %String %20, %String* %3, align 8
  %21 = load %String, %String* %3, align 8
  ret %String %21
}

define dso_local %StringView @StringView_new(%String* %0) {
  %2 = alloca %String*, align 8
  store %String* %0, %String** %2, align 8
  %3 = alloca %StringView, align 8
  %4 = alloca %StringView, align 8
  %5 = bitcast %StringView* %4 to i8**
  %6 = load %String*, %String** %2, align 8
  %7 = bitcast %String* %6 to i8**
  %8 = load i8*, i8** %7, align 8
  store i8* %8, i8** %5, align 8
  %9 = getelementptr inbounds %StringView, %StringView* %4, i32 0, i32 1
  %10 = load %String*, %String** %2, align 8
  %11 = getelementptr inbounds %String, %String* %10, i32 0, i32 1
  %12 = load i32, i32* %11, align 4
  store i32 %12, i32* %9, align 4
  %13 = load %StringView, %StringView* %4, align 8
  store %StringView %13, %StringView* %3, align 8
  %14 = load %StringView, %StringView* %3, align 8
  ret %StringView %14
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

define dso_local %Token @Token_new(%String %0, i32 %1, %Loc %2) {
  %4 = alloca %String, align 8
  store %String %0, %String* %4, align 8
  %5 = alloca i32, align 4
  store i32 %1, i32* %5, align 4
  %6 = alloca %Loc, align 8
  store %Loc %2, %Loc* %6, align 8
  %7 = alloca %Token, align 8
  %8 = alloca %Token, align 8
  %9 = getelementptr inbounds %Token, %Token* %8, i32 0, i32 1
  %10 = load %String, %String* %4, align 8
  store %String %10, %String* %9, align 8
  %11 = bitcast %Token* %8 to i32*
  %12 = load i32, i32* %5, align 4
  store i32 %12, i32* %11, align 4
  %13 = getelementptr inbounds %Token, %Token* %8, i32 0, i32 2
  %14 = load %Loc, %Loc* %6, align 8
  store %Loc %14, %Loc* %13, align 8
  %15 = load %Token, %Token* %8, align 8
  store %Token %15, %Token* %7, align 8
  %16 = load %Token, %Token* %7, align 8
  ret %Token %16
}

define dso_local %VecToken @VecToken_new() {
  %1 = alloca %VecToken, align 8
  %2 = alloca i32, align 4
  store i32 56, i32* %2, align 4
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
  store i32 56, i32* %4, align 4
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
  store i32 56, i32* %3, align 4
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

define dso_local i1 @VecToken_insert(%VecToken* %0, i32 %1, %VecToken* %2) {
  %4 = alloca %VecToken*, align 8
  store %VecToken* %0, %VecToken** %4, align 8
  %5 = alloca i32, align 4
  store i32 %1, i32* %5, align 4
  %6 = alloca %VecToken*, align 8
  store %VecToken* %2, %VecToken** %6, align 8
  %7 = alloca i1, align 1
  %8 = alloca i32, align 4
  store i32 56, i32* %8, align 4
  %9 = load %VecToken*, %VecToken** %4, align 8
  %10 = load %VecToken*, %VecToken** %4, align 8
  call void @VecToken_may_grow(%VecToken* %10)
  %11 = load %VecToken*, %VecToken** %4, align 8
  %12 = getelementptr inbounds %VecToken, %VecToken* %11, i32 0, i32 1
  %13 = load %VecToken*, %VecToken** %4, align 8
  %14 = getelementptr inbounds %VecToken, %VecToken* %13, i32 0, i32 2
  %15 = load %VecToken*, %VecToken** %6, align 8
  %16 = getelementptr inbounds %VecToken, %VecToken* %15, i32 0, i32 2
  %17 = load i32, i32* %14, align 4
  %18 = load i32, i32* %16, align 4
  %19 = add i32 %17, %18
  %20 = load i32, i32* %12, align 4
  %21 = icmp slt i32 %20, %19
  br i1 %21, label %if.then, label %if.end

if.then:                                          ; preds = %3
  %22 = load %VecToken*, %VecToken** %4, align 8
  %23 = getelementptr inbounds %VecToken, %VecToken* %22, i32 0, i32 1
  %24 = load %VecToken*, %VecToken** %4, align 8
  %25 = getelementptr inbounds %VecToken, %VecToken* %24, i32 0, i32 2
  %26 = load %VecToken*, %VecToken** %6, align 8
  %27 = getelementptr inbounds %VecToken, %VecToken* %26, i32 0, i32 2
  %28 = load i32, i32* %25, align 4
  %29 = load i32, i32* %27, align 4
  %30 = add i32 %28, %29
  store i32 %30, i32* %23, align 4
  %31 = load %VecToken*, %VecToken** %4, align 8
  %32 = bitcast %VecToken* %31 to %Token**
  %33 = load %VecToken*, %VecToken** %4, align 8
  %34 = bitcast %VecToken* %33 to %Token**
  %35 = load %Token*, %Token** %34, align 8
  %36 = bitcast %Token* %35 to i8*
  %37 = load %VecToken*, %VecToken** %4, align 8
  %38 = getelementptr inbounds %VecToken, %VecToken* %37, i32 0, i32 1
  %39 = load i32, i32* %38, align 4
  %40 = load i32, i32* %8, align 4
  %41 = mul i32 %39, %40
  %42 = call i8* @realloc(i8* %36, i32 %41)
  %43 = bitcast i8* %42 to %Token*
  store %Token* %43, %Token** %32, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %3
  %44 = load %VecToken*, %VecToken** %4, align 8
  %45 = bitcast %VecToken* %44 to %Token**
  %46 = load %VecToken*, %VecToken** %4, align 8
  %47 = bitcast %VecToken* %46 to %Token**
  %48 = load %Token*, %Token** %47, align 8
  %49 = load %VecToken*, %VecToken** %6, align 8
  %50 = getelementptr inbounds %VecToken, %VecToken* %49, i32 0, i32 2
  %51 = load i32, i32* %5, align 4
  %52 = load i32, i32* %50, align 4
  %53 = add i32 %51, %52
  %54 = getelementptr inbounds %Token, %Token* %48, i32 %53
  %55 = bitcast %Token* %54 to i8*
  %56 = load %VecToken*, %VecToken** %4, align 8
  %57 = bitcast %VecToken* %56 to %Token**
  %58 = load %Token*, %Token** %57, align 8
  %59 = load i32, i32* %5, align 4
  %60 = getelementptr inbounds %Token, %Token* %58, i32 %59
  %61 = bitcast %Token* %60 to i8*
  %62 = load %VecToken*, %VecToken** %6, align 8
  %63 = getelementptr inbounds %VecToken, %VecToken* %62, i32 0, i32 2
  %64 = load i32, i32* %63, align 4
  %65 = load i32, i32* %8, align 4
  %66 = mul i32 %64, %65
  %67 = call i8* @memmove(i8* %55, i8* %61, i32 %66)
  %68 = bitcast i8* %67 to %Token*
  store %Token* %68, %Token** %45, align 8
  %69 = load %VecToken*, %VecToken** %4, align 8
  %70 = bitcast %VecToken* %69 to %Token**
  %71 = load %VecToken*, %VecToken** %4, align 8
  %72 = bitcast %VecToken* %71 to %Token**
  %73 = load %Token*, %Token** %72, align 8
  %74 = load i32, i32* %5, align 4
  %75 = getelementptr inbounds %Token, %Token* %73, i32 %74
  %76 = bitcast %Token* %75 to i8*
  %77 = load %VecToken*, %VecToken** %6, align 8
  %78 = bitcast %VecToken* %77 to %Token**
  %79 = load %Token*, %Token** %78, align 8
  %80 = bitcast %Token* %79 to i8*
  %81 = load %VecToken*, %VecToken** %6, align 8
  %82 = getelementptr inbounds %VecToken, %VecToken* %81, i32 0, i32 2
  %83 = load i32, i32* %82, align 4
  %84 = load i32, i32* %8, align 4
  %85 = mul i32 %83, %84
  %86 = call i8* @memcpy(i8* %76, i8* %80, i32 %85)
  %87 = bitcast i8* %86 to %Token*
  store %Token* %87, %Token** %70, align 8
  %88 = load i1, i1* %7, align 1
  ret i1 %88
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

define dso_local %VecToken @VecToken_clone(%VecToken* %0) {
  %2 = alloca %VecToken*, align 8
  store %VecToken* %0, %VecToken** %2, align 8
  %3 = alloca %VecToken, align 8
  %4 = alloca i32, align 4
  store i32 56, i32* %4, align 4
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
  %25 = getelementptr inbounds %VecToken, %VecToken* %9, i32 0, i32 2
  %26 = load %VecToken*, %VecToken** %2, align 8
  %27 = getelementptr inbounds %VecToken, %VecToken* %26, i32 0, i32 2
  %28 = load i32, i32* %27, align 4
  store i32 %28, i32* %25, align 4
  %29 = load %VecToken, %VecToken* %9, align 8
  store %VecToken %29, %VecToken* %3, align 8
  %30 = load %VecToken, %VecToken* %3, align 8
  ret %VecToken %30
}

define dso_local %Lexer @Lexer_new(i8* %0, i32 %1, %String %2) {
  %4 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  %5 = alloca i32, align 4
  store i32 %1, i32* %5, align 4
  %6 = alloca %String, align 8
  store %String %2, %String* %6, align 8
  %7 = alloca %Lexer, align 8
  %8 = alloca %Lexer, align 8
  %9 = bitcast %Lexer* %8 to %String*
  %10 = load %String, %String* %6, align 8
  store %String %10, %String* %9, align 8
  %11 = getelementptr inbounds %Lexer, %Lexer* %8, i32 0, i32 1
  %12 = load i8*, i8** %4, align 8
  store i8* %12, i8** %11, align 8
  %13 = getelementptr inbounds %Lexer, %Lexer* %8, i32 0, i32 2
  %14 = load i32, i32* %5, align 4
  store i32 %14, i32* %13, align 4
  %15 = getelementptr inbounds %Lexer, %Lexer* %8, i32 0, i32 3
  %16 = load i8*, i8** %4, align 8
  %17 = bitcast i8* %16 to i8*
  %18 = load i8, i8* %17, align 1
  store i8 %18, i8* %15, align 1
  %19 = getelementptr inbounds %Lexer, %Lexer* %8, i32 0, i32 4
  store i32 0, i32* %19, align 4
  %20 = getelementptr inbounds %Lexer, %Lexer* %8, i32 0, i32 5
  store i64 0, i64* %20, align 8
  %21 = getelementptr inbounds %Lexer, %Lexer* %8, i32 0, i32 6
  store i64 0, i64* %21, align 8
  %22 = load %Lexer, %Lexer* %8, align 8
  store %Lexer %22, %Lexer* %7, align 8
  %23 = load %Lexer, %Lexer* %7, align 8
  ret %Lexer %23
}

define dso_local void @Lexer_advance(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = load %Lexer*, %Lexer** %2, align 8
  %4 = getelementptr inbounds %Lexer, %Lexer* %3, i32 0, i32 4
  %5 = load %Lexer*, %Lexer** %2, align 8
  %6 = getelementptr inbounds %Lexer, %Lexer* %5, i32 0, i32 4
  %7 = load i32, i32* %6, align 4
  %8 = add i32 %7, 1
  store i32 %8, i32* %4, align 4
  %9 = load %Lexer*, %Lexer** %2, align 8
  %10 = getelementptr inbounds %Lexer, %Lexer* %9, i32 0, i32 3
  %11 = load %Lexer*, %Lexer** %2, align 8
  %12 = getelementptr inbounds %Lexer, %Lexer* %11, i32 0, i32 1
  %13 = load i8*, i8** %12, align 8
  %14 = load %Lexer*, %Lexer** %2, align 8
  %15 = getelementptr inbounds %Lexer, %Lexer* %14, i32 0, i32 4
  %16 = load i32, i32* %15, align 4
  %17 = getelementptr inbounds i8, i8* %13, i32 %16
  %18 = load i8, i8* %17, align 1
  store i8 %18, i8* %10, align 1
  %19 = load %Lexer*, %Lexer** %2, align 8
  %20 = getelementptr inbounds %Lexer, %Lexer* %19, i32 0, i32 6
  %21 = load %Lexer*, %Lexer** %2, align 8
  %22 = getelementptr inbounds %Lexer, %Lexer* %21, i32 0, i32 6
  %23 = load i64, i64* %22, align 8
  %24 = add i64 %23, 1
  store i64 %24, i64* %20, align 8
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
  %4 = call %String @String_new(i32 0)
  %5 = alloca %String, align 8
  store %String %4, %String* %5, align 8
  %6 = load %Lexer*, %Lexer** %2, align 8
  %7 = bitcast %Lexer* %6 to %String*
  %8 = load %Lexer*, %Lexer** %2, align 8
  %9 = getelementptr inbounds %Lexer, %Lexer* %8, i32 0, i32 5
  %10 = load i64, i64* %9, align 8
  %11 = load %Lexer*, %Lexer** %2, align 8
  %12 = getelementptr inbounds %Lexer, %Lexer* %11, i32 0, i32 6
  %13 = load i64, i64* %12, align 8
  %14 = call %Loc @Loc_new(%String* %7, i64 %10, i64 %13, i64 0)
  %15 = alloca %Loc, align 8
  store %Loc %14, %Loc* %15, align 8
  %16 = load %Lexer*, %Lexer** %2, align 8
  %17 = getelementptr inbounds %Lexer, %Lexer* %16, i32 0, i32 3
  %18 = load i8, i8* %17, align 1
  %19 = alloca i8, align 1
  store i8 %18, i8* %19, align 1
  br label %for.cond

20:                                               ; preds = %for.cond
  %21 = load %Lexer*, %Lexer** %2, align 8
  %22 = getelementptr inbounds %Lexer, %Lexer* %21, i32 0, i32 3
  %23 = load i8, i8* %22, align 1
  %24 = sext i8 %23 to i32
  %25 = call i32 @isdigit(i32 %24)
  %26 = icmp ne i32 %25, 0
  %27 = load %Lexer*, %Lexer** %2, align 8
  %28 = getelementptr inbounds %Lexer, %Lexer* %27, i32 0, i32 3
  %29 = load i8, i8* %28, align 1
  %30 = icmp eq i8 %29, 46
  %31 = or i1 %26, %30
  br i1 %31, label %for.block, label %for.end

for.cond:                                         ; preds = %for.block, %1
  %32 = load %Lexer*, %Lexer** %2, align 8
  %33 = getelementptr inbounds %Lexer, %Lexer* %32, i32 0, i32 3
  %34 = load i8, i8* %33, align 1
  %35 = sext i8 %34 to i32
  %36 = call i32 @isdigit(i32 %35)
  %37 = icmp ne i32 %36, 0
  br i1 %37, label %20, label %for.end

for.block:                                        ; preds = %20
  %38 = load %Lexer*, %Lexer** %2, align 8
  %39 = getelementptr inbounds %Lexer, %Lexer* %38, i32 0, i32 3
  %40 = load i8, i8* %39, align 1
  call void @String_push(%String* %5, i8 %40)
  %41 = load %Lexer*, %Lexer** %2, align 8
  %42 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %42)
  br label %for.cond

for.end:                                          ; preds = %20, %for.cond
  %43 = call i1 @String_contains(%String* %5, i8 46)
  br i1 %43, label %if.then, label %if.end

if.then:                                          ; preds = %for.end
  %44 = load %String, %String* %5, align 8
  %45 = load %Loc, %Loc* %15, align 8
  %46 = call %Token @Token_new(%String %44, i32 2, %Loc %45)
  store %Token %46, %Token* %3, align 8
  br label %ret

if.end:                                           ; preds = %for.end
  %47 = load %String, %String* %5, align 8
  %48 = load %Loc, %Loc* %15, align 8
  %49 = call %Token @Token_new(%String %47, i32 1, %Loc %48)
  store %Token %49, %Token* %3, align 8
  br label %ret

ret:                                              ; preds = %if.end, %if.then
  %50 = load %Token, %Token* %3, align 8
  ret %Token %50
}

define dso_local %Token @Lexer_lex_string(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = alloca %Token, align 8
  %4 = call %String @String_new(i32 0)
  %5 = alloca %String, align 8
  store %String %4, %String* %5, align 8
  %6 = load %Lexer*, %Lexer** %2, align 8
  %7 = bitcast %Lexer* %6 to %String*
  %8 = load %Lexer*, %Lexer** %2, align 8
  %9 = getelementptr inbounds %Lexer, %Lexer* %8, i32 0, i32 5
  %10 = load i64, i64* %9, align 8
  %11 = load %Lexer*, %Lexer** %2, align 8
  %12 = getelementptr inbounds %Lexer, %Lexer* %11, i32 0, i32 6
  %13 = load i64, i64* %12, align 8
  %14 = call %Loc @Loc_new(%String* %7, i64 %10, i64 %13, i64 0)
  %15 = alloca %Loc, align 8
  store %Loc %14, %Loc* %15, align 8
  %16 = load %Lexer*, %Lexer** %2, align 8
  %17 = getelementptr inbounds %Lexer, %Lexer* %16, i32 0, i32 3
  %18 = load i8, i8* %17, align 1
  %19 = alloca i8, align 1
  store i8 %18, i8* %19, align 1
  br label %for.cond

for.cond:                                         ; preds = %for.block, %1
  %20 = load %Lexer*, %Lexer** %2, align 8
  %21 = getelementptr inbounds %Lexer, %Lexer* %20, i32 0, i32 3
  %22 = load i8, i8* %21, align 1
  %23 = icmp ne i8 %22, 34
  br i1 %23, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %24 = load %Lexer*, %Lexer** %2, align 8
  %25 = getelementptr inbounds %Lexer, %Lexer* %24, i32 0, i32 3
  %26 = load i8, i8* %25, align 1
  call void @String_push(%String* %5, i8 %26)
  %27 = load %Lexer*, %Lexer** %2, align 8
  %28 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %28)
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %29 = load %String, %String* %5, align 8
  %30 = load %Loc, %Loc* %15, align 8
  %31 = call %Token @Token_new(%String %29, i32 0, %Loc %30)
  store %Token %31, %Token* %3, align 8
  %32 = load %Token, %Token* %3, align 8
  ret %Token %32
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
  %5 = bitcast %Lexer* %4 to %String*
  %6 = load %Lexer*, %Lexer** %2, align 8
  %7 = getelementptr inbounds %Lexer, %Lexer* %6, i32 0, i32 5
  %8 = load i64, i64* %7, align 8
  %9 = load %Lexer*, %Lexer** %2, align 8
  %10 = getelementptr inbounds %Lexer, %Lexer* %9, i32 0, i32 6
  %11 = load i64, i64* %10, align 8
  %12 = call %Loc @Loc_new(%String* %5, i64 %8, i64 %11, i64 0)
  %13 = alloca %Loc, align 8
  store %Loc %12, %Loc* %13, align 8
  %14 = call %String @String_new(i32 0)
  %15 = alloca %String, align 8
  store %String %14, %String* %15, align 8
  %16 = load %Lexer*, %Lexer** %2, align 8
  %17 = getelementptr inbounds %Lexer, %Lexer* %16, i32 0, i32 3
  %18 = load i8, i8* %17, align 1
  %19 = alloca i8, align 1
  store i8 %18, i8* %19, align 1
  br label %for.cond

for.cond:                                         ; preds = %for.block, %1
  %20 = load %Lexer*, %Lexer** %2, align 8
  %21 = getelementptr inbounds %Lexer, %Lexer* %20, i32 0, i32 3
  %22 = load i8, i8* %21, align 1
  %23 = sext i8 %22 to i32
  %24 = call i32 @isalpha(i32 %23)
  %25 = icmp ne i32 %24, 0
  br i1 %25, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %26 = load %Lexer*, %Lexer** %2, align 8
  %27 = getelementptr inbounds %Lexer, %Lexer* %26, i32 0, i32 3
  %28 = load i8, i8* %27, align 1
  call void @String_push(%String* %15, i8 %28)
  %29 = load %Lexer*, %Lexer** %2, align 8
  %30 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %30)
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %31 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @1, i32 0, i32 0))
  br i1 %31, label %if.then, label %if.end

if.then:                                          ; preds = %for.end
  %32 = load %String, %String* %15, align 8
  %33 = load %Loc, %Loc* %13, align 8
  %34 = call %Token @Token_new(%String %32, i32 37, %Loc %33)
  store %Token %34, %Token* %3, align 8
  br label %ret

if.end:                                           ; preds = %for.end
  %35 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @2, i32 0, i32 0))
  br i1 %35, label %if.then1, label %if.end2

if.then1:                                         ; preds = %if.end
  %36 = load %String, %String* %15, align 8
  %37 = load %Loc, %Loc* %13, align 8
  %38 = call %Token @Token_new(%String %36, i32 38, %Loc %37)
  store %Token %38, %Token* %3, align 8
  br label %ret

if.end2:                                          ; preds = %if.end
  %39 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @3, i32 0, i32 0))
  br i1 %39, label %if.then3, label %if.end4

if.then3:                                         ; preds = %if.end2
  %40 = load %String, %String* %15, align 8
  %41 = load %Loc, %Loc* %13, align 8
  %42 = call %Token @Token_new(%String %40, i32 39, %Loc %41)
  store %Token %42, %Token* %3, align 8
  br label %ret

if.end4:                                          ; preds = %if.end2
  %43 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @4, i32 0, i32 0))
  br i1 %43, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end4
  %44 = load %String, %String* %15, align 8
  %45 = load %Loc, %Loc* %13, align 8
  %46 = call %Token @Token_new(%String %44, i32 40, %Loc %45)
  store %Token %46, %Token* %3, align 8
  br label %ret

if.end6:                                          ; preds = %if.end4
  %47 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @5, i32 0, i32 0))
  br i1 %47, label %if.then7, label %if.end8

if.then7:                                         ; preds = %if.end6
  %48 = load %String, %String* %15, align 8
  %49 = load %Loc, %Loc* %13, align 8
  %50 = call %Token @Token_new(%String %48, i32 41, %Loc %49)
  store %Token %50, %Token* %3, align 8
  br label %ret

if.end8:                                          ; preds = %if.end6
  %51 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @6, i32 0, i32 0))
  br i1 %51, label %if.then9, label %if.end10

if.then9:                                         ; preds = %if.end8
  %52 = load %String, %String* %15, align 8
  %53 = load %Loc, %Loc* %13, align 8
  %54 = call %Token @Token_new(%String %52, i32 42, %Loc %53)
  store %Token %54, %Token* %3, align 8
  br label %ret

if.end10:                                         ; preds = %if.end8
  %55 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @7, i32 0, i32 0))
  br i1 %55, label %if.then11, label %if.end12

if.then11:                                        ; preds = %if.end10
  %56 = load %String, %String* %15, align 8
  %57 = load %Loc, %Loc* %13, align 8
  %58 = call %Token @Token_new(%String %56, i32 43, %Loc %57)
  store %Token %58, %Token* %3, align 8
  br label %ret

if.end12:                                         ; preds = %if.end10
  %59 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @8, i32 0, i32 0))
  br i1 %59, label %if.then13, label %if.end14

if.then13:                                        ; preds = %if.end12
  %60 = load %String, %String* %15, align 8
  %61 = load %Loc, %Loc* %13, align 8
  %62 = call %Token @Token_new(%String %60, i32 44, %Loc %61)
  store %Token %62, %Token* %3, align 8
  br label %ret

if.end14:                                         ; preds = %if.end12
  %63 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @9, i32 0, i32 0))
  br i1 %63, label %if.then15, label %if.end16

if.then15:                                        ; preds = %if.end14
  %64 = load %String, %String* %15, align 8
  %65 = load %Loc, %Loc* %13, align 8
  %66 = call %Token @Token_new(%String %64, i32 45, %Loc %65)
  store %Token %66, %Token* %3, align 8
  br label %ret

if.end16:                                         ; preds = %if.end14
  %67 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @10, i32 0, i32 0))
  br i1 %67, label %if.then17, label %if.end18

if.then17:                                        ; preds = %if.end16
  %68 = load %String, %String* %15, align 8
  %69 = load %Loc, %Loc* %13, align 8
  %70 = call %Token @Token_new(%String %68, i32 46, %Loc %69)
  store %Token %70, %Token* %3, align 8
  br label %ret

if.end18:                                         ; preds = %if.end16
  %71 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @11, i32 0, i32 0))
  br i1 %71, label %if.then19, label %if.end20

if.then19:                                        ; preds = %if.end18
  %72 = load %String, %String* %15, align 8
  %73 = load %Loc, %Loc* %13, align 8
  %74 = call %Token @Token_new(%String %72, i32 47, %Loc %73)
  store %Token %74, %Token* %3, align 8
  br label %ret

if.end20:                                         ; preds = %if.end18
  %75 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @12, i32 0, i32 0))
  br i1 %75, label %if.then21, label %if.end22

if.then21:                                        ; preds = %if.end20
  %76 = load %String, %String* %15, align 8
  %77 = load %Loc, %Loc* %13, align 8
  %78 = call %Token @Token_new(%String %76, i32 48, %Loc %77)
  store %Token %78, %Token* %3, align 8
  br label %ret

if.end22:                                         ; preds = %if.end20
  %79 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @13, i32 0, i32 0))
  br i1 %79, label %if.then23, label %if.end24

if.then23:                                        ; preds = %if.end22
  %80 = load %String, %String* %15, align 8
  %81 = load %Loc, %Loc* %13, align 8
  %82 = call %Token @Token_new(%String %80, i32 49, %Loc %81)
  store %Token %82, %Token* %3, align 8
  br label %ret

if.end24:                                         ; preds = %if.end22
  %83 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @14, i32 0, i32 0))
  br i1 %83, label %if.then25, label %if.end26

if.then25:                                        ; preds = %if.end24
  %84 = load %String, %String* %15, align 8
  %85 = load %Loc, %Loc* %13, align 8
  %86 = call %Token @Token_new(%String %84, i32 50, %Loc %85)
  store %Token %86, %Token* %3, align 8
  br label %ret

if.end26:                                         ; preds = %if.end24
  %87 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @15, i32 0, i32 0))
  br i1 %87, label %if.then27, label %if.end28

if.then27:                                        ; preds = %if.end26
  %88 = load %String, %String* %15, align 8
  %89 = load %Loc, %Loc* %13, align 8
  %90 = call %Token @Token_new(%String %88, i32 51, %Loc %89)
  store %Token %90, %Token* %3, align 8
  br label %ret

if.end28:                                         ; preds = %if.end26
  %91 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @16, i32 0, i32 0))
  br i1 %91, label %if.then29, label %if.end30

if.then29:                                        ; preds = %if.end28
  %92 = load %String, %String* %15, align 8
  %93 = load %Loc, %Loc* %13, align 8
  %94 = call %Token @Token_new(%String %92, i32 52, %Loc %93)
  store %Token %94, %Token* %3, align 8
  br label %ret

if.end30:                                         ; preds = %if.end28
  %95 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @17, i32 0, i32 0))
  br i1 %95, label %if.then31, label %if.end32

if.then31:                                        ; preds = %if.end30
  %96 = load %String, %String* %15, align 8
  %97 = load %Loc, %Loc* %13, align 8
  %98 = call %Token @Token_new(%String %96, i32 53, %Loc %97)
  store %Token %98, %Token* %3, align 8
  br label %ret

if.end32:                                         ; preds = %if.end30
  %99 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @18, i32 0, i32 0))
  br i1 %99, label %if.then33, label %if.end34

if.then33:                                        ; preds = %if.end32
  %100 = load %String, %String* %15, align 8
  %101 = load %Loc, %Loc* %13, align 8
  %102 = call %Token @Token_new(%String %100, i32 54, %Loc %101)
  store %Token %102, %Token* %3, align 8
  br label %ret

if.end34:                                         ; preds = %if.end32
  %103 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @19, i32 0, i32 0))
  br i1 %103, label %if.then35, label %if.end36

if.then35:                                        ; preds = %if.end34
  %104 = load %String, %String* %15, align 8
  %105 = load %Loc, %Loc* %13, align 8
  %106 = call %Token @Token_new(%String %104, i32 55, %Loc %105)
  store %Token %106, %Token* %3, align 8
  br label %ret

if.end36:                                         ; preds = %if.end34
  %107 = call i1 @String_eq_ptr(%String* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @20, i32 0, i32 0))
  br i1 %107, label %if.then37, label %if.end38

if.then37:                                        ; preds = %if.end36
  %108 = load %String, %String* %15, align 8
  %109 = load %Loc, %Loc* %13, align 8
  %110 = call %Token @Token_new(%String %108, i32 56, %Loc %109)
  store %Token %110, %Token* %3, align 8
  br label %ret

if.end38:                                         ; preds = %if.end36
  %111 = load %String, %String* %15, align 8
  %112 = load %Loc, %Loc* %13, align 8
  %113 = call %Token @Token_new(%String %111, i32 3, %Loc %112)
  store %Token %113, %Token* %3, align 8
  br label %ret

ret:                                              ; preds = %if.end38, %if.then37, %if.then35, %if.then33, %if.then31, %if.then29, %if.then27, %if.then25, %if.then23, %if.then21, %if.then19, %if.then17, %if.then15, %if.then13, %if.then11, %if.then9, %if.then7, %if.then5, %if.then3, %if.then1, %if.then
  %114 = load %Token, %Token* %3, align 8
  ret %Token %114
}

define dso_local %Token @Lexer_next_token(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = alloca %Token, align 8
  %4 = alloca i32, align 4
  store i32 0, i32* %4, align 4
  br label %for.cond

for.cond:                                         ; preds = %if.end108, %1
  %5 = load %Lexer*, %Lexer** %2, align 8
  %6 = getelementptr inbounds %Lexer, %Lexer* %5, i32 0, i32 4
  %7 = load %Lexer*, %Lexer** %2, align 8
  %8 = getelementptr inbounds %Lexer, %Lexer* %7, i32 0, i32 2
  %9 = load i32, i32* %6, align 4
  %10 = load i32, i32* %8, align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %12 = alloca i32, align 4
  store i32 0, i32* %12, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond
  %13 = call %String @String_from(i8* getelementptr inbounds ([1 x i8], [1 x i8]* @53, i32 0, i32 0))
  %14 = load %Lexer*, %Lexer** %2, align 8
  %15 = bitcast %Lexer* %14 to %String*
  %16 = load %Lexer*, %Lexer** %2, align 8
  %17 = getelementptr inbounds %Lexer, %Lexer* %16, i32 0, i32 5
  %18 = load i64, i64* %17, align 8
  %19 = load %Lexer*, %Lexer** %2, align 8
  %20 = getelementptr inbounds %Lexer, %Lexer* %19, i32 0, i32 6
  %21 = load i64, i64* %20, align 8
  %22 = call %Loc @Loc_new(%String* %15, i64 %18, i64 %21, i64 0)
  %23 = call %Token @Token_new(%String %13, i32 57, %Loc %22)
  store %Token %23, %Token* %3, align 8
  br label %ret

for.cond1:                                        ; preds = %if.then, %if.else, %for.block
  %24 = load %Lexer*, %Lexer** %2, align 8
  %25 = getelementptr inbounds %Lexer, %Lexer* %24, i32 0, i32 3
  %26 = load i8, i8* %25, align 1
  %27 = sext i8 %26 to i32
  %28 = call i32 @isspace(i32 %27)
  %29 = icmp ne i32 %28, 0
  br i1 %29, label %for.block2, label %for.end3

for.block2:                                       ; preds = %for.cond1
  %30 = load %Lexer*, %Lexer** %2, align 8
  %31 = getelementptr inbounds %Lexer, %Lexer* %30, i32 0, i32 3
  %32 = load i8, i8* %31, align 1
  %33 = icmp eq i8 %32, 10
  br i1 %33, label %if.then, label %if.else

for.end3:                                         ; preds = %for.cond1
  %34 = load %Lexer*, %Lexer** %2, align 8
  %35 = getelementptr inbounds %Lexer, %Lexer* %34, i32 0, i32 3
  %36 = load i8, i8* %35, align 1
  %37 = icmp eq i8 %36, 46
  br i1 %37, label %if.then4, label %if.end6

if.then:                                          ; preds = %for.block2
  %38 = load %Lexer*, %Lexer** %2, align 8
  %39 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %39)
  %40 = load %Lexer*, %Lexer** %2, align 8
  %41 = getelementptr inbounds %Lexer, %Lexer* %40, i32 0, i32 5
  %42 = load %Lexer*, %Lexer** %2, align 8
  %43 = getelementptr inbounds %Lexer, %Lexer* %42, i32 0, i32 5
  %44 = load i64, i64* %43, align 8
  %45 = add i64 %44, 1
  store i64 %45, i64* %41, align 8
  %46 = load %Lexer*, %Lexer** %2, align 8
  %47 = getelementptr inbounds %Lexer, %Lexer* %46, i32 0, i32 6
  store i64 0, i64* %47, align 8
  br label %for.cond1

if.else:                                          ; preds = %for.block2
  %48 = load %Lexer*, %Lexer** %2, align 8
  %49 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %49)
  br label %for.cond1

if.then4:                                         ; preds = %for.end3
  %50 = load %Lexer*, %Lexer** %2, align 8
  %51 = load %Lexer*, %Lexer** %2, align 8
  %52 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @21, i32 0, i32 0))
  %53 = load %Lexer*, %Lexer** %2, align 8
  %54 = bitcast %Lexer* %53 to %String*
  %55 = load %Lexer*, %Lexer** %2, align 8
  %56 = getelementptr inbounds %Lexer, %Lexer* %55, i32 0, i32 5
  %57 = load i64, i64* %56, align 8
  %58 = load %Lexer*, %Lexer** %2, align 8
  %59 = getelementptr inbounds %Lexer, %Lexer* %58, i32 0, i32 6
  %60 = load i64, i64* %59, align 8
  %61 = call %Loc @Loc_new(%String* %54, i64 %57, i64 %60, i64 0)
  %62 = call %Token @Token_new(%String %52, i32 7, %Loc %61)
  %63 = call %Token @Lexer_advance_token(%Lexer* %51, %Token %62)
  store %Token %63, %Token* %3, align 8
  br label %ret

if.end6:                                          ; preds = %for.end3
  %64 = load %Lexer*, %Lexer** %2, align 8
  %65 = getelementptr inbounds %Lexer, %Lexer* %64, i32 0, i32 3
  %66 = load i8, i8* %65, align 1
  %67 = icmp eq i8 %66, 44
  br i1 %67, label %if.then7, label %if.end9

if.then7:                                         ; preds = %if.end6
  %68 = load %Lexer*, %Lexer** %2, align 8
  %69 = load %Lexer*, %Lexer** %2, align 8
  %70 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @22, i32 0, i32 0))
  %71 = load %Lexer*, %Lexer** %2, align 8
  %72 = bitcast %Lexer* %71 to %String*
  %73 = load %Lexer*, %Lexer** %2, align 8
  %74 = getelementptr inbounds %Lexer, %Lexer* %73, i32 0, i32 5
  %75 = load i64, i64* %74, align 8
  %76 = load %Lexer*, %Lexer** %2, align 8
  %77 = getelementptr inbounds %Lexer, %Lexer* %76, i32 0, i32 6
  %78 = load i64, i64* %77, align 8
  %79 = call %Loc @Loc_new(%String* %72, i64 %75, i64 %78, i64 0)
  %80 = call %Token @Token_new(%String %70, i32 8, %Loc %79)
  %81 = call %Token @Lexer_advance_token(%Lexer* %69, %Token %80)
  store %Token %81, %Token* %3, align 8
  br label %ret

if.end9:                                          ; preds = %if.end6
  %82 = load %Lexer*, %Lexer** %2, align 8
  %83 = getelementptr inbounds %Lexer, %Lexer* %82, i32 0, i32 3
  %84 = load i8, i8* %83, align 1
  %85 = icmp eq i8 %84, 59
  br i1 %85, label %if.then10, label %if.end12

if.then10:                                        ; preds = %if.end9
  %86 = load %Lexer*, %Lexer** %2, align 8
  %87 = load %Lexer*, %Lexer** %2, align 8
  %88 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @23, i32 0, i32 0))
  %89 = load %Lexer*, %Lexer** %2, align 8
  %90 = bitcast %Lexer* %89 to %String*
  %91 = load %Lexer*, %Lexer** %2, align 8
  %92 = getelementptr inbounds %Lexer, %Lexer* %91, i32 0, i32 5
  %93 = load i64, i64* %92, align 8
  %94 = load %Lexer*, %Lexer** %2, align 8
  %95 = getelementptr inbounds %Lexer, %Lexer* %94, i32 0, i32 6
  %96 = load i64, i64* %95, align 8
  %97 = call %Loc @Loc_new(%String* %90, i64 %93, i64 %96, i64 0)
  %98 = call %Token @Token_new(%String %88, i32 9, %Loc %97)
  %99 = call %Token @Lexer_advance_token(%Lexer* %87, %Token %98)
  store %Token %99, %Token* %3, align 8
  br label %ret

if.end12:                                         ; preds = %if.end9
  %100 = load %Lexer*, %Lexer** %2, align 8
  %101 = getelementptr inbounds %Lexer, %Lexer* %100, i32 0, i32 3
  %102 = load i8, i8* %101, align 1
  %103 = icmp eq i8 %102, 58
  br i1 %103, label %if.then13, label %if.end15

if.then13:                                        ; preds = %if.end12
  %104 = load %Lexer*, %Lexer** %2, align 8
  %105 = getelementptr inbounds %Lexer, %Lexer* %104, i32 0, i32 1
  %106 = load i8*, i8** %105, align 8
  %107 = load %Lexer*, %Lexer** %2, align 8
  %108 = getelementptr inbounds %Lexer, %Lexer* %107, i32 0, i32 4
  %109 = load i32, i32* %108, align 4
  %110 = add i32 %109, 1
  %111 = getelementptr inbounds i8, i8* %106, i32 %110
  %112 = load i8, i8* %111, align 1
  %113 = icmp eq i8 %112, 58
  br i1 %113, label %if.then16, label %if.end18

if.end15:                                         ; preds = %if.end12
  %114 = load %Lexer*, %Lexer** %2, align 8
  %115 = getelementptr inbounds %Lexer, %Lexer* %114, i32 0, i32 3
  %116 = load i8, i8* %115, align 1
  %117 = icmp eq i8 %116, 43
  br i1 %117, label %if.then19, label %if.end21

if.then16:                                        ; preds = %if.then13
  %118 = load %Lexer*, %Lexer** %2, align 8
  %119 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %119)
  %120 = load %Lexer*, %Lexer** %2, align 8
  %121 = load %Lexer*, %Lexer** %2, align 8
  %122 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @24, i32 0, i32 0))
  %123 = load %Lexer*, %Lexer** %2, align 8
  %124 = bitcast %Lexer* %123 to %String*
  %125 = load %Lexer*, %Lexer** %2, align 8
  %126 = getelementptr inbounds %Lexer, %Lexer* %125, i32 0, i32 5
  %127 = load i64, i64* %126, align 8
  %128 = load %Lexer*, %Lexer** %2, align 8
  %129 = getelementptr inbounds %Lexer, %Lexer* %128, i32 0, i32 6
  %130 = load i64, i64* %129, align 8
  %131 = call %Loc @Loc_new(%String* %124, i64 %127, i64 %130, i64 0)
  %132 = call %Token @Token_new(%String %122, i32 27, %Loc %131)
  %133 = call %Token @Lexer_advance_token(%Lexer* %121, %Token %132)
  store %Token %133, %Token* %3, align 8
  br label %ret

if.end18:                                         ; preds = %if.then13
  %134 = load %Lexer*, %Lexer** %2, align 8
  %135 = load %Lexer*, %Lexer** %2, align 8
  %136 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @25, i32 0, i32 0))
  %137 = load %Lexer*, %Lexer** %2, align 8
  %138 = bitcast %Lexer* %137 to %String*
  %139 = load %Lexer*, %Lexer** %2, align 8
  %140 = getelementptr inbounds %Lexer, %Lexer* %139, i32 0, i32 5
  %141 = load i64, i64* %140, align 8
  %142 = load %Lexer*, %Lexer** %2, align 8
  %143 = getelementptr inbounds %Lexer, %Lexer* %142, i32 0, i32 6
  %144 = load i64, i64* %143, align 8
  %145 = call %Loc @Loc_new(%String* %138, i64 %141, i64 %144, i64 0)
  %146 = call %Token @Token_new(%String %136, i32 10, %Loc %145)
  %147 = call %Token @Lexer_advance_token(%Lexer* %135, %Token %146)
  store %Token %147, %Token* %3, align 8
  br label %ret

if.then19:                                        ; preds = %if.end15
  %148 = load %Lexer*, %Lexer** %2, align 8
  %149 = load %Lexer*, %Lexer** %2, align 8
  %150 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @26, i32 0, i32 0))
  %151 = load %Lexer*, %Lexer** %2, align 8
  %152 = bitcast %Lexer* %151 to %String*
  %153 = load %Lexer*, %Lexer** %2, align 8
  %154 = getelementptr inbounds %Lexer, %Lexer* %153, i32 0, i32 5
  %155 = load i64, i64* %154, align 8
  %156 = load %Lexer*, %Lexer** %2, align 8
  %157 = getelementptr inbounds %Lexer, %Lexer* %156, i32 0, i32 6
  %158 = load i64, i64* %157, align 8
  %159 = call %Loc @Loc_new(%String* %152, i64 %155, i64 %158, i64 0)
  %160 = call %Token @Token_new(%String %150, i32 16, %Loc %159)
  %161 = call %Token @Lexer_advance_token(%Lexer* %149, %Token %160)
  store %Token %161, %Token* %3, align 8
  br label %ret

if.end21:                                         ; preds = %if.end15
  %162 = load %Lexer*, %Lexer** %2, align 8
  %163 = getelementptr inbounds %Lexer, %Lexer* %162, i32 0, i32 3
  %164 = load i8, i8* %163, align 1
  %165 = icmp eq i8 %164, 45
  br i1 %165, label %if.then22, label %if.end24

if.then22:                                        ; preds = %if.end21
  %166 = load %Lexer*, %Lexer** %2, align 8
  %167 = getelementptr inbounds %Lexer, %Lexer* %166, i32 0, i32 1
  %168 = load i8*, i8** %167, align 8
  %169 = load %Lexer*, %Lexer** %2, align 8
  %170 = getelementptr inbounds %Lexer, %Lexer* %169, i32 0, i32 4
  %171 = load i32, i32* %170, align 4
  %172 = add i32 %171, 1
  %173 = getelementptr inbounds i8, i8* %168, i32 %172
  %174 = load i8, i8* %173, align 1
  %175 = icmp eq i8 %174, 62
  br i1 %175, label %if.then25, label %if.end27

if.end24:                                         ; preds = %if.end21
  %176 = load %Lexer*, %Lexer** %2, align 8
  %177 = getelementptr inbounds %Lexer, %Lexer* %176, i32 0, i32 3
  %178 = load i8, i8* %177, align 1
  %179 = icmp eq i8 %178, 42
  br i1 %179, label %if.then28, label %if.end30

if.then25:                                        ; preds = %if.then22
  %180 = load %Lexer*, %Lexer** %2, align 8
  %181 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %181)
  %182 = load %Lexer*, %Lexer** %2, align 8
  %183 = load %Lexer*, %Lexer** %2, align 8
  %184 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @27, i32 0, i32 0))
  %185 = load %Lexer*, %Lexer** %2, align 8
  %186 = bitcast %Lexer* %185 to %String*
  %187 = load %Lexer*, %Lexer** %2, align 8
  %188 = getelementptr inbounds %Lexer, %Lexer* %187, i32 0, i32 5
  %189 = load i64, i64* %188, align 8
  %190 = load %Lexer*, %Lexer** %2, align 8
  %191 = getelementptr inbounds %Lexer, %Lexer* %190, i32 0, i32 6
  %192 = load i64, i64* %191, align 8
  %193 = call %Loc @Loc_new(%String* %186, i64 %189, i64 %192, i64 0)
  %194 = call %Token @Token_new(%String %184, i32 6, %Loc %193)
  %195 = call %Token @Lexer_advance_token(%Lexer* %183, %Token %194)
  store %Token %195, %Token* %3, align 8
  br label %ret

if.end27:                                         ; preds = %if.then22
  %196 = load %Lexer*, %Lexer** %2, align 8
  %197 = load %Lexer*, %Lexer** %2, align 8
  %198 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @28, i32 0, i32 0))
  %199 = load %Lexer*, %Lexer** %2, align 8
  %200 = bitcast %Lexer* %199 to %String*
  %201 = load %Lexer*, %Lexer** %2, align 8
  %202 = getelementptr inbounds %Lexer, %Lexer* %201, i32 0, i32 5
  %203 = load i64, i64* %202, align 8
  %204 = load %Lexer*, %Lexer** %2, align 8
  %205 = getelementptr inbounds %Lexer, %Lexer* %204, i32 0, i32 6
  %206 = load i64, i64* %205, align 8
  %207 = call %Loc @Loc_new(%String* %200, i64 %203, i64 %206, i64 0)
  %208 = call %Token @Token_new(%String %198, i32 17, %Loc %207)
  %209 = call %Token @Lexer_advance_token(%Lexer* %197, %Token %208)
  store %Token %209, %Token* %3, align 8
  br label %ret

if.then28:                                        ; preds = %if.end24
  %210 = load %Lexer*, %Lexer** %2, align 8
  %211 = load %Lexer*, %Lexer** %2, align 8
  %212 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @29, i32 0, i32 0))
  %213 = load %Lexer*, %Lexer** %2, align 8
  %214 = bitcast %Lexer* %213 to %String*
  %215 = load %Lexer*, %Lexer** %2, align 8
  %216 = getelementptr inbounds %Lexer, %Lexer* %215, i32 0, i32 5
  %217 = load i64, i64* %216, align 8
  %218 = load %Lexer*, %Lexer** %2, align 8
  %219 = getelementptr inbounds %Lexer, %Lexer* %218, i32 0, i32 6
  %220 = load i64, i64* %219, align 8
  %221 = call %Loc @Loc_new(%String* %214, i64 %217, i64 %220, i64 0)
  %222 = call %Token @Token_new(%String %212, i32 18, %Loc %221)
  %223 = call %Token @Lexer_advance_token(%Lexer* %211, %Token %222)
  store %Token %223, %Token* %3, align 8
  br label %ret

if.end30:                                         ; preds = %if.end24
  %224 = load %Lexer*, %Lexer** %2, align 8
  %225 = getelementptr inbounds %Lexer, %Lexer* %224, i32 0, i32 3
  %226 = load i8, i8* %225, align 1
  %227 = icmp eq i8 %226, 47
  br i1 %227, label %if.then31, label %if.end33

if.then31:                                        ; preds = %if.end30
  %228 = load %Lexer*, %Lexer** %2, align 8
  %229 = load %Lexer*, %Lexer** %2, align 8
  %230 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @30, i32 0, i32 0))
  %231 = load %Lexer*, %Lexer** %2, align 8
  %232 = bitcast %Lexer* %231 to %String*
  %233 = load %Lexer*, %Lexer** %2, align 8
  %234 = getelementptr inbounds %Lexer, %Lexer* %233, i32 0, i32 5
  %235 = load i64, i64* %234, align 8
  %236 = load %Lexer*, %Lexer** %2, align 8
  %237 = getelementptr inbounds %Lexer, %Lexer* %236, i32 0, i32 6
  %238 = load i64, i64* %237, align 8
  %239 = call %Loc @Loc_new(%String* %232, i64 %235, i64 %238, i64 0)
  %240 = call %Token @Token_new(%String %230, i32 19, %Loc %239)
  %241 = call %Token @Lexer_advance_token(%Lexer* %229, %Token %240)
  store %Token %241, %Token* %3, align 8
  br label %ret

if.end33:                                         ; preds = %if.end30
  %242 = load %Lexer*, %Lexer** %2, align 8
  %243 = getelementptr inbounds %Lexer, %Lexer* %242, i32 0, i32 3
  %244 = load i8, i8* %243, align 1
  %245 = icmp eq i8 %244, 37
  br i1 %245, label %if.then37, label %if.end39

if.then37:                                        ; preds = %if.end33
  %246 = load %Lexer*, %Lexer** %2, align 8
  %247 = load %Lexer*, %Lexer** %2, align 8
  %248 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @31, i32 0, i32 0))
  %249 = load %Lexer*, %Lexer** %2, align 8
  %250 = bitcast %Lexer* %249 to %String*
  %251 = load %Lexer*, %Lexer** %2, align 8
  %252 = getelementptr inbounds %Lexer, %Lexer* %251, i32 0, i32 5
  %253 = load i64, i64* %252, align 8
  %254 = load %Lexer*, %Lexer** %2, align 8
  %255 = getelementptr inbounds %Lexer, %Lexer* %254, i32 0, i32 6
  %256 = load i64, i64* %255, align 8
  %257 = call %Loc @Loc_new(%String* %250, i64 %253, i64 %256, i64 0)
  %258 = call %Token @Token_new(%String %248, i32 20, %Loc %257)
  %259 = call %Token @Lexer_advance_token(%Lexer* %247, %Token %258)
  store %Token %259, %Token* %3, align 8
  br label %ret

if.end39:                                         ; preds = %if.end33
  %260 = load %Lexer*, %Lexer** %2, align 8
  %261 = getelementptr inbounds %Lexer, %Lexer* %260, i32 0, i32 3
  %262 = load i8, i8* %261, align 1
  %263 = icmp eq i8 %262, 91
  br i1 %263, label %if.then40, label %if.end42

if.then40:                                        ; preds = %if.end39
  %264 = load %Lexer*, %Lexer** %2, align 8
  %265 = load %Lexer*, %Lexer** %2, align 8
  %266 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @32, i32 0, i32 0))
  %267 = load %Lexer*, %Lexer** %2, align 8
  %268 = bitcast %Lexer* %267 to %String*
  %269 = load %Lexer*, %Lexer** %2, align 8
  %270 = getelementptr inbounds %Lexer, %Lexer* %269, i32 0, i32 5
  %271 = load i64, i64* %270, align 8
  %272 = load %Lexer*, %Lexer** %2, align 8
  %273 = getelementptr inbounds %Lexer, %Lexer* %272, i32 0, i32 6
  %274 = load i64, i64* %273, align 8
  %275 = call %Loc @Loc_new(%String* %268, i64 %271, i64 %274, i64 0)
  %276 = call %Token @Token_new(%String %266, i32 29, %Loc %275)
  %277 = call %Token @Lexer_advance_token(%Lexer* %265, %Token %276)
  store %Token %277, %Token* %3, align 8
  br label %ret

if.end42:                                         ; preds = %if.end39
  %278 = load %Lexer*, %Lexer** %2, align 8
  %279 = getelementptr inbounds %Lexer, %Lexer* %278, i32 0, i32 3
  %280 = load i8, i8* %279, align 1
  %281 = icmp eq i8 %280, 93
  br i1 %281, label %if.then43, label %if.end45

if.then43:                                        ; preds = %if.end42
  %282 = load %Lexer*, %Lexer** %2, align 8
  %283 = load %Lexer*, %Lexer** %2, align 8
  %284 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @33, i32 0, i32 0))
  %285 = load %Lexer*, %Lexer** %2, align 8
  %286 = bitcast %Lexer* %285 to %String*
  %287 = load %Lexer*, %Lexer** %2, align 8
  %288 = getelementptr inbounds %Lexer, %Lexer* %287, i32 0, i32 5
  %289 = load i64, i64* %288, align 8
  %290 = load %Lexer*, %Lexer** %2, align 8
  %291 = getelementptr inbounds %Lexer, %Lexer* %290, i32 0, i32 6
  %292 = load i64, i64* %291, align 8
  %293 = call %Loc @Loc_new(%String* %286, i64 %289, i64 %292, i64 0)
  %294 = call %Token @Token_new(%String %284, i32 30, %Loc %293)
  %295 = call %Token @Lexer_advance_token(%Lexer* %283, %Token %294)
  store %Token %295, %Token* %3, align 8
  br label %ret

if.end45:                                         ; preds = %if.end42
  %296 = load %Lexer*, %Lexer** %2, align 8
  %297 = getelementptr inbounds %Lexer, %Lexer* %296, i32 0, i32 3
  %298 = load i8, i8* %297, align 1
  %299 = icmp eq i8 %298, 123
  br i1 %299, label %if.then46, label %if.end48

if.then46:                                        ; preds = %if.end45
  %300 = load %Lexer*, %Lexer** %2, align 8
  %301 = load %Lexer*, %Lexer** %2, align 8
  %302 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @34, i32 0, i32 0))
  %303 = load %Lexer*, %Lexer** %2, align 8
  %304 = bitcast %Lexer* %303 to %String*
  %305 = load %Lexer*, %Lexer** %2, align 8
  %306 = getelementptr inbounds %Lexer, %Lexer* %305, i32 0, i32 5
  %307 = load i64, i64* %306, align 8
  %308 = load %Lexer*, %Lexer** %2, align 8
  %309 = getelementptr inbounds %Lexer, %Lexer* %308, i32 0, i32 6
  %310 = load i64, i64* %309, align 8
  %311 = call %Loc @Loc_new(%String* %304, i64 %307, i64 %310, i64 0)
  %312 = call %Token @Token_new(%String %302, i32 31, %Loc %311)
  %313 = call %Token @Lexer_advance_token(%Lexer* %301, %Token %312)
  store %Token %313, %Token* %3, align 8
  br label %ret

if.end48:                                         ; preds = %if.end45
  %314 = load %Lexer*, %Lexer** %2, align 8
  %315 = getelementptr inbounds %Lexer, %Lexer* %314, i32 0, i32 3
  %316 = load i8, i8* %315, align 1
  %317 = icmp eq i8 %316, 125
  br i1 %317, label %if.then49, label %if.end51

if.then49:                                        ; preds = %if.end48
  %318 = load %Lexer*, %Lexer** %2, align 8
  %319 = load %Lexer*, %Lexer** %2, align 8
  %320 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @35, i32 0, i32 0))
  %321 = load %Lexer*, %Lexer** %2, align 8
  %322 = bitcast %Lexer* %321 to %String*
  %323 = load %Lexer*, %Lexer** %2, align 8
  %324 = getelementptr inbounds %Lexer, %Lexer* %323, i32 0, i32 5
  %325 = load i64, i64* %324, align 8
  %326 = load %Lexer*, %Lexer** %2, align 8
  %327 = getelementptr inbounds %Lexer, %Lexer* %326, i32 0, i32 6
  %328 = load i64, i64* %327, align 8
  %329 = call %Loc @Loc_new(%String* %322, i64 %325, i64 %328, i64 0)
  %330 = call %Token @Token_new(%String %320, i32 32, %Loc %329)
  %331 = call %Token @Lexer_advance_token(%Lexer* %319, %Token %330)
  store %Token %331, %Token* %3, align 8
  br label %ret

if.end51:                                         ; preds = %if.end48
  %332 = load %Lexer*, %Lexer** %2, align 8
  %333 = getelementptr inbounds %Lexer, %Lexer* %332, i32 0, i32 3
  %334 = load i8, i8* %333, align 1
  %335 = icmp eq i8 %334, 40
  br i1 %335, label %if.then52, label %if.end54

if.then52:                                        ; preds = %if.end51
  %336 = load %Lexer*, %Lexer** %2, align 8
  %337 = load %Lexer*, %Lexer** %2, align 8
  %338 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @36, i32 0, i32 0))
  %339 = load %Lexer*, %Lexer** %2, align 8
  %340 = bitcast %Lexer* %339 to %String*
  %341 = load %Lexer*, %Lexer** %2, align 8
  %342 = getelementptr inbounds %Lexer, %Lexer* %341, i32 0, i32 5
  %343 = load i64, i64* %342, align 8
  %344 = load %Lexer*, %Lexer** %2, align 8
  %345 = getelementptr inbounds %Lexer, %Lexer* %344, i32 0, i32 6
  %346 = load i64, i64* %345, align 8
  %347 = call %Loc @Loc_new(%String* %340, i64 %343, i64 %346, i64 0)
  %348 = call %Token @Token_new(%String %338, i32 35, %Loc %347)
  %349 = call %Token @Lexer_advance_token(%Lexer* %337, %Token %348)
  store %Token %349, %Token* %3, align 8
  br label %ret

if.end54:                                         ; preds = %if.end51
  %350 = load %Lexer*, %Lexer** %2, align 8
  %351 = getelementptr inbounds %Lexer, %Lexer* %350, i32 0, i32 3
  %352 = load i8, i8* %351, align 1
  %353 = icmp eq i8 %352, 41
  br i1 %353, label %if.then55, label %if.end57

if.then55:                                        ; preds = %if.end54
  %354 = load %Lexer*, %Lexer** %2, align 8
  %355 = load %Lexer*, %Lexer** %2, align 8
  %356 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @37, i32 0, i32 0))
  %357 = load %Lexer*, %Lexer** %2, align 8
  %358 = bitcast %Lexer* %357 to %String*
  %359 = load %Lexer*, %Lexer** %2, align 8
  %360 = getelementptr inbounds %Lexer, %Lexer* %359, i32 0, i32 5
  %361 = load i64, i64* %360, align 8
  %362 = load %Lexer*, %Lexer** %2, align 8
  %363 = getelementptr inbounds %Lexer, %Lexer* %362, i32 0, i32 6
  %364 = load i64, i64* %363, align 8
  %365 = call %Loc @Loc_new(%String* %358, i64 %361, i64 %364, i64 0)
  %366 = call %Token @Token_new(%String %356, i32 36, %Loc %365)
  %367 = call %Token @Lexer_advance_token(%Lexer* %355, %Token %366)
  store %Token %367, %Token* %3, align 8
  br label %ret

if.end57:                                         ; preds = %if.end54
  %368 = load %Lexer*, %Lexer** %2, align 8
  %369 = getelementptr inbounds %Lexer, %Lexer* %368, i32 0, i32 3
  %370 = load i8, i8* %369, align 1
  %371 = icmp eq i8 %370, 35
  br i1 %371, label %if.then58, label %if.end60

if.then58:                                        ; preds = %if.end57
  %372 = load %Lexer*, %Lexer** %2, align 8
  %373 = load %Lexer*, %Lexer** %2, align 8
  %374 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @38, i32 0, i32 0))
  %375 = load %Lexer*, %Lexer** %2, align 8
  %376 = bitcast %Lexer* %375 to %String*
  %377 = load %Lexer*, %Lexer** %2, align 8
  %378 = getelementptr inbounds %Lexer, %Lexer* %377, i32 0, i32 5
  %379 = load i64, i64* %378, align 8
  %380 = load %Lexer*, %Lexer** %2, align 8
  %381 = getelementptr inbounds %Lexer, %Lexer* %380, i32 0, i32 6
  %382 = load i64, i64* %381, align 8
  %383 = call %Loc @Loc_new(%String* %376, i64 %379, i64 %382, i64 0)
  %384 = call %Token @Token_new(%String %374, i32 12, %Loc %383)
  %385 = call %Token @Lexer_advance_token(%Lexer* %373, %Token %384)
  store %Token %385, %Token* %3, align 8
  br label %ret

if.end60:                                         ; preds = %if.end57
  %386 = load %Lexer*, %Lexer** %2, align 8
  %387 = getelementptr inbounds %Lexer, %Lexer* %386, i32 0, i32 3
  %388 = load i8, i8* %387, align 1
  %389 = icmp eq i8 %388, 36
  br i1 %389, label %if.then61, label %if.end63

if.then61:                                        ; preds = %if.end60
  %390 = load %Lexer*, %Lexer** %2, align 8
  %391 = load %Lexer*, %Lexer** %2, align 8
  %392 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @39, i32 0, i32 0))
  %393 = load %Lexer*, %Lexer** %2, align 8
  %394 = bitcast %Lexer* %393 to %String*
  %395 = load %Lexer*, %Lexer** %2, align 8
  %396 = getelementptr inbounds %Lexer, %Lexer* %395, i32 0, i32 5
  %397 = load i64, i64* %396, align 8
  %398 = load %Lexer*, %Lexer** %2, align 8
  %399 = getelementptr inbounds %Lexer, %Lexer* %398, i32 0, i32 6
  %400 = load i64, i64* %399, align 8
  %401 = call %Loc @Loc_new(%String* %394, i64 %397, i64 %400, i64 0)
  %402 = call %Token @Token_new(%String %392, i32 13, %Loc %401)
  %403 = call %Token @Lexer_advance_token(%Lexer* %391, %Token %402)
  store %Token %403, %Token* %3, align 8
  br label %ret

if.end63:                                         ; preds = %if.end60
  %404 = load %Lexer*, %Lexer** %2, align 8
  %405 = getelementptr inbounds %Lexer, %Lexer* %404, i32 0, i32 3
  %406 = load i8, i8* %405, align 1
  %407 = icmp eq i8 %406, 60
  br i1 %407, label %if.then64, label %if.end66

if.then64:                                        ; preds = %if.end63
  %408 = load %Lexer*, %Lexer** %2, align 8
  %409 = getelementptr inbounds %Lexer, %Lexer* %408, i32 0, i32 1
  %410 = load i8*, i8** %409, align 8
  %411 = load %Lexer*, %Lexer** %2, align 8
  %412 = getelementptr inbounds %Lexer, %Lexer* %411, i32 0, i32 4
  %413 = load i32, i32* %412, align 4
  %414 = add i32 %413, 1
  %415 = getelementptr inbounds i8, i8* %410, i32 %414
  %416 = load i8, i8* %415, align 1
  %417 = icmp eq i8 %416, 61
  br i1 %417, label %if.then67, label %if.end69

if.end66:                                         ; preds = %if.end63
  %418 = load %Lexer*, %Lexer** %2, align 8
  %419 = getelementptr inbounds %Lexer, %Lexer* %418, i32 0, i32 3
  %420 = load i8, i8* %419, align 1
  %421 = icmp eq i8 %420, 62
  br i1 %421, label %if.then70, label %if.end72

if.then67:                                        ; preds = %if.then64
  %422 = load %Lexer*, %Lexer** %2, align 8
  %423 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %423)
  %424 = load %Lexer*, %Lexer** %2, align 8
  %425 = load %Lexer*, %Lexer** %2, align 8
  %426 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @40, i32 0, i32 0))
  %427 = load %Lexer*, %Lexer** %2, align 8
  %428 = bitcast %Lexer* %427 to %String*
  %429 = load %Lexer*, %Lexer** %2, align 8
  %430 = getelementptr inbounds %Lexer, %Lexer* %429, i32 0, i32 5
  %431 = load i64, i64* %430, align 8
  %432 = load %Lexer*, %Lexer** %2, align 8
  %433 = getelementptr inbounds %Lexer, %Lexer* %432, i32 0, i32 6
  %434 = load i64, i64* %433, align 8
  %435 = call %Loc @Loc_new(%String* %428, i64 %431, i64 %434, i64 0)
  %436 = call %Token @Token_new(%String %426, i32 23, %Loc %435)
  %437 = call %Token @Lexer_advance_token(%Lexer* %425, %Token %436)
  store %Token %437, %Token* %3, align 8
  br label %ret

if.end69:                                         ; preds = %if.then64
  %438 = load %Lexer*, %Lexer** %2, align 8
  %439 = load %Lexer*, %Lexer** %2, align 8
  %440 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @41, i32 0, i32 0))
  %441 = load %Lexer*, %Lexer** %2, align 8
  %442 = bitcast %Lexer* %441 to %String*
  %443 = load %Lexer*, %Lexer** %2, align 8
  %444 = getelementptr inbounds %Lexer, %Lexer* %443, i32 0, i32 5
  %445 = load i64, i64* %444, align 8
  %446 = load %Lexer*, %Lexer** %2, align 8
  %447 = getelementptr inbounds %Lexer, %Lexer* %446, i32 0, i32 6
  %448 = load i64, i64* %447, align 8
  %449 = call %Loc @Loc_new(%String* %442, i64 %445, i64 %448, i64 0)
  %450 = call %Token @Token_new(%String %440, i32 33, %Loc %449)
  %451 = call %Token @Lexer_advance_token(%Lexer* %439, %Token %450)
  store %Token %451, %Token* %3, align 8
  br label %ret

if.then70:                                        ; preds = %if.end66
  %452 = load %Lexer*, %Lexer** %2, align 8
  %453 = getelementptr inbounds %Lexer, %Lexer* %452, i32 0, i32 1
  %454 = load i8*, i8** %453, align 8
  %455 = load %Lexer*, %Lexer** %2, align 8
  %456 = getelementptr inbounds %Lexer, %Lexer* %455, i32 0, i32 4
  %457 = load i32, i32* %456, align 4
  %458 = add i32 %457, 1
  %459 = getelementptr inbounds i8, i8* %454, i32 %458
  %460 = load i8, i8* %459, align 1
  %461 = icmp eq i8 %460, 61
  br i1 %461, label %if.then73, label %if.end75

if.end72:                                         ; preds = %if.end66
  %462 = load %Lexer*, %Lexer** %2, align 8
  %463 = getelementptr inbounds %Lexer, %Lexer* %462, i32 0, i32 3
  %464 = load i8, i8* %463, align 1
  %465 = icmp eq i8 %464, 38
  br i1 %465, label %if.then76, label %if.end78

if.then73:                                        ; preds = %if.then70
  %466 = load %Lexer*, %Lexer** %2, align 8
  %467 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %467)
  %468 = load %Lexer*, %Lexer** %2, align 8
  %469 = load %Lexer*, %Lexer** %2, align 8
  %470 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @42, i32 0, i32 0))
  %471 = load %Lexer*, %Lexer** %2, align 8
  %472 = bitcast %Lexer* %471 to %String*
  %473 = load %Lexer*, %Lexer** %2, align 8
  %474 = getelementptr inbounds %Lexer, %Lexer* %473, i32 0, i32 5
  %475 = load i64, i64* %474, align 8
  %476 = load %Lexer*, %Lexer** %2, align 8
  %477 = getelementptr inbounds %Lexer, %Lexer* %476, i32 0, i32 6
  %478 = load i64, i64* %477, align 8
  %479 = call %Loc @Loc_new(%String* %472, i64 %475, i64 %478, i64 0)
  %480 = call %Token @Token_new(%String %470, i32 24, %Loc %479)
  %481 = call %Token @Lexer_advance_token(%Lexer* %469, %Token %480)
  store %Token %481, %Token* %3, align 8
  br label %ret

if.end75:                                         ; preds = %if.then70
  %482 = load %Lexer*, %Lexer** %2, align 8
  %483 = load %Lexer*, %Lexer** %2, align 8
  %484 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @43, i32 0, i32 0))
  %485 = load %Lexer*, %Lexer** %2, align 8
  %486 = bitcast %Lexer* %485 to %String*
  %487 = load %Lexer*, %Lexer** %2, align 8
  %488 = getelementptr inbounds %Lexer, %Lexer* %487, i32 0, i32 5
  %489 = load i64, i64* %488, align 8
  %490 = load %Lexer*, %Lexer** %2, align 8
  %491 = getelementptr inbounds %Lexer, %Lexer* %490, i32 0, i32 6
  %492 = load i64, i64* %491, align 8
  %493 = call %Loc @Loc_new(%String* %486, i64 %489, i64 %492, i64 0)
  %494 = call %Token @Token_new(%String %484, i32 34, %Loc %493)
  %495 = call %Token @Lexer_advance_token(%Lexer* %483, %Token %494)
  store %Token %495, %Token* %3, align 8
  br label %ret

if.then76:                                        ; preds = %if.end72
  %496 = load %Lexer*, %Lexer** %2, align 8
  %497 = getelementptr inbounds %Lexer, %Lexer* %496, i32 0, i32 1
  %498 = load i8*, i8** %497, align 8
  %499 = load %Lexer*, %Lexer** %2, align 8
  %500 = getelementptr inbounds %Lexer, %Lexer* %499, i32 0, i32 4
  %501 = load i32, i32* %500, align 4
  %502 = add i32 %501, 1
  %503 = getelementptr inbounds i8, i8* %498, i32 %502
  %504 = load i8, i8* %503, align 1
  %505 = icmp eq i8 %504, 38
  br i1 %505, label %if.then79, label %if.end81

if.end78:                                         ; preds = %if.end72
  %506 = load %Lexer*, %Lexer** %2, align 8
  %507 = getelementptr inbounds %Lexer, %Lexer* %506, i32 0, i32 3
  %508 = load i8, i8* %507, align 1
  %509 = icmp eq i8 %508, 124
  br i1 %509, label %if.then82, label %if.end84

if.then79:                                        ; preds = %if.then76
  %510 = load %Lexer*, %Lexer** %2, align 8
  %511 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %511)
  %512 = load %Lexer*, %Lexer** %2, align 8
  %513 = load %Lexer*, %Lexer** %2, align 8
  %514 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @44, i32 0, i32 0))
  %515 = load %Lexer*, %Lexer** %2, align 8
  %516 = bitcast %Lexer* %515 to %String*
  %517 = load %Lexer*, %Lexer** %2, align 8
  %518 = getelementptr inbounds %Lexer, %Lexer* %517, i32 0, i32 5
  %519 = load i64, i64* %518, align 8
  %520 = load %Lexer*, %Lexer** %2, align 8
  %521 = getelementptr inbounds %Lexer, %Lexer* %520, i32 0, i32 6
  %522 = load i64, i64* %521, align 8
  %523 = call %Loc @Loc_new(%String* %516, i64 %519, i64 %522, i64 0)
  %524 = call %Token @Token_new(%String %514, i32 26, %Loc %523)
  %525 = call %Token @Lexer_advance_token(%Lexer* %513, %Token %524)
  store %Token %525, %Token* %3, align 8
  br label %ret

if.end81:                                         ; preds = %if.then76
  %526 = load %Lexer*, %Lexer** %2, align 8
  %527 = load %Lexer*, %Lexer** %2, align 8
  %528 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @45, i32 0, i32 0))
  %529 = load %Lexer*, %Lexer** %2, align 8
  %530 = bitcast %Lexer* %529 to %String*
  %531 = load %Lexer*, %Lexer** %2, align 8
  %532 = getelementptr inbounds %Lexer, %Lexer* %531, i32 0, i32 5
  %533 = load i64, i64* %532, align 8
  %534 = load %Lexer*, %Lexer** %2, align 8
  %535 = getelementptr inbounds %Lexer, %Lexer* %534, i32 0, i32 6
  %536 = load i64, i64* %535, align 8
  %537 = call %Loc @Loc_new(%String* %530, i64 %533, i64 %536, i64 0)
  %538 = call %Token @Token_new(%String %528, i32 11, %Loc %537)
  %539 = call %Token @Lexer_advance_token(%Lexer* %527, %Token %538)
  store %Token %539, %Token* %3, align 8
  br label %ret

if.then82:                                        ; preds = %if.end78
  %540 = load %Lexer*, %Lexer** %2, align 8
  %541 = getelementptr inbounds %Lexer, %Lexer* %540, i32 0, i32 1
  %542 = load i8*, i8** %541, align 8
  %543 = load %Lexer*, %Lexer** %2, align 8
  %544 = getelementptr inbounds %Lexer, %Lexer* %543, i32 0, i32 4
  %545 = load i32, i32* %544, align 4
  %546 = add i32 %545, 1
  %547 = getelementptr inbounds i8, i8* %542, i32 %546
  %548 = load i8, i8* %547, align 1
  %549 = icmp eq i8 %548, 124
  br i1 %549, label %if.then85, label %if.end87

if.end84:                                         ; preds = %if.end78
  %550 = load %Lexer*, %Lexer** %2, align 8
  %551 = getelementptr inbounds %Lexer, %Lexer* %550, i32 0, i32 3
  %552 = load i8, i8* %551, align 1
  %553 = icmp eq i8 %552, 33
  br i1 %553, label %if.then88, label %if.end90

if.then85:                                        ; preds = %if.then82
  %554 = load %Lexer*, %Lexer** %2, align 8
  %555 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %555)
  %556 = load %Lexer*, %Lexer** %2, align 8
  %557 = load %Lexer*, %Lexer** %2, align 8
  %558 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @46, i32 0, i32 0))
  %559 = load %Lexer*, %Lexer** %2, align 8
  %560 = bitcast %Lexer* %559 to %String*
  %561 = load %Lexer*, %Lexer** %2, align 8
  %562 = getelementptr inbounds %Lexer, %Lexer* %561, i32 0, i32 5
  %563 = load i64, i64* %562, align 8
  %564 = load %Lexer*, %Lexer** %2, align 8
  %565 = getelementptr inbounds %Lexer, %Lexer* %564, i32 0, i32 6
  %566 = load i64, i64* %565, align 8
  %567 = call %Loc @Loc_new(%String* %560, i64 %563, i64 %566, i64 0)
  %568 = call %Token @Token_new(%String %558, i32 25, %Loc %567)
  %569 = call %Token @Lexer_advance_token(%Lexer* %557, %Token %568)
  store %Token %569, %Token* %3, align 8
  br label %ret

if.end87:                                         ; preds = %if.then82
  %570 = load %Lexer*, %Lexer** %2, align 8
  %571 = load %Lexer*, %Lexer** %2, align 8
  %572 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @47, i32 0, i32 0))
  %573 = load %Lexer*, %Lexer** %2, align 8
  %574 = bitcast %Lexer* %573 to %String*
  %575 = load %Lexer*, %Lexer** %2, align 8
  %576 = getelementptr inbounds %Lexer, %Lexer* %575, i32 0, i32 5
  %577 = load i64, i64* %576, align 8
  %578 = load %Lexer*, %Lexer** %2, align 8
  %579 = getelementptr inbounds %Lexer, %Lexer* %578, i32 0, i32 6
  %580 = load i64, i64* %579, align 8
  %581 = call %Loc @Loc_new(%String* %574, i64 %577, i64 %580, i64 0)
  %582 = call %Token @Token_new(%String %572, i32 14, %Loc %581)
  %583 = call %Token @Lexer_advance_token(%Lexer* %571, %Token %582)
  store %Token %583, %Token* %3, align 8
  br label %ret

if.then88:                                        ; preds = %if.end84
  %584 = load %Lexer*, %Lexer** %2, align 8
  %585 = getelementptr inbounds %Lexer, %Lexer* %584, i32 0, i32 1
  %586 = load i8*, i8** %585, align 8
  %587 = load %Lexer*, %Lexer** %2, align 8
  %588 = getelementptr inbounds %Lexer, %Lexer* %587, i32 0, i32 4
  %589 = load i32, i32* %588, align 4
  %590 = add i32 %589, 1
  %591 = getelementptr inbounds i8, i8* %586, i32 %590
  %592 = load i8, i8* %591, align 1
  %593 = icmp eq i8 %592, 61
  br i1 %593, label %if.then91, label %if.end93

if.end90:                                         ; preds = %if.end84
  %594 = load %Lexer*, %Lexer** %2, align 8
  %595 = getelementptr inbounds %Lexer, %Lexer* %594, i32 0, i32 3
  %596 = load i8, i8* %595, align 1
  %597 = icmp eq i8 %596, 61
  br i1 %597, label %if.then94, label %if.end96

if.then91:                                        ; preds = %if.then88
  %598 = load %Lexer*, %Lexer** %2, align 8
  %599 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %599)
  %600 = load %Lexer*, %Lexer** %2, align 8
  %601 = load %Lexer*, %Lexer** %2, align 8
  %602 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @48, i32 0, i32 0))
  %603 = load %Lexer*, %Lexer** %2, align 8
  %604 = bitcast %Lexer* %603 to %String*
  %605 = load %Lexer*, %Lexer** %2, align 8
  %606 = getelementptr inbounds %Lexer, %Lexer* %605, i32 0, i32 5
  %607 = load i64, i64* %606, align 8
  %608 = load %Lexer*, %Lexer** %2, align 8
  %609 = getelementptr inbounds %Lexer, %Lexer* %608, i32 0, i32 6
  %610 = load i64, i64* %609, align 8
  %611 = call %Loc @Loc_new(%String* %604, i64 %607, i64 %610, i64 0)
  %612 = call %Token @Token_new(%String %602, i32 22, %Loc %611)
  %613 = call %Token @Lexer_advance_token(%Lexer* %601, %Token %612)
  store %Token %613, %Token* %3, align 8
  br label %ret

if.end93:                                         ; preds = %if.then88
  %614 = load %Lexer*, %Lexer** %2, align 8
  %615 = load %Lexer*, %Lexer** %2, align 8
  %616 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @49, i32 0, i32 0))
  %617 = load %Lexer*, %Lexer** %2, align 8
  %618 = bitcast %Lexer* %617 to %String*
  %619 = load %Lexer*, %Lexer** %2, align 8
  %620 = getelementptr inbounds %Lexer, %Lexer* %619, i32 0, i32 5
  %621 = load i64, i64* %620, align 8
  %622 = load %Lexer*, %Lexer** %2, align 8
  %623 = getelementptr inbounds %Lexer, %Lexer* %622, i32 0, i32 6
  %624 = load i64, i64* %623, align 8
  %625 = call %Loc @Loc_new(%String* %618, i64 %621, i64 %624, i64 0)
  %626 = call %Token @Token_new(%String %616, i32 15, %Loc %625)
  %627 = call %Token @Lexer_advance_token(%Lexer* %615, %Token %626)
  store %Token %627, %Token* %3, align 8
  br label %ret

if.then94:                                        ; preds = %if.end90
  %628 = load %Lexer*, %Lexer** %2, align 8
  %629 = getelementptr inbounds %Lexer, %Lexer* %628, i32 0, i32 1
  %630 = load i8*, i8** %629, align 8
  %631 = load %Lexer*, %Lexer** %2, align 8
  %632 = getelementptr inbounds %Lexer, %Lexer* %631, i32 0, i32 4
  %633 = load i32, i32* %632, align 4
  %634 = add i32 %633, 1
  %635 = getelementptr inbounds i8, i8* %630, i32 %634
  %636 = load i8, i8* %635, align 1
  %637 = icmp eq i8 %636, 61
  br i1 %637, label %if.then97, label %if.end99

if.end96:                                         ; preds = %if.end90
  %638 = load %Lexer*, %Lexer** %2, align 8
  %639 = getelementptr inbounds %Lexer, %Lexer* %638, i32 0, i32 3
  %640 = load i8, i8* %639, align 1
  %641 = icmp eq i8 %640, 39
  br i1 %641, label %if.then100, label %if.end102

if.then97:                                        ; preds = %if.then94
  %642 = load %Lexer*, %Lexer** %2, align 8
  %643 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %643)
  %644 = load %Lexer*, %Lexer** %2, align 8
  %645 = load %Lexer*, %Lexer** %2, align 8
  %646 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @50, i32 0, i32 0))
  %647 = load %Lexer*, %Lexer** %2, align 8
  %648 = bitcast %Lexer* %647 to %String*
  %649 = load %Lexer*, %Lexer** %2, align 8
  %650 = getelementptr inbounds %Lexer, %Lexer* %649, i32 0, i32 5
  %651 = load i64, i64* %650, align 8
  %652 = load %Lexer*, %Lexer** %2, align 8
  %653 = getelementptr inbounds %Lexer, %Lexer* %652, i32 0, i32 6
  %654 = load i64, i64* %653, align 8
  %655 = call %Loc @Loc_new(%String* %648, i64 %651, i64 %654, i64 0)
  %656 = call %Token @Token_new(%String %646, i32 21, %Loc %655)
  %657 = call %Token @Lexer_advance_token(%Lexer* %645, %Token %656)
  store %Token %657, %Token* %3, align 8
  br label %ret

if.end99:                                         ; preds = %if.then94
  %658 = load %Lexer*, %Lexer** %2, align 8
  %659 = load %Lexer*, %Lexer** %2, align 8
  %660 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @51, i32 0, i32 0))
  %661 = load %Lexer*, %Lexer** %2, align 8
  %662 = bitcast %Lexer* %661 to %String*
  %663 = load %Lexer*, %Lexer** %2, align 8
  %664 = getelementptr inbounds %Lexer, %Lexer* %663, i32 0, i32 5
  %665 = load i64, i64* %664, align 8
  %666 = load %Lexer*, %Lexer** %2, align 8
  %667 = getelementptr inbounds %Lexer, %Lexer* %666, i32 0, i32 6
  %668 = load i64, i64* %667, align 8
  %669 = call %Loc @Loc_new(%String* %662, i64 %665, i64 %668, i64 0)
  %670 = call %Token @Token_new(%String %660, i32 5, %Loc %669)
  %671 = call %Token @Lexer_advance_token(%Lexer* %659, %Token %670)
  store %Token %671, %Token* %3, align 8
  br label %ret

if.then100:                                       ; preds = %if.end96
  %672 = load %Lexer*, %Lexer** %2, align 8
  %673 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %673)
  %674 = load %Lexer*, %Lexer** %2, align 8
  %675 = load %Lexer*, %Lexer** %2, align 8
  %676 = call %Token @Lexer_lex_char(%Lexer* %675)
  store %Token %676, %Token* %3, align 8
  br label %ret

if.end102:                                        ; preds = %if.end96
  %677 = load %Lexer*, %Lexer** %2, align 8
  %678 = getelementptr inbounds %Lexer, %Lexer* %677, i32 0, i32 3
  %679 = load i8, i8* %678, align 1
  %680 = icmp eq i8 %679, 0
  br i1 %680, label %if.then103, label %if.end105

if.then103:                                       ; preds = %if.end102
  %681 = call %String @String_from(i8* getelementptr inbounds ([1 x i8], [1 x i8]* @52, i32 0, i32 0))
  %682 = load %Lexer*, %Lexer** %2, align 8
  %683 = bitcast %Lexer* %682 to %String*
  %684 = load %Lexer*, %Lexer** %2, align 8
  %685 = getelementptr inbounds %Lexer, %Lexer* %684, i32 0, i32 5
  %686 = load i64, i64* %685, align 8
  %687 = load %Lexer*, %Lexer** %2, align 8
  %688 = getelementptr inbounds %Lexer, %Lexer* %687, i32 0, i32 6
  %689 = load i64, i64* %688, align 8
  %690 = call %Loc @Loc_new(%String* %683, i64 %686, i64 %689, i64 0)
  %691 = call %Token @Token_new(%String %681, i32 57, %Loc %690)
  store %Token %691, %Token* %3, align 8
  br label %ret

if.end105:                                        ; preds = %if.end102
  %692 = load %Lexer*, %Lexer** %2, align 8
  %693 = getelementptr inbounds %Lexer, %Lexer* %692, i32 0, i32 3
  %694 = load i8, i8* %693, align 1
  %695 = sext i8 %694 to i32
  %696 = call i32 @isdigit(i32 %695)
  %697 = icmp ne i32 %696, 0
  br i1 %697, label %if.then106, label %if.end108

if.then106:                                       ; preds = %if.end105
  %698 = load %Lexer*, %Lexer** %2, align 8
  %699 = load %Lexer*, %Lexer** %2, align 8
  %700 = call %Token @Lexer_lex_number(%Lexer* %699)
  store %Token %700, %Token* %3, align 8
  br label %ret

if.end108:                                        ; preds = %if.end105
  %701 = load %Lexer*, %Lexer** %2, align 8
  %702 = getelementptr inbounds %Lexer, %Lexer* %701, i32 0, i32 3
  %703 = load i8, i8* %702, align 1
  %704 = sext i8 %703 to i32
  %705 = call i32 @isalpha(i32 %704)
  %706 = icmp ne i32 %705, 0
  br i1 %706, label %if.then109, label %for.cond

if.then109:                                       ; preds = %if.end108
  %707 = load %Lexer*, %Lexer** %2, align 8
  %708 = load %Lexer*, %Lexer** %2, align 8
  %709 = call %Token @Lexer_lex_id(%Lexer* %708)
  store %Token %709, %Token* %3, align 8
  br label %ret

ret:                                              ; preds = %for.end, %if.then109, %if.then106, %if.then103, %if.then100, %if.end99, %if.then97, %if.end93, %if.then91, %if.end87, %if.then85, %if.end81, %if.then79, %if.end75, %if.then73, %if.end69, %if.then67, %if.then61, %if.then58, %if.then55, %if.then52, %if.then49, %if.then46, %if.then43, %if.then40, %if.then37, %if.then31, %if.then28, %if.end27, %if.then25, %if.then19, %if.end18, %if.then16, %if.then10, %if.then7, %if.then4
  %710 = load %Token, %Token* %3, align 8
  ret %Token %710
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
  %12 = icmp ne i32 %11, 57
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
  %17 = load %VecToken, %VecToken* %5, align 8
  store %VecToken %17, %VecToken* %3, align 8
  %18 = load %VecToken, %VecToken* %3, align 8
  ret %VecToken %18
}

define dso_local %VecAST @VecAST_new() {
  %1 = alloca %VecAST, align 8
  %2 = alloca i32, align 4
  store i32 8, i32* %2, align 4
  %3 = alloca %VecAST, align 8
  %4 = bitcast %VecAST* %3 to %AST***
  store %AST** null, %AST*** %4, align 8
  %5 = getelementptr inbounds %VecAST, %VecAST* %3, i32 0, i32 1
  store i32 0, i32* %5, align 4
  %6 = getelementptr inbounds %VecAST, %VecAST* %3, i32 0, i32 2
  store i32 0, i32* %6, align 4
  %7 = load %VecAST, %VecAST* %3, align 8
  store %VecAST %7, %VecAST* %1, align 8
  %8 = load %VecAST, %VecAST* %1, align 8
  ret %VecAST %8
}

define dso_local %VecAST @VecAST_with_size(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = alloca %VecAST, align 8
  %4 = alloca i32, align 4
  store i32 8, i32* %4, align 4
  %5 = alloca %VecAST, align 8
  %6 = bitcast %VecAST* %5 to %AST***
  %7 = load i32, i32* %2, align 4
  %8 = load i32, i32* %4, align 4
  %9 = mul i32 %7, %8
  %10 = call i8* @malloc(i32 %9)
  %11 = bitcast i8* %10 to %AST**
  store %AST** %11, %AST*** %6, align 8
  %12 = getelementptr inbounds %VecAST, %VecAST* %5, i32 0, i32 1
  %13 = load i32, i32* %2, align 4
  store i32 %13, i32* %12, align 4
  %14 = getelementptr inbounds %VecAST, %VecAST* %5, i32 0, i32 2
  store i32 0, i32* %14, align 4
  %15 = load %VecAST, %VecAST* %5, align 8
  store %VecAST %15, %VecAST* %3, align 8
  %16 = load %VecAST, %VecAST* %3, align 8
  ret %VecAST %16
}

define dso_local void @VecAST_may_grow(%VecAST* %0) {
  %2 = alloca %VecAST*, align 8
  store %VecAST* %0, %VecAST** %2, align 8
  %3 = alloca i32, align 4
  store i32 8, i32* %3, align 4
  %4 = load %VecAST*, %VecAST** %2, align 8
  %5 = getelementptr inbounds %VecAST, %VecAST* %4, i32 0, i32 1
  %6 = load i32, i32* %5, align 4
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %1
  %8 = load %VecAST*, %VecAST** %2, align 8
  %9 = getelementptr inbounds %VecAST, %VecAST* %8, i32 0, i32 1
  store i32 1, i32* %9, align 4
  %10 = load %VecAST*, %VecAST** %2, align 8
  %11 = bitcast %VecAST* %10 to %AST***
  %12 = load %VecAST*, %VecAST** %2, align 8
  %13 = bitcast %VecAST* %12 to %AST***
  %14 = load %AST**, %AST*** %13, align 8
  %15 = bitcast %AST** %14 to i8*
  %16 = load %VecAST*, %VecAST** %2, align 8
  %17 = getelementptr inbounds %VecAST, %VecAST* %16, i32 0, i32 1
  %18 = load i32, i32* %17, align 4
  %19 = load i32, i32* %3, align 4
  %20 = mul i32 %18, %19
  %21 = call i8* @realloc(i8* %15, i32 %20)
  %22 = bitcast i8* %21 to %AST**
  store %AST** %22, %AST*** %11, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %1
  %23 = load %VecAST*, %VecAST** %2, align 8
  %24 = getelementptr inbounds %VecAST, %VecAST* %23, i32 0, i32 1
  %25 = load %VecAST*, %VecAST** %2, align 8
  %26 = getelementptr inbounds %VecAST, %VecAST* %25, i32 0, i32 2
  %27 = load i32, i32* %24, align 4
  %28 = load i32, i32* %26, align 4
  %29 = icmp eq i32 %27, %28
  br i1 %29, label %if.then1, label %if.end2

if.then1:                                         ; preds = %if.end
  %30 = load %VecAST*, %VecAST** %2, align 8
  %31 = getelementptr inbounds %VecAST, %VecAST* %30, i32 0, i32 1
  %32 = load %VecAST*, %VecAST** %2, align 8
  %33 = getelementptr inbounds %VecAST, %VecAST* %32, i32 0, i32 1
  %34 = load i32, i32* %33, align 4
  %35 = mul i32 %34, 2
  store i32 %35, i32* %31, align 4
  %36 = load %VecAST*, %VecAST** %2, align 8
  %37 = bitcast %VecAST* %36 to %AST***
  %38 = load %VecAST*, %VecAST** %2, align 8
  %39 = bitcast %VecAST* %38 to %AST***
  %40 = load %AST**, %AST*** %39, align 8
  %41 = bitcast %AST** %40 to i8*
  %42 = load %VecAST*, %VecAST** %2, align 8
  %43 = getelementptr inbounds %VecAST, %VecAST* %42, i32 0, i32 1
  %44 = load i32, i32* %43, align 4
  %45 = load i32, i32* %3, align 4
  %46 = mul i32 %44, %45
  %47 = call i8* @realloc(i8* %41, i32 %46)
  %48 = bitcast i8* %47 to %AST**
  store %AST** %48, %AST*** %37, align 8
  br label %if.end2

if.end2:                                          ; preds = %if.then1, %if.end
  ret void
}

define dso_local void @VecAST_push(%VecAST* %0, %AST* %1) {
  %3 = alloca %VecAST*, align 8
  store %VecAST* %0, %VecAST** %3, align 8
  %4 = alloca %AST*, align 8
  store %AST* %1, %AST** %4, align 8
  %5 = load %VecAST*, %VecAST** %3, align 8
  %6 = load %VecAST*, %VecAST** %3, align 8
  call void @VecAST_may_grow(%VecAST* %6)
  %7 = load %VecAST*, %VecAST** %3, align 8
  %8 = bitcast %VecAST* %7 to %AST***
  %9 = load %AST**, %AST*** %8, align 8
  %10 = load %VecAST*, %VecAST** %3, align 8
  %11 = getelementptr inbounds %VecAST, %VecAST* %10, i32 0, i32 2
  %12 = load i32, i32* %11, align 4
  %13 = getelementptr inbounds %AST*, %AST** %9, i32 %12
  %14 = load %AST*, %AST** %4, align 8
  store %AST* %14, %AST** %13, align 8
  %15 = load %VecAST*, %VecAST** %3, align 8
  %16 = getelementptr inbounds %VecAST, %VecAST* %15, i32 0, i32 2
  %17 = load %VecAST*, %VecAST** %3, align 8
  %18 = getelementptr inbounds %VecAST, %VecAST* %17, i32 0, i32 2
  %19 = load i32, i32* %18, align 4
  %20 = add i32 %19, 1
  store i32 %20, i32* %16, align 4
  ret void
}

define dso_local %AST* @VecAST_pop(%VecAST* %0) {
  %2 = alloca %VecAST*, align 8
  store %VecAST* %0, %VecAST** %2, align 8
  %3 = alloca %AST*, align 8
  %4 = load %VecAST*, %VecAST** %2, align 8
  %5 = getelementptr inbounds %VecAST, %VecAST* %4, i32 0, i32 2
  %6 = load %VecAST*, %VecAST** %2, align 8
  %7 = getelementptr inbounds %VecAST, %VecAST* %6, i32 0, i32 2
  %8 = load i32, i32* %7, align 4
  %9 = sub i32 %8, 1
  store i32 %9, i32* %5, align 4
  %10 = load %VecAST*, %VecAST** %2, align 8
  %11 = bitcast %VecAST* %10 to %AST***
  %12 = load %AST**, %AST*** %11, align 8
  %13 = load %VecAST*, %VecAST** %2, align 8
  %14 = getelementptr inbounds %VecAST, %VecAST* %13, i32 0, i32 2
  %15 = load i32, i32* %14, align 4
  %16 = getelementptr inbounds %AST*, %AST** %12, i32 %15
  %17 = load %AST*, %AST** %16, align 8
  store %AST* %17, %AST** %3, align 8
  %18 = load %AST*, %AST** %3, align 8
  ret %AST* %18
}

define dso_local i1 @VecAST_insert(%VecAST* %0, i32 %1, %VecAST* %2) {
  %4 = alloca %VecAST*, align 8
  store %VecAST* %0, %VecAST** %4, align 8
  %5 = alloca i32, align 4
  store i32 %1, i32* %5, align 4
  %6 = alloca %VecAST*, align 8
  store %VecAST* %2, %VecAST** %6, align 8
  %7 = alloca i1, align 1
  %8 = alloca i32, align 4
  store i32 8, i32* %8, align 4
  %9 = load %VecAST*, %VecAST** %4, align 8
  %10 = load %VecAST*, %VecAST** %4, align 8
  call void @VecAST_may_grow(%VecAST* %10)
  %11 = load %VecAST*, %VecAST** %4, align 8
  %12 = getelementptr inbounds %VecAST, %VecAST* %11, i32 0, i32 1
  %13 = load %VecAST*, %VecAST** %4, align 8
  %14 = getelementptr inbounds %VecAST, %VecAST* %13, i32 0, i32 2
  %15 = load %VecAST*, %VecAST** %6, align 8
  %16 = getelementptr inbounds %VecAST, %VecAST* %15, i32 0, i32 2
  %17 = load i32, i32* %14, align 4
  %18 = load i32, i32* %16, align 4
  %19 = add i32 %17, %18
  %20 = load i32, i32* %12, align 4
  %21 = icmp slt i32 %20, %19
  br i1 %21, label %if.then, label %if.end

if.then:                                          ; preds = %3
  %22 = load %VecAST*, %VecAST** %4, align 8
  %23 = getelementptr inbounds %VecAST, %VecAST* %22, i32 0, i32 1
  %24 = load %VecAST*, %VecAST** %4, align 8
  %25 = getelementptr inbounds %VecAST, %VecAST* %24, i32 0, i32 2
  %26 = load %VecAST*, %VecAST** %6, align 8
  %27 = getelementptr inbounds %VecAST, %VecAST* %26, i32 0, i32 2
  %28 = load i32, i32* %25, align 4
  %29 = load i32, i32* %27, align 4
  %30 = add i32 %28, %29
  store i32 %30, i32* %23, align 4
  %31 = load %VecAST*, %VecAST** %4, align 8
  %32 = bitcast %VecAST* %31 to %AST***
  %33 = load %VecAST*, %VecAST** %4, align 8
  %34 = bitcast %VecAST* %33 to %AST***
  %35 = load %AST**, %AST*** %34, align 8
  %36 = bitcast %AST** %35 to i8*
  %37 = load %VecAST*, %VecAST** %4, align 8
  %38 = getelementptr inbounds %VecAST, %VecAST* %37, i32 0, i32 1
  %39 = load i32, i32* %38, align 4
  %40 = load i32, i32* %8, align 4
  %41 = mul i32 %39, %40
  %42 = call i8* @realloc(i8* %36, i32 %41)
  %43 = bitcast i8* %42 to %AST**
  store %AST** %43, %AST*** %32, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %3
  %44 = load %VecAST*, %VecAST** %4, align 8
  %45 = bitcast %VecAST* %44 to %AST***
  %46 = load %VecAST*, %VecAST** %4, align 8
  %47 = bitcast %VecAST* %46 to %AST***
  %48 = load %AST**, %AST*** %47, align 8
  %49 = load %VecAST*, %VecAST** %6, align 8
  %50 = getelementptr inbounds %VecAST, %VecAST* %49, i32 0, i32 2
  %51 = load i32, i32* %5, align 4
  %52 = load i32, i32* %50, align 4
  %53 = add i32 %51, %52
  %54 = getelementptr inbounds %AST*, %AST** %48, i32 %53
  %55 = bitcast %AST** %54 to i8*
  %56 = load %VecAST*, %VecAST** %4, align 8
  %57 = bitcast %VecAST* %56 to %AST***
  %58 = load %AST**, %AST*** %57, align 8
  %59 = load i32, i32* %5, align 4
  %60 = getelementptr inbounds %AST*, %AST** %58, i32 %59
  %61 = bitcast %AST** %60 to i8*
  %62 = load %VecAST*, %VecAST** %6, align 8
  %63 = getelementptr inbounds %VecAST, %VecAST* %62, i32 0, i32 2
  %64 = load i32, i32* %63, align 4
  %65 = load i32, i32* %8, align 4
  %66 = mul i32 %64, %65
  %67 = call i8* @memmove(i8* %55, i8* %61, i32 %66)
  %68 = bitcast i8* %67 to %AST**
  store %AST** %68, %AST*** %45, align 8
  %69 = load %VecAST*, %VecAST** %4, align 8
  %70 = bitcast %VecAST* %69 to %AST***
  %71 = load %VecAST*, %VecAST** %4, align 8
  %72 = bitcast %VecAST* %71 to %AST***
  %73 = load %AST**, %AST*** %72, align 8
  %74 = load i32, i32* %5, align 4
  %75 = getelementptr inbounds %AST*, %AST** %73, i32 %74
  %76 = bitcast %AST** %75 to i8*
  %77 = load %VecAST*, %VecAST** %6, align 8
  %78 = bitcast %VecAST* %77 to %AST***
  %79 = load %AST**, %AST*** %78, align 8
  %80 = bitcast %AST** %79 to i8*
  %81 = load %VecAST*, %VecAST** %6, align 8
  %82 = getelementptr inbounds %VecAST, %VecAST* %81, i32 0, i32 2
  %83 = load i32, i32* %82, align 4
  %84 = load i32, i32* %8, align 4
  %85 = mul i32 %83, %84
  %86 = call i8* @memcpy(i8* %76, i8* %80, i32 %85)
  %87 = bitcast i8* %86 to %AST**
  store %AST** %87, %AST*** %70, align 8
  %88 = load i1, i1* %7, align 1
  ret i1 %88
}

define dso_local void @VecAST_drop(%VecAST* %0) {
  %2 = alloca %VecAST*, align 8
  store %VecAST* %0, %VecAST** %2, align 8
  %3 = load %VecAST*, %VecAST** %2, align 8
  %4 = bitcast %VecAST* %3 to %AST***
  %5 = load %AST**, %AST*** %4, align 8
  %6 = icmp ne %AST** %5, null
  br i1 %6, label %if.then, label %if.end

if.then:                                          ; preds = %1
  %7 = load %VecAST*, %VecAST** %2, align 8
  %8 = bitcast %VecAST* %7 to %AST***
  %9 = load %AST**, %AST*** %8, align 8
  %10 = bitcast %AST** %9 to i8*
  call void @free(i8* %10)
  br label %if.end

if.end:                                           ; preds = %if.then, %1
  ret void
}

define dso_local %VecAST @VecAST_clone(%VecAST* %0) {
  %2 = alloca %VecAST*, align 8
  store %VecAST* %0, %VecAST** %2, align 8
  %3 = alloca %VecAST, align 8
  %4 = alloca i32, align 4
  store i32 8, i32* %4, align 4
  %5 = load %VecAST*, %VecAST** %2, align 8
  %6 = getelementptr inbounds %VecAST, %VecAST* %5, i32 0, i32 1
  %7 = load i32, i32* %6, align 4
  %8 = call %VecAST @VecAST_with_size(i32 %7)
  %9 = alloca %VecAST, align 8
  store %VecAST %8, %VecAST* %9, align 8
  %10 = bitcast %VecAST* %9 to %AST***
  %11 = bitcast %VecAST* %9 to %AST***
  %12 = load %AST**, %AST*** %11, align 8
  %13 = bitcast %AST** %12 to i8*
  %14 = load %VecAST*, %VecAST** %2, align 8
  %15 = bitcast %VecAST* %14 to %AST***
  %16 = load %AST**, %AST*** %15, align 8
  %17 = bitcast %AST** %16 to i8*
  %18 = load %VecAST*, %VecAST** %2, align 8
  %19 = getelementptr inbounds %VecAST, %VecAST* %18, i32 0, i32 1
  %20 = load i32, i32* %19, align 4
  %21 = load i32, i32* %4, align 4
  %22 = mul i32 %20, %21
  %23 = call i8* @memcpy(i8* %13, i8* %17, i32 %22)
  %24 = bitcast i8* %23 to %AST**
  store %AST** %24, %AST*** %10, align 8
  %25 = getelementptr inbounds %VecAST, %VecAST* %9, i32 0, i32 2
  %26 = load %VecAST*, %VecAST** %2, align 8
  %27 = getelementptr inbounds %VecAST, %VecAST* %26, i32 0, i32 2
  %28 = load i32, i32* %27, align 4
  store i32 %28, i32* %25, align 4
  %29 = load %VecAST, %VecAST* %9, align 8
  store %VecAST %29, %VecAST* %3, align 8
  %30 = load %VecAST, %VecAST* %3, align 8
  ret %VecAST %30
}

define dso_local %Block @Block_new() {
  %1 = alloca %Block, align 8
  %2 = alloca %Block, align 8
  %3 = bitcast %Block* %2 to %VecAST*
  %4 = call %VecAST @VecAST_new()
  store %VecAST %4, %VecAST* %3, align 8
  %5 = getelementptr inbounds %Block, %Block* %2, i32 0, i32 1
  store i64 0, i64* %5, align 8
  %6 = getelementptr inbounds %Block, %Block* %2, i32 0, i32 2
  store i1 false, i1* %6, align 1
  %7 = load %Block, %Block* %2, align 8
  store %Block %7, %Block* %1, align 8
  %8 = load %Block, %Block* %1, align 8
  ret %Block %8
}

define dso_local %Block @Block_from(%VecAST* %0) {
  %2 = alloca %VecAST*, align 8
  store %VecAST* %0, %VecAST** %2, align 8
  %3 = alloca %Block, align 8
  %4 = alloca %Block, align 8
  %5 = bitcast %Block* %4 to %VecAST*
  %6 = load %VecAST*, %VecAST** %2, align 8
  %7 = load %VecAST*, %VecAST** %2, align 8
  %8 = call %VecAST @VecAST_clone(%VecAST* %7)
  store %VecAST %8, %VecAST* %5, align 8
  %9 = getelementptr inbounds %Block, %Block* %4, i32 0, i32 1
  store i64 0, i64* %9, align 8
  %10 = getelementptr inbounds %Block, %Block* %4, i32 0, i32 2
  store i1 false, i1* %10, align 1
  %11 = load %Block, %Block* %4, align 8
  store %Block %11, %Block* %3, align 8
  %12 = load %Block, %Block* %3, align 8
  ret %Block %12
}

define dso_local void @Block_increment(%Block* %0) {
  %2 = alloca %Block*, align 8
  store %Block* %0, %Block** %2, align 8
  %3 = load %Block*, %Block** %2, align 8
  %4 = getelementptr inbounds %Block, %Block* %3, i32 0, i32 1
  %5 = load %Block*, %Block** %2, align 8
  %6 = getelementptr inbounds %Block, %Block* %5, i32 0, i32 1
  %7 = load i64, i64* %6, align 8
  %8 = add i64 %7, 1
  store i64 %8, i64* %4, align 8
  ret void
}

define dso_local void @Block_insert(%Block* %0, %Block* %1) {
  %3 = alloca %Block*, align 8
  store %Block* %0, %Block** %3, align 8
  %4 = alloca %Block*, align 8
  store %Block* %1, %Block** %4, align 8
  %5 = load %Block*, %Block** %3, align 8
  %6 = load %Block*, %Block** %3, align 8
  %7 = bitcast %Block* %6 to %VecAST*
  %8 = load %Block*, %Block** %3, align 8
  %9 = getelementptr inbounds %Block, %Block* %8, i32 0, i32 1
  %10 = load i64, i64* %9, align 8
  %11 = trunc i64 %10 to i32
  %12 = load %Block*, %Block** %4, align 8
  %13 = bitcast %Block* %12 to %VecAST*
  %14 = call i1 @VecAST_insert(%VecAST* %7, i32 %11, %VecAST* %13)
  ret void
}

define dso_local void @Block_push(%Block* %0, %AST* %1) {
  %3 = alloca %Block*, align 8
  store %Block* %0, %Block** %3, align 8
  %4 = alloca %AST*, align 8
  store %AST* %1, %AST** %4, align 8
  %5 = load %Block*, %Block** %3, align 8
  %6 = load %Block*, %Block** %3, align 8
  %7 = bitcast %Block* %6 to %VecAST*
  %8 = load %AST*, %AST** %4, align 8
  call void @VecAST_push(%VecAST* %7, %AST* %8)
  ret void
}

define dso_local %Mod* @Mod_new() {
  %1 = alloca %Mod*, align 8
  %2 = alloca i32, align 4
  store i32 80, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = call i8* @malloc(i32 %3)
  %5 = bitcast i8* %4 to %Mod*
  %6 = alloca %Mod*, align 8
  store %Mod* %5, %Mod** %6, align 8
  %7 = load %Mod*, %Mod** %6, align 8
  %8 = bitcast %Mod* %7 to i32*
  store i32 0, i32* %8, align 4
  %9 = load %Mod*, %Mod** %6, align 8
  %10 = getelementptr inbounds %Mod, %Mod* %9, i32 0, i32 1
  %11 = call %Loc @Loc_new(%String* null, i64 0, i64 0, i64 0)
  store %Loc %11, %Loc* %10, align 8
  %12 = load %Mod*, %Mod** %6, align 8
  %13 = getelementptr inbounds %Mod, %Mod* %12, i32 0, i32 2
  %14 = call %Block @Block_new()
  store %Block %14, %Block* %13, align 8
  %15 = load %Mod*, %Mod** %6, align 8
  %16 = getelementptr inbounds %Mod, %Mod* %15, i32 0, i32 3
  %17 = load %Mod*, %Mod** %6, align 8
  %18 = getelementptr inbounds %Mod, %Mod* %17, i32 0, i32 2
  store %Block* %18, %Block** %16, align 8
  %19 = load %Mod*, %Mod** %6, align 8
  store %Mod* %19, %Mod** %1, align 8
  %20 = load %Mod*, %Mod** %1, align 8
  ret %Mod* %20
}

define dso_local %Parser @Parser_from_lexer(%Lexer* %0) {
  %2 = alloca %Lexer*, align 8
  store %Lexer* %0, %Lexer** %2, align 8
  %3 = alloca %Parser, align 8
  %4 = alloca %Parser, align 8
  %5 = bitcast %Parser* %4 to %VecToken*
  %6 = load %Lexer*, %Lexer** %2, align 8
  %7 = load %Lexer*, %Lexer** %2, align 8
  %8 = call %VecToken @Lexer_collect_tokens(%Lexer* %7)
  store %VecToken %8, %VecToken* %5, align 8
  %9 = getelementptr inbounds %Parser, %Parser* %4, i32 0, i32 1
  store i64 0, i64* %9, align 8
  %10 = load %Parser, %Parser* %4, align 8
  store %Parser %10, %Parser* %3, align 8
  %11 = load %Parser, %Parser* %3, align 8
  ret %Parser %11
}

define dso_local %Parser @Parser_from_tokens(%VecToken* %0) {
  %2 = alloca %VecToken*, align 8
  store %VecToken* %0, %VecToken** %2, align 8
  %3 = alloca %Parser, align 8
  %4 = alloca %Parser, align 8
  %5 = bitcast %Parser* %4 to %VecToken*
  %6 = load %VecToken*, %VecToken** %2, align 8
  %7 = load %VecToken*, %VecToken** %2, align 8
  %8 = call %VecToken @VecToken_clone(%VecToken* %7)
  store %VecToken %8, %VecToken* %5, align 8
  %9 = getelementptr inbounds %Parser, %Parser* %4, i32 0, i32 1
  store i64 0, i64* %9, align 8
  %10 = load %Parser, %Parser* %4, align 8
  store %Parser %10, %Parser* %3, align 8
  %11 = load %Parser, %Parser* %3, align 8
  ret %Parser %11
}

define dso_local %Token @Parser_at(%Parser* %0) {
  %2 = alloca %Parser*, align 8
  store %Parser* %0, %Parser** %2, align 8
  %3 = alloca %Token, align 8
  %4 = load %Parser*, %Parser** %2, align 8
  %5 = bitcast %Parser* %4 to %VecToken*
  %6 = bitcast %VecToken* %5 to %Token**
  %7 = load %Token*, %Token** %6, align 8
  %8 = load %Parser*, %Parser** %2, align 8
  %9 = getelementptr inbounds %Parser, %Parser* %8, i32 0, i32 1
  %10 = load i64, i64* %9, align 8
  %11 = getelementptr inbounds %Token, %Token* %7, i64 %10
  %12 = load %Token, %Token* %11, align 8
  store %Token %12, %Token* %3, align 8
  %13 = load %Token, %Token* %3, align 8
  ret %Token %13
}

define dso_local %Token @Parser_eat(%Parser* %0) {
  %2 = alloca %Parser*, align 8
  store %Parser* %0, %Parser** %2, align 8
  %3 = alloca %Token, align 8
  %4 = load %Parser*, %Parser** %2, align 8
  %5 = bitcast %Parser* %4 to %VecToken*
  %6 = bitcast %VecToken* %5 to %Token**
  %7 = load %Token*, %Token** %6, align 8
  %8 = load %Parser*, %Parser** %2, align 8
  %9 = getelementptr inbounds %Parser, %Parser* %8, i32 0, i32 1
  %10 = load i64, i64* %9, align 8
  %11 = getelementptr inbounds %Token, %Token* %7, i64 %10
  %12 = load %Token, %Token* %11, align 8
  %13 = alloca %Token, align 8
  store %Token %12, %Token* %13, align 8
  %14 = load %Parser*, %Parser** %2, align 8
  %15 = getelementptr inbounds %Parser, %Parser* %14, i32 0, i32 1
  %16 = load %Parser*, %Parser** %2, align 8
  %17 = getelementptr inbounds %Parser, %Parser* %16, i32 0, i32 1
  %18 = load i64, i64* %17, align 8
  %19 = add i64 %18, 1
  store i64 %19, i64* %15, align 8
  %20 = load %Token, %Token* %13, align 8
  store %Token %20, %Token* %3, align 8
  %21 = load %Token, %Token* %3, align 8
  ret %Token %21
}

define dso_local %Token @Parser_peek(%Parser* %0, i64 %1) {
  %3 = alloca %Parser*, align 8
  store %Parser* %0, %Parser** %3, align 8
  %4 = alloca i64, align 8
  store i64 %1, i64* %4, align 8
  %5 = alloca %Token, align 8
  %6 = load %Parser*, %Parser** %3, align 8
  %7 = bitcast %Parser* %6 to %VecToken*
  %8 = bitcast %VecToken* %7 to %Token**
  %9 = load %Token*, %Token** %8, align 8
  %10 = load %Parser*, %Parser** %3, align 8
  %11 = getelementptr inbounds %Parser, %Parser* %10, i32 0, i32 1
  %12 = load i64, i64* %11, align 8
  %13 = load i64, i64* %4, align 8
  %14 = add i64 %12, %13
  %15 = getelementptr inbounds %Token, %Token* %9, i64 %14
  %16 = load %Token, %Token* %15, align 8
  store %Token %16, %Token* %5, align 8
  %17 = load %Token, %Token* %5, align 8
  ret %Token %17
}

define dso_local %AST* @Parser_parse_globals(%Parser* %0) {
  %2 = alloca %Parser*, align 8
  store %Parser* %0, %Parser** %2, align 8
  %3 = alloca %AST*, align 8
  store %AST* null, %AST** %3, align 8
  %4 = load %AST*, %AST** %3, align 8
  ret %AST* %4
}

define dso_local %Mod* @Parser_build_ast(%Parser* %0) {
  %2 = alloca %Parser*, align 8
  store %Parser* %0, %Parser** %2, align 8
  %3 = alloca %Mod*, align 8
  %4 = call %Mod* @Mod_new()
  %5 = alloca %Mod*, align 8
  store %Mod* %4, %Mod** %5, align 8
  %6 = load %Parser*, %Parser** %2, align 8
  %7 = load %Parser*, %Parser** %2, align 8
  %8 = call %Token @Parser_at(%Parser* %7)
  %9 = alloca %Token, align 8
  store %Token %8, %Token* %9, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.block, %1
  %10 = bitcast %Token* %9 to i32*
  %11 = load i32, i32* %10, align 4
  %12 = icmp ne i32 %11, 57
  br i1 %12, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %13 = load %Mod*, %Mod** %5, align 8
  %14 = getelementptr inbounds %Mod, %Mod* %13, i32 0, i32 2
  %15 = load %Mod*, %Mod** %5, align 8
  %16 = getelementptr inbounds %Mod, %Mod* %15, i32 0, i32 2
  %17 = load %Parser*, %Parser** %2, align 8
  %18 = load %Parser*, %Parser** %2, align 8
  %19 = call %AST* @Parser_parse_globals(%Parser* %18)
  call void @Block_push(%Block* %16, %AST* %19)
  %20 = load %Parser*, %Parser** %2, align 8
  %21 = load %Parser*, %Parser** %2, align 8
  %22 = call %Token @Parser_at(%Parser* %21)
  store %Token %22, %Token* %9, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %23 = load %Mod*, %Mod** %5, align 8
  store %Mod* %23, %Mod** %3, align 8
  %24 = load %Mod*, %Mod** %3, align 8
  ret %Mod* %24
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
  store i8* getelementptr inbounds ([20 x i8], [20 x i8]* @54, i32 0, i32 0), i8** %6, align 8
  %7 = call %Ctx @Ctx_init(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @55, i32 0, i32 0))
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
  %20 = call i8* @Ctx_add_function(%Ctx* %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @56, i32 0, i32 0), i8* %19)
  %21 = call %String @String_from(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @58, i32 0, i32 0))
  %22 = call %Lexer @Lexer_new(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @57, i32 0, i32 0), i32 19, %String %21)
  %23 = alloca %Lexer, align 8
  store %Lexer %22, %Lexer* %23, align 8
  %24 = getelementptr inbounds %Lexer, %Lexer* %23, i32 0, i32 1
  %25 = load i8*, i8** %24, align 8
  %26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @59, i32 0, i32 0), i8* %25)
  %27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @60, i32 0, i32 0))
  %28 = call %VecToken @Lexer_collect_tokens(%Lexer* %23)
  %29 = alloca %VecToken, align 8
  store %VecToken %28, %VecToken* %29, align 8
  %30 = alloca i32, align 4
  store i32 0, i32* %30, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.block, %2
  %31 = getelementptr inbounds %VecToken, %VecToken* %29, i32 0, i32 2
  %32 = load i32, i32* %30, align 4
  %33 = load i32, i32* %31, align 4
  %34 = icmp slt i32 %32, %33
  br i1 %34, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %35 = bitcast %VecToken* %29 to %Token**
  %36 = load %Token*, %Token** %35, align 8
  %37 = load i32, i32* %30, align 4
  %38 = getelementptr inbounds %Token, %Token* %36, i32 %37
  %39 = load %Token, %Token* %38, align 8
  %40 = alloca %Token, align 8
  store %Token %39, %Token* %40, align 8
  %41 = getelementptr inbounds %Token, %Token* %40, i32 0, i32 2
  %42 = bitcast %Loc* %41 to %String**
  %43 = load %String*, %String** %42, align 8
  %44 = bitcast %String* %43 to i8**
  %45 = load i8*, i8** %44, align 8
  %46 = getelementptr inbounds %Token, %Token* %40, i32 0, i32 2
  %47 = getelementptr inbounds %Loc, %Loc* %46, i32 0, i32 1
  %48 = load i64, i64* %47, align 8
  %49 = getelementptr inbounds %Token, %Token* %40, i32 0, i32 2
  %50 = getelementptr inbounds %Loc, %Loc* %49, i32 0, i32 2
  %51 = load i64, i64* %50, align 8
  %52 = bitcast %Token* %40 to i32*
  %53 = load i32, i32* %52, align 4
  %54 = getelementptr inbounds %Token, %Token* %40, i32 0, i32 1
  %55 = bitcast %String* %54 to i8**
  %56 = load i8*, i8** %55, align 8
  %57 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([27 x i8], [27 x i8]* @61, i32 0, i32 0), i8* %45, i64 %48, i64 %51, i32 %53, i8* %56)
  %58 = load i32, i32* %30, align 4
  %59 = add i32 %58, 1
  store i32 %59, i32* %30, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %5, align 4
  %60 = load i32, i32* %5, align 4
  ret i32 %60
}
