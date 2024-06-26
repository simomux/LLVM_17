# First assignment of my middle-end compilers class

The goal is to extend `LocalOpts.cpp` from exercise 2 LAB 2, adding the following local optimizations:

1. Algebraic Identity: Simplifying basic equations:
    - `x + 0 = 0 + x = x -> x`
    - `x * 1 = 1 * x = x -> x`

2. Strength Reduction: Transforming an expensive operation into a simpler one:
    - `15 * x = x * 15 -> (x << 4) - x`
      - If the constant is within the range of ±1 from a power of 2 after shifting to the closest power, you need to add a sum/subtraction.
    - `y = x / 8 -> y = x >> 3`

3. Multi-Instruction Optimization:
    - `a = b + 1, c = a - 1 -> a = b + 1, c = b`


## Solution

### [LocalOpts.h](https://github.com/simomux/LLVM_17/blob/testing/TEST/Assignment1/LocalOpts.h)

Contains the class definition for each module pass:

- `AlgebraicIdentity` is the pass for point 1;
- `StrengthReduction` is the pass for point 2;
- `MultiInstructionOptimization`is the pass for point 3;

### [LocalOpts.cpp](https://github.com/simomux/LLVM_17/blob/testing/TEST/Assignment1/LocalOpts.cpp)

Contains the source code and the definition of each pass.

### How to test:

Copy and paste:

- `PassRegistry.def` in `SRC/llvm/lib/Passes/`
- `LocalOpts.cpp` in `SRC/llvm/lib/Transforms/Utils/`
- `LocalOpts.h` in `SRC/llvm/include/llvm/Transforms/Utils/`

Then rebuild opt and reinstall with:

```Bash
make opt
make install
```

To run `AlgebraicIdentity`:

```Bash
opt -p algebraic foo.ll -o foo.optimized.bc
llvm-dis foo.optimized.bc -o foo.optimized.ll
```

To run `StrengthReduction`:

```Bash
opt -p strength foo.ll -o foo.optimized.bc
llvm-dis foo.optimized.bc -o foo.optimized.ll
```

To run `MultiInstructionOptimization`:

```Bash
opt -p multi foo.ll -o foo.optimized.bc
llvm-dis foo.optimized.bc -o foo.optimized.ll
```

To test all the passes together run:

```Bash
opt -passes="multi,strength,algebraic" foo.ll -o foo.optimized.bc 
llvm-dis foo.optimized.bc -o foo.optimized.ll
```

You should always run `multi` before `strength` to avoid possible error of compatibility between passes.

#### Project members: [Simone Mussini](https://github.com/simomux), [Paride Stomeo](https://github.com/paridestomeo)