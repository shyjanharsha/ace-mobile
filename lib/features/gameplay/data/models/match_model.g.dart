// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchPlayerModel _$MatchPlayerModelFromJson(Map<String, dynamic> json) =>
    _MatchPlayerModel(
      userId: (json['user_id'] as num).toInt(),
      seatPosition: (json['seat_position'] as num).toInt(),
      isDonkey: json['is_donkey'] as bool,
      finalRank: (json['final_rank'] as num?)?.toInt(),
      tricksWon: (json['tricks_won'] as num).toInt(),
      coinsWon: (json['coins_won'] as num).toInt(),
    );

Map<String, dynamic> _$MatchPlayerModelToJson(_MatchPlayerModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'seat_position': instance.seatPosition,
      'is_donkey': instance.isDonkey,
      'final_rank': instance.finalRank,
      'tricks_won': instance.tricksWon,
      'coins_won': instance.coinsWon,
    };

_MatchRoomModel _$MatchRoomModelFromJson(Map<String, dynamic> json) =>
    _MatchRoomModel(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
    );

Map<String, dynamic> _$MatchRoomModelToJson(_MatchRoomModel instance) =>
    <String, dynamic>{'id': instance.id, 'code': instance.code};

_MatchModel _$MatchModelFromJson(Map<String, dynamic> json) => _MatchModel(
  id: (json['id'] as num).toInt(),
  status: json['status'] as String,
  startedAt: json['started_at'] as String?,
  endedAt: json['ended_at'] as String?,
  durationS: (json['duration_s'] as num?)?.toInt(),
  room: MatchRoomModel.fromJson(json['room'] as Map<String, dynamic>),
  winnerId: (json['winner_id'] as num?)?.toInt(),
  players: (json['players'] as List<dynamic>)
      .map((e) => MatchPlayerModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MatchModelToJson(_MatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'started_at': instance.startedAt,
      'ended_at': instance.endedAt,
      'duration_s': instance.durationS,
      'room': instance.room.toJson(),
      'winner_id': instance.winnerId,
      'players': instance.players.map((e) => e.toJson()).toList(),
    };
