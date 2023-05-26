#include "ast/ast.h"
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
        void declare(Ref<AST::Mod> root) {
            std::vector<AST::Macro::Cond> conds = {
                {"fmt", AST::Macro::ArgType::Single},
                {"args", AST::Macro::ArgType::Var}
            };
            AST::Block block;
            //auto macro = MakeRef<AST::Macro>("format", AST::Macro::Arm{conds, block});

            //block.Insert();

            //root->DeclMacro(MakeRef<AST::Macro>("format", AST::Macro::Arg{"fmt", AST::Macro::ArgType::Var, 0}, block).get());
        }

        void macro_format_intrinsic(AST::MacroCall *macro, AST::Scope *scope) {
            std::vector<Token> &args = macro->GetArgs()[0];
            /*for(const auto &arg : args) {
                switch (arg.type) {
                    case TokenType::Integer: {

                    } break;
                }
            }*/

            LYGOS_ASSERT(args[0].type == TokenType::String);
            std::string format = args[0].value;
        }
    }
}
