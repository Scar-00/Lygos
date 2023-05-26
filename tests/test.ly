macro bar {
    () -> {
        "test\n";
    }
}

macro foo {
    () -> {
        let x = 10;
    }
    (x: $) -> {
        $x;
    }

    (x: $, y: $) -> {
        let x: $x = $y;
        printf(bar$());
    }

    (x: $, y: $[]) -> {
        $x;
        $y;
        printf("Hello, World\n");
    }
}

fn main() -> i32 {
    foo$(u32, 1);
    return 0;
}
