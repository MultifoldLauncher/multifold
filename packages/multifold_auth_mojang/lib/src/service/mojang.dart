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

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multifold_api/api.dart';

import 'mojang_model.dart';

class MojangAuthenticationService {
  static final _authenticateEndpoint =
      Uri.parse("https://authserver.mojang.com/authenticate");
  static final _refreshEndpoint =
      Uri.parse("https://authserver.mojang.com/refresh");
  static final _validateEndpoint =
      Uri.parse("https://authserver.mojang.com/validate");
  static final _invalidateEndpoint =
      Uri.parse("https://authserver.mojang.com/invalidate");

  final http.Client _client;

  MojangAuthenticationService(this._client);

  Future<MojangAuthenticationResponse> authenticate(
    String username,
    String password,
  ) async {
    final payload = {
      "agent": {
        "name": "Minecraft",
        "version": 1,
      },
      "username": username,
      "password": password,
      "requestUser": true
    };

    final res = await _client.post(
      _authenticateEndpoint,
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
        "user-agent": Constants.userAgent,
      },
      body: jsonEncode(payload),
    );

    if (res.statusCode > 399) {
      throw MojangErrorResponse.fromJson(jsonDecode(res.body));
    }

    return MojangAuthenticationResponse.fromJson(jsonDecode(res.body));
  }

  Future<MojangAuthenticationResponse> refresh(
    String accessToken,
    String clientToken,
    String id,
    String name,
  ) async {
    final payload = {
      "accessToken": accessToken,
      "clientToken": clientToken,
      "selectedProfile": {
        "id": id,
        "name": name,
      },
      "requestUser": true,
    };

    final res = await _client.post(
      _refreshEndpoint,
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
        "user-agent": Constants.userAgent,
      },
      body: jsonEncode(payload),
    );

    if (res.statusCode > 399) {
      throw MojangErrorResponse.fromJson(jsonDecode(res.body));
    }

    return MojangAuthenticationResponse.fromJson(jsonDecode(res.body));
  }

  Future<bool> validate(
    String accessToken,
    String clientToken,
  ) async {
    final payload = {"accessToken": accessToken, "clientToken": clientToken};

    final res = await _client.post(
      _validateEndpoint,
      headers: {
        "content-type": "application/json",
        "user-agent": Constants.userAgent,
      },
      body: jsonEncode(payload),
    );

    if (res.statusCode > 399) {
      throw MojangErrorResponse.fromJson(jsonDecode(res.body));
    }

    return res.statusCode == 204;
  }

  Future<bool> invalidate(
    String accessToken,
    String clientToken,
  ) async {
    final payload = {"accessToken": accessToken, "clientToken": clientToken};

    final res = await _client.post(
      _invalidateEndpoint,
      headers: {
        "content-type": "application/json",
        "user-agent": Constants.userAgent,
      },
      body: jsonEncode(payload),
    );

    if (res.statusCode > 399) {
      throw MojangErrorResponse.fromJson(jsonDecode(res.body));
    }

    return res.statusCode == 204;
  }
}
