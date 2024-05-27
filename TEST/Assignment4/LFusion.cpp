#include "llvm/Transforms/Utils/LFusion.h"
#include "llvm/IR/Dominators.h"
#include "llvm/Analysis/LoopInfo.h"

llvm::PreservedAnalyses llvm::LFusion::run(Function &F, FunctionAnalysisManager &AM) {
  llvm::LoopInfo &LI = AM.getResult<llvm::LoopAnalysis>(F);

  outs() << "Loop Fusion!";

  return llvm::PreservedAnalyses::all();
}