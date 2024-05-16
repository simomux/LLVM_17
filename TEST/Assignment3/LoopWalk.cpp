#include "llvm/Transforms/Utils/LoopWalk.h" 
#include "llvm/IR/Dominators.h"
#include "llvm/Analysis/ValueTracking.h"
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
  if (llvm::isa<llvm::Constant>(operand) || llvm::isa<llvm::Argument>(operand)) {
    return true;
  }
  if (llvm::Instruction *instruction = llvm::dyn_cast<llvm::Instruction>(operand)) {
    if (!L.contains(instruction->getParent()) || loopInvariantInstructions.count(instruction)) {
      return true;
    }
  }
  return false;
}

bool isInstructionLoopInvariant(llvm::Instruction *I, Loop &L, std::unordered_set<llvm::Instruction*> &loopInvariantInstructions) {
  for (auto &operand : I->operands()) {
    if (!isOperandLoopInvariant(operand, L, loopInvariantInstructions)) {
      outs() << "Not Loop invariant: " << *I << "\n";
      return false;
    }
  }
  outs() << "Loop invariant: " << *I << "\n";
  return true;
}

PreservedAnalyses LoopWalk::run(Loop &L, LoopAnalysisManager &AM, LoopStandardAnalysisResults &AR, LPMUpdater &U) {

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
  DominatorTree &DT = AR.DT;

  //DT.print(outs());


  llvm::SmallVector<BasicBlock *> exits{};

  L.getUniqueExitBlocks(exits);

  outs() << "\n\n";
  outs() << "Number of exits: " << exits.size() << " \n";
  for (uint i = 0; i < exits.size(); i++) {
    outs() << *exits[i] << "\n";
  }



  bool allDominators;
  std::vector<llvm::Instruction*> instructionsToMove{};

  for (auto &BB : L.blocks()) {
    allDominators = true;
    for (BasicBlock *exit : exits) {
      allDominators &= DT.dominates(BB, exit);
    }
    if (allDominators) {
      for (llvm::Instruction &I : *BB) {
        // Check if I is in the loop invariant set and if it's safe to move
        if (loopInvariantInstructions.count(&I) && isSafeToSpeculativelyExecute(&I) && I.getOpcode()) {
          outs() << "This instruction can be moved: " << I << "\n";
          instructionsToMove.push_back(&I);
        }
      }
    }
  }
  
  
  BasicBlock *prehead = L.getLoopPreheader();
  for (llvm::Instruction *I : instructionsToMove) {
    I->moveBefore(prehead->getTerminator());
  }
  


  /*
  • Sono loop invariant
  • Si trovano in blocchi che dominano tutte le uscite del loop
  • Assegnano un valore a variabili non assegnate altrove nel loop
  • Si trovano in blocchi che dominano tutti i blocchi nel loop che usano lavariabile a cui si sta assegnando un valore*/


  return PreservedAnalyses::all();
}
