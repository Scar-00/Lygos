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

fn malloc(size: i32) -> *i8;

trait Index {
    fn index(&self, index: i32) -> &i32;
}

struct Vec {
    data: *i32;
    len: u32;
    cap: u32;
};

impl Vec {
    fn new() -> Vec {
        let this: Vec = {
            .data = (:*i32)malloc(10 * 4),
            .len = 0,
            .cap = 10,
        };
        return this;
    }
}

impl Index for Vec {
    fn index(&self, index: i32) -> &i32 {
        return &self->data[index];
    }
}

fn main(argc: i32, argv: **i8) -> i32 {
    let vec = Vec::new();
    let x = vec[0];
    return 0;
}
