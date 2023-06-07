; ModuleID = 'tests/test.ly'
source_filename = "tests/test.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@glob = external global i32

declare i32 @printf(i8*, ...)

define dso_local i32 @main(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = alloca i32, align 4
  store i32 10, i32* @glob, align 4
  store i32 0, i32* %3, align 4
  %4 = load i32, i32* %3, align 4
  ret i32 %4
}
