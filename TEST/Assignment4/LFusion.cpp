#include "llvm/Transforms/Utils/LFusion.h"
#include "llvm/IR/Dominators.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"

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
  std::set<std::pair<llvm::Loop*, llvm::Loop*>> candidateForFusion {};
  
  for (auto loop : adjacentLoops) {
    ///TODO: This condition doesn't seem to work with guarded loops, need to address this
    if (DT.dominates(loop.first->getHeader(), loop.second->getHeader()) && PDT.dominates(loop.second->getHeader(), loop.first->getHeader())) {
      llvm::outs() << "Loops are control flow equivalent\n";
      foundPair(loop.first, loop.second, candidateForFusion);
    }
  }

  
  ScalarEvolution &SE = AM.getResult<ScalarEvolutionAnalysis>(F);

  for (auto loop : candidateForFusion) {
    auto l1Backedges = SE.getSmallConstantMaxTripCount(loop.first);
    auto l2Backedges = SE.getSmallConstantMaxTripCount(loop.second);

    if (l1Backedges == l2Backedges) {
      outs() << "Backedges: " << l1Backedges << " " << l2Backedges<< "\n";
    }
  }

  return llvm::PreservedAnalyses::all();
}