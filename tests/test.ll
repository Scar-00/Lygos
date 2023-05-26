; ModuleID = 'tests/test.ly'
source_filename = "tests/test.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@0 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@1 = private unnamed_addr constant [9 x i8] c"Test, %d\00", align 1

declare i32 @printf(i8*, ...)

define dso_local i32 @main() {
  %1 = alloca i32, align 4
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @0, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @1, i32 0, i32 0), i32 10)
  store i32 0, i32* %1, align 4
  %3 = load i32, i32* %1, align 4
  ret i32 %3
}
