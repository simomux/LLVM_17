//===-- LocalOpts.cpp - Example Transformations --------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Utils/LocalOpts.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstrTypes.h"

using namespace llvm;

bool runOnBasicBlock(BasicBlock &B) {
    for (auto &I : B) {
        if (Instruction::Mul == I.getOpcode()) {
            outs() << "\nFound a multiplication: " << I << "\n";

            ConstantInt *powerOfTwoOp = nullptr;
            bool swap = false;

            // Check if second operand is a constant and if it's a power of 2
            // Gives priority to the second operand, since IR syntax states that if it's just a constant it should be on the right-most side (pass can trasnform even multiplication with a constant on the left side, the right side is the priority in case both operands are constants power of 2)
            if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
              if (secondConst->getValue().isPowerOf2()) {
                  powerOfTwoOp = secondConst;
              }
            }

            // Check for constants and identify the power of 2 operand
            // If second operator is a constant and already a power of 2, we don't need to check the first one
            if (powerOfTwoOp == nullptr) {
              if (ConstantInt *firstConst = dyn_cast<ConstantInt>(I.getOperand(0))) {
                if (firstConst->getValue().isPowerOf2()) {
                    powerOfTwoOp = firstConst;
                    swap = true;
                }
              }
            }

            // Check that at least one of the operands is a constant power of 2
            if (powerOfTwoOp != nullptr) {
                ConstantInt *shiftConst = ConstantInt::get(powerOfTwoOp->getType(), powerOfTwoOp->getValue().exactLogBase2());
                outs() << "Using opreand with value of " << powerOfTwoOp->getValue() << "\n";

                Instruction *NewInst;

                // If the first operand is the power of 2, we need to swap the operands
                if (swap) {
                  NewInst = BinaryOperator::Create(Instruction::Shl, I.getOperand(1), shiftConst);
                } else {
                  NewInst = BinaryOperator::Create(Instruction::Shl, I.getOperand(0), shiftConst);
                }

                NewInst->insertAfter(&I);
                I.replaceAllUsesWith(NewInst);
            } else {
                outs() << "No power of 2 constant found\n";
            }
        }
    }
    return true;
}



bool runOnFunction(Function &F) {
  bool Transformed = false;

  for (auto Iter = F.begin(); Iter != F.end(); ++Iter) {
    if (runOnBasicBlock(*Iter)) {
      Transformed = true;
    }
  }

  return Transformed;
}


PreservedAnalyses LocalOpts::run(Module &M,
                                      ModuleAnalysisManager &AM) {
  for (auto Fiter = M.begin(); Fiter != M.end(); ++Fiter)
    if (runOnFunction(*Fiter))
      return PreservedAnalyses::none();
  
  return PreservedAnalyses::all();
}

