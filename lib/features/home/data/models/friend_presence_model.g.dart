// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_presence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendPresenceModel _$FriendPresenceModelFromJson(Map<String, dynamic> json) =>
    _FriendPresenceModel(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      status: json['status'] as String,
      lastSeenAt: json['last_seen_at'] == null
          ? null
          : DateTime.parse(json['last_seen_at'] as String),
    );

Map<String, dynamic> _$FriendPresenceModelToJson(
  _FriendPresenceModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'display_name': instance.displayName,
  'avatar_url': instance.avatarUrl,
  'status': instance.status,
  'last_seen_at': instance.lastSeenAt?.toIso8601String(),
};
