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



int64_t getOppositeOpcode(Instruction &I) {
  switch(I.getOpcode()) {
    case Instruction::Add:
      return Instruction::Sub;
    case Instruction::Sub:
      return Instruction::Add;
    case Instruction::Mul:
      return Instruction::SDiv;
  }
  return 0;
}



bool isCommutative(Instruction &I) {
  switch(I.getOpcode()) {
    case Instruction::Add:
    case Instruction::Mul:
      return true;
  }
  return false;
}


//===-- Algebraic Identity pass --------------------------===//


/// @brief Check for algebric identities optimizations in the IR for sum, subtraction, mul and sdiv
bool algebraicIdentity(Instruction &I) {
  // Keeps track of which operand is the constant == 1
  ConstantInt *mainInstructionConst = nullptr;

  // Keeps track of the other operand
  Value *mainInstructionValue = nullptr;

  if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
    if ((secondConst->getValue() == 1 && (I.getOpcode() == Instruction::Mul || I.getOpcode() == Instruction::SDiv)) || (secondConst->getValue() == 0 && (I.getOpcode() == Instruction::Add || I.getOpcode() == Instruction::Sub))) {
      mainInstructionConst = secondConst;
      mainInstructionValue = I.getOperand(0);
    }
  }

  if (isCommutative(I) && mainInstructionConst == nullptr) {
    if (ConstantInt *firstConst = dyn_cast<ConstantInt>(I.getOperand(0))) {
      if ((firstConst->getValue() == 1 && (I.getOpcode() == Instruction::Mul || I.getOpcode() == Instruction::SDiv)) || (firstConst->getValue() == 0 && (I.getOpcode() == Instruction::Add || I.getOpcode() == Instruction::Sub))) {
        mainInstructionConst = firstConst;
        mainInstructionValue = I.getOperand(1);
      }
    }
  }
  
  if (mainInstructionConst != nullptr) {
    I.replaceAllUsesWith(mainInstructionValue);
    return true;
  }
  return false;
}

/// @brief Pass that implements the Algebraic Identity optimization
PreservedAnalyses AlgebraicIdentity::run(Module &M, ModuleAnalysisManager &AM) {
  bool modified = false;
  for (auto &F : M) {
    for (auto &B : F) {
      for (auto &I : B) {
        if (algebraicIdentity(I))  modified = true ;
      }
    }
  }
  if (modified) {
    return PreservedAnalyses::none();
  }
  return PreservedAnalyses::all();
}



//===-- Strenght Reduction pass --------------------------===//


