
macro println {
    () -> {
        printf("\n");
    }
    (string: $) -> {
        printf("%s\n", $string);
    }

    (fmt: $, args: $[]) -> {
        printf($fmt, $args);
        printf("\n");
    }
}

macro decl {
    (typ: $) -> {
        struct Vec##$typ {
            data: *$typ;
            cap: i32;
            len: i32;
        };

        impl Vec##$typ {
            fn new() -> Vec##$typ {
                let this: Vec##$typ = {
                    .cap = 0,
                    .len = 0,
                };
                return this;
            }

            fn from_parts(data: *$typ, cap: i32, len: i32) -> Vec##$typ {
                let this: Vec##$typ = {
                    .data = data,
                    .cap = cap,
                    .len = len,
                };
                return this;
            }
        }
    }
}

decl$(i32);
decl$(f32);

fn main() -> i32 {
    let test = Veci32::new();
    return 0;
}
