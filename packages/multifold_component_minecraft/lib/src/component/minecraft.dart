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

final Logger _logger = getLogger('MinecraftComponent');

class MinecraftComponent implements Component {
  @override
  String get name => "Minecraft";

  final String _version;

  MinecraftComponent({required String version}) : _version = version;

  @override
  Future<void> execute(LaunchContext context) async {
    final resourceManager = context.installation.resourceManager;

    _logger.i("downloading launcher manifest for version $_version");
    final launcherManifest = await _fetch(
      manager: resourceManager,
      uri: "https://launchermeta.mojang.com/mc/game/version_manifest.json",
      cacheKey: "manifests/version_manifest.json",
    );

    final versions = launcherManifest["versions"] as List<dynamic>;
    final version = versions.firstWhere((version) => version["id"] == _version);

    final Map<String, dynamic> manifest = await _fetch(
      manager: resourceManager,
      uri: version["url"],
      cacheKey: "versions/$_version/manifest.json",
    );

    final List<ResourceResult> resources = [];

    final time = DateTime.now();
    _logger.i("downloading client jar");
    final clientDownload = manifest["downloads"]["client"];
    final clientResource = _createResource(clientDownload,
        cacheKey: "versions/$_version/client.jar");

    resources.add(await resourceManager.get(clientResource));

    _logger.i("downloading libraries");
    final libraries = manifest["libraries"];

    for (var library in libraries) {
      if (_evaluateRules(library["rules"])) {
        final artifact = library["downloads"]["artifact"];
        final classifiers = library["downloads"]["classifiers"];

        if (classifiers != null) {
          final classifier = classifiers["natives-${Platform.operatingSystem}"];
          if (classifier != null) {
            final resource = _createResource(classifier);
            final result = await resourceManager.get(resource);
            extractZip(result.file, context.environment.nativeLibDir);
          }
        } else if (artifact != null) {
          final resource = _createResource(artifact);
          resources.add(await resourceManager.get(resource));
        }
      }
    }

    _logger.i("downloading assets");
    final assetIndex = manifest["assetIndex"];
    final Map<String, dynamic> assetIndexManifest = await _fetch(
      manager: resourceManager,
      uri: assetIndex["url"],
      cacheKey: "assets/indexes/${manifest["assets"]}.json",
    );

    final objectAssets = assetIndexManifest["objects"] as Map<String, dynamic>;
    final virtual = assetIndexManifest.containsKey("virtual") &&
        assetIndexManifest["virtual"];
    for (var key in objectAssets.keys) {
      final obj = objectAssets[key];
      final hash = obj["hash"] as String;
      final path = "${hash.substring(0, 2)}/$hash";

      final resource = Resource(
        uri: Uri.parse("https://resources.download.minecraft.net/$path"),
        integrity: ResourceIntegrity(sha1: hash),
        namespace: "minecraft",
        cacheKey: virtual
            ? "assets/virtual/${manifest["assets"]}/$key"
            : "assets/objects/$path",
      );
      await resourceManager.get(resource);
    }

    for (var resource in resources) {
      context.environment.classpath.add(resource.file.path);
    }

    // Print elapsed launch time
    _logger
        .i('completed in ${DateTime.now().difference(time).inMilliseconds}ms');

    if (manifest.containsKey("arguments")) {
      context.environment.launchArguments = _getArguments(
          manifest["arguments"]["game"],
          context: context,
          assetsIndexName: manifest["assets"]);
      context.environment.jvmArguments = _getArguments(
          manifest["arguments"]["jvm"],
          context: context,
          assetsIndexName: manifest["assets"]);
    } else {
      context.environment.jvmArguments = _getArguments([
        "-Djava.library.path=\${natives_directory}",
        "-Dminecraft.launcher.brand=\${launcher_name}",
        "-Dminecraft.launcher.version=\${launcher_version}",
        "-cp",
        "\${classpath}",
      ], context: context, assetsIndexName: manifest["assets"]);
      context.environment.launchArguments = _getArguments(
          (manifest["minecraftArguments"] as String).split(" "),
          context: context,
          assetsIndexName: manifest["assets"]);
    }

    context.environment.entryPoint = manifest["mainClass"];
  }

