import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_history_model.freezed.dart';
part 'match_history_model.g.dart';

@freezed
abstract class MatchHistoryModel with _$MatchHistoryModel {
  const factory MatchHistoryModel({
    @JsonKey(name: 'match_id') required int matchId,
    @JsonKey(name: 'played_at') required String playedAt,
    @JsonKey(name: 'is_donkey') required bool isDonkey,
    @JsonKey(name: 'final_rank') int? finalRank,
    @JsonKey(name: 'tricks_won') required int tricksWon,
    @JsonKey(name: 'coins_won') required int coinsWon,
    @JsonKey(name: 'match_status') required String matchStatus,
  }) = _MatchHistoryModel;

  factory MatchHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$MatchHistoryModelFromJson(json);
}
