pub mod ast {
    use super::super::scope::Scope;
    use crate::lexer::Loc;
    use crate::ast::*;
    use crate::types::Type;

    pub type Exprs = Vec<AST>;

    #[derive(Debug)]
    pub enum AST {
        Mod(Mod),
        Function(Function),
        VarDecl(VarDecl),

        AssignmentExpr(AssignmentExpr),
        MemberExpr(MemberExpr),
        CallExpr(CallExpr),
        MemberCallExpr(MemberCallExpr),
        AccessExpr(AccessExpr),
        UnaryExpr(UnaryExpr),
        ResolutionExpr(ResolutionExpr),
        CastExpr(CastExpr),
        ReturnExpr(ReturnExpr),
        BinaryExpr(BinaryExpr),

        IfStmt(IfStmt),
        ForStmt(ForStmt),
        MatchStmt(),
        BreakExpr(BreakExpr),
        ClosureExpr(ClosureExpr),

        StructDef(StructDef),
        EnumDef(EnumDef),
        Impl(Impl),
        Trait(Trait),
        Macro(Macro),
        MacroCall(MacroCall),
        TypeAlias(TypeAlias),
        NumberLiteral(NumberLiteral),
        StringLiteral(StringLiteral),
        InitializerList(InitializerListExpr),
        StaticLiteral(StaticLiteral),
        Id(Identifier),
    }

    impl AST {
        pub fn should_load(&self) -> bool {
            if let AST::MemberExpr(m) = self {
                if let Some(member) = &m.member {
                    if let AST::CallExpr(_) = **member {
                        return false;
                    }
                }
            }
            if let AST::UnaryExpr(u) = self {
                if u.op.inner() == "&" {
                    return false;
                }
            }
            return match self {
                AST::Id(_) | AST::MemberExpr(_) | AST::AccessExpr(_) | AST::UnaryExpr(_) | AST::InitializerList(_) => true,
                _ => false,
            }
        }
    }

    impl Generate for AST {
        fn loc(&self) -> &Loc {
            return match self {
                AST::Mod(m) => m.loc(),
                AST::Function(f) => f.loc(),
                AST::VarDecl(decl) => decl.loc(),
                AST::AssignmentExpr(assi) => assi.loc(),
                AST::MemberExpr(mem) => mem.loc(),
                AST::CastExpr(cast) => cast.loc(),
                AST::UnaryExpr(unary) => unary.loc(),
                AST::ResolutionExpr(res) => res.loc(),
                AST::ReturnExpr(ret) => ret.loc(),
                AST::BinaryExpr(bin) => bin.loc(),
                AST::IfStmt(i) => i.loc(),
                AST::ForStmt(f) => f.loc(),
                AST::BreakExpr(b) => b.loc(),
                AST::ClosureExpr(c) => c.loc(),
                AST::StructDef(def) => def.loc(),
                AST::EnumDef(en) => en.loc(),
                AST::Impl(i) => i.loc(),
                AST::Trait(t) => t.loc(),
                AST::MemberCallExpr(call) => call.loc(),
                AST::AccessExpr(acc) => acc.loc(),
                AST::CallExpr(call) => call.loc(),
                AST::MacroCall(call) => call.loc(),
                AST::TypeAlias(alias) => alias.loc(),
                AST::Macro(_) => unreachable!(),
                AST::NumberLiteral(num) => num.loc(),
                AST::StringLiteral(s) => s.loc(),
                AST::InitializerList(list) => list.loc(),
                AST::StaticLiteral(stat) => stat.loc(),
                AST::Id(id) => id.loc(),
                //AST::Block(b) => b.loc(),
                _ => todo!("loc -> {:#?}", self),
            }
        }

        fn get_value(&self) -> String {
            return match self {
                AST::Mod(m) => m.get_value(),
                AST::Function(f) => f.get_value(),
                AST::VarDecl(decl) => decl.get_value(),
                AST::AssignmentExpr(assi) => assi.get_value(),
                AST::MemberExpr(mem) => mem.get_value(),
                AST::CastExpr(cast) => cast.get_value(),
                AST::UnaryExpr(unary) => unary.get_value(),
                AST::ResolutionExpr(res) => res.get_value(),
                AST::ReturnExpr(ret) => ret.get_value(),
                AST::BinaryExpr(bin) => bin.get_value(),
                AST::IfStmt(i) => i.get_value(),
                AST::ForStmt(f) => f.get_value(),
                AST::BreakExpr(b) => b.get_value(),
                AST::ClosureExpr(c) => c.get_value(),
                AST::StructDef(def) => def.get_value(),
                AST::EnumDef(en) => en.get_value(),
                AST::Impl(i) => i.get_value(),
                AST::Trait(t) => t.get_value(),
                AST::MemberCallExpr(call) => call.get_value(),
                AST::AccessExpr(acc) => acc.get_value(),
                AST::CallExpr(call) => call.get_value(),
                AST::MacroCall(call) => call.get_value(),
                AST::TypeAlias(alias) => alias.get_value(),
                AST::Macro(_) => unreachable!(),
                AST::NumberLiteral(num) => num.get_value(),
                AST::StringLiteral(s) => s.get_value(),
                AST::InitializerList(list) => list.get_value(),
                AST::StaticLiteral(stat) => stat.get_value(),
                AST::Id(id) => id.get_value(),
                _ => todo!("get_value -> {:#?}", self),
            }
        }

