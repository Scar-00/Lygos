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

macro test {
    () -> {
        struct Vec {
            x: i32;
            y: i32;
        };

        impl Vec {
            fn test() -> Self {}
        }
    }
}

test$();

fn main(argc: i32) -> i32 {
    return 0;
}
