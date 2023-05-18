macro foo {
    () -> {
        let x = 10;
    }
    (x: $) -> {
        x;
    }

    (x: $, y: $) -> {
        x;
        y;
        printf("Test\n");
    }

    (x: $, y: $[]) -> {
        x;
        y;
        printf("Hello, World\n");
    }
}

fn main() -> i32 {
    foo$(let x = 10, 1);
    return 0;
}
