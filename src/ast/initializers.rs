use crate::lexer::{Tagged, Loc};
use crate::ast::{AST, Generate};
use crate::types::Type;
use crate::log::{ErrorLabel, error_msg_label, error_msg_labels};

pub type Initializer = (Option<Tagged<String>>, AST);

#[derive(Debug)]
pub struct InitializerListExpr {
    loc: Loc,
    typ: Option<Type>,
    initializers: Vec<Initializer>,
}

impl InitializerListExpr {
    pub fn new(initializers: Vec<Initializer>) -> Self {
        Self{ loc: Loc::new("".into(), 0, 1), typ: None , initializers }
    }

    pub fn set_typ(&mut self, ty: Option<Type>) {
        self.typ = ty;
    }
}

impl Generate for InitializerListExpr {
    fn loc(&self) -> &crate::lexer::Loc {
        &self.loc
    }

    fn get_value(&self) -> String {
        "".into()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        if let Some(ty) = &self.typ {
            let strct = scope.get_struct(&Tagged::new(ty.get_loc(), ty.get_name())).clone();
            let ty = &scope.resolve_type(ty, ctx);
            let tmp = ctx.builder.create_alloca(ty, None);
            for (i, init) in self.initializers.iter_mut().enumerate() {
                let mut value = init.1.gen_code(scope, ctx).unwrap();
                if init.1.should_load() {
                    let base = init.1.get_type(scope, ctx).unwrap();
                    value = value.try_load(&scope.resolve_type(&base, ctx), ctx.builder);
                }
                if let Some(name) = &init.0 {
                    let idx = if let Some(i) = strct.fields.iter().position(|f| *f.id.inner() == *name.inner()) {
                        i
                    }else {
                        error_msg_labels(
                            "invalid struct member", &[
                                ErrorLabel::from(name.loc(), &format!("unkown field `{}` in struct `{}`", name.inner(), strct.name.inner())),
                                ErrorLabel::from(strct.name.loc(), "struct decalared here"),
                            ]);
                    };

                    let gep = ctx.builder.create_struct_gep(ty, &tmp, idx as u32);
                    ctx.builder.create_store(&value, &gep);
                }else {
                    if i >= strct.fields.len() {
                        error_msg_label("out of bounds struct index", ErrorLabel::from(init.1.loc(), "out of bounds"));
                    }

                    //TODO(S): issue a warining if the initializer is incomplete
                    let gep = ctx.builder.create_struct_gep(ty, &tmp, i as u32);
                    //TODO(S): typecheck here
                    ctx.builder.create_store(&value, &gep);
                }
            }
            return Some(tmp);
        }
        todo!("init_list error");
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<crate::types::Type> {
        if let Some(ty) = &self.typ {
            return Some(ty.clone());
        }
        todo!("init_list error");
    }

    fn collect_symbols(&mut self, _scope: &mut super::Scope) {}
}
