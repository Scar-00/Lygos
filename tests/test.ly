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

fn main() -> i32 {
    println$();
    println$("Test");
    return 0;
}
