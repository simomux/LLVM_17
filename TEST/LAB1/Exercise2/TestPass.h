// FIle needs to be pasted in SRC/llvm/include/llvm/Transforms/Utils
// File needs to be added to SRC/llvm/lib/Passes/PassBuilder.cpp by adding '#include "llvm/Transforms/Utils/TestPass.h"' in alphabetical order

#ifndef LLVM_TRANSFORMS_TESTPASS_H
#define LLVM_TRANSFORMS_TESTPASS_H

#include "llvm/IR/PassManager.h"

namespace llvm {
    class TestPass : public PassInfoMixin<TestPass> {
    public:
        // Function version of pass
        // PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);

        // Module version of pass
        PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
    };
} // namespace llvm

#endif // LLVM_TRANSFORMS_TESTPASS _H