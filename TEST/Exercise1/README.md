#### Exercise 1 of my middle-end compilers class
First exercise requires compile and work on 2 .c files given by the professor.

To compile the c files:
`clang <opt flag> -Rpass=.* -emit-llvm -S -c foo.c -o foo.ll`

Both `fibonacci.c` and `loop.c` need to be compiled one time with optimization flag set as O0 and as O2, to compare the resulting IR from the optimization passes.

Once you get the IR representations you need to comment and understand the converted code in both O0 and O2 variants.

Then you need to draw the CFG for each function in each IR.