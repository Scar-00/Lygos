macro foo() {
    let x = 10;
}

macro test(x: $) {
    foo$();
    x;
    printf("Hello, World!\n");
}

macro vec2(v: $[]) {
    let x = v[0];
    let y = v[1];
    let z = v;
    printf("%d, %d", v[...]);
}

fn main() -> i32 {
    test$(let mut y = 10, y = 20);
    printf("%d\n", y);
    return 0;
}
