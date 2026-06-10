// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendshipModel _$FriendshipModelFromJson(
  Map<String, dynamic> json,
) => _FriendshipModel(
  id: (json['id'] as num).toInt(),
  status: json['status'] as String,
  requester: FriendshipUser.fromJson(json['requester'] as Map<String, dynamic>),
  receiver: FriendshipUser.fromJson(json['receiver'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$FriendshipModelToJson(_FriendshipModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'requester': instance.requester.toJson(),
      'receiver': instance.receiver.toJson(),
      'created_at': instance.createdAt,
    };

_FriendshipUser _$FriendshipUserFromJson(Map<String, dynamic> json) =>
    _FriendshipUser(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$FriendshipUserToJson(_FriendshipUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
    };
