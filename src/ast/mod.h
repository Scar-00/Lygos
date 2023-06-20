#ifndef _LYGOS_AST_MOD_H_
#define _LYGOS_AST_MOD_H_

#include "ast.h"
#include <unordered_set>
#include <vector>

namespace lygos {
    namespace AST {
        struct Macro;
        struct Function;
        struct Mod : public AST {
            public:
                Mod();
                Block &Body() { return body; }
                void Insert(Ref<AST> &expr);
                void Insert(Block::Content &exprs);
                void Replace(Ref<AST> &expr);
                void Replace(Block::Content &exprs);
                void SetCurrentBlock(Block *block);
                Block *GetCurrentBlock() { return current_block; }
                void SetCurrentFunction(Function *func);
                Function *GetCurrentFunction();
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
        };
    }
}

#endif // _LYGOS_AST_MOD_H_
