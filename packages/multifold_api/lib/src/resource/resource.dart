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

class Resource {
  final Uri uri;

  final String namespace;

  final ResourceIntegrity? integrity;

  final String? cacheKey;

  Resource({
    required this.uri,
    this.namespace = "default",
    this.integrity,
    this.cacheKey
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
