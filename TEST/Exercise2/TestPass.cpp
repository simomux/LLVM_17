// File needs to be pasted in SRC/llvm/lib/Transforms/Utils
// File needs to be added to SRC/llvm/lib/Transforms/Utils/CMakeLists.txt by adding 'TestPass.cpp' in alphabetical order
// Function TestPass needs to added to SRC/llvm/lib/Passes/PassRegistry.def by adding 'FUNCTION_PASS("testpass", TestPass())' in alphabetical order
 

#include "llvm/Transforms/Utils/TestPass.h"

using namespace llvm;

PreservedAnalyses TestPass::run(Function &F, FunctionAnalysisManager &AM) {
        errs() << "Questa funzione si chiama" << F.getName() << "\n";
        return PreservedAnalyses::all();
}