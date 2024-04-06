#include "../ffi/libc.ly"
#include "../core/types.ly"
#include "../string.ly"

struct StringSet {
    entries: **String;
    size: size_t;
};

impl StringSet {
    fn new() -> StringSet {
        return { .entries = (:**$ty)0, .size = 0 };
    }

    fn insert(&mut self, v: String) {
        let hash = v.as_str().hash() % self->size;
        let entry = self.entries[hash];

        if entry == (*String)0 {
            let this = malloc(sizeof$(String));
            (*this) = v;
            self.entries[hash] = this;
        }
    }

    fn contains(&self, v: str) -> bool {
        let hash = v.as_str().hash() % self->size;
        let entry = self.entries[hash];

        if entry == (*String)0 {
            return false;
        }

    }
}

impl Drop for StringSet {
    fn drop(&self) {
        for let i: size_t = 0 in i < self.size {
            let entry = self.entries[i];
            if entry != (*String)0 {
                free(entry);
            }
            i = i + (:size_t)1;
        }
        free(self.entries);
    }
}

/*macro Set {
    (name: $, ty: $) -> {
        struct $name##Set {
            entries: **$ty;
            size: size_t;
        };

        impl $name##Set {
            fn new() -> Self {
                return { .entries = (:**$ty)0, .size = 0 };
            };

            fn insert(&mut self, item: $ty) {
                
            }

            fn resize() {
                todo$();
            }
        }
    }
}*/
