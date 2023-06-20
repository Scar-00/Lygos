; ModuleID = 'tests/test.ly'
source_filename = "tests/test.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%Vec = type { i32 }

@0 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local %Vec @Vec_new(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = alloca %Vec, align 8
  %4 = alloca %Vec, align 8
  %5 = bitcast %Vec* %4 to i32*
  %6 = load i32, i32* %2, align 4
  store i32 %6, i32* %5, align 4
  %7 = load %Vec, %Vec* %4, align 4
  store %Vec %7, %Vec* %3, align 4
  %8 = load %Vec, %Vec* %3, align 4
  ret %Vec %8
}

define dso_local i32 @Vec_test(%Vec* %0) {
  %2 = alloca %Vec*, align 8
  store %Vec* %0, %Vec** %2, align 8
  %3 = alloca i32, align 4
  %4 = load %Vec*, %Vec** %2, align 8
  %5 = bitcast %Vec* %4 to i32*
  %6 = load i32, i32* %5, align 4
  store i32 %6, i32* %3, align 4
  %7 = load i32, i32* %3, align 4
  ret i32 %7
}

define dso_local i32 @main(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = alloca i32, align 4
  %4 = call %Vec @Vec_new(i32 10)
  %5 = alloca %Vec, align 8
  store %Vec %4, %Vec* %5, align 4
  %6 = call i32 @Vec_test(%Vec* %5)
  %7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @0, i32 0, i32 0), i32 %6)
  store i32 0, i32* %3, align 4
  %8 = load i32, i32* %3, align 4
  ret i32 %8
}
