### Exercise 1 LAB 3 of my middle-end compilers class

Create a new pass that prints out every use for each instruction.
If the instruction uses another one print out the declaration of that registry.

File `LoopWalk.h` was included in `SRC/llvm/lib/Passes/PassBuilder.cpp` with:

```Cpp
#include "llvm/Transforms/Utils/LoopWalk.h"
```

`LoopWalk.cpp` was added to `SRC/llvm/lib/Transforms/Utils/CMakeLists.txt`.

And the pass `loopwalk` was added to `SRC/llvm/lib/Passes/PassRegistry.def` as follow:

```text
MODULE_PASS("loopwalk", LoopWalk())
```

### How-to

To test the pass apply the modification above to each file and paste the following files in the following directories:

- `LoopWalk.h` in `SRC/llvm/include/llvm/Transforms/Utils/`;
- `LoopWalk.cpp` in `SRC/llvm/lib/Transforms/Utils/`.

Now you have to re-build the `opt` binary with:

```bash
make opt
```

And install with:

```bash
make install
```

Finally, run:

```bash
opt -p loopwalk Test.ll -o Test.bc
```

And you should see the output on terminal.
