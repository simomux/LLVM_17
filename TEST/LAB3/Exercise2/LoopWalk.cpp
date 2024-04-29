#include "llvm/Transforms/Utils/LoopWalk.h" 

using namespace llvm;

PreservedAnalyses LoopWalk::run(Loop &L, LoopAnalysisManager &AM, LoopStandardAnalysisResults &AR, LPMUpdater &U) {
  // Check if the loop is in simplified form
  if (L.isLoopSimplifyForm()) {

    // Get the preheader, header and blocks of the loop
    L.getLoopPreheader();
    L.getHeader();
    L.getBlocks();

    // Go through all the blocks in the loop
    for (auto &BB : L.blocks()) {
      outs();
    }

    return PreservedAnalyses::none();
  } else {
      return PreservedAnalyses::all();
  }
}