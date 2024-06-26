#ifndef LLVM_TRANSFORMS_UTILS_LOOPWALK_H
#define LLVM_TRANSFORMS_UTILS_LOOPWALK_H

#include "llvm/IR/PassManager.h"
#include "llvm/Transforms/Scalar/LoopPassManager.h"

namespace llvm {
    class LoopWalk : public PassInfoMixin<LoopWalk> {
    public:
        PreservedAnalyses run(Loop &L, LoopAnalysisManager &AM, LoopStandardAnalysisResults &AR, LPMUpdater &U);
    };
}

#endif