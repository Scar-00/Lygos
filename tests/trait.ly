struct Quad {
    width: i32;
    height: i32;
};

struct Triangle {
    width: i32;
    height: i32;
};

trait Area {
    fn area(&self) -> i32;
    fn test(&self);
}

impl Area for Triangle {
    fn area(&self) -> i32 {
        return self->width * self->height;
    }
    fn test(&self) {

    }
}

impl Area for Quad {
    fn area(&self) -> i32 {
        return self->width * self->height;
    }
    fn test(&self) {

    }
}

fn main() -> i32 {
    let q: Quad = { 10, 5 };
    let tri: Triangle = { 10, 5 };
    let area = q.area();
    printf("area -> %d\n", area);
    return 0;
}
