; ModuleID = 'tests/member_fn.ly'
source_filename = "tests/member_fn.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%V2 = type { i32, i32 }

@0 = private unnamed_addr constant [11 x i8] c"val -> %d\0A\00", align 1
@1 = private unnamed_addr constant [9 x i8] c"%d | %d\0A\00", align 1
@2 = private unnamed_addr constant [9 x i8] c"%d | %d\0A\00", align 1

declare i32 @printf(i8*, ...)

declare i8* @malloc(i32)

define dso_local %V2 @V2_from(i32 %0, i32 %1) {
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = alloca i32, align 4
  store i32 %1, i32* %4, align 4
  %5 = alloca %V2, align 8
  %6 = alloca %V2, align 8
  %7 = bitcast %V2* %6 to i32*
  %8 = load i32, i32* %3, align 4
  store i32 %8, i32* %7, align 4
  %9 = getelementptr inbounds %V2, %V2* %6, i32 0, i32 1
  %10 = load i32, i32* %4, align 4
  store i32 %10, i32* %9, align 4
  %11 = load %V2, %V2* %6, align 4
  store %V2 %11, %V2* %5, align 4
  %12 = load %V2, %V2* %5, align 4
  ret %V2 %12
}

define dso_local i32 @V2_test(%V2* %0, i32 %1) {
  %3 = alloca %V2*, align 8
  store %V2* %0, %V2** %3, align 8
  %4 = alloca i32, align 4
  store i32 %1, i32* %4, align 4
  %5 = alloca i32, align 4
  %6 = load %V2*, %V2** %3, align 8
  %7 = bitcast %V2* %6 to i32*
  %8 = load i32, i32* %7, align 4
  store i32 %8, i32* %5, align 4
  %9 = load i32, i32* %5, align 4
  ret i32 %9
}

define dso_local %V2* @V2_t(i32 %0, i32 %1) {
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
  %15 = load %V2*, %V2** %8, align 8
  store %V2* %15, %V2** %5, align 8
  %16 = load %V2*, %V2** %5, align 8
  ret %V2* %16
}

define dso_local i32 @main(i32 %0, i8** %1) {
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = alloca i8**, align 8
  store i8** %1, i8*** %4, align 8
  %5 = alloca i32, align 4
  %6 = call %V2 @V2_from(i32 10, i32 20)
  %7 = alloca %V2, align 8
  store %V2 %6, %V2* %7, align 4
  %8 = call %V2* @V2_t(i32 200, i32 300)
  %9 = alloca %V2*, align 8
  store %V2* %8, %V2** %9, align 8
  %10 = load %V2*, %V2** %9, align 8
  %11 = load %V2*, %V2** %9, align 8
  %12 = call i32 @V2_test(%V2* %11, i32 10)
  %13 = alloca i32, align 4
  store i32 %12, i32* %13, align 4
  %14 = load i32, i32* %13, align 4
  %15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @0, i32 0, i32 0), i32 %14)
  %16 = load %V2*, %V2** %9, align 8
  %17 = bitcast %V2* %16 to i32*
  %18 = load i32, i32* %17, align 4
  %19 = load %V2*, %V2** %9, align 8
  %20 = getelementptr inbounds %V2, %V2* %19, i32 0, i32 1
  %21 = load i32, i32* %20, align 4
  %22 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @1, i32 0, i32 0), i32 %18, i32 %21)
  %23 = bitcast %V2* %7 to i32*
  %24 = load i32, i32* %23, align 4
  %25 = getelementptr inbounds %V2, %V2* %7, i32 0, i32 1
  %26 = load i32, i32* %25, align 4
  %27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @2, i32 0, i32 0), i32 %24, i32 %26)
  store i32 0, i32* %5, align 4
  %28 = load i32, i32* %5, align 4
  ret i32 %28
}
