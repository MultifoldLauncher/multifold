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

import 'dart:io';

import 'package:multifold_api/api.dart';
import 'package:multifold_core/core.dart';
import 'package:path/path.dart' as p;
import "package:test/test.dart";

final _testUri1 = Uri.parse(
    "https://gist.github.com/Cubxity/9f0c3a27483811092a717655c05def35/raw/9ac66c97abe6011ef2048fcccae22a369e6f6397/multifold-test-resource.json");
final _testUri2 = Uri.parse(
    "https://gist.github.com/Cubxity/9f0c3a27483811092a717655c05def35/raw/e66691f6d14c644d8c70b0451590f4e737754a4f/multifold-test-resource.json");

void main() {
  test("get resource", () async {
    final manager = await _createResourceManager();
    final resource = Resource(uri: _testUri1);
    final result = await manager.get(resource);

    expect(result.cached, isFalse);
    expect(await result.file.exists(), isTrue);
  });

  test("get offline resource", () async {
    final manager = await _createResourceManager();
    final resource = Resource(
      uri: Uri.parse("https://this.url.should.not.exist.multifold.app"),
    );

    await expectLater(manager.get(resource), throwsA(isA<Exception>()));
  });

  test("get resource with sha512 integrity", () async {
    final manager = await _createResourceManager();
    final resource = Resource(
      uri: _testUri1,
      integrity: ResourceIntegrity(
        sha512:
            "b284f5d12b6201c64c163d503d1942a9ea4b51cb211a4b7dafea9ceee46099b8016b9cb5792b04a79e03850628494b1a76c2d3b74609262a1b2191473a069508",
      ),
    );
    final result = await manager.get(resource);

    expect(result.cached, isFalse);
    expect(await result.file.exists(), isTrue);
  });

  test("get resource with sha256 integrity", () async {
    final manager = await _createResourceManager();
    final resource = Resource(
      uri: _testUri1,
      integrity: ResourceIntegrity(
        sha256:
            "9a6be8db4495acf5ab4971355b1cf57f47c97355f13528670f2e30bd06bfb98e",
      ),
    );
    final result = await manager.get(resource);

    expect(result.cached, isFalse);
    expect(await result.file.exists(), isTrue);
  });

  test("get resource with sha1 integrity", () async {
    final manager = await _createResourceManager();
    final resource = Resource(
      uri: _testUri1,
      integrity: ResourceIntegrity(
        sha1: "bfc92e67325096fdb057b13842373750b4ea4d3a",
      ),
    );
    final result = await manager.get(resource);

    expect(result.cached, isFalse);
    expect(await result.file.exists(), isTrue);
  });

  test("get resource with md5", () async {
    final manager = await _createResourceManager();
    final resource = Resource(
      uri: _testUri1,
      integrity: ResourceIntegrity(
        md5: "30b6dc310a78e54c9abd8f278103624d",
      ),
    );
    final result = await manager.get(resource);

    expect(result.cached, isFalse);
    expect(await result.file.exists(), isTrue);
  });

  test("get cached resource", () async {
    final manager = await _createResourceManager();
    final resource = Resource(uri: _testUri1);

    final result1 = await manager.get(resource);
    expect(result1.cached, isFalse);

    final lastModified = await result1.file.lastModified();

    final result2 = await manager.get(resource);
    expect(result2.cached, isTrue);
    expect(await result2.file.lastModified(), equals(lastModified));
  });

  test("get resource with cacheKey", () async {
    final manager = await _createResourceManager();
    final resource = Resource(
      uri: _testUri1,
      cacheKey: "btwiusearch.json",
    );

    final result = await manager.get(resource);

    expect(await result.file.exists(), isTrue);
    expect(p.basename(result.file.path), equals("btwiusearch.json"));
  });

  test("get volatile resource with cacheKey", () async {
    final manager = await _createResourceManager();
    final resource1 = Resource(
      uri: _testUri1,
      cacheKey: "btwiusearch.json",
    );
    final resource2 = Resource(
      uri: _testUri2,
      cacheKey: "btwiusearch.json",
    );

    final result1 = await manager.get(resource1);
    expect(result1.cached, isFalse);

    final lastModified = await result1.file.lastModified();

    // Make sure that there is a time difference
    sleep(const Duration(seconds: 2));

    final result2 = await manager.get(resource2, volatile: true);
    expect(result2.cached, false);
    expect(await result2.file.lastModified(), isNot(equals(lastModified)));
  });

  test("get offline cached volatile resource with cacheKey", () async {
    final manager = await _createResourceManager();
    final integrity = ResourceIntegrity(
      sha256:
          "9a6be8db4495acf5ab4971355b1cf57f47c97355f13528670f2e30bd06bfb98e",
    );
    final resource1 = Resource(
      uri: _testUri1,
      cacheKey: "btwiusearch.json",
      integrity: integrity,
    );
    final resource2 = Resource(
      uri: Uri.parse("https://this.url.should.not.exist.multifold.app"),
      cacheKey: "btwiusearch.json",
      integrity: integrity,
    );

    final result1 = await manager.get(resource1);
    expect(result1.cached, isFalse);

    final result2 = await manager.get(resource2, volatile: true);
    expect(result2.cached, isTrue);
    expect(result2.exception, isNotNull);
  });
}

Future<ResourceManager> _createResourceManager() async {
  final directory = await Directory.systemTemp.createTemp("multifold-");
  final manager = MultiFoldResourceManager(directory.path);

  await manager.init();

  return manager;
}
