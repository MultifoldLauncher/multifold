#pragma once
#include <cstddef>
#include <string>

enum class hash_type {
    SHA1 = 0,
    SHA256 = 1,
    MD5 = 2
};

struct Buffer {
    size_t length;
    const uint8_t *data;
};

extern "C" __declspec(dllexport) void *create_hash(hash_type type);

extern "C" __declspec(dllexport) bool update_hash(void *hash, const void *data, size_t length);

extern "C" __declspec(dllexport) Buffer finish_hash(void *hash);

extern "C" __declspec(dllexport) void free_hash(void *hash);