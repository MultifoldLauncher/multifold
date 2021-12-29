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
import 'package:multifold_core/core.dart';
import 'package:multifold_core/src/instance/instance.dart';
import 'package:path/path.dart' as p;

class DummySessionData extends SessionData {
  @override
  String get username => "Player";

  @override
  String get id => "1db6a87e-47fb-47fe-8617-a19c2fd44d75";

  @override
  String get accessToken => "";
}

void main() async {
  final session = DummySessionData();
  final installation = MultiFoldInstallation.createDefault();
  await installation.init();

  final instance = MultiFoldInstance(
    path: p.join(getDataPath(), "instances", "test"),
    manifest: InstanceManifest(
      metadata: InstanceManifestMetadata(name: "test"),
      spec: InstanceManifestSpec(
        components: [
          ComponentDescriptor(id: "minecraft", version: "1.18.1"),
        ],
      ),
    ),
  );

  await installation.launcher.launch(instance, session);
}
