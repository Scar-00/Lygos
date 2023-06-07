; ModuleID = 'tests/match.ly'
source_filename = "tests/match.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@0 = private unnamed_addr constant [7 x i8] c"arm 1\0A\00", align 1
@1 = private unnamed_addr constant [7 x i8] c"arm 2\0A\00", align 1
@2 = private unnamed_addr constant [7 x i8] c"arm 3\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local void @test(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  switch i32 %3, label %10 [
    i32 1, label %4
    i32 2, label %6
    i32 3, label %8
  ]

4:                                                ; preds = %1
  %5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @0, i32 0, i32 0))
  br label %10

6:                                                ; preds = %1
  %7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @1, i32 0, i32 0))
  br label %10

8:                                                ; preds = %1
  %9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @2, i32 0, i32 0))
  br label %10

10:                                               ; preds = %8, %6, %4, %1
  ret void
}

define dso_local i32 @main(i32 %0, i8** %1) {
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = alloca i8**, align 8
  store i8** %1, i8*** %4, align 8
  %5 = alloca i32, align 4
  call void @test(i32 2)
  store i32 0, i32* %5, align 4
  %6 = load i32, i32* %5, align 4
  ret i32 %6
}
