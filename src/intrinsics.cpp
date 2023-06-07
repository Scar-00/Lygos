#include "ast/ast.h"
#include "ast/mod.h"
#include "ast/macro.h"
#include "core.h"
#include "error/log.h"
#include "intrinsics.h"
#include "lex/lexer.h"
#include "types.h"
#include <cassert>
#include <vector>

namespace lygos {
    namespace Intrinsics {
        void macro_format_intrinsic(AST::MacroCall *macro, AST::Scope *scope) {
            std::vector<Token> &args = macro->GetArgs()[0];
            LYGOS_ASSERT(args[0].type == TokenType::String);
            std::string format = args[0].value;
            fmt::print("format -> {}\n", format);

            //loop format string and call to to [type]::format() -> &str
        }
    }
}
