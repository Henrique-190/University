cmake_minimum_required(VERSION 3.15)
project(desenhos C)

set(CMAKE_C_STANDARD 99)

add_executable(desenhos principal.c desenhos.c desenhos.h)
