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
class MSAErrorResponse implements Exception {
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

  MSAErrorResponse({
    required this.error,
    required this.errorDescription,
    required this.errorCodes,
    required this.timestamp,
    required this.traceId,
    required this.correlationId,
    required this.errorUri,
  });

  factory MSAErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$MSAErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MSAErrorResponseToJson(this);

  @override
  String toString() => errorDescription;
}

@JsonSerializable()
class MSADeviceAuthorizationResponse {
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

  final String? message;

  MSADeviceAuthorizationResponse({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.expiresIn,
    required this.interval,
    this.message,
  });

  factory MSADeviceAuthorizationResponse.fromJson(Map<String, dynamic> json) =>
      _$MSADeviceAuthorizationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MSADeviceAuthorizationResponseToJson(this);
}

@JsonSerializable()
class MSADeviceTokenResponse {
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

  MSADeviceTokenResponse({
    required this.tokenType,
    required this.scope,
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  factory MSADeviceTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$MSADeviceTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MSADeviceTokenResponseToJson(this);
}
