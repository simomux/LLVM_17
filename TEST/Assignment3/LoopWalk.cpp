#include "llvm/Transforms/Utils/LoopWalk.h" 

using namespace llvm;

bool isLoopInvariantOperand(llvm::Instruction &I, Loop &L) {
  if (llvm::Instruction *operand1 = dyn_cast<llvm::Instruction>(I.getOperand(0))) {
    if (L.contains(operand1->getParent())) {
      return false;
    }
  }
  
  if (llvm::Instruction *operand2 = dyn_cast<llvm::Instruction>(I.getOperand(1))) {
    if (L.contains(operand2->getParent())) {
      return false;
    }
  }
  return true;
}

bool isLoopInvariantInstruction() {
  outs() << "isLoopInvariantInstruction\n";
}

PreservedAnalyses LoopWalk::run(Loop &L, LoopAnalysisManager &AM, LoopStandardAnalysisResults &AR, LPMUpdater &U) {
    for (auto &BB : L.blocks()) {
      for (llvm::Instruction &I : *BB) {
        if (I.isBinaryOp()) {
          bool del = true;
          
          del = isLoopInvariantOperand(I, L);

          if (del) {
            outs() << "Operazione da rimuovere: " << I << "\n";
          } else {
            outs() << "Operazione non è da rimuovere: " << I << "\n";
          }
        }
      }
    }
    return PreservedAnalyses::none();
}
