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

import 'package:path/path.dart' as p;

abstract class Resource {
  final ResourceIntegrity? integrity;

  final Uri? uri;

  bool get isDownloadable => uri != null;

  String get path;

  Resource({
    this.integrity,
    this.uri,
  });
}

/// Contains the checksums/digests for a [Resource].
/// If specified, the launcher shall verify the integrity before launching.
class ResourceIntegrity {
  final String? sha512;

  final String? sha256;

  @Deprecated("Insecure algorithm")
  final String? sha1;

  @Deprecated("Insecure algorithm")
  final String? md5;

  ResourceIntegrity({
    this.sha512,
    this.sha256,
    this.sha1,
    this.md5,
  });
}

class Artifact extends Resource {
  final String type;

  /// This is usually the package name of the artifact. For example:
  /// org.ow2.asm. For mods with no known package name, the group id
  /// is as follows: com.modrinth.mods.
  final String groupId;

  /// This is usually the name of the artifact. For example: asm. For mods
  /// with no known artifact id, it is usually the mod id. For example: sodium.
  final String artifactId;

  /// This is the version of the artifact. It is recommended to use semver.
  /// For example: 1.0.0-beta.
  final String version;

  /// The kind of the artifact. The default is jar.
  final String kind;

  /// This is usually unused, however, it is often used to classify native
  /// artifacts. For example: natives-linux.
  final String? classifier;

  @override
  String get path => p.joinAll([
        type,
        ...groupId.split("."),
        artifactId,
        version,
        classifier != null
            ? "${artifactId}-${version}-${classifier}.${kind}"
            : "${artifactId}-${version}.${kind}",
      ]);

  Artifact({
    required this.type,
    required this.groupId,
    required this.artifactId,
    required this.version,
    this.kind = "jar",
    this.classifier,
    ResourceIntegrity? integrity,
    Uri? uri,
  }) : super(integrity: integrity, uri: uri);
}

class FileResource extends Resource {
  final String type;

  /// The namespace this resource belongs to. This is used to organize
  /// resources. Example: minecraft.
  final String namespace;

  /// The relative path of the resource. Note that the path is not validated
  /// by the resource manager. Make sure to sanitize inputs before passing the
  /// values to this field.
  ///
  /// For example: objects/6b/6b1df47660958fcda052627411b6651f8a51da4d.
  final String name;

  @override
  String get path => p.joinAll([type, namespace, ...name.split("/")]);

  FileResource({
    required this.type,
    required this.namespace,
    required this.name,
    ResourceIntegrity? integrity,
    Uri? uri,
  }) : super(integrity: integrity, uri: uri);
}
