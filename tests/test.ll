; ModuleID = 'tests/test.ly'
source_filename = "tests/test.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%Foo = type { i32 }

declare i32 @printf(i8*, ...)

define dso_local %Foo @Foo_copy(%Foo* %0) {
  %2 = alloca %Foo*, align 8
  store %Foo* %0, %Foo** %2, align 8
  %3 = alloca %Foo, align 8
  %4 = alloca %Foo, align 8
  %5 = bitcast %Foo* %4 to i32*
  %6 = load %Foo*, %Foo** %2, align 8
  %7 = bitcast %Foo* %6 to i32*
  %8 = load i32, i32* %7, align 4
  store i32 %8, i32* %5, align 4
  %9 = load %Foo, %Foo* %4, align 4
  store %Foo %9, %Foo* %3, align 4
  %10 = load %Foo, %Foo* %3, align 4
  ret %Foo %10
}

define dso_local i32 @main(i32 %0, i8** %1) {
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = alloca i8**, align 8
  store i8** %1, i8*** %4, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 10, i32* %6, align 4
  %7 = load i32, i32* %6, align 4
  store i32 %7, i32* %5, align 4
  %8 = load i32, i32* %5, align 4
  ret i32 %8
}
