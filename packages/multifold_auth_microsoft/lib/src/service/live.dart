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

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multifold_api/api.dart';

import 'microsoft_model.dart';

class LiveAuthenticationService {
  static final _connectEndpoint =
      Uri.parse("https://login.live.com/oauth20_connect.srf");
  static final _tokenEndpoint =
      Uri.parse("https://login.live.com/oauth20_token.srf");

  final http.Client _client;
  final String clientId;

  LiveAuthenticationService(
    this._client, {
    this.clientId = "00000000402b5328", // Minecraft java
  });

  Future<MSADeviceAuthorizationResponse> connect({
    List<String> scopes = const ["service::user.auth.xboxlive.com::MBI_SSL"],
  }) async {
    final res = await _client.post(
      _connectEndpoint,
      headers: {
        "content-type": "application/x-www-form-urlencoded",
        "user-agent": Constants.userAgent
      },
      body: {
        "client_id": clientId,
        "scope": scopes.join(" "),
        "response_type": "device_code",
      },
    );

    print(res.body);
    final json = jsonDecode(res.body);
    if (json["error"] != null) {
      throw MSAErrorResponse.fromJson(json);
    }

    return MSADeviceAuthorizationResponse.fromJson(json);
  }

  Future<MSADeviceTokenResponse> authenticateUser({
    required String deviceCode,
  }) async {
    final res = await _client.post(
      _tokenEndpoint,
      headers: {
        "content-type": "application/x-www-form-urlencoded",
        "user-agent": Constants.userAgent
      },
      body: {
        "grant_type": "urn:ietf:params:oauth:grant-type:device_code",
        "client_id": clientId,
        "device_code": deviceCode,
      },
    );

    print(res.body);
    final json = jsonDecode(res.body);
    if (json["error"] != null) {
      throw MSAErrorResponse.fromJson(json);
    }

    return MSADeviceTokenResponse.fromJson(json);
  }

  Future<MSADeviceTokenResponse> awaitAuthenticateUser({
    required String deviceCode,
    required int interval,
    required int timeout,
  }) async {
    final completer = Completer<MSADeviceTokenResponse>();

    var elapsedSeconds = 0;
    Timer.periodic(Duration(seconds: interval), (timer) async {
      elapsedSeconds += interval;
      try {
        final res = await authenticateUser(deviceCode: deviceCode);
        completer.complete(res);
        timer.cancel();
      } catch (_) {
        // Ignore
      }
      if (elapsedSeconds >= timeout) {
        completer.completeError(TimeoutException(
            "timeout waiting for authentication", Duration(seconds: timeout)));
        timer.cancel();
      }
    });

    return completer.future;
  }
}
