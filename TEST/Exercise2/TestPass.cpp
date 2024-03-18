// File needs to be pasted in SRC/llvm/lib/Transforms/Utils
// File needs to be added to SRC/llvm/lib/Transforms/Utils/CMakeLists.txt by adding 'TestPass.cpp' in alphabetical order
// Function TestPass needs to added to SRC/llvm/lib/Passes/PassRegistry.def by adding 'MODULE_PASS("testpass", TestPass())' in alphabetical order

#include "llvm/Transforms/Utils/TestPass.h"

using namespace llvm;

/* Function version of pass
In this case you need to add to SRC/llvm/lib/Passes/PassRegistry.def by adding 'FUNCTION_PASS("testpass", TestPass())' in alphabetical order


PreservedAnalyses TestPass::run(Function &F, FunctionAnalysisManager &AM) {
        // Print function name
        errs() << "\nFunzione: " << F.getName() << "\n";

        // Print number of arguments
        if (F.isVarArg()){
            errs() << "N° di argomenti: " << F.arg_size() << "+*\n";
        } else {
            errs() << "N° di argomenti: " << F.arg_size() << "\n";
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
        errs() << "N° di chiamate: " << callCounter << "\n";

        //Print number of basic blocks
        errs() << "N° di BB: " << F.size() << "\n";

        // Print number of instructions
        errs() << "Istruzioni: " << F.getInstructionCount() << "\n";

        return PreservedAnalyses::all();
}*/

// Module version of pass
PreservedAnalyses TestPass::run(Module &M, ModuleAnalysisManager &AM) {
// Print function name
    for (auto &F : M) {
        errs() << "\nFunzione: " << F.getName() << "\n";

        // Print number of arguments
        if (F.isVarArg()){
            errs() << "N° di argomenti: " << F.arg_size() << "+*\n";
        } else {
            errs() << "N° di argomenti: " << F.arg_size() << "\n";
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
        errs() << "N° di chiamate: " << callCounter << "\n";

        //Print number of basic blocks
        errs() << "N° di BB: " << F.size() << "\n";

        // Print number of instructions
        errs() << "Istruzioni: " << F.getInstructionCount() << "\n";
    }

    return PreservedAnalyses::all();
}