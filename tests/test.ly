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

struct Vec {
    x: i32;
    y: i32;
};

impl Vec {
    fn test() -> Self {}
    fn foo(&self) -> i32 {}
}

static foo: *i32;

fn main(argc: i32) -> i32 {
    return 0;
}
