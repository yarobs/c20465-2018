cmake_minimum_required(VERSION 3.12)
project(x4asm C)

set(CMAKE_C_STANDARD 90)

add_executable(x4asm src/main.c src/assembler.h src/assembler.c src/label.c src/label.h src/x4asm.h src/x4asm.c src/parser.h src/parser.c src/x4encode.h src/x4encode.c src/data.h src/data.c)