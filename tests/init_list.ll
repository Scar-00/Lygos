; ModuleID = 'tests/init_list.ly'
source_filename = "tests/init_list.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%Foo = type { i32, i32 }

@0 = private unnamed_addr constant [16 x i8] c"foo -> %d | %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local %Foo @test() {
  %1 = alloca %Foo, align 8
  %2 = alloca %Foo, align 8
  %3 = bitcast %Foo* %2 to i32*
  store i32 200, i32* %3, align 4
  %4 = getelementptr inbounds %Foo, %Foo* %2, i32 0, i32 1
  store i32 300, i32* %4, align 4
  %5 = load %Foo, %Foo* %2, align 4
  store %Foo %5, %Foo* %1, align 4
  %6 = load %Foo, %Foo* %1, align 4
  ret %Foo %6
}

define dso_local i32 @main() {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 10, i32* %2, align 4
  %3 = alloca i32, align 4
  store i32 20, i32* %3, align 4
  %4 = alloca %Foo, align 8
  %5 = bitcast %Foo* %4 to i32*
  %6 = load i32, i32* %2, align 4
  store i32 %6, i32* %5, align 4
  %7 = getelementptr inbounds %Foo, %Foo* %4, i32 0, i32 1
  %8 = load i32, i32* %3, align 4
  store i32 %8, i32* %7, align 4
  %9 = bitcast %Foo* %4 to i32*
  %10 = load i32, i32* %9, align 4
  %11 = getelementptr inbounds %Foo, %Foo* %4, i32 0, i32 1
  %12 = load i32, i32* %11, align 4
  %13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @0, i32 0, i32 0), i32 %10, i32 %12)
  store i32 0, i32* %1, align 4
  %14 = load i32, i32* %1, align 4
  ret i32 %14
}
