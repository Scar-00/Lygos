struct Foo {
    x: i32;
    y: i32;
};

fn test() -> Foo {
    let this: Foo = {
        .x = 200,
        .y = 300
    };
    return this;
}

fn main() -> i32 {
    let x = 10;
    let y = 20;
    let f: Foo = { .x = x, .y = y };
    let foo: Foo = { x, y };
    printf("foo -> %d | %d\n", f.x, f.y);
    return 0;
}
