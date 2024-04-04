
#ifndef LLVM_TRANSFORMS_LOCALOPTS_H
#define LLVM_TRANSFORMS_LOCALOPTS_H

#include "llvm/IR/PassManager.h"
#include <llvm/IR/Constants.h>

namespace llvm {
    class AlgebraicIdentity : public PassInfoMixin<AlgebraicIdentity> {
    public:
        PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
    };

    class StrengthReduction : public PassInfoMixin<StrengthReduction> {
    public:
        PreservedAnalyses run(Module &F, ModuleAnalysisManager &AM);
    };

    class MultiInstructionOptimization : public PassInfoMixin<MultiInstructionOptimization> {
    public:
        PreservedAnalyses run(Module &F, ModuleAnalysisManager &AM);
    };
} // namespace llvm

#endif // LLVM_TRANSFORMS_LOCALOPTS_H