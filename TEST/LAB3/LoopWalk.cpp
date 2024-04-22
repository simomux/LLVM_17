#include "llvm/Transforms/Utils/LoopWalk.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstrTypes.h"

using namespace llvm;

bool runOnBasicBlock(BasicBlock &B) {
    for (auto &I : B) {
      outs() << "I am the instruction: " << I << "\n";

      outs() << "Me as an operand: ";
      I.printAsOperand(outs(), false);
      outs() << "\n";
    }
    return true;
}

PreservedAnalyses LoopWalk::run(Module &M, ModuleAnalysisManager &AM) {
  bool modified = false;
  for (auto &F : M) {
    for (auto &B : F) {
      if (runOnBasicBlock(B)) { modified = true; }
    }
    if (modified) {
      return PreservedAnalyses::none();
    }
  }
  return PreservedAnalyses::all();
}