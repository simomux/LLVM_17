; ModuleID = 'test.optimized.bc'
source_filename = "test.ll"

define dso_local i32 @foo(i32 noundef %0, i32 noundef %1) {
  %3 = add nsw i32 %1, 1
  %4 = mul nsw i32 %3, 2
  %5 = shl i32 %3, 1
  %6 = shl i32 %0, 1
  %7 = sdiv i32 %6, 4
  %8 = mul nsw i32 %5, %7
  %9 = mul nsw i32 %8, 8
  %10 = shl i32 %8, 3
  %11 = mul nsw i32 8, 16
  %12 = shl i32 8, 4
  %13 = mul nsw i32 32, 15
  %14 = shl i32 15, 5
  %15 = mul nsw i32 16, %12
  %16 = shl i32 %12, 4
  ret i32 %8
}
