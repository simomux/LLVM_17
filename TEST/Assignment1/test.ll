; Test file created to pass functionalites
define dso_local i32 @foo(i32 noundef %0, i32 noundef %1) #0 {
  %3 = add nsw i32 %1, 1
  %4 = mul nsw i32 %3, 1
  %5 = add nsw i32 %4, 6
  %6 = mul nsw i32 1, 14
  %7 = add nsw i32 %6, 15
  %8 = sdiv i32 %7, 1
  %9 = add nsw i32 %8, 1
  ret i32 %3
}
