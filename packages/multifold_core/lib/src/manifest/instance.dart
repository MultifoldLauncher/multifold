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

import 'manifest.dart';

/// https://github.com/MultifoldLauncher/rfcs/blob/master/specification/0001-multifold.instance.json.md
class InstanceManifest implements Manifest {
  @override
  int get version => 1;

  @override
  String get kind => "Instance";

  final InstanceManifestMetadata metadata;

  final InstanceManifestSpec spec;

  InstanceManifest({required this.metadata, required this.spec});

  factory InstanceManifest.from(Map<String, dynamic> data) {
    if (data["version"] != 1) {
      throw FormatException("Invalid manifest version");
    }

    if (data["kind"] != "Instance") {
      throw FormatException("Invalid manifest kind");
    }

    final Map<String, dynamic> metadata = data["metadata"];
    final Map<String, dynamic> spec = data["spec"];

    return InstanceManifest(
      metadata: InstanceManifestMetadata.from(metadata),
      spec: InstanceManifestSpec.from(spec),
    );
  }
}

class InstanceManifestMetadata {
  String name;
  String? group;

  InstanceManifestMetadata({required this.name, this.group});

  factory InstanceManifestMetadata.from(Map<String, dynamic> data) {
    return InstanceManifestMetadata(
      name: data["name"],
      group: data["group"],
    );
  }
}

class InstanceManifestSpec {
  final List<InstanceManifestComponent> components;

  InstanceManifestSpec({
    this.components = const [],
  });

  factory InstanceManifestSpec.from(Map<String, dynamic> data) {
    final List<Map<String, dynamic>> components = data["components"];
    final mappedComponents =
        components.map((e) => InstanceManifestComponent.from(e)).toList();

    return InstanceManifestSpec(
      components: mappedComponents,
    );
  }
}

class InstanceManifestComponent {
  String id;
  final String version;
  final Map<String, dynamic>? settings;

  InstanceManifestComponent({
    required this.id,
    required this.version,
    this.settings,
  });

  factory InstanceManifestComponent.from(Map<String, dynamic> data) {
    return InstanceManifestComponent(
      id: data["id"],
      version: data["version"],
      settings: data["settings"],
    );
  }
}
