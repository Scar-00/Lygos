#include "impl.h"
#include "function.h"
#include <vector>

namespace lygos {
    namespace AST {
        Impl::Impl(std::string type, std::vector<Ref<AST>> body):
            AST(ASTType::Impl), type(type), body(body) {

        }

        std::string Impl::GetValue() {
            return type;
        }

        llvm::Value *Impl::GenCode(Scope *scope) {
            for(const auto &member : body) {
                member->GenCode(scope);
            }
            return nullptr;
        }

        void Impl::Lower(AST *parent) {
            for(const auto &item : body)
                item->Lower(parent);
        }

        void Impl::Sanatize() {

        }
    }
}
