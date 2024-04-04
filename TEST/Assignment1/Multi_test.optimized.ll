; ModuleID = 'Multi_test.optimized.bc'
source_filename = "Multi_test.ll"

define dso_local i32 @foo(i32 noundef %0, i32 noundef %1) {
  %3 = add nsw i32 %0, 5
  %4 = sub nsw i32 %3, 5
  %5 = add nsw i32 34, %0

  %6 = add nsw i32 34, %1
  %7 = sub i32 %6, 34
  %8 = add nsw i32 0, %1

  %9 = sub nsw i32 %0, 5
  %10 = add nsw i32 %1, 5
  %11 = sub nsw i32 34, %0

  %12 = mul nsw i32 %0, 5
  %13 = sdiv i32 %12, 5
  %14 = add nsw i32 34, %0

  %15 = mul nsw i32 34, %1
  %16 = sdiv i32 %15, 34
  %17 = add nsw i32 0, %1

  %18 = sdiv i32 %0, 5
  %19 = mul nsw i32 %18, 5
  %20 = sub nsw i32 34, %0
  
  ret i32 %3
}
