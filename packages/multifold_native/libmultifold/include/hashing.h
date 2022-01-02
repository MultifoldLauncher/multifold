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

#ifdef _MSC_VER
#define MULTIFOLD_EXPORT __declspec(dllexport)
#else
#define MULTIFOLD_EXPORT
#endif

extern "C" MULTIFOLD_EXPORT void *create_hash(hash_type type);

extern "C" MULTIFOLD_EXPORT bool update_hash(void *hash, const void *data, size_t length);

extern "C" MULTIFOLD_EXPORT bool update_hash_file(void *hash, const char *path);

extern "C" MULTIFOLD_EXPORT Buffer finish_hash(void *hash);

extern "C" MULTIFOLD_EXPORT void free_hash(void *hash);