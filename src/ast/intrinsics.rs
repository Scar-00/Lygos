use crate::ast::{AST, MacroCall, Scope, Generate};
use crate::GenerationContext;
use crate::log::{error_msg_label, ErrorLabel, token_expected, error_msg, error_msg_labels};
use crate::Parser;
use crate::types::{Type, BaseTypes, TokenType, Path, Pointer};
use crate::lexer::{Tagged, Token, Loc, Lexer};
use crate::ast::symbol::Symbol;

use std::path::PathBuf;

fn get_formatting_function(call_loc: &Loc, ty: Type, scope: &mut Scope, debug: bool) -> String {
    let name = ty.get_full_name();
    let tagged = Tagged::new(ty.get_loc(), name.clone());
    if BaseTypes.contains(&name.as_str()) {
        return name + "_fmt";
    }
    if let Type::Pointer(_) = ty {
        return String::from("ptr_fmt");
    }
    if scope.is_struct(&tagged) {
        if debug {
            if !scope.get_struct(&tagged).implements_trait("Debug") {
                error_msg_label(
                    format!("type `{}` does not implement trait `Debug`", name).as_str(),
                    ErrorLabel::from(call_loc, "not formattable")
                );
            }
            return scope.get_struct(&tagged).get_function("fmt_debug").name_mangeled.clone();
        }else {
            if !scope.get_struct(&tagged).implements_trait("Display") {
                error_msg_label(
                    format!("type `{}` does not implement trait `Display`", name).as_str(),
                    ErrorLabel::from(call_loc, "not formattable")
                );
            }
            return scope.get_struct(&tagged).get_function("fmt").name_mangeled.clone();
        }
    }
    error_msg_label(
        format!("cannot format type `{}` with the default formatter", name).as_str(),
        ErrorLabel::from(call_loc, "not formattable")
    );
}

