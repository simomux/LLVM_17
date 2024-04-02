; Test file created to pass functionalites
define dso_local i32 @foo(i32 noundef %0, i32 noundef %1) #0 {
  %3 = add nsw i32 %1, 1
  %4 = mul nsw i32 15, 17
  ret i32 %3
}
