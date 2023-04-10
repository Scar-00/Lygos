#include "initializer.h"
#include "../error/log.h"
#include "assignment.h"
#include "llvm/IR/Constants.h"
#include <memory>
#include <vector>

namespace lygos {
    namespace AST {
        using Val = llvm::Value;
        std::string InitializerList::GetValue() {
            return {};
        }

        Val *InitializerList::GenCode(Scope *scope) {
            Log::Logger::Warn("[InitializerList] codegen");
            return nullptr;
        }

        void InitializerList::Lower() {
        }

        void InitializerList::Sanatize() {

        }
    }
}
