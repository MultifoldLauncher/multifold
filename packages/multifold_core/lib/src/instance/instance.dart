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

import 'package:multifold_api/api.dart';

class MultiFoldInstance implements Instance {
  @override
  final String path;

  @override
  final InstanceManifest manifest;

  MultiFoldInstance({
    required this.path,
    required this.manifest,
  });
}

class MultifoldInstanceManager extends InstanceManager {
  @override
  final String dir;

  @override
  List<Instance> instances = <Instance>[];

  MultifoldInstanceManager(this.dir);

  @override
  Future<void> setup() async {
    instances = await getInstances();
  }

  @override
  Future<List<Instance>> getInstances() async {
    final files = await Directory(dir).list().toList();
    final instances = <Instance>[];

    for (final instanceDir in files) {
      final manifestFile = File(instanceDir.path + '/instance.json');
      if (!await manifestFile.exists()) continue;

      final json = jsonDecode(await manifestFile.readAsString());
      final manifest = InstanceManifest.from(json);
      instances
          .add(MultiFoldInstance(path: instanceDir.path, manifest: manifest));
    }

    return instances;
  }

  @override
  Instance? getInstance(String name) {
    try {
      return instances.firstWhere(
          (i) => i.manifest.metadata.name.toLowerCase() == name.toLowerCase());
    } catch (e) {
      return null;
    }
  }
}
