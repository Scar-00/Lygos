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
@57 = private unnamed_addr constant [12 x i8] c"let x = 10;\00", align 1
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

for.cond:                                         ; preds = %if.end82, %1
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

for.cond1:                                        ; preds = %if.end, %for.block
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
  br i1 %33, label %if.then, label %if.end

for.end3:                                         ; preds = %for.cond1
  %34 = load %Lexer*, %Lexer** %2, align 8
  %35 = getelementptr inbounds %Lexer, %Lexer* %34, i32 0, i32 3
  %36 = load i8, i8* %35, align 1
  %37 = icmp eq i8 %36, 46
  br i1 %37, label %if.then4, label %if.end5

if.then:                                          ; preds = %for.block2
  %38 = load %Lexer*, %Lexer** %2, align 8
  %39 = getelementptr inbounds %Lexer, %Lexer* %38, i32 0, i32 5
  %40 = load %Lexer*, %Lexer** %2, align 8
  %41 = getelementptr inbounds %Lexer, %Lexer* %40, i32 0, i32 5
  %42 = load i64, i64* %41, align 8
  %43 = add i64 %42, 1
  store i64 %43, i64* %39, align 8
  %44 = load %Lexer*, %Lexer** %2, align 8
  %45 = getelementptr inbounds %Lexer, %Lexer* %44, i32 0, i32 6
  store i64 0, i64* %45, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %for.block2
  %46 = load %Lexer*, %Lexer** %2, align 8
  %47 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %47)
  br label %for.cond1

if.then4:                                         ; preds = %for.end3
  %48 = load %Lexer*, %Lexer** %2, align 8
  %49 = load %Lexer*, %Lexer** %2, align 8
  %50 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @21, i32 0, i32 0))
  %51 = load %Lexer*, %Lexer** %2, align 8
  %52 = bitcast %Lexer* %51 to %String*
  %53 = load %Lexer*, %Lexer** %2, align 8
  %54 = getelementptr inbounds %Lexer, %Lexer* %53, i32 0, i32 5
  %55 = load i64, i64* %54, align 8
  %56 = load %Lexer*, %Lexer** %2, align 8
  %57 = getelementptr inbounds %Lexer, %Lexer* %56, i32 0, i32 6
  %58 = load i64, i64* %57, align 8
  %59 = call %Loc @Loc_new(%String* %52, i64 %55, i64 %58, i64 0)
  %60 = call %Token @Token_new(%String %50, i32 7, %Loc %59)
  %61 = call %Token @Lexer_advance_token(%Lexer* %49, %Token %60)
  store %Token %61, %Token* %3, align 8
  br label %ret

if.end5:                                          ; preds = %for.end3
  %62 = load %Lexer*, %Lexer** %2, align 8
  %63 = getelementptr inbounds %Lexer, %Lexer* %62, i32 0, i32 3
  %64 = load i8, i8* %63, align 1
  %65 = icmp eq i8 %64, 44
  br i1 %65, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end5
  %66 = load %Lexer*, %Lexer** %2, align 8
  %67 = load %Lexer*, %Lexer** %2, align 8
  %68 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @22, i32 0, i32 0))
  %69 = load %Lexer*, %Lexer** %2, align 8
  %70 = bitcast %Lexer* %69 to %String*
  %71 = load %Lexer*, %Lexer** %2, align 8
  %72 = getelementptr inbounds %Lexer, %Lexer* %71, i32 0, i32 5
  %73 = load i64, i64* %72, align 8
  %74 = load %Lexer*, %Lexer** %2, align 8
  %75 = getelementptr inbounds %Lexer, %Lexer* %74, i32 0, i32 6
  %76 = load i64, i64* %75, align 8
  %77 = call %Loc @Loc_new(%String* %70, i64 %73, i64 %76, i64 0)
  %78 = call %Token @Token_new(%String %68, i32 8, %Loc %77)
  %79 = call %Token @Lexer_advance_token(%Lexer* %67, %Token %78)
  store %Token %79, %Token* %3, align 8
  br label %ret

if.end7:                                          ; preds = %if.end5
  %80 = load %Lexer*, %Lexer** %2, align 8
  %81 = getelementptr inbounds %Lexer, %Lexer* %80, i32 0, i32 3
  %82 = load i8, i8* %81, align 1
  %83 = icmp eq i8 %82, 59
  br i1 %83, label %if.then8, label %if.end9

if.then8:                                         ; preds = %if.end7
  %84 = load %Lexer*, %Lexer** %2, align 8
  %85 = load %Lexer*, %Lexer** %2, align 8
  %86 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @23, i32 0, i32 0))
  %87 = load %Lexer*, %Lexer** %2, align 8
  %88 = bitcast %Lexer* %87 to %String*
  %89 = load %Lexer*, %Lexer** %2, align 8
  %90 = getelementptr inbounds %Lexer, %Lexer* %89, i32 0, i32 5
  %91 = load i64, i64* %90, align 8
  %92 = load %Lexer*, %Lexer** %2, align 8
  %93 = getelementptr inbounds %Lexer, %Lexer* %92, i32 0, i32 6
  %94 = load i64, i64* %93, align 8
  %95 = call %Loc @Loc_new(%String* %88, i64 %91, i64 %94, i64 0)
  %96 = call %Token @Token_new(%String %86, i32 9, %Loc %95)
  %97 = call %Token @Lexer_advance_token(%Lexer* %85, %Token %96)
  store %Token %97, %Token* %3, align 8
  br label %ret

if.end9:                                          ; preds = %if.end7
  %98 = load %Lexer*, %Lexer** %2, align 8
  %99 = getelementptr inbounds %Lexer, %Lexer* %98, i32 0, i32 3
  %100 = load i8, i8* %99, align 1
  %101 = icmp eq i8 %100, 58
  br i1 %101, label %if.then10, label %if.end11

if.then10:                                        ; preds = %if.end9
  %102 = load %Lexer*, %Lexer** %2, align 8
  %103 = getelementptr inbounds %Lexer, %Lexer* %102, i32 0, i32 1
  %104 = load i8*, i8** %103, align 8
  %105 = load %Lexer*, %Lexer** %2, align 8
  %106 = getelementptr inbounds %Lexer, %Lexer* %105, i32 0, i32 4
  %107 = load i32, i32* %106, align 4
  %108 = add i32 %107, 1
  %109 = getelementptr inbounds i8, i8* %104, i32 %108
  %110 = load i8, i8* %109, align 1
  %111 = icmp eq i8 %110, 58
  br i1 %111, label %if.then12, label %if.end14

if.end11:                                         ; preds = %if.end9
  %112 = load %Lexer*, %Lexer** %2, align 8
  %113 = getelementptr inbounds %Lexer, %Lexer* %112, i32 0, i32 3
  %114 = load i8, i8* %113, align 1
  %115 = icmp eq i8 %114, 43
  br i1 %115, label %if.then15, label %if.end16

