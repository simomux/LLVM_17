# Third Assignment: Middle-End Compilers Class - LICM

This assignment involves implementing a custom loop pass for Loop Invariant Code Motion (LICM).

You can start with a template such as [LAB3 Exercise2](https://github.com/simomux/LLVM_17/tree/c108417a3bbab5545b7fed1c2dc0f75b7432d83f/TEST/LAB3/Exercise2).

## Algorithm

Given a set of nodes in a loop, the algorithm follows these steps:

1. Identify **reaching definitions**.
2. Locate **loop-invariant** instructions.
3. Compute the dominance tree.
4. Find loop exits.

An instruction to be moved must meet the following criteria:

1. It is loop invariant.
2. It is in a block that dominates all loop exits.
3. It assigns a value to a variable that is not assigned anywhere else in the loop.
4. It is inside a block that dominates all loop blocks where the variable it assigns is used.

For depth-first search blocks:

* Move the candidate instruction to the loop preheader if all loop-invariant instructions it depends on have been moved.

## Solution

File `LoopWalk.h` was included in `SRC/llvm/lib/Passes/PassBuilder.cpp` with the following code:

```cpp
#include "llvm/Transforms/Utils/LoopWalk.h"
```

`LoopWalk.cpp` was added to `SRC/llvm/lib/Transforms/Utils/CMakeLists.txt`.

Pass `loopwalk` was added to `SRC/llvm/lib/Passes/PassRegistry.def` as follows:

```text
LOOP_PASS("loopwalk", LoopWalk())
```

You can find the solution here:

* [LoopWalk.cpp](https://github.com/simomux/LLVM_17/blob/c108417a3bbab5545b7fed1c2dc0f75b7432d83f/TEST/Assignment3/LoopWalk.cpp).
* [LoopWalk.h](https://github.com/simomux/LLVM_17/blob/0e81133baf086c595d61ff524ce518b63a3696b5/TEST/Assignment3/LoopWalk.h)

Paste the following files in the following directories:

* `LoopWalk.h` in `SRC/llvm/include/llvm/Transforms/Utils/`;
* `LoopWalk.cpp` in `SRC/llvm/lib/Transforms/Utils/`.

Then re-build the `opt` binary with:

```bash
make opt
```

And install with:

```bash
make install
```

## Run the pass

You can test by running:

```bash
clang -O0 -Rpass=".*" -emit-llvm -S -c -Xclang -disable-O0-optnone LICM.c -o LICMNotOptimized.ll
```

Then optimizing with `mem2reg` with:

```bash
opt -passes=mem2reg LICMNotOptimized.ll -o LICM.bc
```

Then disassemblying back to IR with:

```bash
llvm-dis LICM.bc -o LICM.ll
```

And finally running the custom pass with:

```bash
opt -passes=loopwalk LICM.ll -o LICM.bc
```

## Check results

To check the results of the pass, first disassamble the bytecode generated from the IR:

```bash
llvm-dis LICM.bc -o LICMOptimized.ll
```

Then check the resulting files.
The instruction should all have been moved inside the pre-header.
You can find a copy of the resulting file [here](https://github.com/simomux/LLVM_17/blob/main/TEST/Assignment3/LICMOptimized.ll).

## Team

* Simone Mussini ([GitHub](https://github.com/simomux))
* Paride Stomeo ([GitHub](https://github.com/paridestomeo))