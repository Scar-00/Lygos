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

struct Box<T> {
    data: T;
};

impl Box<T> {
    fn test() {

    }
}

fn main(argc: i32) -> i32 {
    let mut v: Box<*i32>;
    return 0;
}