/// @brief Transform multiplication and division operations into shifts
bool strenghtReduction(Instruction &I) {

  // Constant power of 2 can be the first operand, the second operand or both. In the last case choose the second one by default (following IR syntax)
  if (I.getOpcode() == Instruction::Mul) {
    outs() << "\nFound a multiplication: " << I << "\n";

    ConstantInt *powerOfTwoOp = nullptr;

    // Need a offset to keep track if the operand was rounded to the closest power of 2 by -1 or +1. If not rounded, offset is 0
    int offset = 0;

    // Check if second operand is a constant and if it's a power of 2
    // Gives priority to the second operand, since IR syntax states that if it's just a constant it should be on the right-most side (pass can trasnform even multiplication with a constant on the left side, the right side is the priority in case both operands are constants power of 2)
    if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {

      // Need to check if value of constant is != 1 to avoid reducing an instruction that should be optimized by algebric identities
      if (secondConst->getValue() != 1) {
        if (secondConst->getValue().isPowerOf2()) {
          powerOfTwoOp = secondConst;
        } else if ((secondConst->getValue()-1).isPowerOf2()) {
            powerOfTwoOp = secondConst;
            offset = -1;
            outs() << "Second operand rounded to closest power of 2 by -1: " << secondConst->getValue()-1 << "\n";
        } else if ((secondConst->getValue()+1).isPowerOf2()) {
            powerOfTwoOp = secondConst;
            offset = 1;
            outs() << "Second operand rounded to closest power of 2 by +1: " << secondConst->getValue()+1 << "\n";
        }
      }
    }

    // Need a swap flag to keep track of which operand is the power of 2
    bool swap = false;
    
    // Check for constants and identify the power of 2 operand
    // If second operator is a constant and already a power of 2, we don't need to check the first one
    if (powerOfTwoOp == nullptr) {
      if (ConstantInt *firstConst = dyn_cast<ConstantInt>(I.getOperand(0))) {

        // Need to check if value of constant is != 1 to avoid reducing an instruction that should be optimized by algebric identities
        if (firstConst->getValue() != 1) {
          if (firstConst->getValue().isPowerOf2()){
            powerOfTwoOp = firstConst;
            swap = true;
          } else if ((firstConst->getValue()-1).isPowerOf2()) {
            powerOfTwoOp = firstConst;
            offset = -1;
            swap = true;
            outs() << "First operand rounded to closest power of 2 by -1: " << firstConst->getValue()-1 << "\n";
          } else if ((firstConst->getValue()+1).isPowerOf2()) {
            powerOfTwoOp = firstConst;
            offset = 1;
            swap = true;
            outs() << "First operand rounded to closest power of 2 by +1: " << firstConst->getValue()+1 << "\n";
          }
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

        // Create and add the shift instruction
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

      // Need to check if value of constant is != 1 to avoid reducing an instruction that should be optimized by algebric identities
      if (secondConst->getValue().isPowerOf2() && secondConst->getValue() != 1) {
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


/// @brief Pass that implements the Strength Reduction optimization
PreservedAnalyses StrengthReduction::run(Module &M, ModuleAnalysisManager &AM) {
  bool modified = false;
  for (auto &F : M) {
    for (auto &B : F) {
      for (auto &I : B) {
        switch(I.getOpcode()) {
          case Instruction::Mul:
          case Instruction::SDiv:
            if (strenghtReduction(I)) { modified = true; }
            break;
        }
      }
    }
    if (modified) {
      return PreservedAnalyses::none();
    }
  }
  return PreservedAnalyses::all();
}


//===-- Multi Instruction Optimization pass --------------------------===//

/// @brief Check for multiple instructions optimizations in the IR
bool multiInstruction(Instruction &I) {

  // Scroll trough the uses of the instruction and check if there is an opposite instruction
  for (auto &U : I.uses()) {
    if (auto *User = dyn_cast<Instruction>(U.getUser())) {
      if (User->getOpcode() == getOppositeOpcode(I)) {
        outs() << "Found opposite instruction: " << *User << "\n";

        ConstantInt *userInstOperand = nullptr;

        if (ConstantInt *secondConst = dyn_cast<ConstantInt>(User->getOperand(1))) {
          userInstOperand = secondConst;
        }
        if (isCommutative(I) && userInstOperand == nullptr) {
          if (ConstantInt *firstConst = dyn_cast<ConstantInt>(User->getOperand(0))) {
            userInstOperand = firstConst;
          }
        }

        if (userInstOperand == I.getOperand(0) ^ userInstOperand == I.getOperand(1)) {
          outs() << "Found opposite instruction with same constant: " << *User << "\n";
          if (userInstOperand == I.getOperand(0)) {
            User->replaceAllUsesWith(User->getOperand(0));
          } else {
            User->replaceAllUsesWith(User->getOperand(1));
          }
          return true;
        }
      }
    }
  }
  return false;
}

/// @brief Pass that implements Multi Instruction Optimization
PreservedAnalyses MultiInstructionOptimization::run(Module &M, ModuleAnalysisManager &AM) {
  bool modified = false;
  for (auto &F : M) {
    for (auto &B : F) {
      for (auto &I : B) {
        if (multiInstruction(I)) { modified = true; }
      }
    }
    if (modified) {
      return PreservedAnalyses::none();
    }
  }
  return PreservedAnalyses::all();
}