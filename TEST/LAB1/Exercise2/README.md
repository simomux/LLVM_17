## Exercise 2 of My Middle-End Compilers Class
### Part 1:
#### The objective is to add a new custom pass to opt.

The first step is to create the pass by writing a new `TestPass.h` in `SRC/llvm/include/llvm/Transforms/Utils/`.
Then, you can effectively create the code of the pass function in `TestPass.cpp` in `SRC/llvm/lib/Transforms/Utils/`.

After that, you can add the definition of the pass function to `PassRegistry.cpp` in `SRC/llvm/lib/Passes/`.
You can include the pass header in `PassBuilder.cpp` in `SRC/llvm/lib/Passes/`.
Finally, add the pass source code to the CMake configuration by adding the source code filename to the `CMakeList.txt` in `SRC/llvm/lib/Transforms/Utils/`.

We can rebuild the install by running `make opt` in `BUILD` and then `make install` (this final part is not necessary, you can run opt directly from `BUILD/bin`).

In the end, you can run:
```
opt -passes=testpass TEST/Exercise1/LoopO2.ll –o LoopTestPassO2.ll
```


### Part 2:
#### The objective is to add more functionalities to the pass.

List of functionalities:
- The pass must print the number of arguments for each function (`N+*` if `argc` is variable).
- The pass must print the number of call instructions for each function.
- The pass must print the number of Basic Blocks (BB) for each function.
- The pass must print the number of instructions for each function.


### Part 3:
#### Convert the function pass to a module pass

First adapt `TestPass.h` to crate a module pass, by passing the module and the analyzer in the run method.

Then change the actual run method code in `TestPass.cpp`, making it loop on every funcion of the module.

Finally change `PassRegistry.def` by removing from the function pass block:
```
FUNCTION_PASS("testpass", TestPass())
```

And adding to the Module pass block in alphabetical order:
```
MODULE_PASS("testpass", TestPass())
```
