; ModuleID = 'tests/trait.ly'
source_filename = "tests/trait.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%Triangle = type { i32, i32 }
%Quad = type { i32, i32 }

declare i32 @printf(i8*, ...)

define dso_local i32 @Triangle_area(%Triangle* %0) {
  %2 = alloca %Triangle*, align 8
  store %Triangle* %0, %Triangle** %2, align 8
  %3 = alloca i32, align 4
  %4 = load %Triangle*, %Triangle** %2, align 8
  %5 = bitcast %Triangle* %4 to i32*
  %6 = load %Triangle*, %Triangle** %2, align 8
  %7 = getelementptr inbounds %Triangle, %Triangle* %6, i32 0, i32 1
  %8 = load i32, i32* %5, align 4
  %9 = load i32, i32* %7, align 4
  %10 = mul i32 %8, %9
  store i32 %10, i32* %3, align 4
  %11 = load i32, i32* %3, align 4
  ret i32 %11
}

define dso_local void @Triangle_test(%Triangle* %0) {
  %2 = alloca %Triangle*, align 8
  store %Triangle* %0, %Triangle** %2, align 8
  ret void
}

define dso_local i32 @Quad_area(%Quad* %0) {
  %2 = alloca %Quad*, align 8
  store %Quad* %0, %Quad** %2, align 8
  %3 = alloca i32, align 4
  %4 = load %Quad*, %Quad** %2, align 8
  %5 = bitcast %Quad* %4 to i32*
  %6 = load %Quad*, %Quad** %2, align 8
  %7 = getelementptr inbounds %Quad, %Quad* %6, i32 0, i32 1
  %8 = load i32, i32* %5, align 4
  %9 = load i32, i32* %7, align 4
  %10 = mul i32 %8, %9
  store i32 %10, i32* %3, align 4
  %11 = load i32, i32* %3, align 4
  ret i32 %11
}

define dso_local void @Quad_test(%Quad* %0) {
  %2 = alloca %Quad*, align 8
  store %Quad* %0, %Quad** %2, align 8
  ret void
}

define dso_local i32 @main() {
  %1 = alloca i32, align 4
  %2 = alloca %Quad, align 8
  %3 = bitcast %Quad* %2 to i32*
  store i32 10, i32* %3, align 4
  %4 = getelementptr inbounds %Quad, %Quad* %2, i32 0, i32 1
  store i32 5, i32* %4, align 4
  store i32 0, i32* %1, align 4
  %5 = load i32, i32* %1, align 4
  ret i32 %5
}
