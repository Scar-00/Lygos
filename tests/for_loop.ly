fn main(argc: i32, argv: **i8) -> i32 {
    for let x = 0 in x < argc {
        printf("%d -> %s\n", x, argv[x]);
        x = x + 1;
    }
    return 0;
}
