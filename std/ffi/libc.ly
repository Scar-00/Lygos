#include "../core/types.ly"

fn isdigit(c: i32) -> i32;
fn isalpha(c: i32) -> i32;
fn isspace(c: i32) -> i32;

fn exit(code: i32);

fn malloc(size: u64) -> *i8;
fn realloc(ptr: *i8, size: u32) -> *i8;
fn calloc(count: u64, size: u64) -> *i8;
fn free(block: *i8);
fn memcpy(dest: *i8, src: *i8, size: u32) -> *i8;
fn memmove(dest: *i8, src: *i8, len: u64) -> *i8;
fn memset(ptr: *i8, v: i32, n: size_t) -> *i8;
fn strlen(str: *i8) -> u32;
fn strcpy(dest: *i8, src: *i8) -> *i8;

type FileDescriptor = *i8;
fn fopen(filename: *i8, modes: *i8) -> FileDescriptor;
fn fclose(stream: FileDescriptor) -> i32;
fn fseek(stream: FileDescriptor, off: u64, whence: i32) -> i32;
fn ftell(stream: FileDescriptor) -> u64;
fn rewind(stream: FileDescriptor);
fn fread(ptr: *i8, size: u64, n: u64, stream: FileDescriptor) -> u64;
