use std::path::{Path, PathBuf};
use std::fs::File;
use std::io::prelude::*;
use std::format;
use crate::GenerationContext;

use clap::{Parser, arg, ValueEnum};

#[derive(Parser, Debug)]
#[command(author, version, about)]
struct CliArgs {
    #[arg(short)]
    input_file: Option<String>,
    #[arg(short = 'c')]
    input_file_obj: Option<String>,
    #[arg(value_enum)]
    emit: Option<EmitType>,
    #[arg(short, default_value_t = String::from("out.o"))]
    output_file: String,
}

#[allow(non_camel_case_types)]
#[derive(ValueEnum, Clone, Debug)]
pub enum EmitType {
    llvm_ir,
    ast,
}

#[derive(Debug)]
pub struct CompilationOptions {
    pub input_file: Option<String>,
    pub output_file: String,
    pub emit_exe: bool,
    pub emit_extra: Option<EmitType>,
}

pub fn get_cli_options() -> CompilationOptions {
    let args = CliArgs::parse();
    if args.input_file.is_some() && args.input_file_obj.is_some() {
        eprintln!("[error]: several input files provided");
        std::process::exit(1);
    }

    let emit_exe = args.input_file.is_some();
    let input_file = match (args.input_file, args.input_file_obj) {
        (Some(file), None) => Some(file),
        (None, Some(file)) => Some(file),
        (None, None) => None,
        _ => None
    };

    return CompilationOptions{ input_file, output_file: args.output_file, emit_exe, emit_extra: args.emit };
}

pub fn read_file<S: AsRef<Path>>(path: S) -> Result<String, std::io::Error> {
    std::fs::read_to_string(path)
}

pub fn emit_ast<P: AsRef<Path>>(path: P, ast: &crate::ast::AST) -> std::io::Result<()> {
    let mut file = match File::create(path) {
        Ok(f) => f,
        Err(e) => panic!("could not open file `{}`", e),
    };

    let out = format!("{:#?}", ast);

    file.write_all(out.as_ref())?;
    return Ok(());
}

pub fn emit_ir<P: AsRef<Path>>(path: P, ctx: &GenerationContext) -> std::io::Result<()> {
    let mut file = match File::create(path) {
        Ok(f) => f,
        Err(e) => panic!("could not open file `{}`", e),
    };
    file.write_all(ctx.module.print().as_ref())?;
    return Ok(());
}

pub fn emit_exe(path: &PathBuf, m: &llvm::Module, tm: &llvm::TargetMachineRef) -> std::io::Result<()> {
    emit_obj(path, m, tm)?;
    let exe_path = path.with_extension("");
    let obj_path = path.with_extension("o");
    let cmd = format!("clang -o {} {} -lc ~/Desktop/lygos/debug_print.o", exe_path.to_str().unwrap(), obj_path.to_str().unwrap());
    println!("{}", cmd);
    let cmd = std::ffi::CString::new(cmd).unwrap();
    if unsafe{libc::system(cmd.as_ptr())} != 0 {
        return Err(std::io::Error::new(std::io::ErrorKind::Other, "failed to execture linker command"));
    };
    return Ok(());
}

pub fn emit_obj(path: &PathBuf, m: &llvm::Module, tm: &llvm::TargetMachineRef) -> std::io::Result<()> {
    let obj_path = path.with_extension("o");
    if llvm::emit_obj_file(obj_path.to_str().unwrap(), m, tm) {
        return Ok(());
    }else {
        return Err(std::io::Error::new(std::io::ErrorKind::Other, "fail"));
    }
}

pub fn emit_asm(path: &PathBuf, m: &llvm::Module, tm: &llvm::TargetMachineRef) -> std::io::Result<()> {
    let obj_path = path.with_extension("asm");
    if llvm::emit_asm_file(obj_path.to_str().unwrap(), m, tm) {
        return Ok(());
    }else {
        return Err(std::io::Error::new(std::io::ErrorKind::Other, "fail"));
    }
}
