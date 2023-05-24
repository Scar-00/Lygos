#include "ast/ast.h"
#include "ast/macro.h"
#include "error/log.h"
#include "intrinsics.h"

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

        static bool Formatable(AST::ASTType type) {

        }

        void macro_format_intrinsic(AST::MacroCall *macro, AST::Scope *scope) {
            auto args = macro->GetArgs();
            for(const auto &arg : args) {
                //if(!Formatable(arg->type))
                //    Log::Logger::Warn("cannot format");
                if(arg->type == AST::ASTType::Id) {
                }
            }

            std::string format = args[0]->GetValue();
        }
    }
}
