fn test(x: i32) {
    match x {
        1 -> { printf("arm 1\n"); }
        2 -> { printf("arm 2\n"); }
        3 -> { printf("arm 3\n"); }
    }
}

fn main(argc: i32, argv: **i8) -> i32 {
    test(2);
    return 0;
}
