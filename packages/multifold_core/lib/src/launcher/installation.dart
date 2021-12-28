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
import 'package:multifold_component_minecraft/api.dart';
import 'package:path/path.dart' as p;

import '../resource/manager.dart';
import 'launcher.dart';

class MultiFoldInstallation implements Installation {
  @override
  final String path;

  @override
  late final ResourceManager resourceManager;

  @override
  late final Launcher launcher;

  MultiFoldInstallation(this.path) {
    resourceManager = MultiFoldResourceManager(p.join(path, "resources"));
    launcher = MultiFoldLauncher(this);
  }

  factory MultiFoldInstallation.createDefault() {
    final installation = MultiFoldInstallation(getDataPath());

    // Register defaults
    installation.launcher.registerComponentFactory(MinecraftComponentFactory());

    return installation;
  }

  @override
  Future<void> init() async {
    await new Directory(path).create(recursive: true);

    await Future.wait([
      resourceManager.init(),
      // other stuff in the future...
    ]);
  }

  void close() {
    resourceManager.close();
  }
}
