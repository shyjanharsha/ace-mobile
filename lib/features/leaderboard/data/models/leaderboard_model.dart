import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_model.freezed.dart';
part 'leaderboard_model.g.dart';

@freezed
abstract class LeaderboardUserModel with _$LeaderboardUserModel {
  const factory LeaderboardUserModel({
    @JsonKey(name: 'user_id') required int userId,
    required String username,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    required int level,
    required int wins,
    @JsonKey(name: 'donkey_count') required int donkeyCount,
    @JsonKey(name: 'best_streak') required int bestStreak,
    @JsonKey(name: 'total_games') required int totalGames,
    required dynamic value,
  }) = _LeaderboardUserModel;

  factory LeaderboardUserModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardUserModelFromJson(json);
}
