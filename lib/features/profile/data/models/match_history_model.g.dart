// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchHistoryModel _$MatchHistoryModelFromJson(Map<String, dynamic> json) =>
    _MatchHistoryModel(
      matchId: (json['match_id'] as num).toInt(),
      playedAt: json['played_at'] as String,
      isDonkey: json['is_donkey'] as bool,
      finalRank: (json['final_rank'] as num?)?.toInt(),
      tricksWon: (json['tricks_won'] as num).toInt(),
      coinsWon: (json['coins_won'] as num).toInt(),
      matchStatus: json['match_status'] as String,
    );

Map<String, dynamic> _$MatchHistoryModelToJson(_MatchHistoryModel instance) =>
    <String, dynamic>{
      'match_id': instance.matchId,
      'played_at': instance.playedAt,
      'is_donkey': instance.isDonkey,
      'final_rank': instance.finalRank,
      'tricks_won': instance.tricksWon,
      'coins_won': instance.coinsWon,
      'match_status': instance.matchStatus,
    };
