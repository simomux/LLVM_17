# Fourth Assignment: Middle-End Compilers Class - Loop Fusion

This assignment involves implementing a custom loop pass for Loop Fusion.

## Algorithm



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

* [LFusion.cpp](https://github.com/simomux/LLVM_17/blob/c108417a3bbab5545b7fed1c2dc0f75b7432d83f/TEST/Assignment3/LoopWalk.cpp).
* [LFusion.h](https://github.com/simomux/LLVM_17/blob/0e81133baf086c595d61ff524ce518b63a3696b5/TEST/Assignment3/LoopWalk.h)

Paste the following files in the following directories:

* `LFusion.h` in `SRC/llvm/include/llvm/Transforms/Utils/`;
* `LFusion.cpp` in `SRC/llvm/lib/Transforms/Utils/`.

Then re-build the `opt` binary and install with:

```bash
make opt && make install
```

## Run the pass

You can test by running:

```bash
clang -O0 -Rpass=".*" -emit-llvm -S -c -Xclang -disable-O0-optnone Foo.c -o Foo.ll
```

Then running the custom pass with:

```bash
opt -passes=lfusion Foo.ll -o Foo.bc
```

We've uploaded 2 test files, one containing 2 ungarded loops, and the other one with 2 guarded ones, since depending on this the steps of the algortihm vary.

## Team

* Simone Mussini ([GitHub](https://github.com/simomux))
* Paride Stomeo ([GitHub](https://github.com/paridestomeo))