if.then12:                                        ; preds = %if.then10
  %116 = load %Lexer*, %Lexer** %2, align 8
  %117 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %117)
  %118 = load %Lexer*, %Lexer** %2, align 8
  %119 = load %Lexer*, %Lexer** %2, align 8
  %120 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @24, i32 0, i32 0))
  %121 = load %Lexer*, %Lexer** %2, align 8
  %122 = bitcast %Lexer* %121 to %String*
  %123 = load %Lexer*, %Lexer** %2, align 8
  %124 = getelementptr inbounds %Lexer, %Lexer* %123, i32 0, i32 5
  %125 = load i64, i64* %124, align 8
  %126 = load %Lexer*, %Lexer** %2, align 8
  %127 = getelementptr inbounds %Lexer, %Lexer* %126, i32 0, i32 6
  %128 = load i64, i64* %127, align 8
  %129 = call %Loc @Loc_new(%String* %122, i64 %125, i64 %128, i64 0)
  %130 = call %Token @Token_new(%String %120, i32 27, %Loc %129)
  %131 = call %Token @Lexer_advance_token(%Lexer* %119, %Token %130)
  store %Token %131, %Token* %3, align 8
  br label %ret

if.end14:                                         ; preds = %if.then10
  %132 = load %Lexer*, %Lexer** %2, align 8
  %133 = load %Lexer*, %Lexer** %2, align 8
  %134 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @25, i32 0, i32 0))
  %135 = load %Lexer*, %Lexer** %2, align 8
  %136 = bitcast %Lexer* %135 to %String*
  %137 = load %Lexer*, %Lexer** %2, align 8
  %138 = getelementptr inbounds %Lexer, %Lexer* %137, i32 0, i32 5
  %139 = load i64, i64* %138, align 8
  %140 = load %Lexer*, %Lexer** %2, align 8
  %141 = getelementptr inbounds %Lexer, %Lexer* %140, i32 0, i32 6
  %142 = load i64, i64* %141, align 8
  %143 = call %Loc @Loc_new(%String* %136, i64 %139, i64 %142, i64 0)
  %144 = call %Token @Token_new(%String %134, i32 10, %Loc %143)
  %145 = call %Token @Lexer_advance_token(%Lexer* %133, %Token %144)
  store %Token %145, %Token* %3, align 8
  br label %ret

if.then15:                                        ; preds = %if.end11
  %146 = load %Lexer*, %Lexer** %2, align 8
  %147 = load %Lexer*, %Lexer** %2, align 8
  %148 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @26, i32 0, i32 0))
  %149 = load %Lexer*, %Lexer** %2, align 8
  %150 = bitcast %Lexer* %149 to %String*
  %151 = load %Lexer*, %Lexer** %2, align 8
  %152 = getelementptr inbounds %Lexer, %Lexer* %151, i32 0, i32 5
  %153 = load i64, i64* %152, align 8
  %154 = load %Lexer*, %Lexer** %2, align 8
  %155 = getelementptr inbounds %Lexer, %Lexer* %154, i32 0, i32 6
  %156 = load i64, i64* %155, align 8
  %157 = call %Loc @Loc_new(%String* %150, i64 %153, i64 %156, i64 0)
  %158 = call %Token @Token_new(%String %148, i32 16, %Loc %157)
  %159 = call %Token @Lexer_advance_token(%Lexer* %147, %Token %158)
  store %Token %159, %Token* %3, align 8
  br label %ret

if.end16:                                         ; preds = %if.end11
  %160 = load %Lexer*, %Lexer** %2, align 8
  %161 = getelementptr inbounds %Lexer, %Lexer* %160, i32 0, i32 3
  %162 = load i8, i8* %161, align 1
  %163 = icmp eq i8 %162, 45
  br i1 %163, label %if.then17, label %if.end18

if.then17:                                        ; preds = %if.end16
  %164 = load %Lexer*, %Lexer** %2, align 8
  %165 = getelementptr inbounds %Lexer, %Lexer* %164, i32 0, i32 1
  %166 = load i8*, i8** %165, align 8
  %167 = load %Lexer*, %Lexer** %2, align 8
  %168 = getelementptr inbounds %Lexer, %Lexer* %167, i32 0, i32 4
  %169 = load i32, i32* %168, align 4
  %170 = add i32 %169, 1
  %171 = getelementptr inbounds i8, i8* %166, i32 %170
  %172 = load i8, i8* %171, align 1
  %173 = icmp eq i8 %172, 62
  br i1 %173, label %if.then19, label %if.end21

if.end18:                                         ; preds = %if.end16
  %174 = load %Lexer*, %Lexer** %2, align 8
  %175 = getelementptr inbounds %Lexer, %Lexer* %174, i32 0, i32 3
  %176 = load i8, i8* %175, align 1
  %177 = icmp eq i8 %176, 42
  br i1 %177, label %if.then22, label %if.end23

if.then19:                                        ; preds = %if.then17
  %178 = load %Lexer*, %Lexer** %2, align 8
  %179 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %179)
  %180 = load %Lexer*, %Lexer** %2, align 8
  %181 = load %Lexer*, %Lexer** %2, align 8
  %182 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @27, i32 0, i32 0))
  %183 = load %Lexer*, %Lexer** %2, align 8
  %184 = bitcast %Lexer* %183 to %String*
  %185 = load %Lexer*, %Lexer** %2, align 8
  %186 = getelementptr inbounds %Lexer, %Lexer* %185, i32 0, i32 5
  %187 = load i64, i64* %186, align 8
  %188 = load %Lexer*, %Lexer** %2, align 8
  %189 = getelementptr inbounds %Lexer, %Lexer* %188, i32 0, i32 6
  %190 = load i64, i64* %189, align 8
  %191 = call %Loc @Loc_new(%String* %184, i64 %187, i64 %190, i64 0)
  %192 = call %Token @Token_new(%String %182, i32 6, %Loc %191)
  %193 = call %Token @Lexer_advance_token(%Lexer* %181, %Token %192)
  store %Token %193, %Token* %3, align 8
  br label %ret

if.end21:                                         ; preds = %if.then17
  %194 = load %Lexer*, %Lexer** %2, align 8
  %195 = load %Lexer*, %Lexer** %2, align 8
  %196 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @28, i32 0, i32 0))
  %197 = load %Lexer*, %Lexer** %2, align 8
  %198 = bitcast %Lexer* %197 to %String*
  %199 = load %Lexer*, %Lexer** %2, align 8
  %200 = getelementptr inbounds %Lexer, %Lexer* %199, i32 0, i32 5
  %201 = load i64, i64* %200, align 8
  %202 = load %Lexer*, %Lexer** %2, align 8
  %203 = getelementptr inbounds %Lexer, %Lexer* %202, i32 0, i32 6
  %204 = load i64, i64* %203, align 8
  %205 = call %Loc @Loc_new(%String* %198, i64 %201, i64 %204, i64 0)
  %206 = call %Token @Token_new(%String %196, i32 17, %Loc %205)
  %207 = call %Token @Lexer_advance_token(%Lexer* %195, %Token %206)
  store %Token %207, %Token* %3, align 8
  br label %ret

