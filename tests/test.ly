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

fn main(argc: i32) -> i32 {
    for let i = 0 in i < 10 {
        if argc == 5 {
            return 100;
        }
        i = i + 1;
    }
    return 0;
}
