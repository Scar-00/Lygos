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

type a = i32;
type int = a;

fn main(argc: i32) -> i32 {
    let x: int = 10;
    return 0;
}
