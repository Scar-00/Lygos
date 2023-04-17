#ifndef _LYGOS_AST_MOD_H_
#define _LYGOS_AST_MOD_H_

#include "ast.h"
#include <unordered_set>
#include <vector>

namespace lygos {
    namespace AST {
        struct Function;
        struct Mod : public AST {
            public:
                Mod();
                std::vector<Ref<AST>> &Body() { return body; }
                void IncrInstr() { instr_index++; }
                void Insert(std::vector<Ref<AST>> &elems);
                void SetCurrentFunction(Function *func);
                Function *GetCurrentFunction();
                Function *GetFunction(std::string &name);
                void AddFunction(Function *func);
            public:
                std::string GetValue() override;
                llvm::Value *GenCode(Scope *scope) override;
                void Lower(AST *parent) override;
                void Sanatize() override;
            private:
                std::string name;
                std::vector<Ref<AST>> body;
                u32 instr_index = 0;
                Function *current_func = nullptr;
                std::unordered_map<std::string, Function *> functions;
        };
    }
}

#endif // _LYGOS_AST_MOD_H_
