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

import 'package:json_annotation/json_annotation.dart';

part 'microsoft_model.g.dart';

@JsonSerializable()
class ErrorResponse implements Exception {
  final String error;

  @JsonKey(name: "error_description")
  final String errorDescription;

  @JsonKey(name: "error_codes")
  final List<int> errorCodes;

  final DateTime timestamp;

  @JsonKey(name: "trace_id")
  final String traceId;

  @JsonKey(name: "correlation_id")
  final String correlationId;

  @JsonKey(name: "error_uri")
  final Uri errorUri;

  ErrorResponse({
    required this.error,
    required this.errorDescription,
    required this.errorCodes,
    required this.timestamp,
    required this.traceId,
    required this.correlationId,
    required this.errorUri,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() => errorDescription;
}

@JsonSerializable()
class DeviceAuthorizationResponse {
  @JsonKey(name: "device_code")
  final String deviceCode;

  @JsonKey(name: "user_code")
  final String userCode;

  @JsonKey(name: "verification_uri")
  final Uri verificationUri;

  @JsonKey(name: "expires_in")
  final int expiresIn;

  @JsonKey(name: "interval")
  final int interval;

  final String message;

  DeviceAuthorizationResponse({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.expiresIn,
    required this.interval,
    required this.message,
  });

  factory DeviceAuthorizationResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceAuthorizationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceAuthorizationResponseToJson(this);
}

@JsonSerializable()
class DeviceTokenResponse {
  @JsonKey(name: "token_type")
  final String tokenType;

  @JsonKey(name: "scope")
  final String scope;

  @JsonKey(name: "expires_in")
  final int expiresIn;

  @JsonKey(name: "access_token")
  final String accessToken;

  @JsonKey(name: "refresh_token")
  final String refreshToken;

  DeviceTokenResponse({
    required this.tokenType,
    required this.scope,
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  factory DeviceTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceTokenResponseToJson(this);
}
