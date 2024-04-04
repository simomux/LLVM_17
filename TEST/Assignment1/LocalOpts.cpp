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


//===-- Algebraic Identity pass --------------------------===//


/// @brief Check for algebric identities optimizations in the IR for sum and subtraction
bool algebricIdentitySumSub(Instruction &I) {

  // Check if the sum's second operand is a constant == 0
  if (I.getOpcode() == Instruction::Add){
    if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
      if (secondConst->getZExtValue() == 0) {
        outs() << "Fond sum: " << I << "\n";
        I.replaceAllUsesWith(I.getOperand(0));
        ///TODO: Remove the add instruction
        return true;
      }

    // Check if the sum's first operand is a constant == 0
    } else if (ConstantInt *firstConst = dyn_cast<ConstantInt>(I.getOperand(0))) {
      if (firstConst->getZExtValue() == 0) {
        outs() << "Fond sum: " << I << "\n";
        I.replaceAllUsesWith(I.getOperand(1));
        ///TODO: Remove the add instruction
        return true;
      }
    }
    
  // Check if the subtraction's second operand is a constant == 0
  // Just need to check the second operand, since the first one is the minuend
  } else if (I.getOpcode() == Instruction::Sub) {
    if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
      if (secondConst->getZExtValue() == 0) {
        outs() << "Fond subtraction: " << I << "\n";
        I.replaceAllUsesWith(I.getOperand(0));
        ///TODO: Remove the sub instruction
        return true;
      }
    }
  }
  
  return false;
}



/// @brief Check for algebric identities optimizations in the IR for multiplication and division
bool algebricIdentityMulDiv(Instruction &I) {
  if (Instruction::Mul == I.getOpcode()) {

    // Check if the multiplication's second operand is a constant == 1
    if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
      if (secondConst->getValue() == 1) {
        I.replaceAllUsesWith(I.getOperand(0));
        ///TODO: Remove the mul instruction
        return true;
      }

    // Check if the multiplication's first operand is a constant == 1
    } else if (ConstantInt *firstConst = dyn_cast<ConstantInt>(I.getOperand(0))) {
      if (firstConst->getValue() == 1) {
        I.replaceAllUsesWith(I.getOperand(1));
        ///TODO: Remove the mul instruction
        return true;
      }
    }

  // Check if the division has the second operand == 1
  // Just need to check the second operand, since the first one is the dividend
  } else if (Instruction::SDiv == I.getOpcode()) {
    if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
      if (secondConst->getValue() == 1) {
        I.replaceAllUsesWith(I.getOperand(0));
        ///TODO: Remove the sdiv instruction
        return true;
      }
    }
  }
  return false;
}

