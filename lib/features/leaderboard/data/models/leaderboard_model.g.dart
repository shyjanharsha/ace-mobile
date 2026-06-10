// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardUserModel _$LeaderboardUserModelFromJson(
  Map<String, dynamic> json,
) => _LeaderboardUserModel(
  userId: (json['user_id'] as num).toInt(),
  username: json['username'] as String,
  displayName: json['display_name'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  level: (json['level'] as num).toInt(),
  wins: (json['wins'] as num).toInt(),
  donkeyCount: (json['donkey_count'] as num).toInt(),
  bestStreak: (json['best_streak'] as num).toInt(),
  totalGames: (json['total_games'] as num).toInt(),
  value: json['value'],
);

Map<String, dynamic> _$LeaderboardUserModelToJson(
  _LeaderboardUserModel instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'username': instance.username,
  'display_name': instance.displayName,
  'avatar_url': instance.avatarUrl,
  'level': instance.level,
  'wins': instance.wins,
  'donkey_count': instance.donkeyCount,
  'best_streak': instance.bestStreak,
  'total_games': instance.totalGames,
  'value': instance.value,
};
