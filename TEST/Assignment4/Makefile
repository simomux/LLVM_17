all: guard unguard multiguard multiunguard

guard:
	clang -O0 -Rpass=".*" -emit-llvm -S -c -Xclang -disable-O0-optnone LoopGuarded.c -o LoopGuarded.ll && opt -p mem2reg LoopGuarded.ll -o Foo.bc && llvm-dis Foo.bc -o LoopGuarded.ll && opt -passes=lfusion LoopGuarded.ll -o Foo.bc && llvm-dis Foo.bc -o GuardedResults.ll

unguard:
	clang -O0 -Rpass=".*" -emit-llvm -S -c -Xclang -disable-O0-optnone LoopUnguarded.c -o LoopUnguarded.ll && opt -p mem2reg LoopUnguarded.ll -o Foo.bc && llvm-dis Foo.bc -o LoopUnguarded.ll && opt -passes=lfusion LoopUnguarded.ll -o Foo.bc && llvm-dis Foo.bc -o UnguardedResults.ll


multiguard:
	clang -O0 -Rpass=".*" -emit-llvm -S -c -Xclang -disable-O0-optnone MultipleGuarded.c -o MultipleGuarded.ll && opt -p mem2reg MultipleGuarded.ll -o Foo.bc && llvm-dis Foo.bc -o MultipleGuarded.ll && opt -passes=lfusion MultipleGuarded.ll -o Foo.bc && llvm-dis Foo.bc -o MultipleGuardedResults.ll

multiunguard:
	clang -O0 -Rpass=".*" -emit-llvm -S -c -Xclang -disable-O0-optnone MultipleUnguarded.c -o MultipleUnguarded.ll && opt -p mem2reg MultipleUnguarded.ll -o Foo.bc && llvm-dis Foo.bc -o MultipleUnguarded.ll && opt -passes=lfusion MultipleUnguarded.ll -o Foo.bc && llvm-dis Foo.bc -o MultipleUnguardedResults.ll


clean:
	rm -f *.bc

cleanall: clean
	rm -f *.ll *.log