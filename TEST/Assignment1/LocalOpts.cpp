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

bool strenghtReductionMul(Instruction &I) {
  // Constant power of 2 can be the first operand, the second operand or both. In the last case choose the second one by default (following IR syntax)
  if (I.getOpcode() == Instruction::Mul) {
    outs() << "\nFound a multiplication: " << I << "\n";

    ConstantInt *powerOfTwoOp = nullptr;
    bool swap = false;
    // Need a offset to keep track if the operand was rounded to the closest power of 2 by -1 or +1. If not rounded, offset is 0
    int offset = 0;

    // Check if second operand is a constant and if it's a power of 2
    // Gives priority to the second operand, since IR syntax states that if it's just a constant it should be on the right-most side (pass can trasnform even multiplication with a constant on the left side, the right side is the priority in case both operands are constants power of 2)
    if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
      if (secondConst->getValue().isPowerOf2()) {
          powerOfTwoOp = secondConst;
      } else if ((secondConst->getValue()-1).isPowerOf2()) {
          powerOfTwoOp = secondConst;
          offset = -1;
          outs() << "Operand rounded to closest power of 2 by -1: " << secondConst->getValue()-1 << "\n";
      } else if ((secondConst->getValue()+1).isPowerOf2()) {
          powerOfTwoOp = secondConst;
          offset = 1;
          outs() << "Operand rounded to closest power of 2 by +1: " << secondConst->getValue()+1 << "\n";
      }
    }

    // Check for constants and identify the power of 2 operand
    // If second operator is a constant and already a power of 2, we don't need to check the first one
    if (powerOfTwoOp == nullptr) {
      if (ConstantInt *firstConst = dyn_cast<ConstantInt>(I.getOperand(0))) {
        if (firstConst->getValue().isPowerOf2()) {
          powerOfTwoOp = firstConst;
          swap = true;
        } else if ((firstConst->getValue()-1).isPowerOf2()) {
          powerOfTwoOp = firstConst;
          offset = -1;
          swap = true;
          outs() << "Operand rounded to closest power of 2 by -1: " << firstConst->getValue()-1 << "\n";
        } else if ((firstConst->getValue()+1).isPowerOf2()) {
          powerOfTwoOp = firstConst;
          offset = 1;
          swap = true;
          outs() << "Operand rounded to closest power of 2 by +1: " << firstConst->getValue()+1 << "\n";
        }
      }
    }

    // Check that at least one of the operands is a constant power of 2
    if (powerOfTwoOp != nullptr) {
        ConstantInt *shiftConst = ConstantInt::get(powerOfTwoOp->getType(), (powerOfTwoOp->getValue()+offset).exactLogBase2());
        outs() << "Using opreand with value of " << powerOfTwoOp->getValue() << "\n";

        Instruction *NewInst;

        // If the first operand is the power of 2, we need to swap the operands
        Value *tmpValue;
        if (swap) {
          tmpValue = I.getOperand(1);
        } else {
          tmpValue = I.getOperand(0);
        }

        NewInst = BinaryOperator::Create(Instruction::Shl, tmpValue, shiftConst);
        NewInst->insertAfter(&I);

        // Offset = 1 if operand + 1 is a power of 2, so we need to subtract the operand 1 more time to the result and change uses to the sub result
        if (offset == 1) {
          Instruction *offsetInst = BinaryOperator::Create(Instruction::Sub, NewInst, tmpValue);
          offsetInst->insertAfter(NewInst);
          I.replaceAllUsesWith(offsetInst);

        // Offset = -1 if operand - 1 is a power of 2, so we need to add the operand 1 more time to the result and change uses to the add result
        } else if (offset == -1) {
          Instruction *offsetInst = BinaryOperator::Create(Instruction::Add, NewInst, tmpValue);
          offsetInst->insertAfter(NewInst);
          I.replaceAllUsesWith(offsetInst);
        // If no offset, just replace uses with the shift instruction
        } else {
          I.replaceAllUsesWith(NewInst);
        }

        return true;
    } else {
        outs() << "No power of 2 constant found\n";
    }
  } else if (Instruction::SDiv == I.getOpcode()) {
    outs() << "\nFound a division: " << I << "\n";
    // Just need to check if second operand is a constant power of 2
    if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
      if (secondConst->getValue().isPowerOf2()) {
        ConstantInt *shiftConst = ConstantInt::get(secondConst->getType(), (secondConst->getValue()).exactLogBase2());
        outs() << "Using opreand with value of " << secondConst->getValue() << "\n";
        Instruction *NewInst = BinaryOperator::Create(Instruction::AShr, I.getOperand(0), shiftConst);

        NewInst->insertAfter(&I);
        I.replaceAllUsesWith(NewInst);
        return true;
      } else {
        outs() << "Second operand is not a power of 2\n";
      }
    }
  }
  return false;
}


bool algebricIdentitySumSub(Instruction &I) {
  // x+0 or 0+x
  if (I.getOpcode() == Instruction::Add)
  {
    /* code */
  }else if (I.getOpcode() == Instruction::Sub)
  {
    /* code */
  }
  
  
}

bool algebricIdentityMulDiv(Instruction &I) {
  //x*1 or 1*x
}

bool runOnBasicBlock(BasicBlock &B) {
  bool modified = false;
  for (auto &I : B) {
      switch(I.getOpcode()){
        case Instruction::Add:

          break;
        case Instruction::Sub:

          break;
        case Instruction::Mul:
        case Instruction::SDiv:
          if(strenghtReductionMul(I)) { modified = true; }
          break;
      }
  }
  if (modified) {
    return true;
  }
  return false;
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

