#include "assignment.h"
#include "../error/log.h"

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
        std::string AssignmentExpr::GetValue() {
            return {};
        }

        Val *AssignmentExpr::GenCode(Scope *scope) {
            //change this to scope->LookupVar ?
            if(!scope->GetVars().contains(id->GetValue()))
                Log::Logger::Warn(fmt::format("cannot assign to `{}`", id->GetValue()));

            if(scope->GetConstants().contains(id->GetValue()))
                Log::Logger::Warn(fmt::format("cannot assign to immutable variable `{}`", id->GetValue()));

            auto id = this->id->GenCode(scope);
            auto val = this->value->GenCode(scope);
            if(ShouldLoad(value)) {
                val = LoadOrIgnore(val);
            }

            //check for castablility

            builder->CreateStore(val, id);
            return id;
        }
    }
}
