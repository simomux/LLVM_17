#ifndef LLVM_TRANSFORMS_PRINTCHAINS_H
#define LLVM_TRANSFORMS_PRINTCHAINS_H

#include "llvm/IR/PassManager.h"
#include <llvm/IR/Constants.h>

namespace llvm {
    class PrintChains : public PassInfoMixin<PrintChains> {
    public:
        PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
    };
} // namespace llvm

#endif