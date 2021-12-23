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

part 'mojang_model.g.dart';

@JsonSerializable()
class MojangAuthenticationResponse {
  final User user;
  final String clientToken;
  final String accessToken;
  final Profile selectedProfile;

  MojangAuthenticationResponse({
    required this.user,
    required this.clientToken,
    required this.accessToken,
    required this.selectedProfile,
  });

  factory MojangAuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$MojangAuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MojangAuthenticationResponseToJson(this);
}

@JsonSerializable()
class MojangErrorResponse implements Exception {
  final String error;
  final String? errorMessage;

  MojangErrorResponse({
    required this.error,
    this.errorMessage
  });

  factory MojangErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$MojangErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MojangErrorResponseToJson(this);

  @override
  String toString() => errorMessage ?? error;
}

@JsonSerializable()
class User {
  final String username;
  final String id;

  User({
    required this.username,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Profile {
  final String id;
  final String name;

  Profile({
    required this.id,
    required this.name,
  });

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
