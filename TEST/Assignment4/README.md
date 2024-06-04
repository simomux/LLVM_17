# Fourth Assignment: Middle-End Compilers Class - Loop Fusion

This assignment involves implementing a custom loop pass for Loop Fusion.

## Algorithm

In order for two loops, Lj and Lk to be fused, they must satisfy the following conditions:

1. Lj and Lk **must be adjacent**: There cannot be any statements that execute between the end of Lj and the beginning of Lk.

2. Lj and Lk must **iterate the same number of times**.

3. Lj and Lk must **be control flow equivalent**: When Lj executes Lk also executes or when Lk executes Lj also executes.

4. There **cannot be any negative distance dependencies** between Lj and Lk: A negative distance dependence occurs between Lj and Lk, Lj before Lk, when at iteration m from Lk.

Once all the conditions for loop fusion have been verified, I proceed with the code transformation:

1. Modify the uses of the induction variable in the body of loop 2 with those of the induction variable in loop 1.

2. Modify the CFG so that the body of loop 2 is attached after the body of loop 1 in loop 1.

## Solution

File `LFusion.h` was included in `SRC/llvm/lib/Passes/PassBuilder.cpp` with the following code:

```cpp
#include "llvm/Transforms/Utils/LFusion.h"
```

`LFusion.cpp` was added to `SRC/llvm/lib/Transforms/Utils/CMakeLists.txt`.

Pass `lfusion` was added to `SRC/llvm/lib/Passes/PassRegistry.def` as follows:

```text
FUNCTION_PASS("lfusion", LFusion())
```

You can find the solution here:

* [LFusion.cpp](https://github.com/simomux/LLVM_17/blob/a3f0ed97d372149775a020613a7015b8a697fc51/TEST/Assignment4/LFusion.cpp).
* [LFusion.h](https://github.com/simomux/LLVM_17/blob/a3f0ed97d372149775a020613a7015b8a697fc51/TEST/Assignment4/LFusion.h)

Paste the following files in the following directories:

* `LFusion.h` in `SRC/llvm/include/llvm/Transforms/Utils/`;
* `LFusion.cpp` in `SRC/llvm/lib/Transforms/Utils/`.

Then re-build the `opt` binary and install with:

```bash
make opt && make install
```

## Run the pass

To run the pass on all files simply run:

```bash
make all
```

To run the pass on individual files check [makefile](https://github.com/simomux/LLVM_17/blob/06b5d8da686215954231e1062e23625ad758cf0a/TEST/Assignment4/Makefile).

The pass should be able to optimize multiple pairs of loops in the same function.

We haven't tested if the pass is able to fuse multiple loops, so we can't guarantee that.

We've uploaded 2 test files, one containing 2 unguarded loops, and the other one with 2 guarded ones, since depending on this the steps of the algortihm vary:

* [LoopUnguarded.ll](https://github.com/simomux/LLVM_17/blob/cfb065723ca5d197adc5b86022c75297dc6b40a2/TEST/Assignment4/LoopUnguarded.ll)
* [LoopGuarded.ll](https://github.com/simomux/LLVM_17/blob/cfb065723ca5d197adc5b86022c75297dc6b40a2/TEST/Assignment4/LoopGuarded.ll)
* [MultipleUnguarded.ll](https://github.com/simomux/LLVM_17/blob/06b5d8da686215954231e1062e23625ad758cf0a/TEST/Assignment4/MultipleUnguarded.ll)
* [MultipleGuarded.ll](https://github.com/simomux/LLVM_17/blob/06b5d8da686215954231e1062e23625ad758cf0a/TEST/Assignment4/MultipleGuarded.ll)

## Check results

CFG for each pair of mergeable loops have been rearragend as follows:

### Unguarded loops

```text
header 1 --> L2 exit
body 1 --> body 2
body 2 --> latch 1
header 2 --> latch 2
```

### Guarded loops

```text
guard 1 --> L2 exit
latch 1 --> L2 exit
header 1 --> header 2
header 2 --> latch 1
```

Modified files:

* [UnguardedResults.ll](https://github.com/simomux/LLVM_17/blob/main/TEST/Assignment4/UnguardedResults.ll).
* [GuardedResults.ll](https://github.com/simomux/LLVM_17/blob/main/TEST/Assignment4/GuardedResults.ll).
* [MultipleUnguardedResults.ll](https://github.com/simomux/LLVM_17/blob/06b5d8da686215954231e1062e23625ad758cf0a/TEST/Assignment4/MultipleUnguardedResults.ll)
* [MultipleGuardedResults.ll](https://github.com/simomux/LLVM_17/blob/06b5d8da686215954231e1062e23625ad758cf0a/TEST/Assignment4/MultipleGuardedResults.ll)

## Team

* Simone Mussini ([GitHub](https://github.com/simomux))
* Paride Stomeo ([GitHub](https://github.com/paridestomeo))