if.then22:                                        ; preds = %if.end18
  %208 = load %Lexer*, %Lexer** %2, align 8
  %209 = load %Lexer*, %Lexer** %2, align 8
  %210 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @29, i32 0, i32 0))
  %211 = load %Lexer*, %Lexer** %2, align 8
  %212 = bitcast %Lexer* %211 to %String*
  %213 = load %Lexer*, %Lexer** %2, align 8
  %214 = getelementptr inbounds %Lexer, %Lexer* %213, i32 0, i32 5
  %215 = load i64, i64* %214, align 8
  %216 = load %Lexer*, %Lexer** %2, align 8
  %217 = getelementptr inbounds %Lexer, %Lexer* %216, i32 0, i32 6
  %218 = load i64, i64* %217, align 8
  %219 = call %Loc @Loc_new(%String* %212, i64 %215, i64 %218, i64 0)
  %220 = call %Token @Token_new(%String %210, i32 18, %Loc %219)
  %221 = call %Token @Lexer_advance_token(%Lexer* %209, %Token %220)
  store %Token %221, %Token* %3, align 8
  br label %ret

if.end23:                                         ; preds = %if.end18
  %222 = load %Lexer*, %Lexer** %2, align 8
  %223 = getelementptr inbounds %Lexer, %Lexer* %222, i32 0, i32 3
  %224 = load i8, i8* %223, align 1
  %225 = icmp eq i8 %224, 47
  br i1 %225, label %if.then24, label %if.end25

if.then24:                                        ; preds = %if.end23
  %226 = load %Lexer*, %Lexer** %2, align 8
  %227 = load %Lexer*, %Lexer** %2, align 8
  %228 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @30, i32 0, i32 0))
  %229 = load %Lexer*, %Lexer** %2, align 8
  %230 = bitcast %Lexer* %229 to %String*
  %231 = load %Lexer*, %Lexer** %2, align 8
  %232 = getelementptr inbounds %Lexer, %Lexer* %231, i32 0, i32 5
  %233 = load i64, i64* %232, align 8
  %234 = load %Lexer*, %Lexer** %2, align 8
  %235 = getelementptr inbounds %Lexer, %Lexer* %234, i32 0, i32 6
  %236 = load i64, i64* %235, align 8
  %237 = call %Loc @Loc_new(%String* %230, i64 %233, i64 %236, i64 0)
  %238 = call %Token @Token_new(%String %228, i32 19, %Loc %237)
  %239 = call %Token @Lexer_advance_token(%Lexer* %227, %Token %238)
  store %Token %239, %Token* %3, align 8
  br label %ret

if.end25:                                         ; preds = %if.end23
  %240 = load %Lexer*, %Lexer** %2, align 8
  %241 = getelementptr inbounds %Lexer, %Lexer* %240, i32 0, i32 3
  %242 = load i8, i8* %241, align 1
  %243 = icmp eq i8 %242, 37
  br i1 %243, label %if.then29, label %if.end30

if.then29:                                        ; preds = %if.end25
  %244 = load %Lexer*, %Lexer** %2, align 8
  %245 = load %Lexer*, %Lexer** %2, align 8
  %246 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @31, i32 0, i32 0))
  %247 = load %Lexer*, %Lexer** %2, align 8
  %248 = bitcast %Lexer* %247 to %String*
  %249 = load %Lexer*, %Lexer** %2, align 8
  %250 = getelementptr inbounds %Lexer, %Lexer* %249, i32 0, i32 5
  %251 = load i64, i64* %250, align 8
  %252 = load %Lexer*, %Lexer** %2, align 8
  %253 = getelementptr inbounds %Lexer, %Lexer* %252, i32 0, i32 6
  %254 = load i64, i64* %253, align 8
  %255 = call %Loc @Loc_new(%String* %248, i64 %251, i64 %254, i64 0)
  %256 = call %Token @Token_new(%String %246, i32 20, %Loc %255)
  %257 = call %Token @Lexer_advance_token(%Lexer* %245, %Token %256)
  store %Token %257, %Token* %3, align 8
  br label %ret

if.end30:                                         ; preds = %if.end25
  %258 = load %Lexer*, %Lexer** %2, align 8
  %259 = getelementptr inbounds %Lexer, %Lexer* %258, i32 0, i32 3
  %260 = load i8, i8* %259, align 1
  %261 = icmp eq i8 %260, 91
  br i1 %261, label %if.then31, label %if.end32

if.then31:                                        ; preds = %if.end30
  %262 = load %Lexer*, %Lexer** %2, align 8
  %263 = load %Lexer*, %Lexer** %2, align 8
  %264 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @32, i32 0, i32 0))
  %265 = load %Lexer*, %Lexer** %2, align 8
  %266 = bitcast %Lexer* %265 to %String*
  %267 = load %Lexer*, %Lexer** %2, align 8
  %268 = getelementptr inbounds %Lexer, %Lexer* %267, i32 0, i32 5
  %269 = load i64, i64* %268, align 8
  %270 = load %Lexer*, %Lexer** %2, align 8
  %271 = getelementptr inbounds %Lexer, %Lexer* %270, i32 0, i32 6
  %272 = load i64, i64* %271, align 8
  %273 = call %Loc @Loc_new(%String* %266, i64 %269, i64 %272, i64 0)
  %274 = call %Token @Token_new(%String %264, i32 29, %Loc %273)
  %275 = call %Token @Lexer_advance_token(%Lexer* %263, %Token %274)
  store %Token %275, %Token* %3, align 8
  br label %ret

if.end32:                                         ; preds = %if.end30
  %276 = load %Lexer*, %Lexer** %2, align 8
  %277 = getelementptr inbounds %Lexer, %Lexer* %276, i32 0, i32 3
  %278 = load i8, i8* %277, align 1
  %279 = icmp eq i8 %278, 93
  br i1 %279, label %if.then33, label %if.end34

if.then33:                                        ; preds = %if.end32
  %280 = load %Lexer*, %Lexer** %2, align 8
  %281 = load %Lexer*, %Lexer** %2, align 8
  %282 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @33, i32 0, i32 0))
  %283 = load %Lexer*, %Lexer** %2, align 8
  %284 = bitcast %Lexer* %283 to %String*
  %285 = load %Lexer*, %Lexer** %2, align 8
  %286 = getelementptr inbounds %Lexer, %Lexer* %285, i32 0, i32 5
  %287 = load i64, i64* %286, align 8
  %288 = load %Lexer*, %Lexer** %2, align 8
  %289 = getelementptr inbounds %Lexer, %Lexer* %288, i32 0, i32 6
  %290 = load i64, i64* %289, align 8
  %291 = call %Loc @Loc_new(%String* %284, i64 %287, i64 %290, i64 0)
  %292 = call %Token @Token_new(%String %282, i32 30, %Loc %291)
  %293 = call %Token @Lexer_advance_token(%Lexer* %281, %Token %292)
  store %Token %293, %Token* %3, align 8
  br label %ret

