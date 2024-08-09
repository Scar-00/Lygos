#include "./ffi/libc.ly"
#include "./core/trait.ly"

struct T {
    data: *i8;
    len: u64;
};

impl str {
    fn len(&self) -> u64 {
        return ((:*T)&self)->len;
    }

    fn as_ptr(&self) -> *i8 {
        return ((:*T)&self)->data;
    }

    fn from_parts(ptr: *i8, len: u64) -> Self {
        let s: T = { ptr, len };
        return (*((:*str)(&s)));
    }

    fn to_string(&self) -> String {
        return String::from(self);
    }
}

impl Hash for str {
    fn hash(&self) -> size_t {
        let p: u32  = 53;
        let m: u32 = 561634546;
        let mut hash_value: size_t = 0;
        let mut pow: size_t = 1;
        let ptr = self.as_ptr();
        for let i: size_t = 0 in i < (:size_t)self.len() {
            hash_value = (hash_value + ((:size_t)(ptr[i] - 'a' + (:i8)1)) * pow) % (:size_t)m;
            pow = (pow * (:size_t)p) % (:size_t)m;
            i = i + (:size_t)1;
        }
        return hash_value;
    }
}

struct String {
    data: *i8;
    len: u32;
    cap: u32;
};

impl Drop for String {
    fn drop(&mut self) {
        if self.data != (:*i8)0 {
            free(self.data);
        }
    }
}

impl String {
    fn new(size: u32) -> String {
        let s: String = {
            .data = malloc(((:size_t)size) * sizeof$(i8)),
            .len = (:u32)0,
            .cap = size,
        };
        return s;
    }

    fn from(s: str) -> String {
        let len: u32 = s.len();
        let ptr = s.as_ptr();
        let string = String::new(len);
        memcpy(string.data, ptr, ((:size_t)len) * sizeof$(i8));
        string.len = len;
        return string;
    }

    fn grow(&mut self) {
        if self.cap == (:u32)0 {
            self.cap = (:u32)1;
        }
        self.cap = self.cap * (:u32)2;
        self.data = realloc(self.data, ((:size_t)self.cap) * sizeof$(i8));
    }

    fn push(&mut self, char: i8) {
        if self.len == self.cap {
            self.grow();
        }
        self.data[self.len] = char;
        self.len = self.len + (:u32)1;
    }

    fn push_str(&mut self, other: str) {
        let len: u32 = other.len();
        let ptr = other.as_ptr();
        for let i: u32 = 0 in i < len {
            self.push(ptr[i]);
            i = i + (:u32)1;
        }
        return;
    }

    fn eq(&self, other: String) -> bool {
        if self.len != other.len {
            return (:bool)0;
        }
        for let i: u32 = 0 in i < self.len {
            if self.data[i] != other.data[i] {
                return (:bool)0;
            }
            i = i + (:u32)1;
        }
        return (:bool)1;
    }

    fn eq_ptr(&self, ptr: str) -> bool {
        let other = String::from(ptr);
        let eq = self.eq(other);
        other.drop();
        return eq;
    }

    fn contains(&self, matchee: i8) -> bool {
        for let mut i: u32 = 0 in i < self.len {
            let data = self.data;
            if data[i] == matchee {
                return (:bool)1;
            }
            i = i + (:u32)1;
        }
        return (:bool)0;
    }

    fn as_str(&self) -> str {
        return str::from_parts(self.data, (:u64)self.len);
    }
}

impl Clone for String {
    fn clone(&self) -> String {
        let mut this = String::new(self.cap);
        let size: i32 = sizeof$(i8);
        this.len = self.len;
        strcpy(this.data, self.data);
        return this;
    }
}
