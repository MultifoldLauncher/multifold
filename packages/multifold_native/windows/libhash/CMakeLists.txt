cmake_minimum_required(VERSION 3.14)

add_library(hash STATIC hashing.cpp)
target_include_directories(hash PUBLIC include)

add_executable(hashing_test test.cpp)
target_link_libraries(hashing_test hash)