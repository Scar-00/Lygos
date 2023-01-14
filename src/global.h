#pragma once
#include "./backend/scope.h"

#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Support/Host.h>
#include <llvm/Target/TargetMachine.h>
#include <memory>
#include <fstream>
#include <iostream>
#include <ostream>
#include <system_error>

extern std::shared_ptr<llvm::LLVMContext> ctx;
extern std::shared_ptr<llvm::Module> mod;
extern std::shared_ptr<llvm::IRBuilder<>> builder;
