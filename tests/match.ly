fn test(x: i32) {
    if x == 10 {
        printf("True\n");
    }
    printf("Test\n");
}

fn main(argc: i32, argv: **i8) -> i32 {
    test(10);
    return 0;
}
