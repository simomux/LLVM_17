; ModuleID = 'Strength_test.optimized.bc'
source_filename = "Strength_test.ll"

define dso_local i32 @foo(i32 noundef %0, i32 noundef %1) {
  %3 = mul nsw i32 %0, 15
  %4 = shl i32 %0, 4
  %5 = sub i32 %4, %0

  %6 = mul nsw i32 13, %1

  %7 = mul nsw i32 %5, 16
  %8 = shl i32 %5, 4

  %9 = mul nsw i32 3, %6
  %10 = shl i32 %6, 1
  %11 = add i32 %10, %6

  %12 = sdiv i32 %0, 15

  %13 = sdiv i32 14, %1

  %14 = sdiv i32 %12, 32
  %15 = ashr i32 %12, 5

  %16 = sdiv i32 4, %13
  
  ret i32 %5
}
