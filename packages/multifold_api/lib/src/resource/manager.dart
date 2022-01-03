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

import 'resource.dart';

/// Responsible for managing resources in an installation,
/// this includes libraries, mods, and more.
abstract class ResourceManager {
  /// Initializes the resource manager.
  Future<void> init();

  /// Retrieve a resource
  Future<ResourceResult> get(Resource resource, {bool volatile = false});

  String getPath({String namespace = "default", String? cacheKey});

  Future<String> fetch(
    Uri uri, {
    String namespace = "default",
    String? cacheKey,
    ResourceIntegrity? integrity,
  });

  Future<T> fetchJSON<T extends dynamic>(
    Uri uri, {
    String namespace = "default",
    String? cacheKey,
    ResourceIntegrity? integrity,
  });

  void close();
}

class ResourceResult {
  final File file;
  final bool cached;
  final Exception? exception;

  ResourceResult({
    required this.file,
    required this.cached,
    this.exception,
  });
}
