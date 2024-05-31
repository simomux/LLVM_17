#include "llvm/Transforms/Utils/LFusion.h"
#include "llvm/IR/Dominators.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/DependenceAnalysis.h"
#include "llvm/IR/TypedPointerType.h"

void foundPair(llvm::Loop* &L1, llvm::Loop* &L2, std::set<std::pair<llvm::Loop*, llvm::Loop*>> &set) {
  L1->print(llvm::outs());
  L2->print(llvm::outs());
  set.insert(std::make_pair(L1, L2));
}

void findAdjacentLoops(llvm::LoopInfo &LI, std::set<std::pair<llvm::Loop*, llvm::Loop*>> &adjacentLoops) {
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

llvm::PreservedAnalyses llvm::LFusion::run(Function &F, FunctionAnalysisManager &AM) {
  llvm::LoopInfo &LI = AM.getResult<llvm::LoopAnalysis>(F);
  
  // Sctructure containg pairs of loops that are adjacent
  std::set<std::pair<llvm::Loop*, llvm::Loop*>> adjacentLoops {};

  // Find adjacent loops
  findAdjacentLoops(LI, adjacentLoops);

  /* for(auto loop : adjacentLoops) {
    llvm::outs() << "Pair: \n";
    loop.first->print(llvm::outs());
    loop.second->print(llvm::outs());
  } */

  DominatorTree &DT = AM.getResult<DominatorTreeAnalysis>(F);
  PostDominatorTree &PDT = AM.getResult<PostDominatorTreeAnalysis>(F);

  DT.print(llvm::outs());
  PDT.print(llvm::outs());

  // Sctructure containg the pairs of loops that are candidates for fusion
  std::set<std::pair<llvm::Loop*, llvm::Loop*>> areCFEquivalent {};
  
  // Check if loops are control flow equivalent
  for (auto loop : adjacentLoops) {
    if(loop.first->isGuarded()){
      if(DT.dominates(loop.first->getLoopGuardBranch()->getParent(), loop.second->getLoopGuardBranch()->getParent()) && PDT.dominates(loop.second->getLoopGuardBranch()->getParent(), loop.first->getLoopGuardBranch()->getParent())){
        llvm::outs() << "\nLoops are control flow equivalent\n";
        foundPair(loop.first, loop.second, areCFEquivalent);
      }
    } else {
      if (DT.dominates(loop.first->getHeader(), loop.second->getHeader()) && PDT.dominates(loop.second->getHeader(), loop.first->getHeader())) {
        llvm::outs() << "\nLoops are control flow equivalent\n";
        foundPair(loop.first, loop.second, areCFEquivalent);
      }
    }
  }

  
  ScalarEvolution &SE = AM.getResult<ScalarEvolutionAnalysis>(F);

  std::set<std::pair<llvm::Loop*, llvm::Loop*>> haveSameTripCount {};

  // Check if loops have the same trip count
  for (auto loop : areCFEquivalent) {
    auto l1Backedges = SE.getBackedgeTakenCount(loop.first);
    auto l2Backedges = SE.getBackedgeTakenCount(loop.second);

    if (l1Backedges->getSCEVType() == llvm::SCEVCouldNotCompute().getSCEVType() || l2Backedges->getSCEVType() == llvm::SCEVCouldNotCompute().getSCEVType()) exit(1);

    /* l1Backedges->print(llvm::outs());
    llvm::outs() << "\n";
    l2Backedges->print(llvm::outs()); */

    if (l1Backedges == l2Backedges) {
      llvm::outs() << "\nLoops have the same backedge taken count\n";
      foundPair(loop.first, loop.second, haveSameTripCount);
    }
  }
  
  llvm::DependenceInfo &DI = AM.getResult<llvm::DependenceAnalysis>(F);

  std::set<std::pair<llvm::Loop*, llvm::Loop*>> candidateForFusion {};

  // Set that contains all the instructions that has a matrix as operand used in the other loop too.
  std::set<llvm::Instruction*> temporarySet {};


  // Check negative depencence distance
  for (auto loop : haveSameTripCount) {
    for (auto &BB : loop.first->getBlocks()) {
      for (llvm::Instruction &I : *BB) {
        if (I.getOpcode() == llvm::Instruction::GetElementPtr){
          llvm::outs() << "\nInstruction: " << I << "\n";
          
          auto arrayPointer = I.getOperand(0);
          auto offset = I.getOperand(1);

          llvm::outs() << "Use in second loop:\n";
          for (auto &use : arrayPointer->uses()) {
            if (auto inst = llvm::dyn_cast<llvm::Instruction>(use.getUser())) {
              if (loop.second->contains(inst)) {
                llvm::outs() << *inst << "\n";
                if (auto sext = llvm::dyn_cast<llvm::Instruction>(inst->getOperand(1))) {
                  if (auto phyInstruction = llvm::dyn_cast<llvm::Instruction>(sext->getOperand(0))) {
                    if (phyInstruction->getOpcode() != llvm::Instruction::PHI) {
                      temporarySet.insert(phyInstruction);
                    } else {
                      ;
                      ///TODO: Check if the non phi instruction is using a negative offset, in this case you should still be able to merge the loops.
                    }
                  }
                }
              }
            }
          }
        } 
      }
    }
  }

  ///TODO: Code below this comment must me moved inside del for loop at line 103

  // If there are instructions that violates negative depencence distance, print them and don't fuse
  if (!temporarySet.empty()) {
    llvm::outs() << "\n\nThe loop cannot be fused because the following instructions violates negative depencence distance:\n";
    for (auto inst : temporarySet) {
      llvm::outs() << "Instruction: " << *inst << "\n";
    }
    return llvm::PreservedAnalyses::all();
  }

  llvm::outs() << "Loops can be fused\n";
  ///TODO: Code for fusing loops

  return llvm::PreservedAnalyses::none();
}