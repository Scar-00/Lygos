#include <stdarg.h>
#include <stdio.h>

char buffer[1024];

char *_format(const char *format, ...) {
    va_list args;
    va_start(args, format);
    vsnprintf(buffer, 1024, format, args);
    va_end(args);
    return buffer;
}

int print_int(int val) {
    return printf("%d\n", val);
}

int read_char() {
    return fgetc(stdin);
}

void print_deref(int *ptr) {
    printf("%d\n", *ptr);
}
