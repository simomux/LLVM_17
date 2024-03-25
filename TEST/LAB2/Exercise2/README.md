### Exercise 2 LAB 2 of my middle-end compilers class

Goal is to rewrite the pass in `LocalOpts.cpp`, from exercise 1, creating a new one able to replace all multiplications with a constant power of 2 with a shift.

Example:

Before:
```LLVM_IR
%1 = add %2, %3
%4 = mul %1, 8
print %4
```

After:
```LLVM_IR
%1 = add %2, %3
%4 = mul %1, 8
%5 = shl %1, 3
print %5
```

#### Notes
Since we haven't already seen a DCE (Dead Code Elimination) we just limit to adding the shift right after the mul and giving it all the mul's user and use.

### Solution
Check `LocalOpts.cpp` for the solution.

The solution is capable of transforming a mul with this following syntaxes:
Before:
```LLVM_IR
  %4 = mul nsw i32 %3, 2
  %7 = mul nsw i32 %4, %6
  %8 = mul nsw i32 %7, 8
  %9 = mul nsw i32 8, 16
  %10 = mul nsw i32 32, 15
  %11 = mul nsw i32 16, %9
```


After:
```LLVM_IR
  %4 = mul nsw i32 %3, 2
  %5 = shl i32 %3, 1

  %8 = mul nsw i32 %5, %7

  %9 = mul nsw i32 %8, 8
  %10 = shl i32 %8, 3

  %11 = mul nsw i32 8, 16
  %12 = shl i32 8, 4

  %13 = mul nsw i32 32, 15
  %14 = shl i32 15, 5

  %15 = mul nsw i32 16, %12
  %16 = shl i32 %12, 4
```