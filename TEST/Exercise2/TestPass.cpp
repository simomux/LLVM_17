// File needs to be pasted in SRC/llvm/lib/Transforms/Utils
// File needs to be added to SRC/llvm/lib/Transforms/Utils/CMakeLists.txt by adding 'TestPass.cpp' in alphabetical order
// Function TestPass needs to added to SRC/llvm/lib/Passes/PassRegistry.def by adding 'FUNCTION_PASS("testpass", TestPass())' in alphabetical order

#include "llvm/Transforms/Utils/TestPass.h"

using namespace llvm;

PreservedAnalyses TestPass::run(Function &F, FunctionAnalysisManager &AM) {
        // Print function name
        errs() << "\nFunction: " << F.getName() << "\n";

        // Print number of arguments
        if (F.isVarArg()){
            errs() << "Args: " << F.arg_size() << "+*\n";
        } else {
            errs() << "Args: " << F.arg_size() << "\n";
        }

        // Count number of function calls
        int callCounter = 0;
        for (auto &BB : F) {
            for (auto &I : BB) {
                if (I.getOpcode() == Instruction::Call) {
                    callCounter++;
                }
            }
        }

        // Print number of function calls
        errs() << "Call instrucion: " << callCounter << "\n";

        //Print number of basic blocks
        errs() << "BB: " << F.size() << "\n";

        // Print number of instructions
        errs() << "Instruction: " << F.getInstructionCount() << "\n";

        return PreservedAnalyses::all();
}