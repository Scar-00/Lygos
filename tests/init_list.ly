struct Foo {
    x: i32;
    y: i32;
};

fn main() -> i32 {
    let x = 10;
    let y = 20;
    let foo: Foo = {
        .x = y,
        .y = x
    };
    printf("foo -> %d | %d\n", foo.x, foo.y);
    return 0;
}
