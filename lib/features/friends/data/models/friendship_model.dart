import 'package:freezed_annotation/freezed_annotation.dart';

part 'friendship_model.freezed.dart';
part 'friendship_model.g.dart';

@freezed
abstract class FriendshipModel with _$FriendshipModel {
  const factory FriendshipModel({
    required int id,
    required String status, // pending, accepted, declined, blocked
    required FriendshipUser requester,
    required FriendshipUser receiver,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _FriendshipModel;

  factory FriendshipModel.fromJson(Map<String, dynamic> json) =>
      _$FriendshipModelFromJson(json);
}

@freezed
abstract class FriendshipUser with _$FriendshipUser {
  const factory FriendshipUser({
    required int id,
    required String username,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _FriendshipUser;

  factory FriendshipUser.fromJson(Map<String, dynamic> json) =>
      _$FriendshipUserFromJson(json);
}
