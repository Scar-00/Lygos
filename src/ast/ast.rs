pub mod AST {
    use inkwell::values::AnyValueEnum;

    use super::super::scope::Scope;
    use crate::ast::module::Mod;
    use crate::ctx;

    pub type Exprs = Vec<AST>;

    #[derive(Debug)]
    pub enum AST {
        Mod(Mod),
        Function(),
        VarDecl(),

        AssignmentExpr(),
        MemberExpr(),
        CallExpr(),
        AccessExpr(),
        UnaryExpr(),
        ResolutionExpr(),
        CastExpr(),
        ReturnExpr(),
        BinaryExpr(),

        IfStmt(),
        ForStmt(),
        MatchStmt(),

        StructDef(),
        EnumDef(),
        Impl(),
        Trait(),
        Macro(),
        MacroCall(),
        MacroInclude(),
        MacroSizeOf(),
        TypeAlias(),
        NumberLiteral(),
        StringLiteral(),
        InitializerList(),
        StaticLiteral(),
        Id(),

        Invalid,
    }

    impl Traverse for AST {
        fn get_value(&self) -> String {
            String::new()
        }

        fn gen_code<'a>(&self, scope: &mut Scope) -> AnyValueEnum<'a> {
            AnyValueEnum::IntValue(ctx::get_ctx().i32_type().const_int(10, false))
        }

        fn lower(&self, parent: &mut AST, scope: &mut Scope) {}
    }

    pub trait Traverse {
        fn get_value(&self) -> String;
        fn gen_code<'a>(&self, scope: &mut Scope) -> AnyValueEnum<'a>;
        fn lower(&self, parent: &mut AST, scope: &mut Scope);
    }

    #[derive(Debug)]
    pub struct Block {
        pub body: Exprs,
        pub returns: bool,
        pub scope: Scope,
        index: usize,
    }

    impl Block {
        pub fn new() -> Self {
            Self {
                body: Vec::new(),
                returns: false,
                scope: Scope::new(),
                index: 0,
            }
        }

        pub fn from(exprs: Exprs) -> Self {
            Self {
                body: exprs,
                returns: false,
                scope: Scope::new(),
                index: 0,
            }
        }
    }
}