        fn gen_code(&mut self, scope: &mut Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
            return match self {
                AST::Mod(m) => m.gen_code(scope, ctx),
                AST::Function(f) => f.gen_code(scope, ctx),
                AST::VarDecl(decl) => decl.gen_code(scope, ctx),
                AST::AssignmentExpr(assi) => assi.gen_code(scope, ctx),
                AST::MemberExpr(mem) => mem.gen_code(scope, ctx),
                AST::CastExpr(cast) => cast.gen_code(scope, ctx),
                AST::UnaryExpr(unary) => unary.gen_code(scope, ctx),
                AST::ResolutionExpr(res) => res.gen_code(scope, ctx),
                AST::ReturnExpr(ret) => ret.gen_code(scope, ctx),
                AST::BinaryExpr(bin) => bin.gen_code(scope, ctx),
                AST::IfStmt(i) => i.gen_code(scope, ctx),
                AST::ForStmt(f) => f.gen_code(scope, ctx),
                AST::BreakExpr(b) => b.gen_code(scope, ctx),
                AST::ClosureExpr(c) => c.gen_code(scope, ctx),
                AST::StructDef(def) => def.gen_code(scope, ctx),
                AST::EnumDef(en) => en.gen_code(scope, ctx),
                AST::Impl(i) => i.gen_code(scope, ctx),
                AST::Trait(t) => t.gen_code(scope, ctx),
                AST::MemberCallExpr(call) => call.gen_code(scope, ctx),
                AST::AccessExpr(acc) => acc.gen_code(scope, ctx),
                AST::CallExpr(call) => call.gen_code(scope, ctx),
                AST::MacroCall(call) => call.gen_code(scope, ctx),
                AST::TypeAlias(alias) => alias.gen_code(scope, ctx),
                AST::Macro(_) => None,
                AST::NumberLiteral(num) => num.gen_code(scope, ctx),
                AST::StringLiteral(s) => s.gen_code(scope, ctx),
                AST::InitializerList(list) => list.gen_code(scope, ctx),
                AST::StaticLiteral(stat) => stat.gen_code(scope, ctx),
                AST::Id(id) => id.gen_code(scope, ctx),
                _ => todo!("gen_code -> {:#?}", self),
            }
        }

        fn get_type(&self, scope: &mut Scope, ctx: &crate::GenerationContext) -> Option<Type> {
            return match self {
                AST::Mod(m) => m.get_type(scope, ctx),
                AST::Function(f) => f.get_type(scope, ctx),
                AST::VarDecl(decl) => decl.get_type(scope, ctx),
                AST::AssignmentExpr(assi) => assi.get_type(scope, ctx),
                AST::MemberExpr(mem) => mem.get_type(scope, ctx),
                AST::CastExpr(cast) => cast.get_type(scope, ctx),
                AST::UnaryExpr(unary) => unary.get_type(scope, ctx),
                AST::ResolutionExpr(res) => res.get_type(scope, ctx),
                AST::ReturnExpr(ret) => ret.get_type(scope, ctx),
                AST::BinaryExpr(bin) => bin.get_type(scope, ctx),
                AST::IfStmt(i) => i.get_type(scope, ctx),
                AST::ForStmt(f) => f.get_type(scope, ctx),
                AST::BreakExpr(b) => b.get_type(scope, ctx),
                AST::ClosureExpr(c) => c.get_type(scope, ctx),
                AST::StructDef(def) => def.get_type(scope, ctx),
                AST::EnumDef(en) => en.get_type(scope, ctx),
                AST::Impl(i) => i.get_type(scope, ctx),
                AST::Trait(t) => t.get_type(scope, ctx),
                AST::CallExpr(call) => call.get_type(scope, ctx),
                AST::MacroCall(call) => call.get_type(scope, ctx),
                AST::TypeAlias(alias) => alias.get_type(scope, ctx),
                AST::MemberCallExpr(call) => call.get_type(scope, ctx),
                AST::AccessExpr(acc) => acc.get_type(scope, ctx),
                AST::Macro(_) => None,
                AST::NumberLiteral(num) => num.get_type(scope, ctx),
                AST::StringLiteral(s) => s.get_type(scope, ctx),
                AST::InitializerList(list) => list.get_type(scope, ctx),
                AST::StaticLiteral(stat) => stat.get_type(scope, ctx),
                AST::Id(id) => id.get_type(scope, ctx),
                _ => todo!("get_type -> {:#?}", self),
            }
        }

        /*
         *  TODO:
         *  do symbol collection before the actual compilation, so the order of decleration does
         *  not matter
         *
         *  individual symbols should not depend on any other declaration in the module tree
         *
         */

        fn collect_symbols(&mut self, scope: &mut Scope) {
            match self {
                AST::Mod(m) => m.collect_symbols(scope),
                AST::TypeAlias(a) => a.collect_symbols(scope),
                AST::StructDef(s) => s.collect_symbols(scope),
                AST::EnumDef(v) => v.collect_symbols(scope),
                AST::Function(v) => v.collect_symbols(scope),
                AST::Impl(v) => v.collect_symbols(scope),
                AST::Macro(_) => return,
                AST::MacroCall(v) => v.collect_symbols(scope),
                AST::Trait(v) => v.collect_symbols(scope),
                _ => todo!("collect_symbols -> {:#?}", self),
            }
        }
    }

    pub trait Generate {
        fn loc(&self) -> &Loc;
        fn get_value(&self) -> String;
        fn gen_code(&mut self, scope: &mut Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef>;
        fn get_type(&self, scope: &mut Scope, ctx: &crate::GenerationContext) -> Option<Type>;
        fn collect_symbols(&mut self, scope: &mut Scope);
    }

    #[derive(Debug)]
    pub struct Block {
        pub body: Exprs,
        pub returns: bool,
        pub scope: Scope,
    }

    impl Block {
        pub fn new() -> Self {
            Self {
                body: Vec::new(),
                returns: false,
                scope: Scope::new(),
            }
        }

        pub fn from(exprs: Exprs) -> Self {
            Self {
                body: exprs,
                returns: false,
                scope: Scope::new(),
            }
        }
    }
}
