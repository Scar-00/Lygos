; ModuleID = 'test'
source_filename = "test"

define i32 @main() {
  %1 = alloca i32, align 4
  store i32 10, ptr %1, align 4
  ret void
}
