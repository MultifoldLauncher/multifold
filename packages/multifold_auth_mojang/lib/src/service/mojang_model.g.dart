// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mojang_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MojangAuthenticationResponse _$MojangAuthenticationResponseFromJson(
        Map<String, dynamic> json) =>
    MojangAuthenticationResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      clientToken: json['clientToken'] as String,
      accessToken: json['accessToken'] as String,
      selectedProfile:
          Profile.fromJson(json['selectedProfile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MojangAuthenticationResponseToJson(
        MojangAuthenticationResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'clientToken': instance.clientToken,
      'accessToken': instance.accessToken,
      'selectedProfile': instance.selectedProfile,
    };

MojangErrorResponse _$MojangErrorResponseFromJson(Map<String, dynamic> json) =>
    MojangErrorResponse(
      error: json['error'] as String,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$MojangErrorResponseToJson(
        MojangErrorResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorMessage': instance.errorMessage,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'id': instance.id,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
