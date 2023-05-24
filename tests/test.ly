//fn malloc(size: u64) -> *i8;

struct Foo { x: i32; };

struct Vec<T> {
    data: *i32;
    len: u32;
    cap: u32;
};

//impl Vec<T> {
//    fn new(size: u32) -> Vec<T> {
//        let this: Vec<T> = {
//            .data = malloc((:u64)(size * 4)),
//            .len = 0,
//            .cap = size,
//        };
//        return this;
//    }
//}

fn main() -> i32 {
    return 0;
}
