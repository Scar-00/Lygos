macro foo() {
    let x = 10;
}

macro test() {
    foo$();
    printf("Hello, World!\n");
}

fn main() -> i32 {
    test$();
    return 0;
}
