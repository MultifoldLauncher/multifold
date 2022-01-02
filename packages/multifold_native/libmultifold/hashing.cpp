#include <hashing.h>
#ifdef _WIN32
#include <windows.h>
#include <wincrypt.h>
#else
#include <openssl/sha.h>
#include <openssl/md5.h>
#endif
#include <stdexcept>

class Hash {
public:
    virtual ~Hash() = default;

    virtual void update(const void *data, size_t length) = 0;

    virtual Buffer finish() = 0;
};

#ifdef _WIN32
class OSHash : public Hash {
public:
    explicit OSHash(hash_type type) {
        ALG_ID algorithm;
        size_t length;
        DWORD provider_type = PROV_RSA_AES;

        switch (type) {
            case hash_type::SHA1:
                algorithm = CALG_SHA1;
                length = 20;
                break;
            case hash_type::SHA256:
                algorithm = CALG_SHA_256;
                length = 32;
                break;
            case hash_type::MD5:
                algorithm = CALG_MD5;
                length = 16;
                break;
        }

        buffer_len = length;

        if (!CryptAcquireContext(&provider, nullptr, nullptr, provider_type, 0)) {
            throw std::runtime_error("failed to create provider");
        }

        if (!CryptCreateHash(provider, algorithm, 0, 0, &hash)) {
            throw std::runtime_error("failed to create hash");
        }

        buffer = new BYTE[length];
    }

    ~OSHash() override {
        CryptDestroyHash(hash);
        CryptReleaseContext(provider, 0);
        delete[] buffer;
    }

    void update(const void *data, size_t length) override {
        if (!CryptHashData(hash, (const BYTE *) data, length, 0)) {
            throw std::runtime_error("failed to update hash");
        }
    }

    Buffer finish() override {
        DWORD actual_len = buffer_len;
        if (!CryptGetHashParam(hash, HP_HASHVAL, buffer, &actual_len, 0)) {
            return { 0, nullptr };
        }
        return { actual_len, buffer };
    }

private:
    HCRYPTPROV provider = 0;
    HCRYPTHASH hash = 0;
    BYTE *buffer;
    size_t buffer_len;
};
#else
class OSHash : public Hash {
public:
    explicit OSHash(hash_type type) : context({}), type(type) {
        switch (type) {
            case hash_type::SHA1:
                buf_len = SHA_DIGEST_LENGTH;
                if (!SHA1_Init(&context.sha1)) error();
                break;
            case hash_type::SHA256:
                buf_len = SHA256_DIGEST_LENGTH;
                if (!SHA256_Init(&context.sha256)) error();
                break;
            case hash_type::MD5:
                buf_len = MD5_DIGEST_LENGTH;
                if (!MD5_Init(&context.md5)) error();
                break;
        }
        buffer = new uint8_t[buf_len];
    }

    ~OSHash() override {
        delete[] buffer;
    }

    void update(const void *data, size_t length) override {
        switch (type) {
            case hash_type::SHA1:
                if (!SHA1_Update(&context.sha1, data, length)) error();
                break;
            case hash_type::SHA256:
                if (!SHA256_Update(&context.sha256, data, length)) error();
                break;
            case hash_type::MD5:
                if (!MD5_Update(&context.md5, data, length)) error();
                break;
        }
    }

    Buffer finish() override {
        switch (type) {
            case hash_type::SHA1:
                if (!SHA1_Final(buffer, &context.sha1)) error();
                break;
            case hash_type::SHA256:
                if (!SHA256_Final(buffer, &context.sha256)) error();
                break;
            case hash_type::MD5:
                if (!MD5_Final(buffer, &context.md5)) error();
                break;
        }
        return { buf_len, buffer };
    }
private:
    static inline void error() {
        throw std::runtime_error("failed to hash");
    }

    union {
        SHA_CTX sha1;
        SHA256_CTX sha256;
        MD5_CTX md5;
    } context;
    hash_type type;
    uint8_t *buffer;
    size_t buf_len;
};
#endif

extern "C" void *create_hash(hash_type type) {
    try {
        return new OSHash(type);
    } catch (std::runtime_error &) {
        return nullptr;
    }
}

extern "C" bool update_hash(void *hash, const void *data, size_t length) {
    try {
        ((Hash *) hash)->update(data, length);
        return true;
    } catch (std::runtime_error &) {
        return false;
    }
}

extern "C" MULTIFOLD_EXPORT bool update_hash_file(void *hash, const char *path) {
    FILE *f = fopen(path, "rb");
    if (!f) {
        return false;
    }

    uint8_t buffer[MULTIFOLD_HASH_FILE_BUFFER_SIZE];
    while (true) {
        size_t bytes_read = fread(buffer, sizeof(uint8_t), MULTIFOLD_HASH_FILE_BUFFER_SIZE, f);
        if (bytes_read == 0) break;
        if (!update_hash(hash, buffer, bytes_read)) {
            fclose(f);
            return false;
        }
    }

    fclose(f);
    return true;
}

extern "C" void free_hash(void *hash) {
    delete ((Hash *) hash);
}

extern "C" Buffer finish_hash(void *hash) {
    return ((Hash *) hash)->finish();
}