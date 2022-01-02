cmake_minimum_required(VERSION 3.14)
project(libmultifold)

add_library(multifold SHARED hashing.cpp)
target_include_directories(multifold PUBLIC include)

if (UNIX)
    find_package(OpenSSL REQUIRED)
    target_link_libraries(multifold OpenSSL::Crypto)
endif ()

target_compile_definitions(multifold PRIVATE MULTIFOLD_HASH_FILE_BUFFER_SIZE=16384)