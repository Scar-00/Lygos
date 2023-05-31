; ModuleID = 'tests/test.ly'
source_filename = "tests/test.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%Veci32 = type { i32*, i32, i32 }
%Vecf32 = type { float*, i32, i32 }

declare i32 @printf(i8*, ...)

define dso_local %Veci32 @Veci32_new() {
  %1 = alloca %Veci32, align 8
  %2 = alloca %Veci32, align 8
  %3 = getelementptr inbounds %Veci32, %Veci32* %2, i32 0, i32 1
  store i32 0, i32* %3, align 4
  %4 = getelementptr inbounds %Veci32, %Veci32* %2, i32 0, i32 2
  store i32 0, i32* %4, align 4
  %5 = load %Veci32, %Veci32* %2, align 8
  store %Veci32 %5, %Veci32* %1, align 8
  %6 = load %Veci32, %Veci32* %1, align 8
  ret %Veci32 %6
}

define dso_local %Veci32 @Veci32_from_parts(i32* %0, i32 %1, i32 %2) {
  %4 = alloca i32*, align 8
  store i32* %0, i32** %4, align 8
  %5 = alloca i32, align 4
  store i32 %1, i32* %5, align 4
  %6 = alloca i32, align 4
  store i32 %2, i32* %6, align 4
  %7 = alloca %Veci32, align 8
  %8 = alloca %Veci32, align 8
  %9 = bitcast %Veci32* %8 to i32**
  %10 = load i32*, i32** %4, align 8
  store i32* %10, i32** %9, align 8
  %11 = getelementptr inbounds %Veci32, %Veci32* %8, i32 0, i32 1
  %12 = load i32, i32* %5, align 4
  store i32 %12, i32* %11, align 4
  %13 = getelementptr inbounds %Veci32, %Veci32* %8, i32 0, i32 2
  %14 = load i32, i32* %6, align 4
  store i32 %14, i32* %13, align 4
  %15 = load %Veci32, %Veci32* %8, align 8
  store %Veci32 %15, %Veci32* %7, align 8
  %16 = load %Veci32, %Veci32* %7, align 8
  ret %Veci32 %16
}

define dso_local %Vecf32 @Vecf32_new() {
  %1 = alloca %Vecf32, align 8
  %2 = alloca %Vecf32, align 8
  %3 = getelementptr inbounds %Vecf32, %Vecf32* %2, i32 0, i32 1
  store i32 0, i32* %3, align 4
  %4 = getelementptr inbounds %Vecf32, %Vecf32* %2, i32 0, i32 2
  store i32 0, i32* %4, align 4
  %5 = load %Vecf32, %Vecf32* %2, align 8
  store %Vecf32 %5, %Vecf32* %1, align 8
  %6 = load %Vecf32, %Vecf32* %1, align 8
  ret %Vecf32 %6
}

define dso_local %Vecf32 @Vecf32_from_parts(float* %0, i32 %1, i32 %2) {
  %4 = alloca float*, align 8
  store float* %0, float** %4, align 8
  %5 = alloca i32, align 4
  store i32 %1, i32* %5, align 4
  %6 = alloca i32, align 4
  store i32 %2, i32* %6, align 4
  %7 = alloca %Vecf32, align 8
  %8 = alloca %Vecf32, align 8
  %9 = bitcast %Vecf32* %8 to float**
  %10 = load float*, float** %4, align 8
  store float* %10, float** %9, align 8
  %11 = getelementptr inbounds %Vecf32, %Vecf32* %8, i32 0, i32 1
  %12 = load i32, i32* %5, align 4
  store i32 %12, i32* %11, align 4
  %13 = getelementptr inbounds %Vecf32, %Vecf32* %8, i32 0, i32 2
  %14 = load i32, i32* %6, align 4
  store i32 %14, i32* %13, align 4
  %15 = load %Vecf32, %Vecf32* %8, align 8
  store %Vecf32 %15, %Vecf32* %7, align 8
  %16 = load %Vecf32, %Vecf32* %7, align 8
  ret %Vecf32 %16
}

define dso_local i32 @main() {
  %1 = alloca i32, align 4
  %2 = call %Veci32 @Veci32_new()
  %3 = alloca %Veci32, align 8
  store %Veci32 %2, %Veci32* %3, align 8
  store i32 0, i32* %1, align 4
  %4 = load i32, i32* %1, align 4
  ret i32 %4
}