pub fn macro_format(call: &MacroCall, scope: &mut Scope, ctx: &GenerationContext) -> llvm::ValueRef {
    let format_string = call.args[0][0].clone();

    if format_string.typ != TokenType::String {
        token_expected(&format_string.loc, "unexpected token found", "expected string literal as first argument to `format_args`");
    }

    let mut format_string = format_string.value.as_str();
    let mut piecies: Vec<String> = Vec::new();
    let mut args_expected = 0;
    let mut debug: Vec<bool> = Vec::new();
    while let Some(mut pos) = format_string.find('{') {
        args_expected += 1;
        piecies.push(format_string[..pos].to_string());
        if pos + 3 < format_string.len() {
            if format_string[pos+1..pos+3] == *":?" {
                pos += 2;
                debug.push(true);
            }else {
                debug.push(false);
            }
        }else {
            debug.push(false);
        }
        format_string = &format_string[pos + 2..];
    }
    if format_string.len() > 0 {
        piecies.push(format_string.to_string());
    }

    if call.args.len() != args_expected + 1 {
        error_msg_label(
            format!("macro `format_args` expected `{}` args, but `{}` were provided", args_expected, call.args.len()).as_str(),
            ErrorLabel::from(call.id.loc(), "incorrect number of arguments")
        );
    }

    let mut arg_idents: Vec<AST> = Vec::new();
    for i in 1..args_expected+1 {
        let mut arg = call.args[i].clone();
        arg.push(Token::new(";", TokenType::Semi, Loc::new("".into(), 0, 1)));
        let mut parser = Parser::from(arg);
        if let AST::Mod(mut m) = parser.build_ast() {
            arg_idents.push(m.body.body.remove(0));
        }
    }

    let zero = llvm::ConstantInt::get(&llvm::TypeRef::get_int(ctx.ctx, 32), 0);

    let arg_ty = Type::Path(Path::new(Loc::new("internal".into(), 0, 1), "Argument".into()));
    let arr_ty = llvm::ArrayTypeRef::get(&scope.resolve_type(&arg_ty, ctx), args_expected).into();

    let args_arr = ctx.builder.create_alloca(&arr_ty, None);
    let fmt_type = scope.resolve_type(&scope.get_struct(&Tagged::new(Loc::new("internal".into(), 0, 1), "Argument".to_string())).fields[1].typ, ctx);
    for i in 0..args_expected {
        //getting a member_call_expr's type before its value is generated will lead to the
        //functions name to not be mangeled an therefore be invalid
        let mut value_val = arg_idents[i].gen_code(scope, ctx).unwrap();

        let func = ctx.module.get_function(&get_formatting_function(call.id.loc(), arg_idents[i].get_type(scope, ctx).unwrap(), scope, debug[i])).unwrap_or_else(|| {
            error_msg_label(
                format!("failed to get formatting function for `{}`", get_formatting_function(call.id.loc(), arg_idents[i].get_type(scope, ctx).unwrap(), scope, debug[i])).as_str(),
                ErrorLabel::from(call.id.loc(), "not formattable")
            );
        });

        let arg = ctx.builder.create_alloca(&scope.resolve_type(&arg_ty, ctx), None);
        let type_ptr = Type::Pointer(Pointer::new(Loc::new("internal".into(), 0, 1), Box::new(arg_idents[i].get_type(scope, ctx).unwrap()), false, false));
        let value = ctx.builder.create_alloca(&scope.resolve_type(&type_ptr, ctx), None);

        if !value_val.get_type().is_pointer_ty() {
            let alloc = ctx.builder.create_alloca(&value_val.get_type(), None);
            ctx.builder.create_store(&value_val, &alloc);
            value_val = alloc;
        }

        ctx.builder.create_store(&value_val, &value);

        let value_gep = ctx.builder.create_struct_gep(&arg.get_type().get_base().unwrap(), &arg, 0);
        let load = ctx.builder.create_load(&value.get_type().get_base().unwrap(), &value);
        ctx.builder.create_store(&ctx.builder.create_pointer_cast(&load, &llvm::TypeRef::get_ptr(llvm::TypeRef::get_int(ctx.ctx, 8), 0)), &value_gep);

        let ptr_gep = ctx.builder.create_struct_gep(&arg.get_type().get_base().unwrap(), &arg, 1);
        ctx.builder.create_store(&ctx.builder.create_cast(llvm::CastOps::BitCast, &func.into(), &fmt_type), &ptr_gep);

        let idx = llvm::ConstantInt::get(&llvm::TypeRef::get_int(ctx.ctx, 32), i as i32);
        let arr_index = ctx.builder.create_gep(&args_arr.get_type().get_base().unwrap(), &args_arr, &[zero.clone(), idx], true);
        ctx.builder.create_store(&ctx.builder.create_load(&arg.get_type().get_base().unwrap(), &arg), &arr_index);
    }
    let piece_type = llvm::StructTypeRef::get(&ctx.ctx, &[llvm::TypeRef::get_ptr(llvm::TypeRef::get_int(&ctx.ctx, 8), 0), llvm::TypeRef::get_int(&ctx.ctx, 64)], false).into();
    let piecies_ty = llvm::ArrayTypeRef::get(&piece_type, piecies.len()).into();
    let pieces_arr = ctx.builder.create_alloca(&piecies_ty, None);

    for i in 0..piecies.len() {
        let idx = llvm::ConstantInt::get(&llvm::TypeRef::get_int(ctx.ctx, 32), i as i32);
        let gep = ctx.builder.create_gep(&pieces_arr.get_type().get_base().unwrap(), &pieces_arr, &[zero.clone(), idx], true);
        let lit = llvm::ConstantStruct::get(piece_type.clone(),
            &[
                ctx.builder.create_global_string_pointer(piecies[i].as_str()),
                llvm::ConstantInt::get(&llvm::TypeRef::get_int(ctx.ctx, 64), piecies[i].len() as i32)
            ]
        );
        ctx.builder.create_store(&lit, &gep);
    }

    let arr_idx = ctx.builder.create_gep(&args_arr.get_type().get_base().unwrap(), &args_arr, &[zero.clone(), zero.clone()], true);
    let pieces_idx = ctx.builder.create_gep(&pieces_arr.get_type().get_base().unwrap(), &pieces_arr, &[zero.clone(), zero.clone()], true);

    let func = ctx.module.get_function("Arguments_new").unwrap_or_else(|| {
        error_msg("internal", "Arguments::new is undefined");
    });
    return ctx.builder.create_call(&func.into(), &[
        arr_idx, llvm::ConstantInt::get(&llvm::TypeRef::get_int(ctx.ctx, 32), args_expected as i32),
        pieces_idx, llvm::ConstantInt::get(&llvm::TypeRef::get_int(ctx.ctx, 32), piecies.len() as i32),
    ]);
}

pub fn macro_sizeof(call: &MacroCall, scope: &mut Scope, ctx: &GenerationContext) -> llvm::ValueRef {
    if call.args.len() != 1 {
        error_msg_label(
            "macro `sizeof` expected exactly 1 argument",
            ErrorLabel::from(call.id.loc(), "invalid number of arguments")
        );
    }

    let mut arg = call.args[0].clone();
    arg.push(crate::lexer::Token::new(";", crate::types::TokenType::Semi, arg.last().unwrap().loc.clone()));
    let mut parser = Parser::from(arg.clone());
    if let AST::Mod(m) = parser.build_ast() {
        let ident = &m.body.body[0];


        let ty = if scope.has_symbol(ident.get_value()) {
            if let Symbol::Variable(_) = scope.resolve_symbol(&Tagged::new(ident.loc().clone(), ident.get_value().clone())) {
                if let Some(ty) = ident.get_type(scope, ctx) {
                    ty
                }else {
                    Type::from_string(ident.get_value()).unwrap()
                }
            }else {
                Type::from_string(ident.get_value()).unwrap()
            }
        }else {
            Type::from_string(ident.get_value()).unwrap()
        };
        let ty = scope.resolve_type(&ty, ctx);
        let size = ctx.module.get_data_layout().get_type_size_in_bits(&ty);
        return llvm::ConstantInt::get(&llvm::TypeRef::get_int(&ctx.ctx, 64), size as i32 / 8);
    }else {
        unreachable!();
    }
}

