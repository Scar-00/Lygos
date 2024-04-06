#include "../ffi/libc.ly"

macro array {
    (name: $, typ: $) -> {
        struct Array##$name {
            data: *$typ;
            cap: u32;
            size: u32;
        };

        impl Array##$name {
            fn new(cap: u32) -> Self {
                let this: Self {
                    data: malloc((:u64)cap * sizeof$($typ)),
                    cap: cap,
                    size: 0,
                };
                return this;
            }
        }
    }
}