if.end34:                                         ; preds = %if.end32
  %294 = load %Lexer*, %Lexer** %2, align 8
  %295 = getelementptr inbounds %Lexer, %Lexer* %294, i32 0, i32 3
  %296 = load i8, i8* %295, align 1
  %297 = icmp eq i8 %296, 123
  br i1 %297, label %if.then35, label %if.end36

if.then35:                                        ; preds = %if.end34
  %298 = load %Lexer*, %Lexer** %2, align 8
  %299 = load %Lexer*, %Lexer** %2, align 8
  %300 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @34, i32 0, i32 0))
  %301 = load %Lexer*, %Lexer** %2, align 8
  %302 = bitcast %Lexer* %301 to %String*
  %303 = load %Lexer*, %Lexer** %2, align 8
  %304 = getelementptr inbounds %Lexer, %Lexer* %303, i32 0, i32 5
  %305 = load i64, i64* %304, align 8
  %306 = load %Lexer*, %Lexer** %2, align 8
  %307 = getelementptr inbounds %Lexer, %Lexer* %306, i32 0, i32 6
  %308 = load i64, i64* %307, align 8
  %309 = call %Loc @Loc_new(%String* %302, i64 %305, i64 %308, i64 0)
  %310 = call %Token @Token_new(%String %300, i32 31, %Loc %309)
  %311 = call %Token @Lexer_advance_token(%Lexer* %299, %Token %310)
  store %Token %311, %Token* %3, align 8
  br label %ret

if.end36:                                         ; preds = %if.end34
  %312 = load %Lexer*, %Lexer** %2, align 8
  %313 = getelementptr inbounds %Lexer, %Lexer* %312, i32 0, i32 3
  %314 = load i8, i8* %313, align 1
  %315 = icmp eq i8 %314, 125
  br i1 %315, label %if.then37, label %if.end38

if.then37:                                        ; preds = %if.end36
  %316 = load %Lexer*, %Lexer** %2, align 8
  %317 = load %Lexer*, %Lexer** %2, align 8
  %318 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @35, i32 0, i32 0))
  %319 = load %Lexer*, %Lexer** %2, align 8
  %320 = bitcast %Lexer* %319 to %String*
  %321 = load %Lexer*, %Lexer** %2, align 8
  %322 = getelementptr inbounds %Lexer, %Lexer* %321, i32 0, i32 5
  %323 = load i64, i64* %322, align 8
  %324 = load %Lexer*, %Lexer** %2, align 8
  %325 = getelementptr inbounds %Lexer, %Lexer* %324, i32 0, i32 6
  %326 = load i64, i64* %325, align 8
  %327 = call %Loc @Loc_new(%String* %320, i64 %323, i64 %326, i64 0)
  %328 = call %Token @Token_new(%String %318, i32 32, %Loc %327)
  %329 = call %Token @Lexer_advance_token(%Lexer* %317, %Token %328)
  store %Token %329, %Token* %3, align 8
  br label %ret

if.end38:                                         ; preds = %if.end36
  %330 = load %Lexer*, %Lexer** %2, align 8
  %331 = getelementptr inbounds %Lexer, %Lexer* %330, i32 0, i32 3
  %332 = load i8, i8* %331, align 1
  %333 = icmp eq i8 %332, 40
  br i1 %333, label %if.then39, label %if.end40

if.then39:                                        ; preds = %if.end38
  %334 = load %Lexer*, %Lexer** %2, align 8
  %335 = load %Lexer*, %Lexer** %2, align 8
  %336 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @36, i32 0, i32 0))
  %337 = load %Lexer*, %Lexer** %2, align 8
  %338 = bitcast %Lexer* %337 to %String*
  %339 = load %Lexer*, %Lexer** %2, align 8
  %340 = getelementptr inbounds %Lexer, %Lexer* %339, i32 0, i32 5
  %341 = load i64, i64* %340, align 8
  %342 = load %Lexer*, %Lexer** %2, align 8
  %343 = getelementptr inbounds %Lexer, %Lexer* %342, i32 0, i32 6
  %344 = load i64, i64* %343, align 8
  %345 = call %Loc @Loc_new(%String* %338, i64 %341, i64 %344, i64 0)
  %346 = call %Token @Token_new(%String %336, i32 35, %Loc %345)
  %347 = call %Token @Lexer_advance_token(%Lexer* %335, %Token %346)
  store %Token %347, %Token* %3, align 8
  br label %ret

if.end40:                                         ; preds = %if.end38
  %348 = load %Lexer*, %Lexer** %2, align 8
  %349 = getelementptr inbounds %Lexer, %Lexer* %348, i32 0, i32 3
  %350 = load i8, i8* %349, align 1
  %351 = icmp eq i8 %350, 41
  br i1 %351, label %if.then41, label %if.end42

if.then41:                                        ; preds = %if.end40
  %352 = load %Lexer*, %Lexer** %2, align 8
  %353 = load %Lexer*, %Lexer** %2, align 8
  %354 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @37, i32 0, i32 0))
  %355 = load %Lexer*, %Lexer** %2, align 8
  %356 = bitcast %Lexer* %355 to %String*
  %357 = load %Lexer*, %Lexer** %2, align 8
  %358 = getelementptr inbounds %Lexer, %Lexer* %357, i32 0, i32 5
  %359 = load i64, i64* %358, align 8
  %360 = load %Lexer*, %Lexer** %2, align 8
  %361 = getelementptr inbounds %Lexer, %Lexer* %360, i32 0, i32 6
  %362 = load i64, i64* %361, align 8
  %363 = call %Loc @Loc_new(%String* %356, i64 %359, i64 %362, i64 0)
  %364 = call %Token @Token_new(%String %354, i32 36, %Loc %363)
  %365 = call %Token @Lexer_advance_token(%Lexer* %353, %Token %364)
  store %Token %365, %Token* %3, align 8
  br label %ret

if.end42:                                         ; preds = %if.end40
  %366 = load %Lexer*, %Lexer** %2, align 8
  %367 = getelementptr inbounds %Lexer, %Lexer* %366, i32 0, i32 3
  %368 = load i8, i8* %367, align 1
  %369 = icmp eq i8 %368, 35
  br i1 %369, label %if.then43, label %if.end44

