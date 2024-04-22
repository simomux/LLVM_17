#ifndef LLVM_TRANSFORMS_LOOPWALK_H
#define LLVM_TRANSFORMS_LOOPWALK_H

#include "llvm/IR/PassManager.h"
#include <llvm/IR/Constants.h>

namespace llvm {
    class LoopWalk : public PassInfoMixin<LoopWalk> {
    public:
        PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
    };
} // namespace llvm

#endif // LLVM_TRANSFORMS_LOOPWALK_H