// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'microsoft_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      error: json['error'] as String,
      errorDescription: json['error_description'] as String,
      errorCodes:
          (json['error_codes'] as List<dynamic>).map((e) => e as int).toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      traceId: json['trace_id'] as String,
      correlationId: json['correlation_id'] as String,
      errorUri: Uri.parse(json['error_uri'] as String),
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'error_description': instance.errorDescription,
      'error_codes': instance.errorCodes,
      'timestamp': instance.timestamp.toIso8601String(),
      'trace_id': instance.traceId,
      'correlation_id': instance.correlationId,
      'error_uri': instance.errorUri.toString(),
    };

DeviceAuthorizationResponse _$DeviceAuthorizationResponseFromJson(
        Map<String, dynamic> json) =>
    DeviceAuthorizationResponse(
      deviceCode: json['device_code'] as String,
      userCode: json['user_code'] as String,
      verificationUri: Uri.parse(json['verification_uri'] as String),
      expiresIn: json['expires_in'] as int,
      interval: json['interval'] as int,
      message: json['message'] as String,
    );

Map<String, dynamic> _$DeviceAuthorizationResponseToJson(
        DeviceAuthorizationResponse instance) =>
    <String, dynamic>{
      'device_code': instance.deviceCode,
      'user_code': instance.userCode,
      'verification_uri': instance.verificationUri.toString(),
      'expires_in': instance.expiresIn,
      'interval': instance.interval,
      'message': instance.message,
    };

DeviceTokenResponse _$DeviceTokenResponseFromJson(Map<String, dynamic> json) =>
    DeviceTokenResponse(
      tokenType: json['token_type'] as String,
      scope: json['scope'] as String,
      expiresIn: json['expires_in'] as int,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$DeviceTokenResponseToJson(
        DeviceTokenResponse instance) =>
    <String, dynamic>{
      'token_type': instance.tokenType,
      'scope': instance.scope,
      'expires_in': instance.expiresIn,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };
