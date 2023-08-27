use std::fmt::format;
use std::path::PathBuf;
use std::sync::atomic::AtomicPtr;

use inkwell::builder::Builder;
use inkwell::context::Context;
use inkwell::module::Module;
use inkwell::values::{AnyValue, PointerValue};

mod ast;
mod io;
mod lexer;
mod parse;
mod types;
use ast::ast::AST;
use lexer::lexer::Lexer as lex;
use parse::parser::Parser;

pub mod ctx {
    use inkwell::builder::Builder;
    use inkwell::context::Context;
    use inkwell::module::Module;
    use std::sync::atomic::{AtomicPtr, Ordering};

    #[allow(non_upper_case_globals)]
    static ctx: AtomicPtr<Context> = AtomicPtr::new(&mut Context::create());
    #[allow(non_upper_case_globals)]
    static module: AtomicPtr<Module> = AtomicPtr::new(&mut get_ctx().create_module(""));
    #[allow(non_upper_case_globals)]
    static builder: AtomicPtr<Builder> = AtomicPtr::new(&mut get_ctx().create_builder());

    pub fn get_ctx() -> &'static mut Context {
        unsafe { ctx.load(Ordering::Relaxed).as_mut().unwrap() }
    }

    pub fn get_mod() -> &'static mut Module<'static> {
        unsafe { module.load(Ordering::Relaxed).as_mut().unwrap() }
    }

    pub fn get_builder() -> &'static mut Builder<'static> {
        unsafe { builder.load(Ordering::Relaxed).as_mut().unwrap() }
    }

    pub fn set_mod_name(name: &str) {
        get_mod().set_name(name);
    }
}

fn main() {
    let ctx = Context::create();
    let module = ctx.create_module("test");
    let builder = ctx.create_builder();

    let fn_type = ctx.i32_type().fn_type(&[], false);

    let main = module.add_function("main", fn_type, None);
    let bb = ctx.append_basic_block(main, "");
    builder.position_at_end(bb);

    let typ = ctx.opaque_struct_type("test");
    typ.set_body(&[ctx.i32_type().into()], false);
    let alloca = builder.build_alloca(ctx.i32_type(), "");
    builder.build_store(alloca, ctx.i32_type().const_int(10, false));
    builder.build_return(None);

    module.print_to_file("main.ll");

    let file = PathBuf::from("test.ly");
    let content = match io::read_file(&file) {
        Ok(c) => c,
        Err(_) => panic!("could not read file"),
    };

    ctx::set_mod_name(file.to_str().unwrap());

    let mut lexer = lex::Lexer::from(&content, &file);
    let tokens = lexer.get_tokens();
    println!("{:#?}", tokens);
}

struct Foo;
