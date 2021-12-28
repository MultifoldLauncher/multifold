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

import 'package:path/path.dart' as p;

String getDataPath() {
  switch (Platform.operatingSystem) {
    case "windows":
      final appData = Platform.environment["APPDATA"]!;
      return p.join(appData, "MultiFold");

    case "macos":
      final home = Platform.environment["HOME"]!;
      return p.join(home, "Library", "Application Support", "multifold");

    case "linux":
      final xdgDataHome = Platform.environment["XDG_DATA_HOME"];
      if (xdgDataHome != null) {
        return p.join(xdgDataHome, "multifold");
      }

      final home = Platform.environment["HOME"]!;
      return p.join(home, ".local", "share", "multifold");

    default:
      final home = Platform.environment["HOME"]!;
      return p.join(home, ".multifold");
  }
}
