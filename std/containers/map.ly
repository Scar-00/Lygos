#include "../ffi/libc.ly"
#include "../core/types.ly"
#include "../string.ly"

macro StringMap {
    (name: $, typ: $) -> {
        struct StringMapNode##$name {
            key: String;
            value: $typ;
            next: *i8;
        };

        impl StringMapNode##$name {
            fn new(key: String, value: $typ) -> *Self {
                let this = (:*Self)malloc(sizeof$(StringMapNode##$name));
                this->key = key;
                this->value = value;
                this->next = (:*i8)0;
                return this;
            }

            fn set_next(&self, node: *Self) {
                self.next = (:*i8)node;
            }

            fn get_next(&self) -> *Self {
                return (:*Self)self.next;
            }
        }

        struct StringMap##$name {
            seed: size_t;
            table: **StringMapNode##$name;
            size: size_t;
        };

        impl StringMap##$name {
            fn new(size: size_t) -> Self {
                let this: Self = ${
                    .seed = (:u64)16446456,
                    .table = (:**StringMapNode##$name)malloc(size * sizeof$(*StringMapNode##$name)),
                    .size = size,
                };
                memset((:*i8)this.table, 0, this.size * sizeof$(*StringMapNode##$name));
                return this;
            }

            fn insert_helper(&mut self, hash_value: size_t, prev: *StringMapNode##$name, entry: *StringMapNode##$name) {
                if prev == (:*StringMapNode##$name)0 {
                    self.table[hash_value] = entry;
                }else {
                    prev->set_next(entry);
                }
            }

            fn is_valid_entry(entry: *StringMapNode##$name, key: String) -> bool {
                if entry == (:*StringMapNode##$name)0 {
                    return false;
                }
                return entry->key.eq(key) == false;
            }

            fn insert(&mut self, key: String, value: $typ) {
                let hash_value = key.as_str().hash() % self.size;
                let prev = (:*StringMapNode##$name)0;
                let entry = self.table[hash_value];

                for let i = 0 in StringMap##$name::is_valid_entry(entry, key) {
                    prev = entry;
                    entry = entry->get_next();
                }

                if entry == (:*StringMapNode##$name)0 {
                    entry = StringMapNode##$name::new(key, value);
                    self.insert_helper(hash_value, prev, entry);
                }else {
                    entry->value = value;
                }
            }

            fn get(&self, key: String) -> &$typ {
                let hash_value = key.as_str().hash() % self.size;
                let entry = self.table[hash_value];

                for let i = 0 in StringMap##$name::is_valid_entry(entry, key) {
                    entry = entry->get_next();
                }

                if entry == (:*StringMapNode##$name)0 {
                    return (:*$typ)0;
                }
                return &entry->value;
            }

            fn contains(&self, key: String) -> bool {
                let hash_value = key.as_str().hash() % self.size;
                let entry = self.table[hash_value];

                for let i = 0 in StringMap##$name::is_valid_entry(entry, key) {
                    entry = entry->get_next();
                }

                if entry == (:*StringMapNode##$name)0 {
                    return (:bool)0;
                }
                return (:bool)1;
            }
        }
    }
}
