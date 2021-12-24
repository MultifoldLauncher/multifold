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

class XboxAuthenticationService {
  static const _headers = {
    "cache-control": "no-store, must-revalidate, no-cache",
    "pragma": "no-cache",
    "x-xbl-contract-version": "2",
  };

  static final _userAuthenticateEndpoint =
      Uri.parse("https://workers.multifold.app/proxy/xbl/user/authenticate");

  final http.Client _client;

  XboxAuthenticationService(this._client);

  Future<void> authenticateUser({
    required String accessToken,
  }) async {
    final payload = {
      "RelyingParty": "http://auth.xboxlive.com",
      "TokenType": "JWT",
      "Properties": {
        "AuthMethod": "RPS",
        "SiteName": "user.auth.xboxlive.com",
        "RpsTicket": "t=$accessToken"
      }
    };

    final res = await _client.post(
      _userAuthenticateEndpoint,
      headers: {
        ..._headers,
        "accept": "application/json",
        "content-type": "application/json",
        "user-agent": Constants.userAgent
      },
      body: jsonEncode(payload),
    );

    print(res.statusCode);
    print(res.headers);
    print(res.body);
  }
}
