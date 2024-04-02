; ModuleID = 'test.optimized.bc'
source_filename = "test.ll"

define dso_local i32 @foo(i32 noundef %0, i32 noundef %1) {
  %3 = add nsw i32 %1, 1
  %4 = mul nsw i32 15, 17
  %5 = shl i32 15, 4
  %6 = add i32 %5, 15
  ret i32 %3
}
