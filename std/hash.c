#define STB_DS_IMPLEMENTATION
#include "stb_ds.h"

#include <time.h>

typedef struct StringInt {
    char *key;
    int value;
}StringInt;

void hash_init() {
    stbds_rand_seed(time(0));
}

void string_int_map_insert(StringInt *map, char *key, int value) {
    shput(map, key, value);
}

int string_int_map_get(StringInt *map, char *key) {
    return shget(map, key);
}

void string_int_map_delete(StringInt *map, char *key) {
    shdel(map, key);
}
