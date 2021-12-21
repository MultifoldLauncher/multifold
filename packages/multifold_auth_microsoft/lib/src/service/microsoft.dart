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

import 'microsoft_model.dart';

class PublicClientApplication {
  final http.Client _client;
  final String clientId;
  final String authority;

  PublicClientApplication(
    this._client, {
    this.clientId = "389b1b32-b5d5-43b2-bddc-84ce938d6737",
    this.authority = "https://login.microsoftonline.com/consumers",
  });

  // https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-device-code#device-authorization-request
  Future<DeviceAuthorizationResponse> authorizeDevice({
    List<String> scopes = const ["XboxLive.signin", "offline_access"],
  }) async {
    final uri = Uri.parse(authority + "/oauth2/v2.0/devicecode");

    final res = await _client.post(
      uri,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "client_id": clientId,
        "scope": scopes.join(" "),
      },
    );
    final json = jsonDecode(res.body);
    if (json["error"] != null) {
      throw ErrorResponse.fromJson(json);
    }

    return DeviceAuthorizationResponse.fromJson(json);
  }

  // https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-device-code#authenticating-the-user
  Future<DeviceTokenResponse> authenticateUser({
    required String deviceCode,
  }) async {
    final uri = Uri.parse(authority + "/oauth2/v2.0/token");

    final res = await _client.post(
      uri,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "grant_type": "urn:ietf:params:oauth:grant-type:device_code",
        "client_id": clientId,
        "device_code": deviceCode,
      },
    );
    final json = jsonDecode(res.body);
    if (json["error"] != null) {
      throw ErrorResponse.fromJson(json);
    }

    return DeviceTokenResponse.fromJson(json);
  }

  Future<DeviceTokenResponse> awaitAuthenticateUser({
    required String deviceCode,
    required int interval,
    required int timeout,
  }) async {
    final completer = Completer<DeviceTokenResponse>();

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