if.then43:                                        ; preds = %if.end42
  %370 = load %Lexer*, %Lexer** %2, align 8
  %371 = load %Lexer*, %Lexer** %2, align 8
  %372 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @38, i32 0, i32 0))
  %373 = load %Lexer*, %Lexer** %2, align 8
  %374 = bitcast %Lexer* %373 to %String*
  %375 = load %Lexer*, %Lexer** %2, align 8
  %376 = getelementptr inbounds %Lexer, %Lexer* %375, i32 0, i32 5
  %377 = load i64, i64* %376, align 8
  %378 = load %Lexer*, %Lexer** %2, align 8
  %379 = getelementptr inbounds %Lexer, %Lexer* %378, i32 0, i32 6
  %380 = load i64, i64* %379, align 8
  %381 = call %Loc @Loc_new(%String* %374, i64 %377, i64 %380, i64 0)
  %382 = call %Token @Token_new(%String %372, i32 12, %Loc %381)
  %383 = call %Token @Lexer_advance_token(%Lexer* %371, %Token %382)
  store %Token %383, %Token* %3, align 8
  br label %ret

if.end44:                                         ; preds = %if.end42
  %384 = load %Lexer*, %Lexer** %2, align 8
  %385 = getelementptr inbounds %Lexer, %Lexer* %384, i32 0, i32 3
  %386 = load i8, i8* %385, align 1
  %387 = icmp eq i8 %386, 36
  br i1 %387, label %if.then45, label %if.end46

if.then45:                                        ; preds = %if.end44
  %388 = load %Lexer*, %Lexer** %2, align 8
  %389 = load %Lexer*, %Lexer** %2, align 8
  %390 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @39, i32 0, i32 0))
  %391 = load %Lexer*, %Lexer** %2, align 8
  %392 = bitcast %Lexer* %391 to %String*
  %393 = load %Lexer*, %Lexer** %2, align 8
  %394 = getelementptr inbounds %Lexer, %Lexer* %393, i32 0, i32 5
  %395 = load i64, i64* %394, align 8
  %396 = load %Lexer*, %Lexer** %2, align 8
  %397 = getelementptr inbounds %Lexer, %Lexer* %396, i32 0, i32 6
  %398 = load i64, i64* %397, align 8
  %399 = call %Loc @Loc_new(%String* %392, i64 %395, i64 %398, i64 0)
  %400 = call %Token @Token_new(%String %390, i32 13, %Loc %399)
  %401 = call %Token @Lexer_advance_token(%Lexer* %389, %Token %400)
  store %Token %401, %Token* %3, align 8
  br label %ret

if.end46:                                         ; preds = %if.end44
  %402 = load %Lexer*, %Lexer** %2, align 8
  %403 = getelementptr inbounds %Lexer, %Lexer* %402, i32 0, i32 3
  %404 = load i8, i8* %403, align 1
  %405 = icmp eq i8 %404, 60
  br i1 %405, label %if.then47, label %if.end48

if.then47:                                        ; preds = %if.end46
  %406 = load %Lexer*, %Lexer** %2, align 8
  %407 = getelementptr inbounds %Lexer, %Lexer* %406, i32 0, i32 1
  %408 = load i8*, i8** %407, align 8
  %409 = load %Lexer*, %Lexer** %2, align 8
  %410 = getelementptr inbounds %Lexer, %Lexer* %409, i32 0, i32 4
  %411 = load i32, i32* %410, align 4
  %412 = add i32 %411, 1
  %413 = getelementptr inbounds i8, i8* %408, i32 %412
  %414 = load i8, i8* %413, align 1
  %415 = icmp eq i8 %414, 61
  br i1 %415, label %if.then49, label %if.end51

if.end48:                                         ; preds = %if.end46
  %416 = load %Lexer*, %Lexer** %2, align 8
  %417 = getelementptr inbounds %Lexer, %Lexer* %416, i32 0, i32 3
  %418 = load i8, i8* %417, align 1
  %419 = icmp eq i8 %418, 62
  br i1 %419, label %if.then52, label %if.end53

if.then49:                                        ; preds = %if.then47
  %420 = load %Lexer*, %Lexer** %2, align 8
  %421 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %421)
  %422 = load %Lexer*, %Lexer** %2, align 8
  %423 = load %Lexer*, %Lexer** %2, align 8
  %424 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @40, i32 0, i32 0))
  %425 = load %Lexer*, %Lexer** %2, align 8
  %426 = bitcast %Lexer* %425 to %String*
  %427 = load %Lexer*, %Lexer** %2, align 8
  %428 = getelementptr inbounds %Lexer, %Lexer* %427, i32 0, i32 5
  %429 = load i64, i64* %428, align 8
  %430 = load %Lexer*, %Lexer** %2, align 8
  %431 = getelementptr inbounds %Lexer, %Lexer* %430, i32 0, i32 6
  %432 = load i64, i64* %431, align 8
  %433 = call %Loc @Loc_new(%String* %426, i64 %429, i64 %432, i64 0)
  %434 = call %Token @Token_new(%String %424, i32 23, %Loc %433)
  %435 = call %Token @Lexer_advance_token(%Lexer* %423, %Token %434)
  store %Token %435, %Token* %3, align 8
  br label %ret

if.end51:                                         ; preds = %if.then47
  %436 = load %Lexer*, %Lexer** %2, align 8
  %437 = load %Lexer*, %Lexer** %2, align 8
  %438 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @41, i32 0, i32 0))
  %439 = load %Lexer*, %Lexer** %2, align 8
  %440 = bitcast %Lexer* %439 to %String*
  %441 = load %Lexer*, %Lexer** %2, align 8
  %442 = getelementptr inbounds %Lexer, %Lexer* %441, i32 0, i32 5
  %443 = load i64, i64* %442, align 8
  %444 = load %Lexer*, %Lexer** %2, align 8
  %445 = getelementptr inbounds %Lexer, %Lexer* %444, i32 0, i32 6
  %446 = load i64, i64* %445, align 8
  %447 = call %Loc @Loc_new(%String* %440, i64 %443, i64 %446, i64 0)
  %448 = call %Token @Token_new(%String %438, i32 33, %Loc %447)
  %449 = call %Token @Lexer_advance_token(%Lexer* %437, %Token %448)
  store %Token %449, %Token* %3, align 8
  br label %ret

if.then52:                                        ; preds = %if.end48
  %450 = load %Lexer*, %Lexer** %2, align 8
  %451 = getelementptr inbounds %Lexer, %Lexer* %450, i32 0, i32 1
  %452 = load i8*, i8** %451, align 8
  %453 = load %Lexer*, %Lexer** %2, align 8
  %454 = getelementptr inbounds %Lexer, %Lexer* %453, i32 0, i32 4
  %455 = load i32, i32* %454, align 4
  %456 = add i32 %455, 1
  %457 = getelementptr inbounds i8, i8* %452, i32 %456
  %458 = load i8, i8* %457, align 1
  %459 = icmp eq i8 %458, 61
  br i1 %459, label %if.then54, label %if.end56

