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

import 'package:multifold_api/api.dart';

abstract class ComponentFactory {
  String get id;

  Component create(ComponentDescriptor descriptor);
}

abstract class Component {
  String get name;

  Future<void> execute(LaunchContext context);
}

class ComponentDescriptor {
  final String id;
  final String? version;
  final Map<String, dynamic>? settings;

  ComponentDescriptor({
    required this.id,
    this.version,
    this.settings,
  });
}
