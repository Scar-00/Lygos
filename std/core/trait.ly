trait Drop {
    fn drop(&mut self);
}

trait Clone {
    fn clone(&self) -> Self;
}

trait Debug {
    fn fmt_debug(&self, fmt: &mut Formatter) -> FormattingError;
}

trait Display {
    fn fmt(&self, fmt: &mut Formatter) -> FormattingError;
}

trait Hash {
    fn hash(&self) -> size_t;
}

/*trait Alloc {
    fn alloc<T>(count: u64);
    fn realloc<T>(ptr: *T, new_size: u64);
    fn free<T>(ptr: *T);
}*/