if.end53:                                         ; preds = %if.end48
  %460 = load %Lexer*, %Lexer** %2, align 8
  %461 = getelementptr inbounds %Lexer, %Lexer* %460, i32 0, i32 3
  %462 = load i8, i8* %461, align 1
  %463 = icmp eq i8 %462, 38
  br i1 %463, label %if.then57, label %if.end58

if.then54:                                        ; preds = %if.then52
  %464 = load %Lexer*, %Lexer** %2, align 8
  %465 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %465)
  %466 = load %Lexer*, %Lexer** %2, align 8
  %467 = load %Lexer*, %Lexer** %2, align 8
  %468 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @42, i32 0, i32 0))
  %469 = load %Lexer*, %Lexer** %2, align 8
  %470 = bitcast %Lexer* %469 to %String*
  %471 = load %Lexer*, %Lexer** %2, align 8
  %472 = getelementptr inbounds %Lexer, %Lexer* %471, i32 0, i32 5
  %473 = load i64, i64* %472, align 8
  %474 = load %Lexer*, %Lexer** %2, align 8
  %475 = getelementptr inbounds %Lexer, %Lexer* %474, i32 0, i32 6
  %476 = load i64, i64* %475, align 8
  %477 = call %Loc @Loc_new(%String* %470, i64 %473, i64 %476, i64 0)
  %478 = call %Token @Token_new(%String %468, i32 24, %Loc %477)
  %479 = call %Token @Lexer_advance_token(%Lexer* %467, %Token %478)
  store %Token %479, %Token* %3, align 8
  br label %ret

if.end56:                                         ; preds = %if.then52
  %480 = load %Lexer*, %Lexer** %2, align 8
  %481 = load %Lexer*, %Lexer** %2, align 8
  %482 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @43, i32 0, i32 0))
  %483 = load %Lexer*, %Lexer** %2, align 8
  %484 = bitcast %Lexer* %483 to %String*
  %485 = load %Lexer*, %Lexer** %2, align 8
  %486 = getelementptr inbounds %Lexer, %Lexer* %485, i32 0, i32 5
  %487 = load i64, i64* %486, align 8
  %488 = load %Lexer*, %Lexer** %2, align 8
  %489 = getelementptr inbounds %Lexer, %Lexer* %488, i32 0, i32 6
  %490 = load i64, i64* %489, align 8
  %491 = call %Loc @Loc_new(%String* %484, i64 %487, i64 %490, i64 0)
  %492 = call %Token @Token_new(%String %482, i32 34, %Loc %491)
  %493 = call %Token @Lexer_advance_token(%Lexer* %481, %Token %492)
  store %Token %493, %Token* %3, align 8
  br label %ret

if.then57:                                        ; preds = %if.end53
  %494 = load %Lexer*, %Lexer** %2, align 8
  %495 = getelementptr inbounds %Lexer, %Lexer* %494, i32 0, i32 1
  %496 = load i8*, i8** %495, align 8
  %497 = load %Lexer*, %Lexer** %2, align 8
  %498 = getelementptr inbounds %Lexer, %Lexer* %497, i32 0, i32 4
  %499 = load i32, i32* %498, align 4
  %500 = add i32 %499, 1
  %501 = getelementptr inbounds i8, i8* %496, i32 %500
  %502 = load i8, i8* %501, align 1
  %503 = icmp eq i8 %502, 38
  br i1 %503, label %if.then59, label %if.end61

if.end58:                                         ; preds = %if.end53
  %504 = load %Lexer*, %Lexer** %2, align 8
  %505 = getelementptr inbounds %Lexer, %Lexer* %504, i32 0, i32 3
  %506 = load i8, i8* %505, align 1
  %507 = icmp eq i8 %506, 124
  br i1 %507, label %if.then62, label %if.end63

if.then59:                                        ; preds = %if.then57
  %508 = load %Lexer*, %Lexer** %2, align 8
  %509 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %509)
  %510 = load %Lexer*, %Lexer** %2, align 8
  %511 = load %Lexer*, %Lexer** %2, align 8
  %512 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @44, i32 0, i32 0))
  %513 = load %Lexer*, %Lexer** %2, align 8
  %514 = bitcast %Lexer* %513 to %String*
  %515 = load %Lexer*, %Lexer** %2, align 8
  %516 = getelementptr inbounds %Lexer, %Lexer* %515, i32 0, i32 5
  %517 = load i64, i64* %516, align 8
  %518 = load %Lexer*, %Lexer** %2, align 8
  %519 = getelementptr inbounds %Lexer, %Lexer* %518, i32 0, i32 6
  %520 = load i64, i64* %519, align 8
  %521 = call %Loc @Loc_new(%String* %514, i64 %517, i64 %520, i64 0)
  %522 = call %Token @Token_new(%String %512, i32 26, %Loc %521)
  %523 = call %Token @Lexer_advance_token(%Lexer* %511, %Token %522)
  store %Token %523, %Token* %3, align 8
  br label %ret

if.end61:                                         ; preds = %if.then57
  %524 = load %Lexer*, %Lexer** %2, align 8
  %525 = load %Lexer*, %Lexer** %2, align 8
  %526 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @45, i32 0, i32 0))
  %527 = load %Lexer*, %Lexer** %2, align 8
  %528 = bitcast %Lexer* %527 to %String*
  %529 = load %Lexer*, %Lexer** %2, align 8
  %530 = getelementptr inbounds %Lexer, %Lexer* %529, i32 0, i32 5
  %531 = load i64, i64* %530, align 8
  %532 = load %Lexer*, %Lexer** %2, align 8
  %533 = getelementptr inbounds %Lexer, %Lexer* %532, i32 0, i32 6
  %534 = load i64, i64* %533, align 8
  %535 = call %Loc @Loc_new(%String* %528, i64 %531, i64 %534, i64 0)
  %536 = call %Token @Token_new(%String %526, i32 11, %Loc %535)
  %537 = call %Token @Lexer_advance_token(%Lexer* %525, %Token %536)
  store %Token %537, %Token* %3, align 8
  br label %ret

if.then62:                                        ; preds = %if.end58
  %538 = load %Lexer*, %Lexer** %2, align 8
  %539 = getelementptr inbounds %Lexer, %Lexer* %538, i32 0, i32 1
  %540 = load i8*, i8** %539, align 8
  %541 = load %Lexer*, %Lexer** %2, align 8
  %542 = getelementptr inbounds %Lexer, %Lexer* %541, i32 0, i32 4
  %543 = load i32, i32* %542, align 4
  %544 = add i32 %543, 1
  %545 = getelementptr inbounds i8, i8* %540, i32 %544
  %546 = load i8, i8* %545, align 1
  %547 = icmp eq i8 %546, 124
  br i1 %547, label %if.then64, label %if.end66

