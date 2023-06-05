; ModuleID = 'tests/test.ly'
source_filename = "tests/test.ly"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

declare i32 @printf(i8*, ...)

define dso_local i32 @main(i32 %0) {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %4, align 4
  br label %for.cond

for.cond:                                         ; preds = %if.end, %1
  %5 = load i32, i32* %4, align 4
  %6 = icmp slt i32 %5, 10
  br i1 %6, label %for.block, label %for.end

for.block:                                        ; preds = %for.cond
  %7 = load i32, i32* %2, align 4
  %8 = icmp eq i32 %7, 5
  br i1 %8, label %if.then, label %if.end

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %3, align 4
  br label %ret

if.then:                                          ; preds = %for.block
  store i32 100, i32* %3, align 4
  br label %ret

if.end:                                           ; preds = %for.block
  %9 = load i32, i32* %4, align 4
  %10 = add i32 %9, 1
  store i32 %10, i32* %4, align 4
  br label %for.cond

ret:                                              ; preds = %for.end, %if.then
  %11 = load i32, i32* %3, align 4
  ret i32 %11
}
