# First assignment of my middle-end compilers class

The goal is to extend `LocalOpts.cpp` from exercise 2 LAB 2, adding the following local optimizations:

1. Algebraic Identity: Simplifying basic equations:
    - `x + 0 = 0 + x = x -> x`
    - `x * 1 = 1 * x = x -> x`

2. Strength Reduction: Transforming an expensive operation into a simpler one:
    - `15 * x = x * 15 -> (x << 4) - x`
      - If the constant is within the range of +- 1 from a power of 2 after shifting to the closest power, you need to add a sum/subtraction.
    - `y = x / 8 -> y = x >> 3`

3. Multi-Instruction Optimization:
    - `a = b + 1, c = a - 1 -> a = b + 1, c = b`


## Solution



#### Project members: [Simone Mussini](https://github.com/simomux), [Paride Stomeo](https://github.com/SupremeXGucci420)