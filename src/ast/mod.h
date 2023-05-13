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
                std::vector<Ref<AST>> &Body() { return body.Body(); }
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
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
                Block body;
                Block *current_block = &body;
                Function *current_func = nullptr;
                std::unordered_map<std::string, Function *> functions;
                std::unordered_map<std::string, Macro*> macros;
        };
    }
}

#endif // _LYGOS_AST_MOD_H_
