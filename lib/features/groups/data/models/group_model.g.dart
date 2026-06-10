// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) =>
    _GroupMemberModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      joinedAt: json['joined_at'] as String,
    );

Map<String, dynamic> _$GroupMemberModelToJson(_GroupMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'role': instance.role,
      'joined_at': instance.joinedAt,
    };

_GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => _GroupModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  groupType: json['group_type'] as String,
  inviteCode: json['invite_code'] as String?,
  ownerId: (json['owner_id'] as num).toInt(),
  ownerName: json['owner_name'] as String,
  membersCount: (json['members_count'] as num).toInt(),
  createdAt: json['created_at'] as String,
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => GroupMemberModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GroupModelToJson(_GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'avatar_url': instance.avatarUrl,
      'group_type': instance.groupType,
      'invite_code': instance.inviteCode,
      'owner_id': instance.ownerId,
      'owner_name': instance.ownerName,
      'members_count': instance.membersCount,
      'created_at': instance.createdAt,
      'members': instance.members?.map((e) => e.toJson()).toList(),
    };
