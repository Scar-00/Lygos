use crate::ast::{Generate, AST};
use crate::lexer::{Loc, Tagged};
use crate::log::{error_msg_label, error_msg_labels, ErrorLabel};
use crate::types::{Path, Pointer, Type};

#[derive(Debug)]
pub struct UnaryExpr {
    pub op: Tagged<String>,
    obj: Box<AST>,
}

impl UnaryExpr {
    pub fn new(op: Tagged<String>, obj: Box<AST>) -> Self {
        Self{ op, obj }
    }
}

impl Generate for UnaryExpr {
    fn loc(&self) -> &crate::lexer::Loc {
        self.obj.loc()
    }

    fn get_value(&self) -> String {
        self.obj.get_value()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let mut obj = self.obj.gen_code(scope, ctx).unwrap();
        match self.op.inner().as_str() {
            "*" => {
                if !self.obj.get_type(scope, ctx).unwrap().is_pointer_like() {
                    error_msg_label(
                        "cannot deref value type",
                        ErrorLabel::from(self.loc(), format!("cannot deref value type `{}`", self.obj.get_type(scope, ctx).unwrap().get_full_name()).as_str()),
                    );
                }
                /*return match *self.obj {
                    AST::MemberExpr(_) => obj,
                    AST::

                }*/
                return Some(if let AST::MemberExpr(_) = *self.obj {
                    obj
                } else {
                    let base = self.obj.get_type(scope, ctx).unwrap();
                    /*
                     *  NOTE(S): This is a dirty hack and should not be handled like this
                     */
                    let base_ty = scope.resolve_type(&base, ctx);
                    if !obj.get_type().matches(&base_ty) {
                        ctx.builder.create_load(&base_ty, &obj)
                    }else {
                        ctx.builder.create_load(&scope.resolve_type(&base.get_base().unwrap(), ctx), &obj)
                    }
                });
            }
            "&" => {
                /*
                 *  TODO(S):
                 *  cannot take address of value type wich is returned by a function, create
                 *  temporary allocation to take its address
                 *
                 */
                return Some(obj);
            }
            "!" => {
                if self.obj.should_load() {
                    let base = self.obj.get_type(scope, ctx).unwrap();
                    obj = obj.try_load(&scope.resolve_type(&base, ctx), ctx.builder);
                }
                let zero = llvm::ConstantInt::get(&obj.get_type(), 0);
                let ne = ctx.builder.create_icmp_ne(&obj, &zero);
                return Some(ctx.builder.create_xor_vl(&ne, 1));
            }
            _ => error_msg_label(
                format!("unknown unary operator `{}`", self.op.inner()).as_str(),
                ErrorLabel::from(self.loc(), "unknown unary operator"),
            ),
        }
    }

    fn get_type(&self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<Type> {
        let ty = self.obj.get_type(scope, ctx).unwrap();
        match self.op.inner().as_str() {
            "*" => {
                if let Type::Pointer(ptr) = &ty {
                    return Some(*ptr.typ.clone());
                }
                return None;
            }
            "&" => {
                return Some(Type::Pointer(Pointer::new(ty.get_loc(), Box::new(ty), false, false)));
            }
            "!" => {
                return Some(Type::Path(Path::new(self.loc().clone(), "bool".to_string())));
            }
            _ => error_msg_label(
                format!("unknown unary operator `{}`", self.op.inner()).as_str(),
                ErrorLabel::from(self.loc(), "unknown unary operator"),
            ),
        }
    }

    fn collect_symbols(&mut self, _scope: &mut super::Scope) {}
}

#[derive(Debug)]
pub struct CastExpr {
    obj: Box<AST>,
    target_type: Type,
}

impl CastExpr {
    pub fn new(obj: Box<AST>, target_type: Type) -> Self {
        Self{ obj, target_type }
    }
}

pub fn allow_implicit_cast(src: &llvm::TypeRef, dest: &llvm::TypeRef) -> bool {
    if src.is_int_ty() && dest.is_int_ty() {
        if src.get_int_bit_width() > dest.get_int_bit_width() {
            return false;
        }
        return true;
    }
    if src.is_pointer_ty() && dest.is_pointer_ty() {
        return true;
    }
    if src.is_float_ty() && dest.is_double_ty() {
        return true;
    }
    return false;
}

pub fn get_cast_ops(src_loc: &Loc, src: &llvm::TypeRef, dest_loc: &Loc, dest: &llvm::TypeRef) -> llvm::CastOps {
    if src.is_int_ty() && dest.is_int_ty() {
        if src.get_int_bit_width() > dest.get_int_bit_width() {
            return llvm::CastOps::Trunc;
        }
        return llvm::CastOps::SExt;
    }
    if src.is_pointer_ty() && dest.is_pointer_ty() {
        return llvm::CastOps::BitCast;
    }
    if src.is_pointer_ty() && dest.is_int_ty() {
        return llvm::CastOps::PtrToInt;
    }
    if src.is_float_ty() && dest.is_float_ty() {
        if src.is_float_ty() && dest.is_double_ty() {
            return llvm::CastOps::FPExt;
        }
    }
    if src.is_int_ty() {
        if dest.is_float_ty() {
            return llvm::CastOps::SIToFP;
        }
        if dest.is_pointer_ty() {
            return llvm::CastOps::IntToPtr;
        }
    }
    if src.is_struct_ty() && dest.is_struct_ty() {
        if src.can_losslessly_bit_cast_to(dest) {
            return llvm::CastOps::BitCast;
        }
    }
    error_msg_labels("unable to convert types", &[
        ErrorLabel::from(src_loc, format!("`from {}`", src.print()).as_str()),
        ErrorLabel::from(dest_loc, format!("`to {}`", dest.print()).as_str()),
    ]);
}

impl Generate for CastExpr {
    fn loc(&self) -> &crate::lexer::Loc {
        self.obj.loc()
    }

    fn get_value(&self) -> String {
        self.obj.get_value()
    }

    fn gen_code(&mut self, scope: &mut super::Scope, ctx: &crate::GenerationContext) -> Option<llvm::ValueRef> {
        let mut obj = self.obj.gen_code(scope, ctx).unwrap();
        if self.obj.should_load() {
            let base = self.obj.get_type(scope, ctx).unwrap();
            obj = obj.try_load(&scope.resolve_type(&base, ctx), ctx.builder);
        }

        let dest_ty = scope.resolve_type(&self.target_type, ctx);
        let src_ty = obj.get_type();

        return Some(ctx.builder.create_cast(get_cast_ops(&self.obj.loc(), &src_ty, &self.target_type.get_loc(), &dest_ty), &obj, &dest_ty));
    }

    fn get_type(&self, _: &mut super::Scope, _: &crate::GenerationContext) -> Option<Type> {
        return Some(self.target_type.clone());
    }

    fn collect_symbols(&mut self, _scope: &mut super::Scope) {}
}
