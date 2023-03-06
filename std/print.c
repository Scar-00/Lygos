#include <stdarg.h>
#include <stdio.h>

int printf_ln(const char *format, ...) {
    va_list args;
    va_start(args, format);
    int res = vprintf(format, args);
    printf("\n");
    va_end(args);
    return res;
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
