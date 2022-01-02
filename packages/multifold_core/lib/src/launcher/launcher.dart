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

import 'package:logger/logger.dart';
import 'package:multifold_api/api.dart';

final Logger _logger = getLogger('Launcher');

class MultiFoldLauncher implements Launcher {
  final Map<String, ComponentFactory> _components = {};
  final Installation _installation;

  MultiFoldLauncher(this._installation);

  @override
  void registerComponentFactory(ComponentFactory factory) {
    _components[factory.id] = factory;
  }

  @override
  Component createComponent(ComponentDescriptor manifest) {
    final factory = _components[manifest.id];
    if (factory == null) {
      // TODO: Localized exception??
      throw Exception("unknown component '${manifest.id}'");
    }

    return factory.create(manifest);
  }

  @override
  Future<void> launch(Instance instance, SessionData session) async {
    _logger.i('Launching instance ${instance.path}');
    final components = instance.manifest.spec.components
        .map((e) => createComponent(e))
        .toList();

    final environment = LaunchEnvironment();
    final context = LaunchContext(
      installation: _installation,
      instance: instance,
      components: components,
      session: session,
      environment: environment,
    );

    // TODO: Parallel processing
    for (var component in components) {
      _logger.i('Processing component ${component.name}');
      await component.execute(context);
    }

    await Directory(instance.path).create(recursive: true);

    final separator = Platform.isWindows ? ";" : ":";
    final arguments = [
      "-cp",
      environment.classpath.join(separator),
      environment.entryPoint,
      ...environment.launchArguments
    ];

    _logger.i('Launching ${instance.path}');
    _logger.d('Executing: ${environment.command} ${arguments.join(' ')}');

    // ignore: unused_local_variable
    final process = await Process.start(
      environment.command,
      arguments,
      workingDirectory: instance.path,
      mode: ProcessStartMode.inheritStdio,
    );
  }
}
