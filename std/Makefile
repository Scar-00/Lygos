CC = clang
AR = ar -rcs

SRC = $(wildcard *.c)
OBJ = $(SRC:.c=.o)

build: $(OBJ)
	$(AR) libstd.a $^

%.o: %.c
	$(CC) -o $@ -c $<
