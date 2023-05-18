fn malloc(size: i32) -> *i8;

struct V2 {
    x: i32;
    y: i32;
};

impl V2 {
    fn from(x: i32, y: i32) -> V2 {
        let this: V2 = { .x = x, .y = y };
        return this;
    }

    fn test(&mut self, x: i32) -> i32 {
        return self->x;
    }

    fn t(x: i32, y: i32) -> *V2 {
        let this: *V2 = malloc(8);
        this->x = x;
        this->y = y;
        return this;
    }
}

fn main(argc: i32, argv: **i8) -> i32 {
    let v: V2 = V2::from(10, 20);
    let ptr = V2::t(200, 300);
    let val = ptr->test(10);
    printf("val -> %d\n", val);
    printf("%d | %d\n", ptr->x, ptr->y);
    printf("%d | %d\n", v.x, v.y);
    return 0;
}
