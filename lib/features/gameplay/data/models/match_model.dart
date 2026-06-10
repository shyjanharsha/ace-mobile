import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

@freezed
abstract class MatchPlayerModel with _$MatchPlayerModel {
  const factory MatchPlayerModel({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'seat_position') required int seatPosition,
    @JsonKey(name: 'is_donkey') required bool isDonkey,
    @JsonKey(name: 'final_rank') int? finalRank,
    @JsonKey(name: 'tricks_won') required int tricksWon,
    @JsonKey(name: 'coins_won') required int coinsWon,
  }) = _MatchPlayerModel;

  factory MatchPlayerModel.fromJson(Map<String, dynamic> json) =>
      _$MatchPlayerModelFromJson(json);
}

@freezed
abstract class MatchRoomModel with _$MatchRoomModel {
  const factory MatchRoomModel({
    required int id,
    required String code,
  }) = _MatchRoomModel;

  factory MatchRoomModel.fromJson(Map<String, dynamic> json) =>
      _$MatchRoomModelFromJson(json);
}

@freezed
abstract class MatchModel with _$MatchModel {
  const factory MatchModel({
    required int id,
    required String status,
    @JsonKey(name: 'started_at') String? startedAt,
    @JsonKey(name: 'ended_at') String? endedAt,
    @JsonKey(name: 'duration_s') int? durationS,
    required MatchRoomModel room,
    @JsonKey(name: 'winner_id') int? winnerId,
    required List<MatchPlayerModel> players,
  }) = _MatchModel;

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
}
