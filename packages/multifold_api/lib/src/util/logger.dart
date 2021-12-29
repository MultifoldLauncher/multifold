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

class SimpleLogPrinter extends LogPrinter {
  final String name;

  SimpleLogPrinter(this.name);

  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level] ?? AnsiColor.none();
    var emoji = PrettyPrinter.levelEmojis[event.level] ?? "";
    return [color('$emoji $name: ${event.message}')];
  }
}

Logger getLogger(String name) {
  final String levelName = Platform.environment['LOG_LEVEL'] ?? 'info';
  Logger.level = Level.values
      .firstWhere((l) => l.name == levelName, orElse: () => Level.info);
  return Logger(printer: SimpleLogPrinter(name));
}
