# Lab assignments for my Middle-End compilers class A.Y. 2023-2024

LLVM version: 17.0.6

LLVM was build by it's source code at: [github link](https://github.com/llvm/llvm-project/releases/tag/llvmorg-17.0.6)

Source was then configured with CMake as follows:
```
cmake ../SRC/llvm -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../INSTALL -DBUILD_SHARED_LIBS=on -DLLVM_ENABLE_PROJECTS="clang" -DLLVM_TARGETS_TO_BUILD=host
```

After that source was built in separare directory with:
```
make -j<number of jobs>
```

and finally installed with:
```
make install
```

This was all done because during this class we will have to create our own optimization passes and rebuild `opt` to test them, so a binary version of LLVM can't be used.

Final build should be around 3.6 - 4 GB.

All exercises are stored in `TEST` with a brief description of them in a README.

All steps about adding function and include to LLVM files are commented in each file that needs that, I didn't load on the git every modified file since it would be a useless waste of space.