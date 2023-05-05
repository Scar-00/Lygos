fn malloc(size: i32) -> *i8;

struct V2 {
    x: i32;
    y: i32;
};

impl V2 {
    fn from(x: i32, y: i32) -> *V2 {
        let this: *V2 = malloc(8);
        this->x = x;
        this->y = y;
    }

    fn test(&mut self, x: i32) -> *i32 {
        return (:*i32)malloc(4);
    }
}

fn main(argc: i32, argv: **i8) -> i32 {
    let v: *V2 = V2::from(10, 20);
    let mut x: *i32;
    x = v->test(10);
    x = (*v).test(10);
    return 0;
}
