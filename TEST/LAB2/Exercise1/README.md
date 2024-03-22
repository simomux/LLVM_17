### Exercise 1 LAB 2 of my middle-end compilers class
Given a `Foo.ll` and `LocalOpts.cpp` from my professor we need to create in the correct repository `LocalOpts.h` with the definition of the run method and then add the pass and it's run method to `SRC/llvm/lib/Transforms/Utils/CMakeLists.txt`, `SRC/llvm/lib/Passes/PassRegistry.def` and `SRC/llvm/lib/Passes/PassBuilder.cpp`, following the same steps of Exercise 2 LAB 1.

Then rebuild opt with:
```
make opt
```
And then:
```
make install
```

Finally optimize `Foo.ll` with:
```
opt -p localopts Foo.ll -o Foo.optimized.bc
```

And disassemble the bytecode back into IR with:
```
llvm-dis Foo.optimized.bc -o Foo.optimized.ll
```