; ModuleID = 'tests/for_loop.ly'
source_filename = "tests/for_loop.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@0 = private unnamed_addr constant [10 x i8] c"%d -> %s\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local i32 @main(i32 %0, i8** %1) {
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = alloca i8**, align 8
  store i8** %1, i8*** %4, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 0, i32* %6, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.block, %2
  %7 = load i32, i32* %6, align 4
  %8 = load i32, i32* %3, align 4
  %9 = icmp slt i32 %7, %8
  br i1 %9, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %10 = load i32, i32* %6, align 4
  %11 = load i8**, i8*** %4, align 8
  %12 = load i32, i32* %6, align 4
  %13 = getelementptr inbounds i8*, i8** %11, i32 %12
  %14 = load i8*, i8** %13, align 8
  %15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @0, i32 0, i32 0), i32 %10, i8* %14)
  %16 = load i32, i32* %6, align 4
  %17 = add i32 %16, 1
  store i32 %17, i32* %6, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %5, align 4
  %18 = load i32, i32* %5, align 4
  ret i32 %18
}
