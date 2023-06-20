struct Vec {
    value: i32;
};

impl Vec {
    fn new(value: i32) -> Self {
        let this: Self = {
            .value = value,
        };
        return this;
    }

    fn test(&self) -> i32 {
        return self->value;
    }
}

fn main(argc: i32) -> i32 {
    let mut x = Vec::new(10);
    printf("%d\n", x.test());
    return 0;
}
