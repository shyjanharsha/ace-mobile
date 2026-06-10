// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  displayName: json['display_name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  isGuest: json['is_guest'] as bool? ?? false,
  verified: json['verified'] as bool? ?? false,
  coins: (json['coins'] as num?)?.toInt() ?? 1000,
  xp: (json['xp'] as num?)?.toInt() ?? 0,
  level: (json['level'] as num?)?.toInt() ?? 1,
  status: json['status'] as String? ?? 'offline',
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
      'email': instance.email,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'is_guest': instance.isGuest,
      'verified': instance.verified,
      'coins': instance.coins,
      'xp': instance.xp,
      'level': instance.level,
      'status': instance.status,
    };
