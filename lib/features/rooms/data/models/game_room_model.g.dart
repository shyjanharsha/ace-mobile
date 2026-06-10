// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameRoomModel _$GameRoomModelFromJson(Map<String, dynamic> json) =>
    _GameRoomModel(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      status: json['status'] as String,
      roomType: json['room_type'] as String,
      hostId: (json['host_id'] as num).toInt(),
      maxPlayers: (json['max_players'] as num).toInt(),
      betCoins: (json['bet_coins'] as num).toInt(),
      playerCount: (json['player_count'] as num).toInt(),
      players: (json['players'] as List<dynamic>?)
          ?.map((e) => RoomPlayerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameRoomModelToJson(_GameRoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'status': instance.status,
      'room_type': instance.roomType,
      'host_id': instance.hostId,
      'max_players': instance.maxPlayers,
      'bet_coins': instance.betCoins,
      'player_count': instance.playerCount,
      'players': instance.players?.map((e) => e.toJson()).toList(),
    };
