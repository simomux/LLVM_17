#include "llvm/Transforms/Utils/LoopWalk.h" 

using namespace llvm;

PreservedAnalyses LoopWalk::run(Loop &L, LoopAnalysisManager &AM, LoopStandardAnalysisResults &AR, LPMUpdater &U) {
  // Check if the loop is in simplified form
  if (L.isLoopSimplifyForm()) {
    outs() << "LoopWalk: Loop is in simplified form\n";
    
    outs() << "\nLoop pre-header: ";
    L.getLoopPreheader()->print(outs());

    outs() << "\n\nLoop header:";
    L.getHeader()->print(outs());

    // Go through all the blocks in the loop
    outs() << "\n\nLoop blocks:";
    for (auto &BB : L.blocks()) {
      BB->print(outs());
    }

    return PreservedAnalyses::none();
  } else {
    outs() << "LoopWalk: Loop is not in simplified form\n";
    return PreservedAnalyses::all();
  }
}