#ifndef LLVM_TRANSFORMS_LFUSION_H
#define LLVM_TRANSFORMS_LFUSION_H

#include "llvm/IR/PassManager.h"
#include <llvm/IR/Constants.h>

namespace llvm {
    class LFusion : public PassInfoMixin<LFusion> {
    public:
        PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
    };
}

#endif