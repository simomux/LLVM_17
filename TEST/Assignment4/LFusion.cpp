#include "llvm/Transforms/Utils/LFusion.h"
#include "llvm/IR/Dominators.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/DependenceAnalysis.h"
#include "llvm/IR/TypedPointerType.h"

// Just a helper function to print the pair of loops that are adjacent
void foundPair(llvm::Loop* &L1, llvm::Loop* &L2, std::set<std::pair<llvm::Loop*, llvm::Loop*>> &set) {
  L1->print(llvm::outs());
  L2->print(llvm::outs());
  set.insert(std::make_pair(L1, L2));
}


// First condition: check if loops are adjacent
void findAdjacentLoops(std::set<std::pair<llvm::Loop*, llvm::Loop*>> &adjacentLoops, llvm::LoopInfo &LI) {
  for (auto *L1 : LI) {
    for (auto *L2: LI) {
      if (L1->isGuarded() && L2->isGuarded()) {
        if (L1->getExitBlock()->getSingleSuccessor() == L2->getLoopGuardBranch()->getParent()) {
          llvm::outs() << "Trovata coppia di loop guarded adiacenti!\n";
          foundPair(L1, L2, adjacentLoops);
        }
      } else {
        if (L1->getExitBlock() == L2->getLoopPreheader()) {
          llvm::outs() << "Trovata coppia di loop unguarded adiacenti!\n";
          foundPair(L1, L2, adjacentLoops);
        }
      }
    }
  }
}


// Second condition: check if loops are control flow equivalent
bool checkEquivalence(std::pair<llvm::Loop*, llvm::Loop*> loop, llvm::DominatorTree &DT, llvm::PostDominatorTree &PDT) {
  if(loop.first->isGuarded()){
    if(DT.dominates(loop.first->getLoopGuardBranch()->getParent(), loop.second->getLoopGuardBranch()->getParent()) && PDT.dominates(loop.second->getLoopGuardBranch()->getParent(), loop.first->getLoopGuardBranch()->getParent())){
      llvm::outs() << "\nLoops are control flow equivalent\n";
      return 1;
    }
  } else {
    if (DT.dominates(loop.first->getHeader(), loop.second->getHeader()) && PDT.dominates(loop.second->getHeader(), loop.first->getHeader())) {
      llvm::outs() << "\nLoops are control flow equivalent\n";
      return 1;
    }
  }
  return 0;
}


// Third condition: check if loops have the same trip count
bool checkSameTripCount(std::pair<llvm::Loop*, llvm::Loop*> loop, llvm::ScalarEvolution &SE) {
  auto l1Backedges = SE.getBackedgeTakenCount(loop.first);
  auto l2Backedges = SE.getBackedgeTakenCount(loop.second);

  if (l1Backedges->getSCEVType() == llvm::SCEVCouldNotCompute().getSCEVType() || l2Backedges->getSCEVType() == llvm::SCEVCouldNotCompute().getSCEVType()) return 0;

  if (l1Backedges == l2Backedges) {
    llvm::outs() << "\nLoops have the same backedge taken count\n";
    return 1;
  }
  return 0;
}


// Fourth condition: check if loops have negative dependencies
bool checkNegativeDependencies(std::pair<llvm::Loop*, llvm::Loop*> loop) {

  // Set that contains all the instructions that has a matrix as operand used in the other loop too.
  std::set<llvm::Instruction*> dependantInstructions {};

  for (auto &BB : loop.first->getBlocks()) {
    for (llvm::Instruction &I : *BB) {
      // Find instructions that works on arrays and get the array pointer
      if (I.getOpcode() == llvm::Instruction::GetElementPtr){
        
        llvm::outs() << "\nInstruction: " << I << "\n";
        llvm::outs() << "Use in second loop:\n";

        // Check if pointer is used in the second loop
        for (auto &use : I.getOperand(0)->uses()) {
          if (auto inst = llvm::dyn_cast<llvm::Instruction>(use.getUser())) {
            if (loop.second->contains(inst)) {
              llvm::outs() << *inst << "\n";
              // Check if the instruction where the pointer is used, uses a sext instruction. This instuction should be another GetElementPtr in L2
              if (auto sext = llvm::dyn_cast<llvm::Instruction>(inst->getOperand(1))) {
                // Check if the sext instruction uses a PHI instruction, if it doesn't it means that there is another instruction that alters the value of the offset
                if (auto phyInstruction = llvm::dyn_cast<llvm::Instruction>(sext->getOperand(0))) {
                  switch(phyInstruction->getOpcode()) {
                    case llvm::Instruction::PHI:
                    case llvm::Instruction::Sub: // If the non-phi instruction is a sub, it means I'm working with a negative offset, in this case you should still be able to merge the loops.
                      break;
                    default:
                      dependantInstructions.insert(phyInstruction); // Otherwise, the offset is being modified by another instruction, so the loops cannot be merged
                  }
                }
              }
            }
          }
        }
      } 
    }
  }

  // Print the instructions that violates the negative dependence distance, if there are any, else return 1
  if (!dependantInstructions.empty()) {
    llvm::outs() << "\n\nThe loop cannot be fused because the following instructions violates negative depencence distance:\n";
    for (auto inst : dependantInstructions) {
      llvm::outs() << "Instruction: " << *inst << "\n";
    }
    return 0;
  }
  return 1;
}

