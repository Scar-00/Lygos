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

struct Foo {
    x: i32;
};

trait Copy {
    fn copy(&self) -> Self;
}

impl Copy for Foo {
    fn copy(&self) -> Self {
        let this: Foo = {
            .x = self->x,
        };
        return this;
    }
}

fn main(argc: i32, argv: **i8) -> i32 {
    let x = 10;
    return x;
}
