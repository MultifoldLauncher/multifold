#include "include/multifold_native/multifold_native_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>
#include <cstdint>

#include <hashing.h>

namespace {

    class MultifoldNativePlugin : public flutter::Plugin {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

        MultifoldNativePlugin();

        virtual ~MultifoldNativePlugin();

    private:
        // Called when a method is called on this plugin's channel from Dart.
        void HandleMethodCall(
                const flutter::MethodCall<flutter::EncodableValue> &method_call,
                std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    };

// static
    void MultifoldNativePlugin::RegisterWithRegistrar(
            flutter::PluginRegistrarWindows *registrar) {
        auto channel =
                std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
                        registrar->messenger(), "multifold_native",
                        &flutter::StandardMethodCodec::GetInstance());

        auto plugin = std::make_unique<MultifoldNativePlugin>();

        channel->SetMethodCallHandler(
                [plugin_pointer = plugin.get()](const auto &call, auto result) {
                    plugin_pointer->HandleMethodCall(call, std::move(result));
                });

        registrar->AddPlugin(std::move(plugin));
    }

    MultifoldNativePlugin::MultifoldNativePlugin() {}

    MultifoldNativePlugin::~MultifoldNativePlugin() {}

    void MultifoldNativePlugin::HandleMethodCall(
            const flutter::MethodCall<flutter::EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());

        if (method_call.method_name() == "createHash") {
            auto type_it = arguments->find(flutter::EncodableValue("type"));
            if (type_it == arguments->end()) {
                result->NotImplemented();
                return;
            }
            auto type = (hash_type) type_it->second.LongValue();
            auto pointer = create_hash(type);
            printf("got pointer: %p\n", pointer);
            fflush(stdout);
            result->Success(flutter::EncodableValue((int64_t) pointer));
        } else if (method_call.method_name() == "updateHash") {
            auto hash_it = arguments->find(flutter::EncodableValue("hash"));
            auto data_it = arguments->find(flutter::EncodableValue("data"));
            if (hash_it == arguments->end() || data_it == arguments->end()) {
                result->NotImplemented();
                return;
            }

            auto hash = (void *) hash_it->second.LongValue();
            auto data = std::get<std::vector<uint8_t>>(data_it->second);

            auto return_value = update_hash(hash, data.data(), data.size());
            result->Success(flutter::EncodableValue(return_value));
        } else if (method_call.method_name() == "finalizeHash") {
            auto hash_it = arguments->find(flutter::EncodableValue("hash"));
            if (hash_it == arguments->end()) {
                result->NotImplemented();
                return;
            }

            auto hash = (void *) hash_it->second.LongValue();
            auto buffer = finish_hash(hash);
            result->Success(flutter::EncodableValue(std::vector<uint8_t>(buffer.data, buffer.data + buffer.length)));
        } else if (method_call.method_name() == "freeHash") {
            auto hash_it = arguments->find(flutter::EncodableValue("hash"));
            if (hash_it == arguments->end()) {
                result->NotImplemented();
                return;
            }

            auto hash = (void *) hash_it->second.LongValue();
            free_hash(hash);
            result->Success(flutter::EncodableValue(std::monostate()));
        } else {
            result->NotImplemented();
        }
    }

}  // namespace

void MultifoldNativePluginRegisterWithRegistrar(
        FlutterDesktopPluginRegistrarRef registrar) {
    MultifoldNativePlugin::RegisterWithRegistrar(
            flutter::PluginRegistrarManager::GetInstance()
                    ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
