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

class LaunchContext {
  final Installation installation;
  final Instance instance;
  final List<Component> components;
  final SessionData session;
  final LaunchEnvironment environment;

  LaunchContext({
    required this.installation,
    required this.instance,
    required this.components,
    required this.session,
    required this.environment,
  });
}

class LaunchEnvironment {
  /// The command to launch with. This is usually the fully-qualified path for
  /// java executable. E.g. /usr/bin/java.
  String command = "java";

  /// The main class to launch. This is usually Minecraft's main class name or
  /// a wrapper class in a mod loader. E.g. net.minecraft.client.Main.
  late String entryPoint;

  /// Additional classpath entries to be added to the JVM argument.
  List<String> classpath = [];

  /// Launch arguments to pass to Minecraft.
  List<String> launchArguments = [];

  /// Additional JVM arguments to pass to the JVM.
  List<String> jvmArguments = [];

  /// Native library directory
  String nativeLibDir =
      Directory.systemTemp.createTempSync("multifold-natives-").path;
}
