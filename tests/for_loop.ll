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
  %7 = load i32, i32* %6, align 4
  %8 = load i32, i32* %3, align 4
  %9 = icmp slt i32 %7, %8
  br i1 %9, label %.preheader, label %22

.preheader:                                       ; preds = %2
  br label %10

10:                                               ; preds = %.preheader, %10
  %11 = load i32, i32* %6, align 4
  %12 = load i8**, i8*** %4, align 8
  %13 = load i32, i32* %6, align 4
  %14 = getelementptr inbounds i8*, i8** %12, i32 %13
  %15 = load i8*, i8** %14, align 8
  %16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @0, i32 0, i32 0), i32 %11, i8* %15)
  %17 = load i32, i32* %6, align 4
  %18 = add i32 %17, 1
  store i32 %18, i32* %6, align 4
  %19 = load i32, i32* %6, align 4
  %20 = load i32, i32* %3, align 4
  %21 = icmp slt i32 %19, %20
  br i1 %21, label %10, label %22

22:                                               ; preds = %10, %2
  store i32 0, i32* %5, align 4
  %23 = load i32, i32* %5, align 4
  ret i32 %23
}