  List<String> _getArguments(List<dynamic> arguments,
      {required LaunchContext context, required String assetsIndexName}) {
    final List<String> args = [];

    for (var argument in arguments) {
      if (argument is String) {
        args.add(argument);
      } else if (argument is Map<String, dynamic>) {
        if (argument.containsKey("rules")) {
          if (!_evaluateRules(argument["rules"])) {
            continue;
          }
        }

        final value = argument["value"] is String
            ? [argument["value"]]
            : argument["value"];

        args.addAll(value);
      }
    }

    return args
        .map((arg) => _templateArgument(arg,
            context: context, assetsIndexName: assetsIndexName))
        .toList();
  }

  String _templateArgument(
    String argument, {
    required LaunchContext context,
    required String assetsIndexName,
  }) {
    if (!argument.contains("\$")) {
      return argument;
    }

    Map<String, String> variables = {
      // Game arguments
      "auth_player_name": context.session.username,
      "version_name": _version,
      "game_directory": context.instance.path,
      "assets_root": context.installation.resourceManager
          .getPath(namespace: "minecraft", cacheKey: "assets"),
      "game_assets": context.installation.resourceManager
          .getPath(namespace: "minecraft", cacheKey: "assets/virtual/legacy"),
      "assets_index_name": assetsIndexName,
      "auth_uuid": context.session.id,
      "auth_access_token": context.session.accessToken,
      "auth_session": context.session.accessToken,
      "version_type": "release", // TODO
      "user_properties": "{}",
      "user_type": "mojang",

      // JVM arguments
      "classpath": context.environment.classpath.join(Constants.separator),
      "launcher_name": "Multifold",
      "launcher_version": "1.0.0",
      "natives_directory": context.environment.nativeLibDir,
    };

    return argument.replaceAllMapped(RegExp(r"\${(\w+)}"), (match) {
      final content = variables[match.group(1)] ?? match.group(0) ?? "";
      return content.isEmpty ? "\"\"" : content;
    });
  }

  bool _evaluateRules(List<dynamic>? rules) {
    if (rules == null) {
      return true;
    }

    var action = false;
    for (var rule in rules) {
      final os = rule["os"];
      final features = rule["features"];
      if (os != null) {
        if (os == _mapOSName()) {
          action = rule["action"] == "allow";
        }
      } else if (features != null) {
        // TODO
      } else {
        action = rule["action"] == "allow";
      }
    }

    return action;
  }

  String _mapOSName() {
    final os = Platform.operatingSystem;
    if (os == "macos") {
      return "osx";
    }

    return os;
  }

  Resource _createResource(Map<String, dynamic> json, {String? cacheKey}) {
    final path = json["path"];
    if (path != null) {
      cacheKey = "libraries/$path";
    }

    return Resource(
      uri: Uri.parse(json["url"]),
      namespace: "minecraft",
      cacheKey: cacheKey,
      integrity: ResourceIntegrity(sha1: json["sha1"]),
    );
  }

  Future<T> _fetch<T extends dynamic>({
    required ResourceManager manager,
    required String uri,
    required String cacheKey,
  }) {
    final actualUri = Uri.parse(uri);

    return manager.fetchJSON(
      actualUri,
      namespace: "minecraft",
      cacheKey: cacheKey,
    );
  }
}

class MinecraftComponentFactory implements ComponentFactory {
  @override
  String get id => "minecraft";

  @override
  Component create(ComponentDescriptor descriptor) {
    final version = descriptor.version;
    if (version == null) {
      throw Exception("version must not be null");
    }

    return MinecraftComponent(version: version);
  }
}
