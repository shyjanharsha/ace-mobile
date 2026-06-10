import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_player_model.freezed.dart';
part 'room_player_model.g.dart';

@freezed
abstract class RoomPlayerModel with _$RoomPlayerModel {
  const factory RoomPlayerModel({
    @JsonKey(name: 'user_id') required int userId,
    required String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'seat_position') required int seatPosition,
    required String status,
    required bool ready,
  }) = _RoomPlayerModel;

  factory RoomPlayerModel.fromJson(Map<String, dynamic> json) =>
      _$RoomPlayerModelFromJson(json);
}
