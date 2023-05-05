; ModuleID = 'tests/member_fn.ly'
source_filename = "tests/member_fn.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%V2 = type { i32, i32 }

declare i32 @printf(i8*, ...)

declare i8* @malloc(i32)

define dso_local %V2* @V2_from(i32 %0, i32 %1) {
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = alloca i32, align 4
  store i32 %1, i32* %4, align 4
  %5 = alloca %V2*, align 8
  %6 = call i8* @malloc(i32 8)
  %7 = bitcast i8* %6 to %V2*
  %8 = alloca %V2*, align 8
  store %V2* %7, %V2** %8, align 8
  %9 = load %V2*, %V2** %8, align 8
  %10 = bitcast %V2* %9 to i32*
  %11 = load i32, i32* %3, align 4
  store i32 %11, i32* %10, align 4
  %12 = load %V2*, %V2** %8, align 8
  %13 = getelementptr inbounds %V2, %V2* %12, i32 0, i32 1
  %14 = load i32, i32* %4, align 4
  store i32 %14, i32* %13, align 4
  %15 = load %V2*, %V2** %5, align 8
  ret %V2* %15
}

define dso_local i32* @V2_test(%V2* %0, i32 %1) {
  %3 = alloca %V2*, align 8
  store %V2* %0, %V2** %3, align 8
  %4 = alloca i32, align 4
  store i32 %1, i32* %4, align 4
  %5 = alloca i32*, align 8
  %6 = call i8* @malloc(i32 4)
  %7 = bitcast i8* %6 to i32*
  store i32* %7, i32** %5, align 8
  %8 = load i32*, i32** %5, align 8
  ret i32* %8
}

define dso_local i32 @main(i32 %0, i8** %1) {
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = alloca i8**, align 8
  store i8** %1, i8*** %4, align 8
  %5 = alloca i32, align 4
  %6 = call %V2* @V2_from(i32 10, i32 20)
  %7 = alloca %V2*, align 8
  store %V2* %6, %V2** %7, align 8
  %8 = alloca i32*, align 8
  %9 = load %V2*, %V2** %7, align 8
  %10 = load %V2*, %V2** %7, align 8
  %11 = call i32* @V2_test(%V2* %10, i32 10)
  store i32* %11, i32** %8, align 8
  %12 = load %V2*, %V2** %7, align 8
  %13 = load %V2*, %V2** %7, align 8
  %14 = call i32* @V2_test(%V2* %13, i32 10)
  store i32* %14, i32** %8, align 8
  store i32 0, i32* %5, align 4
  %15 = load i32, i32* %5, align 4
  ret i32 %15
}
