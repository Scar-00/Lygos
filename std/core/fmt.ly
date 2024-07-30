#include "../string.ly"

fn int_to_str(buffer: *i8, i: i64, base: i32) -> i64;
fn ptr_to_str(buffer: *i8, buf_size: u64, ptr: *i8) -> i32;

enum FormattingError {
    None,
    T,
}

struct DebugStructBuilder {
    formatter: &Formatter;
    has_fields: bool;
};

struct Formatter {
    buf: &String;
};

impl Formatter {
    fn new(buffer: &String) -> Self {
        let this: Self = { &buffer };
        return this;
    }

    fn write_str(&self, slice: str) -> FormattingError {
        let buf: &String = self.buf;
        buf.push_str(slice);
        return FormattingError::None;
    }

    fn debug_struct(&self, name: str) -> DebugStructBuilder {
        self.write_str(name);
        let this: DebugStructBuilder = { &self, (:bool)0 };
        return this;
    }
}

struct Argument {
    value: &i8;
    formatter: fn(&i8, &Formatter) -> FormattingError;
};

impl Argument {
    fn fmt(&self, fmt: &mut Formatter) -> FormattingError {
        (self.formatter)(self.value, &fmt);
    }
}

/*
    [Info]: this structure stores references to local variables
            returning it from a function will lead to UB(undefined behavior)
*/
struct Arguments {
    args: *Argument;
    arg_count: u32;
    pieces: *str;
    pieces_count: u32;
};

impl Arguments {
    fn new(args: *Argument, args_count: u32, pieces: *str, pieces_count: u32) -> Self {
        let this: Self = { args, args_count, pieces, pieces_count };
        return this;
    }

    fn estimate_length(&self) -> u32 {
        let mut len: u32 = 0;
        for let i: u32 = 0 in i < self.pieces_count {
            let piece = self.pieces[i];
            len = len + (:u32)piece.len();
            i = i + (:u32)1;
        }
        return len;
    }
}

fn format_(args: Arguments) -> String {
    let len = args.estimate_length();
    let buf = String::new(len);
    let formatter = Formatter::new(&buf);


    let idx = 0;
    for let i: u32 = 0 in i < args.arg_count {
        let arg = args.args[i];
        formatter.write_str(args.pieces[i]);
        arg.fmt(&formatter);
        i = i + (:u32)1;
        idx = idx + 1;
    }


    if ((:u32)idx) < args.pieces_count {
        formatter.write_str(args.pieces[idx]);
    }
    return buf;
}

impl DebugStructBuilder {
    fn field(&self, name: str, args: Arguments) -> &mut Self {
        let fmt: &Formatter = self.formatter;
        let mut prefix = "{ ";
        if self.has_fields == (:bool)1 {
            prefix = ", ";
        }
        fmt.write_str(prefix);
        fmt.write_str(name);
        fmt.write_str(": ");
        let arg = args.args[0];
        (arg.formatter)(arg.value, &fmt);
        self.has_fields = (:bool)1;
        return &self;
    }

    fn finish(&self) {
        if self.has_fields != (:bool)0 {
            let fmt = self.formatter;
            fmt.write_str(" }");
        }
    }
}

fn i64_fmt(i: &i64, fmt: &Formatter) -> FormattingError {
    let mut buf: [i8; 24];
    let ptr = &buf[0];
    let len: u64 = int_to_str(ptr, i, 10);
    let s = str::from_parts(ptr, len);
    return fmt.write_str(s);
}

fn i32_fmt(v: &i32, fmt: &Formatter) -> FormattingError {
    let val = (:i64)v;
    return i64_fmt(&val, &fmt);
}

fn i16_fmt(v: &i16, fmt: &Formatter) -> FormattingError {
    let val = (:i64)v;
    return i64_fmt(&val, &fmt);
}

fn i8_fmt(v: &i8, fmt: &Formatter) -> FormattingError {
    let val = (:i64)v;
    return i64_fmt(&val, &fmt);
}

fn u64_fmt(v: &u64, fmt: &Formatter) -> FormattingError {
    let val = (:i64)v;
    return i64_fmt(&val, &fmt);
}

fn u32_fmt(v: &u32, fmt: &Formatter) -> FormattingError {
    let val = (:i64)v;
    return i64_fmt(&val, &fmt);
}

fn u16_fmt(v: &u16, fmt: &Formatter) -> FormattingError {
    let val = (:i64)v;
    return i64_fmt(&val, &fmt);
}

fn u8_fmt(v: &u32, fmt: &Formatter) -> FormattingError {
    let val = (:i64)v;
    return i64_fmt(&val, &fmt);
}

fn bool_fmt(v: &bool, fmt: &Formatter) -> FormattingError {
    let mut s = "false";
    if v != (:bool)0 {
        s = "true";
    }
    return fmt.write_str(s);
}

fn ptr_fmt(v: &i8, fmt: &Formatter) -> FormattingError {
    let mut buf: [i8; 64];
    let ptr = &buf[0];
    let len: u64 = ptr_to_str(ptr, (:u64)64, (:*i8)v);
    let s = str::from_parts(ptr, len);
    return fmt.write_str(s);
}

impl Display for str {
    fn fmt(&self, fmt: &Formatter) -> FormattingError {
        return fmt.write_str(self);
    }
}

impl Display for String {
    fn fmt(&self, fmt: &Formatter) -> FormattingError {
        let s = self.as_str();
        return fmt.write_str(s);
    }
}

impl Debug for String {
    fn fmt_debug(&self, fmt: &mut Formatter) -> FormattingError {
        fmt.debug_struct("String")
        .field("content", format_args$("{}", self.as_str()))
        .field("len", format_args$("{}", self.len))
        .field("cap", format_args$("{}", self.cap))
        .finish();
    }
}

/*macro format {
    (fmt: $, args: $[]) -> {
        format_(format_args$($fmt, $args));
    }
}*/
