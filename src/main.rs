#![allow(non_upper_case_globals)]

use std::path::PathBuf;

mod ast;
mod io;
mod lexer;
mod parse;
mod types;
mod log;
use lexer::{Lexer, Loc};
use parse::Parser;
use ast::Generate;
use ast::Scope;

/*
 *  TODO(S): automatically promote int type values if it can be safely done: allow u32 -> u64 |
 *  forbid u32 -> u16.
 *  Convert constant int types to whatever is requested by the operation its used in
 *
 */

pub struct GenerationContext<'a> {
    pub ctx: &'a llvm::Context,
    pub module: &'a llvm::Module<'a>,
    pub builder: &'a llvm::IRBuilder<'a>,
    pub current_function: *mut crate::ast::Function,
    pub current_break_point: Vec<*mut llvm::BasicBlock>,
}

impl<'a> GenerationContext<'a> {
    pub fn new(ctx: &'a llvm::Context, module: &'a llvm::Module<'a>, builder: &'a llvm::IRBuilder<'a>) -> GenerationContext<'a> {
        return Self{ ctx, module, builder, current_function: std::ptr::null_mut(), current_break_point: Vec::new() }
    }
}

fn main() {
    let opt = io::get_cli_options();

    let file = if let Some(file) = &opt.input_file {
        PathBuf::from(file)
    }else {
        eprintln!("[error]: no input file provided");
        std::process::exit(1);
    };

    let content = match io::read_file(&file) {
        Ok(c) => c,
        Err(_) => panic!("could not read file"),
    };

    llvm::init_all();
    let tt = llvm::get_default_target_triple();
    let target = llvm::lookup_target(&tt);

    let cpu = "generic";
    let features = "";
    let target_machine = llvm::create_target_machine(target, tt.as_str(), cpu, features);

    let ctx = llvm::Context::new();
    ctx.set_opaque_pointers(false);
    let mut m = llvm::Module::new(opt.input_file.unwrap().as_str(), &ctx);
    m.set_data_layout(&target_machine);
    m.set_target_triple(&tt);
    let builder = llvm::IRBuilder::new(&ctx);

    let mut lexer = Lexer::from(&content, &file);
    let mut parser = Parser::new(&mut lexer);
    let mut ast = parser.build_ast();
    let mut scope = Scope::new();
    ast.collect_symbols(&mut scope);
    let ctx = GenerationContext::new(&ctx, &m, &builder);
    ast.gen_code(&mut Scope::new(), &ctx);

    let out_file = PathBuf::from(&opt.output_file);

    if let Some(extra) = opt.emit_extra {
        let _res = match extra {
            io::EmitType::llvm_ir => {
                let mut out = out_file.clone();
                out.set_extension("ll");
                io::emit_ir(out, &ctx)
            }
            io::EmitType::ast => {
                let mut out = out_file.clone();
                out.set_extension("ast");
                io::emit_ast(out, &ast)
            }
        };
    }

    let _res = if opt.emit_exe {
        io::emit_exe(&out_file, &m, &target_machine)
    }else {
        io::emit_obj(&out_file, &m, &target_machine)
    };
}
