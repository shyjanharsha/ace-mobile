import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
abstract class GroupMemberModel with _$GroupMemberModel {
  const factory GroupMemberModel({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String username,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    required String role,
    @JsonKey(name: 'joined_at') required String joinedAt,
  }) = _GroupMemberModel;

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);
}

@freezed
abstract class GroupModel with _$GroupModel {
  const factory GroupModel({
    required int id,
    required String name,
    String? description,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'group_type') required String groupType,
    @JsonKey(name: 'invite_code') String? inviteCode,
    @JsonKey(name: 'owner_id') required int ownerId,
    @JsonKey(name: 'owner_name') required String ownerName,
    @JsonKey(name: 'members_count') required int membersCount,
    @JsonKey(name: 'created_at') required String createdAt,
    List<GroupMemberModel>? members,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
}
