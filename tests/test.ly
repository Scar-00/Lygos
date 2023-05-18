struct Quad {
    width: i32;
    height: i32;
};

trait Area {
    fn area(&self) -> i32;
    fn test(&self);
}

impl Area for Quad {
    fn area(&self) -> i32 {
        return self->width * self->height;
    }
    fn test(&self) {

    }
}

fn main() -> i32 {
    return 0;
}
