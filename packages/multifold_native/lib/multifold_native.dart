import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

enum HashType { sha1, sha256, md5 }

class MultifoldNative {
  static const MethodChannel _channel = MethodChannel('multifold_native');

  static Future<int?> createHash(HashType type) async =>
      await _channel.invokeMethod('createHash', <String, dynamic>{
        'type': type.index,
      });

  static Future<bool?> updateHash(int hash, Uint8List data) async =>
      await _channel.invokeMethod('updateHash', <String, dynamic>{
        'hash': hash,
        'data': data,
      });

  static Future<Uint8List?> finalizeHash(int hash) async =>
      await _channel.invokeMethod('finalizeHash', <String, dynamic>{
        'hash': hash,
      });

  static Future<void> freeHash(int hash) async =>
      await _channel.invokeMethod('freeHash', <String, dynamic>{
        'hash': hash,
      });

  static Future<String?> hash(HashType type, Uint8List data) async {
    final pointer = await createHash(type);
    if (pointer == null || pointer == 0) return null;

    await updateHash(pointer, data);
    final finalized = await finalizeHash(pointer);
    final hash = finalized?.map((e) => e.toRadixString(16)).join();

    await freeHash(pointer);
    return hash;
  }
}
