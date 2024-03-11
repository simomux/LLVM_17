First exercise requires to comment both IR representation compiled with O0 and O2 flag by clang and draw the Control Flow Graph (GFG) of each function, dividing the code in Building Blocks (BB).

To compile the c files:
`clang <opt flag> -Rpass=.* -emit-llvm -S -c foo.c -o foo.ll`

Files both need to be compiled with opt flag = O0 and opt flag = O2.