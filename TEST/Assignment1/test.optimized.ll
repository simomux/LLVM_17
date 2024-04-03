; ModuleID = 'test.optimized.bc'
source_filename = "test.ll"

define dso_local i32 @foo(i32 noundef %0, i32 noundef %1) {
  %3 = add nsw i32 %1, 1
  %4 = sub nsw i32 %3, 1
  %5 = add nsw i32 %1, 64
  ret i32 %3
}
