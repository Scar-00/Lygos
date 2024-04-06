#include "../core/fmt.ly"
#include "../string.ly"

enum ProcDescriptor {
    Stdin,
    Stdout,
    Stderr,
}

fn write(file: u32, ptr: *i8, len: u64) -> i64;

fn print_(s: str) {
    write((:u32)ProcDescriptor::Stdout, s.as_ptr(), s.len());
}

fn eprint_(s: str) {
    write((:u32)ProcDescriptor::Stderr, s.as_ptr(), s.len());
}

fn print_fmt_(args: Arguments) {
    let buf = format_(args);
    let s = buf.as_str();
    write((:u32)ProcDescriptor::Stdout, s.as_ptr(), s.len());
    buf.drop();
}

fn eprint_fmt_(args: Arguments) {
    let buf = format_(args);
    let s = buf.as_str();
    write((:u32)ProcDescriptor::Stderr, s.as_ptr(), s.len());
    buf.drop();
}

macro println {
    () -> {
        print_("\n");
    }
    (string: $) -> {
        print_($string);
        print_("\n");
    }
    (fmt: $, args: $[]) -> {
        print_fmt_(format_args$($fmt, $args));
        print_("\n");
    }
}

macro print {
    (string: $) -> {
        print_($string);
    }
    (fmt: $, args: $[]) -> {
        print_fmt_(format_args$($fmt, $args));
    }
}

macro panic {
    () -> {
        eprint_("\n");
        exit(1);
    }
    (string: $) -> {
        eprint_($string);
        eprint_("\n");
        exit(1);
    }
    (fmt: $, args: $[]) -> {
        eprint_fmt_(format_args$($fmt, $args));
        eprint_("\n");
        exit(1);
    }
}

macro todo {
    () -> {
        eprint_("[TODO]");
        exit(1);
    }

    (string: $) -> {
        eprint_("[TODO]: ");
        eprint_($string);
        eprint_("\n");
        exit(1);
    }

    (fmt: $, args: $[]) -> {
        eprint_("[TODO]: ");
        eprint_fmt_(format_args$($fmt, $args));
        eprint_("\n");
        exit(1);
    }
}
