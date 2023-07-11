; ModuleID = 'tests/test.ly'
source_filename = "tests/test.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%Vec = type { i32, i32 }

@0 = internal global i32* zeroinitializer
@1 = private unnamed_addr constant [10 x i8] c"foo -> %d\00", align 1
@2 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local %Vec @Vec_test() {
  %1 = alloca %Vec, align 8
  %2 = load %Vec, %Vec* %1, align 4
  ret %Vec %2
}

define dso_local i32 @Vec_foo(%Vec* %0) {
  %2 = alloca %Vec*, align 8
  store %Vec* %0, %Vec** %2, align 8
  %3 = alloca i32, align 4
  %4 = load i32, i32* %3, align 4
  ret i32 %4
}

define dso_local i32 @main(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = alloca i32, align 4
  store i32* %2, i32** @0, align 8
  %4 = load i32*, i32** @0, align 8
  %5 = load i32, i32* %4, align 4
  %6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @1, i32 0, i32 0), i32 %5)
  %7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @2, i32 0, i32 0))
  store i32 0, i32* %3, align 4
  %8 = load i32, i32* %3, align 4
  ret i32 %8
}
