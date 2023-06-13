; ModuleID = 'tests/test.ly'
source_filename = "tests/test.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%Vec = type { i32*, i32, i32 }

declare i32 @printf(i8*, ...)

declare i8* @malloc(i32)

define dso_local %Vec @Vec_new() {
  %1 = alloca %Vec, align 8
  %2 = alloca %Vec, align 8
  %3 = bitcast %Vec* %2 to i32**
  %4 = call i8* @malloc(i32 40)
  %5 = bitcast i8* %4 to i32*
  store i32* %5, i32** %3, align 8
  %6 = getelementptr inbounds %Vec, %Vec* %2, i32 0, i32 1
  store i32 0, i32* %6, align 4
  %7 = getelementptr inbounds %Vec, %Vec* %2, i32 0, i32 2
  store i32 10, i32* %7, align 4
  %8 = load %Vec, %Vec* %2, align 8
  store %Vec %8, %Vec* %1, align 8
  %9 = load %Vec, %Vec* %1, align 8
  ret %Vec %9
}

define dso_local i32* @Vec_index(%Vec* %0, i32 %1) {
  %3 = alloca %Vec*, align 8
  store %Vec* %0, %Vec** %3, align 8
  %4 = alloca i32, align 4
  store i32 %1, i32* %4, align 4
  %5 = alloca i32*, align 8
  %6 = load %Vec*, %Vec** %3, align 8
  %7 = bitcast %Vec* %6 to i32**
  %8 = load i32*, i32** %7, align 8
  %9 = load i32, i32* %4, align 4
  %10 = getelementptr inbounds i32, i32* %8, i32 %9
  store i32* %10, i32** %5, align 8
  %11 = load i32*, i32** %5, align 8
  ret i32* %11
}

define dso_local i32 @main(i32 %0, i8** %1) {
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = alloca i8**, align 8
  store i8** %1, i8*** %4, align 8
  %5 = alloca i32, align 4
  %6 = call %Vec @Vec_new()
  %7 = alloca %Vec, align 8
  store %Vec %6, %Vec* %7, align 8
  %8 = load %Vec, %Vec* %7, align 8
  %9 = load %Vec, %Vec* %7, align 8
  %10 = call i32* @Vec_index(%Vec* %7, i32 0)
  %11 = load i32, i32* %10, align 4
  %12 = alloca i32, align 4
  store i32 %11, i32* %12, align 4
  store i32 0, i32* %5, align 4
  %13 = load i32, i32* %5, align 4
  ret i32 %13
}
