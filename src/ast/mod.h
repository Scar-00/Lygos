#ifndef _LYGOS_AST_MOD_H_
#define _LYGOS_AST_MOD_H_

#include "ast.h"
#include <unordered_set>
#include <vector>

namespace lygos {
    namespace AST {
        struct Macro;
        struct Function;
        namespace Trait {
            struct Trait;
        }
        struct Mod : public AST {
            public:
                Mod();
                Block &Body() { return body; }
                void Insert(Ref<AST> &expr);
                void Insert(Block::Content &exprs);
                void Replace(Ref<AST> &expr);
                void Replace(Block::Content &exprs);
                void SetCurrentBlock(Block *block);

                void SetCurrentFunction(Function *func);
                Function *GetCurrentFunction();
                Function *GetFunction(std::string &name);
                void AddFunction(Function *func);
                void DeclMacro(Macro *macro);
                Macro *GetMacro(std::string &name);
                void DeclTrait(Trait::Trait *trait);
                Trait::Trait *GetTrait(std::string &name);
                std::unordered_map<std::string, Function *> &GetFunctions() { return functions; }
                std::unordered_map<std::string, Macro*> &GetMacros() { return macros; }
                std::unordered_map<std::string, Trait::Trait *> &GetTraits() { return traits; }
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                Ref<Type::Type> GetType(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
                Block body;
                Block *current_block = &body;
                Function *current_func = nullptr;
                std::unordered_map<std::string, Function *> functions;
                std::unordered_map<std::string, Macro*> macros;
                std::unordered_map<std::string, Trait::Trait *> traits;
                //std::unordered_map<std::string, MacroIntrinsicCallBack> macros_intrinsic;
        };
    }
}

#endif // _LYGOS_AST_MOD_H_
