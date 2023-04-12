#include "types.h"
#include "core.h"

namespace lygos {
    std::string PrintType(llvm::Type *type) {
        std::string type_string;
        llvm::raw_string_ostream ros(type_string);
        type->print(ros, true);
        return type_string;
    }

    std::string PrintValue(llvm::Value *val) {
        std::string val_string;
        llvm::raw_string_ostream ros(val_string);
        val->print(ros, true);
        return val_string;
    }

    llvm::Type *ResolveType(std::string &type) {
        if(type == "i8") return llvm::Type::getInt8Ty(*ctx);
        if(type == "i16") return llvm::Type::getInt16Ty(*ctx);
        if(type == "i32") return llvm::Type::getInt32Ty(*ctx);
        if(type == "i64") return llvm::Type::getInt64Ty(*ctx);
        if(type == "u8") return llvm::Type::getIntNTy(*ctx, 8);
        if(type == "u16") return llvm::Type::getIntNTy(*ctx, 16);
        if(type == "u32") return llvm::Type::getIntNTy(*ctx, 32);
        if(type == "u64") return llvm::Type::getIntNTy(*ctx, 64);
        if(type == "f32") return llvm::Type::getFloatTy(*ctx);
        if(type == "f64") return llvm::Type::getDoubleTy(*ctx);
        if(type == "void") return llvm::Type::getVoidTy(*ctx);
        Log::Logger::Warn(fmt::format("unknown type `{}`", type));
        std::exit(1);
    }

    llvm::Type *TryGetPointerBase(llvm::Type *type) {
        if(type->isPointerTy()) {
            return static_cast<llvm::PointerType *>(type)->getContainedType(0);
        }
        return type;
    }

    llvm::Value *LoadOrIgnore(llvm::Value *value) {
        if(value->getType()->isPointerTy()) {
            return builder->CreateLoad(TryGetPointerBase(value->getType()), value);
        }
        return value;
    }

    llvm::Instruction::CastOps GetCastOp(llvm::Type *src, llvm::Type *dest) {
        using CastOps = llvm::Instruction::CastOps;
        if(src->isIntegerTy() && dest->isIntegerTy()) {
            if(src->getIntegerBitWidth() > dest->getIntegerBitWidth()) return CastOps::Trunc;
            return CastOps::SExt;
        }
        if(src->isPointerTy() && dest->isPointerTy()) return CastOps::BitCast;
        if(src->isPointerTy() && dest->isIntegerTy()) return CastOps::PtrToInt;
        if(src->isFloatingPointTy() && dest->isFloatingPointTy()) {
            if(src->isFloatTy() && dest->isDoubleTy()) return CastOps::FPExt;
        }
        if(src->isIntegerTy()) {
            if(dest->isFloatTy()) return CastOps::SIToFP;
        }
        Log::Logger::Warn(fmt::format("cannot convert `{}` to `{}`", PrintType(src), PrintType(dest)));
        std::exit(1);
    }

    //static void IsImplicityCastable(llvm::Type *src);

    bool IsCastable(llvm::Type *src, llvm::Type *dest) {
        if(src->isPointerTy() && dest->isPointerTy()) return true;
        if(src->isIntegerTy() && dest->isIntegerTy()) return true;
        if(src->isFloatingPointTy() && dest->isFloatingPointTy()) return true;
        if(src->isIntegerTy() && dest->isFloatingPointTy()) return true;
        return false;
    }

    bool IsFunctionType(llvm::Type *type) {
        if(type->isPointerTy()) {
            return IsFunctionType(TryGetPointerBase(type));
        }

        return type->isFunctionTy();
    }

    bool IsArrayType(llvm::Type *type) {
        if(type->isPointerTy())
            return IsArrayType(TryGetPointerBase(type));
        return type->isArrayTy();
    }

    std::string &MangleName(std::string &name) {

        return name;
    }

    bool Type::Type::Matches(Ref<Type> other) {
        if(kind == Kind::ptr)
            return ((Pointer *)this)->GetType()->Matches(other);

        if(other->kind == Kind::ptr) {
            return Matches(((Pointer *)other.get())->GetType());
        }

        if((kind == Kind::path && other->kind == Kind::trait)
        || (kind == Kind::trait && other->kind == Kind::path)) {
            return ((Path *)kind)->GetPath() == ((Trait *)kind)->GetName();
        }

        return kind == other->kind;
    }
}
