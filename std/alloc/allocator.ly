#include "../ffi/libc.ly"

trait Allocator {
    fn alloc(size: size_t) -> *i8;
    fn calloc(n: size_t, elem_size: size_t) -> *i8;
    fn realloc(ptr: *i8, new_size: size_t) -> *i8;
    fn free(block: *i8);
}

struct DefaultAllocator {};

impl Allocator for DefaultAllocator {
    fn alloc(size: size_t) -> *i8 {
        return malloc(size);
    }

    fn calloc(n: size_t, elem_size: size_t) -> *i8 {
        return calloc(n, elem_size);
    }

    fn realloc(ptr: *i8, new_size: size_t) -> *i8 {
        return realloc(ptr, new_size);
    }

    fn free(block: *i8) {
        free(block);
    }
}
