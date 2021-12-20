/*
 *     Multifold: the next-generation Minecraft launcher.
 *     Copyright (C) 2021  Cubxity
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:path/path.dart' as p;

import 'package:multifold_api/api.dart';

final RegExp _namespaceRegex = RegExp(r'^[0-9a-zA-Z_-]+$');
const String _userAgent = "Mozilla/5.0 Multifold Launcher";

class MutlifoldResourceManager implements ResourceManager {
  final RetryClient _client = RetryClient(http.Client());
  final String _path;

  MutlifoldResourceManager(this._path);

  @override
  Future<void> init() async {
    await Directory(this._path).create();
  }

  @override
  Future<ResourceResult> get(Resource resource, {bool volatile = false}) async {
    assert(_namespaceRegex.hasMatch(resource.namespace));

    final cacheKey = resource.cacheKey ?? _computeCacheKey(resource);
    final path = p.join(this._path, resource.namespace, cacheKey);

    final file = File(path);
    final exists = await file.exists();

    if (!volatile && exists) {
      // If the resource is not volatile and the file exists
      final integrity = resource.integrity;
      if (integrity == null || await _verifyIntegrity(file, integrity)) {
        // Cache hit
        return ResourceResult(file: file, cached: true);
      } else {
        // Integrity check failed, re-download
        await _download(resource.uri, file);
      }
    } else {
      // If the resource is volatile or the file does not exist
      await file.parent.create(recursive: true);
      try {
        await _download(resource.uri, file);
      } catch (e) {
        // Re-throw of the file does not exist
        if (!exists) throw e;

        final integrity = resource.integrity;
        if (integrity == null || await _verifyIntegrity(file, integrity)) {
          return ResourceResult(
            file: file,
            cached: true,
            exception: e as Exception,
          );
        } else {
          throw Exception("integrity check failed");
        }
      }
    }

    final integrity = resource.integrity;
    if (integrity == null || await _verifyIntegrity(file, integrity)) {
      // Cache miss
      return ResourceResult(file: file, cached: false);
    }

    // Probably hacked??
    throw Exception("integrity check failed");
  }

  Future<bool> _verifyIntegrity(File file, ResourceIntegrity integrity) async {
    var digest = integrity.sha512;
    if (digest != null) {
      return await _checkDigest(file, sha512, digest);
    }

    digest = integrity.sha256;
    if (digest != null) {
      return await _checkDigest(file, sha256, digest);
    }

    // ignore: deprecated_member_use
    digest = integrity.sha1;
    if (digest != null) {
      return await _checkDigest(file, sha1, digest);
    }

    // ignore: deprecated_member_use
    digest = integrity.md5;
    if (digest != null) {
      return await _checkDigest(file, md5, digest);
    }

    // No integrity to be checked
    return true;
  }

  Future<bool> _checkDigest(File file, Hash hash, String digest) async {
    final output = AccumulatorSink<Digest>();
    final input = hash.startChunkedConversion(output);

    await for (final chunk in file.openRead()) {
      input.add(chunk);
    }
    input.close();

    return output.events.single.toString() == digest.toLowerCase();
  }

  Future<void> _download(Uri uri, File destination) async {
    final req = http.Request("GET", uri);
    req.headers["user-agent"] = _userAgent;

    final res = await _client.send(req);
    final sink = destination.openWrite();
    try {
      await sink.addStream(res.stream);
    } finally {
      await sink.flush();
      await sink.close();
    }
  }

  /// Compute cache key for [resource] using the URI's SHA-256
  String _computeCacheKey(Resource resource) {
    final uri = utf8.encode(resource.uri.toString());
    final digest = sha256.convert(uri).toString();

    return p.join(
      digest.substring(0, 2),
      digest.substring(2, 4),
      digest.substring(4),
    );
  }

  void close() {
    _client.close();
  }
}
