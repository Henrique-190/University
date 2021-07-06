cmake_minimum_required(VERSION 3.15)
project(Array3 C)

set(CMAKE_C_STANDARD 99)

add_executable(Array3 main.c library.c library.h)