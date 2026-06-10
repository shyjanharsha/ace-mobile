import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_presence_model.freezed.dart';
part 'friend_presence_model.g.dart';

@freezed
abstract class FriendPresenceModel with _$FriendPresenceModel {
  const factory FriendPresenceModel({
    required int id,
    required String username,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    required String status,
    @JsonKey(name: 'last_seen_at') DateTime? lastSeenAt,
  }) = _FriendPresenceModel;

  factory FriendPresenceModel.fromJson(Map<String, dynamic> json) =>
      _$FriendPresenceModelFromJson(json);
}