/// @brief Pass that implements the Algebraic Identity optimization
PreservedAnalyses AlgebraicIdentity::run(Module &M, ModuleAnalysisManager &AM) {
  bool modified = false;
  for (auto &F : M) {
    for (auto &B : F) {
      for (auto &I : B) {
        switch(I.getOpcode()) {
          case Instruction::Add:
          case Instruction::Sub:
            if(algebricIdentitySumSub(I)){ modified = true; }
            break;
          case Instruction::Mul:
          case Instruction::SDiv:
            if (algebricIdentityMulDiv(I)) { modified = true; }
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



//===-- Strenght Reduction pass --------------------------===//


/// @brief Transform multiplication and division operations into shifts
bool strenghtReductionMul(Instruction &I) {

  // Constant power of 2 can be the first operand, the second operand or both. In the last case choose the second one by default (following IR syntax)
  if (I.getOpcode() == Instruction::Mul) {
    outs() << "\nFound a multiplication: " << I << "\n";

    ConstantInt *powerOfTwoOp = nullptr;

    // Needs an offset to keep track if the operand was rounded to the closest power of 2 by +-1. If not rounded, offset is 0
    int offset = 0;

    // Check if second operand is a constant and if it's a power of 2
    // Gives priority to the second operand, since IR syntax states that if it's just a constant it should be on the right-most side (pass can trasnform even multiplication with a constant on the left side, the right side is the priority in case both operands are constants power of 2)
    if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {

      // Need to check if value of constant is != 1 to avoid reducing an instruction that should be optimized by algebraic identity
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

        // Need to check if value of constant is != 1 to avoid reducing an instruction that should be optimized by algebraic identity
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
        ///TODO: Remove the mul instruction

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
        ///TODO: Remove the sdiv instruction
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
            if (strenghtReductionMul(I)) { modified = true; }
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
  ConstantInt *mainInstructionOperand, *nextInstOperand;

  // Need a swap flag to keep track of which operand i choose
  bool swap = false;

  // Manage optimization based on the type of instruction
  switch(I.getOpcode()){


    // Manage add instruction
    case Instruction::Add:
      outs() << "Instruction: " << I << "\n";

      // Control logic to choose the constant operand
      if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
        mainInstructionOperand = secondConst;
      }
      if (mainInstructionOperand == nullptr) {
        if (ConstantInt *firstConst = dyn_cast<ConstantInt>(I.getOperand(0))) {
          mainInstructionOperand = firstConst;
          swap = true;
        }
      }

      if (mainInstructionOperand != nullptr) {
        Instruction *nextInst = I.getNextNonDebugInstruction();

        if (nextInst != nullptr && nextInst->getOpcode() == Instruction::Sub) {

          // Check if following sub instruction has a constant in one of its operands
          if (ConstantInt *secondConst = dyn_cast<ConstantInt>(nextInst->getOperand(1))) {

            // Check if the constant in the sub instruction is the same as the one in the add instruction
            if (mainInstructionOperand->getValue() == secondConst->getValue())
              nextInstOperand = secondConst;
          }

          if (nextInstOperand != nullptr) {
            outs() << "Next instruction: " << *nextInst << "\n";
            if (swap) {
              nextInst->replaceAllUsesWith(I.getOperand(1));
            } else {
              nextInst->replaceAllUsesWith(I.getOperand(0));
            }
            ///TODO: Remove the sub instruction
            return true;
          }
        }
      } else {
        outs() << "Instruction doesn't have a constant operand\n";
      }
      break;


    // Manage sub instruction
    case Instruction::Sub:
      outs() << "Instruction: " << I << "\n";
      // Check if sub instruction has a constant
      if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
        mainInstructionOperand = secondConst;
      }

      if (mainInstructionOperand != nullptr) {

        // Get next instruction and check if it's an add instruction
        Instruction *nextInst = I.getNextNonDebugInstruction();

        if (nextInst != nullptr && nextInst->getOpcode() == Instruction::Add) {
          
          // Check if following add instruction has the same constant in one of its operands 
          if (ConstantInt *secondConst = dyn_cast<ConstantInt>(nextInst->getOperand(1))) {
            if (secondConst->getValue() == mainInstructionOperand->getValue())
              nextInstOperand = secondConst;
          }

          if (nextInstOperand == nullptr) {
            if (ConstantInt *secondConst = dyn_cast<ConstantInt>(nextInst->getOperand(0))) {
              if (secondConst->getValue() == mainInstructionOperand->getValue()) {
                nextInstOperand = secondConst;
              }
            }
          }

          // True if I find the same constant in one of the operands of the add instruction
          if (nextInstOperand != nullptr) {
            outs() << "Next instruction: " << *nextInst << "\n";
            nextInst->replaceAllUsesWith(I.getOperand(0));
            return true;
          }
        }
      } else {
        outs() << "Instruction doesn't have a constant operand\n";
      }
      break;



    // Manage mul instruction
    case Instruction::Mul:
      outs() << "Instruction: " << I << "\n";
      // Control logic to choose the constant operand
      if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
        mainInstructionOperand = secondConst;
      }
      if (mainInstructionOperand == nullptr) {
        if (ConstantInt *firstConst = dyn_cast<ConstantInt>(I.getOperand(0))) {
          mainInstructionOperand = firstConst;
          swap = true;
        }
      }

      if (mainInstructionOperand != nullptr) {
        Instruction *nextInst = I.getNextNonDebugInstruction();

        if (nextInst != nullptr && nextInst->getOpcode() == Instruction::SDiv) {

          // Check if following SDiv instruction has a constant in one of its operands
          if (ConstantInt *secondConst = dyn_cast<ConstantInt>(nextInst->getOperand(1))) {
            if (mainInstructionOperand->getValue() == secondConst->getValue()) {
              nextInstOperand = secondConst;
            }
          }

          if (nextInstOperand != nullptr) {
            outs() << "Next instruction: " << *nextInst << "\n";
            if (swap) {
              nextInst->replaceAllUsesWith(I.getOperand(1));
            } else {
              nextInst->replaceAllUsesWith(I.getOperand(0));
            }
            ///TODO: Remove the sdiv instruction
            return true;
          }
        }
      } else {
        outs() << "Instruction doesn't have a constant operand\n";
      }
      break;
    


    // Manage sdiv instruction
    case Instruction::SDiv:
      outs() << "Instruction: " << I << "\n";
      // Check if sdiv instruction has a constant
      if (ConstantInt *secondConst = dyn_cast<ConstantInt>(I.getOperand(1))) {
        mainInstructionOperand = secondConst;
      }

      if (mainInstructionOperand != nullptr) {
        // Get next instruction and check if it's a mul instruction
        Instruction *nextInst = I.getNextNonDebugInstruction();

        if (nextInst != nullptr && nextInst->getOpcode() == Instruction::Mul) {
          
          // Check if following mul instruction has the same constant in one of its operands 
          if (ConstantInt *secondConst = dyn_cast<ConstantInt>(nextInst->getOperand(1))) {
            if (secondConst->getValue() == mainInstructionOperand->getValue())
              nextInstOperand = secondConst;
          }

          if (nextInstOperand == nullptr) {
            if (ConstantInt *secondConst = dyn_cast<ConstantInt>(nextInst->getOperand(0))) {
              if (secondConst->getValue() == mainInstructionOperand->getValue()) {
                nextInstOperand = secondConst;
              }
            }
          }

          // True if I find the same constant in one of the operands of the add instruction
          if (nextInstOperand != nullptr) {
            outs() << "Next instruction: " << *nextInst << "\n";
            nextInst->replaceAllUsesWith(I.getOperand(0));
            return true;
          }
        }
      } else {
        outs() << "Instruction doesn't have a constant operand\n";
      }
      break;
  }

  return false;
}

/// @brief Pass that implements the Strength Reduction optimization
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