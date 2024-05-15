#include "llvm/Transforms/Utils/LoopWalk.h" 
#include <unordered_set>

using namespace llvm;

void printLoopInfo(llvm::Loop &L) {
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
  } else {
    outs() << "LoopWalk: Loop is not in simplified form\n";
  }
  outs() << "\n\n\n";
}

// True if the operand is defined inside the loop
bool isOperandLoopInvariant(llvm::Value *operand, Loop &L, std::unordered_set<llvm::Instruction*> &loopInvariantInstructions) {
  ///TODO: forse si può migliorare la logica in sta funzione
  if (isa<llvm::Constant>(operand) || isa<llvm::Argument>(operand)) {
    return true;
  }
  if (llvm::Instruction *instruction = dyn_cast<llvm::Instruction>(operand)) {
    if (!L.contains(instruction->getParent()) || loopInvariantInstructions.count(instruction)) {
      return true;
    }
  }
  return false;
}

bool isInstructionLoopInvariant(llvm::Instruction *I, Loop &L, std::unordered_set<llvm::Instruction*> &loopInvariantInstructions) {
  ///TODO: fix di questo if perché così fa schifo
  if (isOperandLoopInvariant(I->getOperand(0), L, loopInvariantInstructions) || (I->isBinaryOp()) ? isOperandLoopInvariant(I->getOperand(1), L, loopInvariantInstructions) : false) {
    outs() << "This instruction can be removed: " << *I << "\n";
    return true;
  } else {
    outs() << "This instruction can't be removed: " << *I << "\n";
    return false;
  }
}

PreservedAnalyses LoopWalk::run(Loop &L, LoopAnalysisManager &AM, LoopStandardAnalysisResults &AR, LPMUpdater &U) {

  // Print loop information
  printLoopInfo(L);

  std::unordered_set<llvm::Instruction*> loopInvariantInstructions{};

  // Go through all the instructions in the loop and check if they are loop invariant
  for (auto &BB : L.blocks()) {
    for (llvm::Instruction &I : *BB) {
      if (isInstructionLoopInvariant(&I, L, loopInvariantInstructions)) {
        loopInvariantInstructions.insert(&I);
      }
    }
  }

  // At this point you should a have all the LI instructions in the loopInvariantInstructions vector
  ///TODO: controllo con dominance treee

  return PreservedAnalyses::all();
}
