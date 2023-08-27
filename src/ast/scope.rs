#[derive(Debug)]
pub struct Scope {
    parent: Option<Box<Scope>>,
}

impl Scope {
    pub fn new() -> Self {
        Self { parent: None }
    }

    pub fn with_parent(parent: Box<Scope>) -> Self {
        Self {
            parent: Some(parent),
        }
    }
}
