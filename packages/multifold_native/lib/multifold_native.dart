import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

class Buffer extends Struct {
  @Int32()
  external int length;

  external Pointer<Uint8> data;
}

enum HashType { sha1, sha256, md5 }

typedef CreateHash = int Function(int);
typedef CreateHashFunc = Int64 Function(Int32);

typedef UpdateHash = bool Function(int, Pointer<Uint8>, int);
typedef UpdateHashFunc = Bool Function(Int64, Pointer<Uint8>, Int64);

typedef UpdateHashFile = bool Function(int, Pointer<Utf8>);
typedef UpdateHashFileFunc = Bool Function(Int64, Pointer<Utf8>);

typedef FinishHash = Buffer Function(int);
typedef FinishHashFunc = Buffer Function(Int64);

typedef FreeHash = int Function(int);
typedef FreeHashFunc = Int64 Function(Int64);

class MultifoldNative {
  static late final MultifoldNative instance = MultifoldNative._();

  static bool isSupported() {
    return Platform.isWindows || Platform.isLinux;
  }

  late final CreateHash _createHash;
  late final UpdateHash _updateHash;
  late final UpdateHashFile _updateHashFile;
  late final FinishHash _finishHash;
  late final FreeHash _freeHash;

  MultifoldNative._() {
    if (!isSupported()) {
      return;
    }

    final lib = DynamicLibrary.open(_getLibraryPath());
    _createHash =
        lib.lookup<NativeFunction<CreateHashFunc>>('create_hash').asFunction();
    _updateHash =
        lib.lookup<NativeFunction<UpdateHashFunc>>('update_hash').asFunction();
    _updateHashFile = lib
        .lookup<NativeFunction<UpdateHashFileFunc>>('update_hash_file')
        .asFunction();
    _finishHash =
        lib.lookup<NativeFunction<FinishHashFunc>>('finish_hash').asFunction();
    _freeHash =
        lib.lookup<NativeFunction<FreeHashFunc>>('free_hash').asFunction();
  }

  int createHash(HashType type) => _createHash(type.index);

  bool updateHash(int hash, Uint8List data) {
    final dataPtr = malloc.allocate<Uint8>(data.length);
    dataPtr.asTypedList(data.length).setAll(0, data);

    final result = _updateHash(hash, dataPtr, data.length);
    malloc.free(dataPtr);
    return result;
  }

  bool updateHashFile(int hash, String filePath) {
    final filePathPtr = filePath.toNativeUtf8();
    final result = _updateHashFile(hash, filePathPtr);
    malloc.free(filePathPtr);
    return result;
  }

  Uint8List finishHash(int hash) {
    final buffer = _finishHash(hash);
    final result = Uint8List(buffer.length);
    result.setAll(0, buffer.data.asTypedList(buffer.length));

    _freeHash(hash);
    return result;
  }

  String hash(Uint8List data, HashType type) {
    final hash = createHash(type);
    updateHash(hash, data);
    final result = finishHash(hash);
    return toHex(result);
  }

  static String _getLibraryPath() {
    if (isInDebugMode) {
      return Platform.script
          .resolve(
              "../../multifold_native/libmultifold/bin/${_getLibraryName()}")
          .toFilePath();
    } else {
      return Platform.script.resolve(_getLibraryName()).toFilePath();
    }
  }

  static String _getLibraryName() {
    if (Platform.isWindows) {
      return 'multifold-amd64.dll';
    } else if (Platform.isLinux) {
      return 'libmultifold.so';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String toHex(Uint8List data) {
    return data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}
