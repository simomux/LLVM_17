#include "llvm/Transforms/Utils/PrintChains.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstrTypes.h"

using namespace llvm;

bool runOnBasicBlock(BasicBlock &B) {
    for (auto &I : B) {
      if (I.isBinaryOp()) {
        // Print instruction I uses
        outs() << "Instruction: " << I << "\n";
        outs() << "Uses: \n";
        for (auto &U: I.uses()) {
          outs() << *U.getUser() << "\n";
        }

        outs() << "First operand: ";
        // Print definition of I operands
        if (ConstantInt *Operand1 = dyn_cast<ConstantInt>(I.getOperand(0))) {
          outs() << "constant " << Operand1->getValue() << "\n";
        } else {
          outs() << *I.getOperand(0) << "\n";
        }
        
        outs() << "Second operand: ";
        if (ConstantInt *Operand2 = dyn_cast<ConstantInt>(I.getOperand(1))) {
          outs()  << "constant " << Operand2->getValue() << "\n";
        } else {
          outs() << *I.getOperand(1) << "\n";
        }
        outs() << "\n";
      }
    }
    return false;
}

PreservedAnalyses PrintChains::run(Module &M, ModuleAnalysisManager &AM) {
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