# Third Assignment: Middle-End Compilers Class - LICM

This assignment involves implementing a custom Loop pass for Loop Invariant Code Motion (LICM).

You can start with a template such as [LAB3 Exercise2](https://github.com/simomux/LLVM_17/tree/c108417a3bbab5545b7fed1c2dc0f75b7432d83f/TEST/LAB3/Exercise2).

## Algorithm

Given a set of nodes in a loop, the algorithm follows these steps:

* Identify **reaching definitions**
* Locate **loop-invariant** instructions
* Compute the dominance tree
* Find loop exits

An instruction to be removed must meet the following criteria:

* It is loop invariant
* It is in a block that dominates all loop exits
* It assigns a value to a variable that is not assigned anywhere else in the loop
* It is inside a block that dominates all loop blocks where the variable it assigns is used

For depth-first search blocks:

* Move the candidate instruction to the loop preheader if all loop-invariant instructions, which this instruction depends on, have been moved.

**Solution:** [link](https://github.com/simomux/LLVM_17/blob/c108417a3bbab5545b7fed1c2dc0f75b7432d83f/TEST/Assignment3/LoopWalk.cpp)

**Team:** Simone Mussini ([link](https://github.com/simomux)), Paride Stomeo ([link](https://github.com/paridestomeo))