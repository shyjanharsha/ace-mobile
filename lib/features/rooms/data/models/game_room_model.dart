import 'package:freezed_annotation/freezed_annotation.dart';
import 'room_player_model.dart';

part 'game_room_model.freezed.dart';
part 'game_room_model.g.dart';

@freezed
abstract class GameRoomModel with _$GameRoomModel {
  const factory GameRoomModel({
    required int id,
    required String code,
    required String status,
    @JsonKey(name: 'room_type') required String roomType,
    @JsonKey(name: 'host_id') required int hostId,
    @JsonKey(name: 'max_players') required int maxPlayers,
    @JsonKey(name: 'bet_coins') required int betCoins,
    @JsonKey(name: 'player_count') required int playerCount,
    List<RoomPlayerModel>? players,
  }) = _GameRoomModel;

  factory GameRoomModel.fromJson(Map<String, dynamic> json) =>
      _$GameRoomModelFromJson(json);
}
