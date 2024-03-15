### Exercise 2 of my middle-end compilers class
Objective is to add a new custom pass to opt.

First step is to create the pass by writing a new `TestPass.h` in `SRC/llvm/include/llvm/Transforms/Utils/`.
Then you can effectively create the code of the pass function in `TestPass.cpp` in `SRC/llvm/lib/Transforms/Utils/`.

After that you can add the definition of the pass function to `PassRegistry.cpp` in `SRC/llvm/lib/Passes/`.
You can include the pass header to `PassBuilder.cpp` in `SRC/llvm/lib/Passes/`.
Finally add the pass source code to the CMake configuration by adding the source code filename to the `CMakeList.txt` in `SRC/llvm/lib/Transforms/Utils/`

We can rebuild the install by running `make opt` in `BUILD` and then `make install` (this final part is not necessary, you can run opt directly from `BUILD/bin`).

In the end you can run `opt -passes=testpass TEST/Exercise1/LoopO2.ll –o TEST/Exercise2/LoopTestPassO2.ll`.
The output should be:
`Questa funzione si chiama g_incr`
`Questa funzione si chiama loop`