// Fusion of the 2 loops
void loopFusion(llvm::Loop* &L1, llvm::Loop* &L2){
  // Replace uses of IV in L2 with IV in L1
  
  auto firstLoopIV = L1->getCanonicalInductionVariable();
  auto secondLoopIV = L2->getCanonicalInductionVariable();

  llvm::outs() << "First loop IV: " << *firstLoopIV << "\n";
  llvm::outs() << "Second loop IV: " << *secondLoopIV << "\n";

  secondLoopIV->replaceAllUsesWith(firstLoopIV);

  ///TODO: code below this is just testing, need to make this work

  // Modify CFG as follows:
  // header 1 --> L2 exit
  // body 1 --> body 2
  // body 2 --> latch 1
  // header 2 --> latch 2
  
  auto header1 = L1->getHeader();
  auto header2 = L2->getHeader();

  auto latch1 = L1->getLoopLatch();
  auto latch2 = L2->getLoopLatch();

  llvm::outs() << "Header 1: " << *header1 << "\n";
  llvm::outs() << "Header 2: " << *header2 << "\n";
  llvm::outs() << "Latch 1: " << *latch1 << "\n";
  llvm::outs() << "Latch 2: " << *latch2 << "\n";

  // moving induction var to header1 
  indvar2->moveBefore(indvar1);
  indvar1->replaceAllUsesWith(indvar2);
  indvar1->eraseFromParent();

  // update phi instruction 
  indvar2->replaceIncomingBlockWith(preheader2, preheader1);

  header2->replaceAllUsesWith(header1);

  auto *successor = header1;
  while (successor != nullptr && successor->getSingleSuccessor() != latch1) {
      successor = header1->getSingleSuccessor(); //probabile errore loro, sarebbe meglio successor->getSingleSuccessor() secondo me
  }

  // make header2 the successor of header1
    auto * instr = successor->getTerminator();
    auto *br = dyn_cast<BranchInst>(instr);
    br->setSuccessor(0, header2);

}

// Main function
llvm::PreservedAnalyses llvm::LFusion::run(Function &F, FunctionAnalysisManager &AM) {

  // Analysis results
  llvm::LoopInfo &LI = AM.getResult<llvm::LoopAnalysis>(F);
  llvm::DominatorTree &DT = AM.getResult<DominatorTreeAnalysis>(F);
  llvm::PostDominatorTree &PDT = AM.getResult<PostDominatorTreeAnalysis>(F);
  llvm::ScalarEvolution &SE = AM.getResult<ScalarEvolutionAnalysis>(F);


  llvm::DependenceInfo &DI = AM.getResult<llvm::DependenceAnalysis>(F);
  
  // Structure containg pairs of loops that are adjacent
  std::set<std::pair<llvm::Loop*, llvm::Loop*>> adjacentLoops {};
  
  findAdjacentLoops(adjacentLoops, LI);

  bool modified = 0;

  
  for (std::pair<llvm::Loop*, llvm::Loop*> loop : adjacentLoops) {
    if (!checkEquivalence(loop, DT, PDT)) continue;
    if (!checkSameTripCount(loop, SE)) continue;
    if (!checkNegativeDependencies(loop)) continue;
    

    llvm::outs() << "Loops can be fused\n";
    loopFusion(loop.first, loop.second);

    modified = 1;
  }
  if (modified) return llvm::PreservedAnalyses::none();
  else return llvm::PreservedAnalyses::all();
}