if.end63:                                         ; preds = %if.end58
  %548 = load %Lexer*, %Lexer** %2, align 8
  %549 = getelementptr inbounds %Lexer, %Lexer* %548, i32 0, i32 3
  %550 = load i8, i8* %549, align 1
  %551 = icmp eq i8 %550, 33
  br i1 %551, label %if.then67, label %if.end68

if.then64:                                        ; preds = %if.then62
  %552 = load %Lexer*, %Lexer** %2, align 8
  %553 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %553)
  %554 = load %Lexer*, %Lexer** %2, align 8
  %555 = load %Lexer*, %Lexer** %2, align 8
  %556 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @46, i32 0, i32 0))
  %557 = load %Lexer*, %Lexer** %2, align 8
  %558 = bitcast %Lexer* %557 to %String*
  %559 = load %Lexer*, %Lexer** %2, align 8
  %560 = getelementptr inbounds %Lexer, %Lexer* %559, i32 0, i32 5
  %561 = load i64, i64* %560, align 8
  %562 = load %Lexer*, %Lexer** %2, align 8
  %563 = getelementptr inbounds %Lexer, %Lexer* %562, i32 0, i32 6
  %564 = load i64, i64* %563, align 8
  %565 = call %Loc @Loc_new(%String* %558, i64 %561, i64 %564, i64 0)
  %566 = call %Token @Token_new(%String %556, i32 25, %Loc %565)
  %567 = call %Token @Lexer_advance_token(%Lexer* %555, %Token %566)
  store %Token %567, %Token* %3, align 8
  br label %ret

if.end66:                                         ; preds = %if.then62
  %568 = load %Lexer*, %Lexer** %2, align 8
  %569 = load %Lexer*, %Lexer** %2, align 8
  %570 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @47, i32 0, i32 0))
  %571 = load %Lexer*, %Lexer** %2, align 8
  %572 = bitcast %Lexer* %571 to %String*
  %573 = load %Lexer*, %Lexer** %2, align 8
  %574 = getelementptr inbounds %Lexer, %Lexer* %573, i32 0, i32 5
  %575 = load i64, i64* %574, align 8
  %576 = load %Lexer*, %Lexer** %2, align 8
  %577 = getelementptr inbounds %Lexer, %Lexer* %576, i32 0, i32 6
  %578 = load i64, i64* %577, align 8
  %579 = call %Loc @Loc_new(%String* %572, i64 %575, i64 %578, i64 0)
  %580 = call %Token @Token_new(%String %570, i32 14, %Loc %579)
  %581 = call %Token @Lexer_advance_token(%Lexer* %569, %Token %580)
  store %Token %581, %Token* %3, align 8
  br label %ret

if.then67:                                        ; preds = %if.end63
  %582 = load %Lexer*, %Lexer** %2, align 8
  %583 = getelementptr inbounds %Lexer, %Lexer* %582, i32 0, i32 1
  %584 = load i8*, i8** %583, align 8
  %585 = load %Lexer*, %Lexer** %2, align 8
  %586 = getelementptr inbounds %Lexer, %Lexer* %585, i32 0, i32 4
  %587 = load i32, i32* %586, align 4
  %588 = add i32 %587, 1
  %589 = getelementptr inbounds i8, i8* %584, i32 %588
  %590 = load i8, i8* %589, align 1
  %591 = icmp eq i8 %590, 61
  br i1 %591, label %if.then69, label %if.end71

if.end68:                                         ; preds = %if.end63
  %592 = load %Lexer*, %Lexer** %2, align 8
  %593 = getelementptr inbounds %Lexer, %Lexer* %592, i32 0, i32 3
  %594 = load i8, i8* %593, align 1
  %595 = icmp eq i8 %594, 61
  br i1 %595, label %if.then72, label %if.end73

if.then69:                                        ; preds = %if.then67
  %596 = load %Lexer*, %Lexer** %2, align 8
  %597 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %597)
  %598 = load %Lexer*, %Lexer** %2, align 8
  %599 = load %Lexer*, %Lexer** %2, align 8
  %600 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @48, i32 0, i32 0))
  %601 = load %Lexer*, %Lexer** %2, align 8
  %602 = bitcast %Lexer* %601 to %String*
  %603 = load %Lexer*, %Lexer** %2, align 8
  %604 = getelementptr inbounds %Lexer, %Lexer* %603, i32 0, i32 5
  %605 = load i64, i64* %604, align 8
  %606 = load %Lexer*, %Lexer** %2, align 8
  %607 = getelementptr inbounds %Lexer, %Lexer* %606, i32 0, i32 6
  %608 = load i64, i64* %607, align 8
  %609 = call %Loc @Loc_new(%String* %602, i64 %605, i64 %608, i64 0)
  %610 = call %Token @Token_new(%String %600, i32 22, %Loc %609)
  %611 = call %Token @Lexer_advance_token(%Lexer* %599, %Token %610)
  store %Token %611, %Token* %3, align 8
  br label %ret

if.end71:                                         ; preds = %if.then67
  %612 = load %Lexer*, %Lexer** %2, align 8
  %613 = load %Lexer*, %Lexer** %2, align 8
  %614 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @49, i32 0, i32 0))
  %615 = load %Lexer*, %Lexer** %2, align 8
  %616 = bitcast %Lexer* %615 to %String*
  %617 = load %Lexer*, %Lexer** %2, align 8
  %618 = getelementptr inbounds %Lexer, %Lexer* %617, i32 0, i32 5
  %619 = load i64, i64* %618, align 8
  %620 = load %Lexer*, %Lexer** %2, align 8
  %621 = getelementptr inbounds %Lexer, %Lexer* %620, i32 0, i32 6
  %622 = load i64, i64* %621, align 8
  %623 = call %Loc @Loc_new(%String* %616, i64 %619, i64 %622, i64 0)
  %624 = call %Token @Token_new(%String %614, i32 15, %Loc %623)
  %625 = call %Token @Lexer_advance_token(%Lexer* %613, %Token %624)
  store %Token %625, %Token* %3, align 8
  br label %ret

if.then72:                                        ; preds = %if.end68
  %626 = load %Lexer*, %Lexer** %2, align 8
  %627 = getelementptr inbounds %Lexer, %Lexer* %626, i32 0, i32 1
  %628 = load i8*, i8** %627, align 8
  %629 = load %Lexer*, %Lexer** %2, align 8
  %630 = getelementptr inbounds %Lexer, %Lexer* %629, i32 0, i32 4
  %631 = load i32, i32* %630, align 4
  %632 = add i32 %631, 1
  %633 = getelementptr inbounds i8, i8* %628, i32 %632
  %634 = load i8, i8* %633, align 1
  %635 = icmp eq i8 %634, 61
  br i1 %635, label %if.then74, label %if.end76

