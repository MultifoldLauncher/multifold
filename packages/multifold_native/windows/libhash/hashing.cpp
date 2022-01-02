#include <hashing.h>
#include <windows.h>
#include <wincrypt.h>
#include <stdexcept>

class Hash {
public:
    virtual ~Hash() = default;

    virtual void update(const void *data, size_t length) = 0;

    virtual Buffer finish() = 0;
};

class Win32Hash : public Hash {
public:
    Win32Hash(ALG_ID algorithm, size_t length, DWORD provider_type = PROV_RSA_AES) : buffer_len(length) {
        if (!CryptAcquireContext(&provider, nullptr, nullptr, provider_type, 0)) {
            throw std::runtime_error("failed to create provider");
        }

        if (!CryptCreateHash(provider, algorithm, 0, 0, &hash)) {
            throw std::runtime_error("failed to create hash");
        }

        buffer = new BYTE[length];
    }

    ~Win32Hash() override {
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

extern "C" void *create_hash(hash_type type) {
    try {
        switch (type) {
            case hash_type::SHA1: return new Win32Hash(CALG_SHA1, 20);
            case hash_type::SHA256: return new Win32Hash(CALG_SHA_256, 32);
            case hash_type::MD5: return new Win32Hash(CALG_MD5, 16);
            default:
                return nullptr;
        }
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

extern "C" void free_hash(void *hash) {
    delete ((Hash *) hash);
}

extern "C" Buffer finish_hash(void *hash) {
    return ((Hash *) hash)->finish();
}