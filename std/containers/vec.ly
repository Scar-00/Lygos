macro Vec {
    (name: $, typ: $) -> {
        struct Vec##$name {
            data: *$typ;
            cap: u32;
            len: u32;
        };

        impl Vec##$name {
            fn new() -> Vec##$name {
                let size: i32 = sizeof$($typ);
                let this: Vec##$name = {
                    .data = (:*$typ)0,
                    .cap = (:u32)0,
                    .len = (:u32)0,
                };
                return this;
            }

            fn with_size(size: u32) -> Self {
                let this: Vec##$name = {
                    .data = (:*$typ)malloc(((:u64)size) * sizeof$($typ)),
                    .cap = size,
                    .len = (:u32)0,
                };
                return this;
            }

            fn from_raw_parts(data: *$typ, len: u32, cap: u32) -> Self {
                let this: Self = { data, cap, len };
                return this;
            }

            fn may_grow(&mut self) {
                let size: u32 = sizeof$($typ);
                if self.cap == (:u32)0 {
                    self.cap = (:u32)1;
                    self.data = (:*$typ)realloc((:*i8)self.data, self.cap * size);
                }
                if self.cap == self.len {
                    self.cap = self.cap * (:u32)2;
                    self.data = (:*$typ)realloc((:*i8)self.data, self.cap * size);
                }
            }

            fn push(&mut self, value: $typ) {
                self.may_grow();
                self.data[self.len] = value;
                self.len = self.len + (:u32)1;
            }

            fn pop(&mut self) -> $typ {
                self.len = self.len - (:u32)1;
                return self.data[self.len];
            }

            /*fn insert(&mut self, index: u32, other: &Self) -> bool {
                let typ_size: u32 = sizeof$($typ);
                self.may_grow();
                if self.cap < (self.len + other.len) {
                    self.cap = self.len + other.len;
                    self.data = (:*$typ)realloc((:*i8)self.data, self.cap * typ_size);
                }
                self.data = (:*$typ)memmove((:*i8)&self.data[index + other.len], (:*i8)&self.data[index], ((:u64)(other.len * typ_size)));
                self.data = (:*$typ)memcpy((:*i8)&self.data[index], (:*i8)other.data, ((:u32)(other.len * typ_size)));
            }*/

            fn insert_item(&mut self, index: u64, item: $typ) {
                self.len = self.len + (:u32)1;
                self.may_grow();
                memmove((:*i8)&self.data[index + (:u64)1], (:*i8)&self.data[index], (((:u64)self.len) - index) * sizeof$($typ));
                self.data[index] = item;
            }

            fn remove(&mut self, index: u32) {
                if index > self.cap {
                    panic$("remove index out of bounds");
                }
                memmove((:*i8)&self.data[index], (:*i8)&self.data[index + (:u32)1], ((:u64)(self.len - index)) * sizeof$($typ));
                self.len = self.len - (:u32)1;
            }
        }

        impl Drop for Vec##$name {
            fn drop(&mut self) {
                if self.data != (:*$typ)0 {
                    free((:*i8)self.data);
                }
            }
        }

        impl Clone for Vec##$name {
            fn clone(&self) -> Self {
                let typ_size: u32 = sizeof$($typ);
                let this = Vec##$name::with_size(self.cap);
                this.data = (:*$typ)memcpy((:*i8)this.data, (:*i8)self.data, self.cap * typ_size);
                this.len = self.len;
                return this;
            }
        }
    }
}
