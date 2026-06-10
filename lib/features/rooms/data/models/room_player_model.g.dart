// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomPlayerModel _$RoomPlayerModelFromJson(Map<String, dynamic> json) =>
    _RoomPlayerModel(
      userId: (json['user_id'] as num).toInt(),
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      seatPosition: (json['seat_position'] as num).toInt(),
      status: json['status'] as String,
      ready: json['ready'] as bool,
    );

Map<String, dynamic> _$RoomPlayerModelToJson(_RoomPlayerModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'username': instance.username,
      'avatar_url': instance.avatarUrl,
      'seat_position': instance.seatPosition,
      'status': instance.status,
      'ready': instance.ready,
    };