if.end73:                                         ; preds = %if.end68
  %636 = load %Lexer*, %Lexer** %2, align 8
  %637 = getelementptr inbounds %Lexer, %Lexer* %636, i32 0, i32 3
  %638 = load i8, i8* %637, align 1
  %639 = icmp eq i8 %638, 39
  br i1 %639, label %if.then77, label %if.end78

if.then74:                                        ; preds = %if.then72
  %640 = load %Lexer*, %Lexer** %2, align 8
  %641 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %641)
  %642 = load %Lexer*, %Lexer** %2, align 8
  %643 = load %Lexer*, %Lexer** %2, align 8
  %644 = call %String @String_from(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @50, i32 0, i32 0))
  %645 = load %Lexer*, %Lexer** %2, align 8
  %646 = bitcast %Lexer* %645 to %String*
  %647 = load %Lexer*, %Lexer** %2, align 8
  %648 = getelementptr inbounds %Lexer, %Lexer* %647, i32 0, i32 5
  %649 = load i64, i64* %648, align 8
  %650 = load %Lexer*, %Lexer** %2, align 8
  %651 = getelementptr inbounds %Lexer, %Lexer* %650, i32 0, i32 6
  %652 = load i64, i64* %651, align 8
  %653 = call %Loc @Loc_new(%String* %646, i64 %649, i64 %652, i64 0)
  %654 = call %Token @Token_new(%String %644, i32 21, %Loc %653)
  %655 = call %Token @Lexer_advance_token(%Lexer* %643, %Token %654)
  store %Token %655, %Token* %3, align 8
  br label %ret

if.end76:                                         ; preds = %if.then72
  %656 = load %Lexer*, %Lexer** %2, align 8
  %657 = load %Lexer*, %Lexer** %2, align 8
  %658 = call %String @String_from(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @51, i32 0, i32 0))
  %659 = load %Lexer*, %Lexer** %2, align 8
  %660 = bitcast %Lexer* %659 to %String*
  %661 = load %Lexer*, %Lexer** %2, align 8
  %662 = getelementptr inbounds %Lexer, %Lexer* %661, i32 0, i32 5
  %663 = load i64, i64* %662, align 8
  %664 = load %Lexer*, %Lexer** %2, align 8
  %665 = getelementptr inbounds %Lexer, %Lexer* %664, i32 0, i32 6
  %666 = load i64, i64* %665, align 8
  %667 = call %Loc @Loc_new(%String* %660, i64 %663, i64 %666, i64 0)
  %668 = call %Token @Token_new(%String %658, i32 5, %Loc %667)
  %669 = call %Token @Lexer_advance_token(%Lexer* %657, %Token %668)
  store %Token %669, %Token* %3, align 8
  br label %ret

if.then77:                                        ; preds = %if.end73
  %670 = load %Lexer*, %Lexer** %2, align 8
  %671 = load %Lexer*, %Lexer** %2, align 8
  call void @Lexer_advance(%Lexer* %671)
  %672 = load %Lexer*, %Lexer** %2, align 8
  %673 = load %Lexer*, %Lexer** %2, align 8
  %674 = call %Token @Lexer_lex_char(%Lexer* %673)
  store %Token %674, %Token* %3, align 8
  br label %ret

if.end78:                                         ; preds = %if.end73
  %675 = load %Lexer*, %Lexer** %2, align 8
  %676 = getelementptr inbounds %Lexer, %Lexer* %675, i32 0, i32 3
  %677 = load i8, i8* %676, align 1
  %678 = icmp eq i8 %677, 0
  br i1 %678, label %if.then79, label %if.end80

if.then79:                                        ; preds = %if.end78
  %679 = call %String @String_from(i8* getelementptr inbounds ([1 x i8], [1 x i8]* @52, i32 0, i32 0))
  %680 = load %Lexer*, %Lexer** %2, align 8
  %681 = bitcast %Lexer* %680 to %String*
  %682 = load %Lexer*, %Lexer** %2, align 8
  %683 = getelementptr inbounds %Lexer, %Lexer* %682, i32 0, i32 5
  %684 = load i64, i64* %683, align 8
  %685 = load %Lexer*, %Lexer** %2, align 8
  %686 = getelementptr inbounds %Lexer, %Lexer* %685, i32 0, i32 6
  %687 = load i64, i64* %686, align 8
  %688 = call %Loc @Loc_new(%String* %681, i64 %684, i64 %687, i64 0)
  %689 = call %Token @Token_new(%String %679, i32 57, %Loc %688)
  store %Token %689, %Token* %3, align 8
  br label %ret

if.end80:                                         ; preds = %if.end78
  %690 = load %Lexer*, %Lexer** %2, align 8
  %691 = getelementptr inbounds %Lexer, %Lexer* %690, i32 0, i32 3
  %692 = load i8, i8* %691, align 1
  %693 = sext i8 %692 to i32
  %694 = call i32 @isdigit(i32 %693)
  %695 = icmp ne i32 %694, 0
  br i1 %695, label %if.then81, label %if.end82

if.then81:                                        ; preds = %if.end80
  %696 = load %Lexer*, %Lexer** %2, align 8
  %697 = load %Lexer*, %Lexer** %2, align 8
  %698 = call %Token @Lexer_lex_number(%Lexer* %697)
  store %Token %698, %Token* %3, align 8
  br label %ret

if.end82:                                         ; preds = %if.end80
  %699 = load %Lexer*, %Lexer** %2, align 8
  %700 = getelementptr inbounds %Lexer, %Lexer* %699, i32 0, i32 3
  %701 = load i8, i8* %700, align 1
  %702 = sext i8 %701 to i32
  %703 = call i32 @isalpha(i32 %702)
  %704 = icmp ne i32 %703, 0
  br i1 %704, label %if.then83, label %for.cond

if.then83:                                        ; preds = %if.end82
  %705 = load %Lexer*, %Lexer** %2, align 8
  %706 = load %Lexer*, %Lexer** %2, align 8
  %707 = call %Token @Lexer_lex_id(%Lexer* %706)
  store %Token %707, %Token* %3, align 8
  br label %ret

ret:                                              ; preds = %for.end, %if.then83, %if.then81, %if.then79, %if.then77, %if.end76, %if.then74, %if.end71, %if.then69, %if.end66, %if.then64, %if.end61, %if.then59, %if.end56, %if.then54, %if.end51, %if.then49, %if.then45, %if.then43, %if.then41, %if.then39, %if.then37, %if.then35, %if.then33, %if.then31, %if.then29, %if.then24, %if.then22, %if.end21, %if.then19, %if.then15, %if.end14, %if.then12, %if.then8, %if.then6, %if.then4
  %708 = load %Token, %Token* %3, align 8
  ret %Token %708
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
  %22 = call %Lexer @Lexer_new(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @57, i32 0, i32 0), i32 11, %String %21)
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
