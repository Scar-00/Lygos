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

static glob: i32;

fn main(argc: i32) -> i32 {
    if argc == 10 || argc < 5 {
        println$("Hello World");
    }
    return 0;
}