pub fn macro_file(call: &MacroCall, _: &mut Scope, ctx: &GenerationContext) -> llvm::ValueRef {
    let file = call.loc().file.to_str().unwrap();
    return llvm::ConstantStruct::get(
            llvm::StructTypeRef::get(&ctx.ctx, &[ llvm::TypeRef::get_ptr(llvm::TypeRef::get_int(&ctx.ctx, 8), 0), llvm::TypeRef::get_int(&ctx.ctx, 64)], false).into(),
            &[
                ctx.builder.create_global_string_pointer(file),
                llvm::ConstantInt::get(&llvm::TypeRef::get_int(ctx.ctx, 64), file.len() as i32)
            ]
        );
}

pub fn macro_line(_call: &MacroCall, _scope: &mut Scope, _ctx: &GenerationContext) -> llvm::ValueRef {
    todo!();
    //return llvm::ConstantInt::get(&llvm::TypeRef::get_int(&ctx.ctx, 64), call.);
}

pub fn impl_debug(call: &MacroCall, scope: &mut Scope, ctx: &GenerationContext) -> llvm::ValueRef {
    if call.args.len() != 1 {
        token_expected(call.loc(), "incorrect number of arguments supplied", &format!("expected `1` argument, got `{}`", call.args.len()));
    }

    let ty = call.args[0][0].clone();
    if ty.typ != TokenType::Id {
        token_expected(&ty.loc, "unexpected token found", "expected identifier");
    }
    let strct = scope.get_struct(&Tagged::from(ty));

    let mut func = format!("
        impl Debug for {} {{
            fn fmt_debug(&self, fmt: &mut Formatter) -> FormattingError {{
                let mut debug = fmt.debug_struct(\"{}\");
    ", strct.name.inner(), strct.name.inner());
    for field in &strct.fields {
        match &field.typ {
            Type::Path(_) => func += format!("debug.field(\"{}\", format_args$(\"{{:?}}\", self.{}));\n", field.id.inner(), field.id.inner()).as_str(),
            Type::Pointer(ptr) => {
                if ptr.is_ref {
                    func += format!("let tmp = self.{}; debug.field(\"{}\", format_args$(\"{{:?}}\", tmp));\n", field.id.inner(), field.id.inner()).as_str();
                }else {
                    func += format!("
                        if self.{} != (:{})0 {{
                            let tmp = self.{};
                            debug.field(\"{}\", format_args$(\"{{:?}}\", *tmp));
                        }} else {{
                            debug.field(\"{}\", format_args$(\"{{}}\", \"NULL\"));
                        }}
                    ", field.id.inner(), field.typ.get_full_name(), field.id.inner(), field.id.inner(), field.id.inner()).as_str();
                }
            },
            Type::Array(arr) => {
                func += format!("
                    if debug.has_fields {{
                        fmt.write_str(\", \");
                    }}
                    fmt.write_str(\"{}: [\");
                    for let mut i: u32 = 0 in i < (:u32){} {{
                        let tmp = self.{};
                        let s = format_(format_args$(\"{{:?}}\", tmp[i]));
                        fmt.write_str(s.as_str());
                        if (i + (:u32)1) < (:u32){} {{
                            fmt.write_str(\", \");
                        }}
                        s.drop();
                        i = i + (:u32)1;
                    }}
                    fmt.write_str(\"]\");
                ", field.id.inner(), arr.elems, field.id.inner(), arr.elems).as_str();
            },
            _ => {
                error_msg_labels(&format!("cannot format `{}`", field.id.inner()), &[
                    ErrorLabel::from(&field.typ.get_loc(), "cannot format type"),
                ]);
            }
        }
    }
    func += "
                debug.finish();
            }
        }
    ";

    //println!("{}", func);
    //panic!();

    let mut lexer = Lexer::from(&func, &PathBuf::from("internal"));
    let mut parser = Parser::new(&mut lexer);
    let ast = parser.build_ast();
    if let AST::Mod(mut m) = ast {
        if let AST::Impl(imp) = &mut m.body.body[0] {
            imp.gen_code(scope, ctx);
        }else {
            todo!();
        }
    }else {
        todo!();
    }

    return llvm::ConstantInt::get(&llvm::TypeRef::get_int(ctx.ctx, 1), 0);
}
