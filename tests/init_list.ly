struct Foo {
    x: i32;
    y: i32;
};

fn test() -> Foo {
    //return {
    //    .x = 200,
    //    .y = 300
    //};
}

fn main() -> i32 {
    let x = 10;
    let y = 20;
    let foo: Foo = {
        .x = y,
        .y = x
    };
    let f: Foo = { x, y };
    let z = f[0];
    printf("foo -> %d | %d\n", foo.x, foo.y);
    return 0;
}
