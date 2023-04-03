CC = clang++
#CC = cl

CFLAGS = -std=c++20 -O0 -g -Wall -Wextra -Wpedantic -Wstrict-aliasing -Wno-newline-eof -Wno-deprecated-declarations -Wno-unused-parameter
CFLAGS += -I../D/LLVM

#LDFLAGS = -lrt -ldl -lpthread -lm -ltinfo
#LDFLAGS += `llvm-config -lib All Analysis Core ExecutionEngine InstCombine Object OrcJIT RuntimeDyld ScalarOpts Support native finfo`
LDFLAGS += `llvm-config --cxxflags --ldflags --libs all`
LDFLAGS += -lrt
LDFLAGS += -ldl
LDFLAGS += -lm
LDFLAGS += -lz
#LDFLAGS += -lzstd.so
LDFLAGS += -ltinfo
LDFLAGS += -lxml2
LDFLAGS += /usr/lib/libzstd.so.1.5.2

SRC = $(wildcard src/**/**/*.cpp) $(wildcard src/**/*.cpp) $(wildcard src/*.cpp)
DATA = $(wildcard src/**/**/*.o.json) $(wildcard src/**/*.o.json) $(wildcard src/*.o.json)
OBJ = $(SRC:.cpp=.o)
STD = $(wildcard std/**/**/*.c) $(wildcard std/**/*.c) $(wildcard std/*.c)
STD_OBJ = $(SRC:.c=.o)

.PHONY: std

build: $(OBJ)
	$(CC) -o bin/lygosc $^ $(LDFLAGS)

run: build
	bin/lygosc test3.txt -o tmp/test3.o -e llvm-ir

data: build
	sed -e '1 s/./[ '\\\n'{/' -e '$$ s/,$$/'\\\n'] /' $(DATA) > compile_commands.json

std:
	make -C ./std build

lib: $(OBJ)
	$(AR) test.lib $^ $(LDFLAGS)

%.o: %.cpp
	$(CC) -o $@ -c $< -MJ $@.json $(CFLAGS)

clean:
	rm -rf $(OBJ) bin/lygosc
