
/// Represents a single play in the center trick pile.
class TrickPlay {
  const TrickPlay({required this.userId, required this.cardCode});

  final int userId;
  final String cardCode;

  factory TrickPlay.fromMap(Map<String, dynamic> map) => TrickPlay(
        userId: int.parse(map['player_id'].toString()),
        cardCode: map['card'] as String,
      );

  Map<String, dynamic> toMap() => {'player_id': userId, 'card': cardCode};
}

/// Persisted record of a completed trick.
class TrickModel {
  const TrickModel({
    required this.trickNumber,
    required this.plays,
    required this.leadingSuit,
    this.winnerId,
    this.penalizedPlayerId,
    required this.wasCut,
  });

  final int trickNumber;
  final List<TrickPlay> plays;
  final String leadingSuit;
  final int? winnerId;
  final int? penalizedPlayerId;
  final bool wasCut;
}

/// Persisted record of a single move (for replay).
class MoveModel {
  const MoveModel({
    required this.seq,
    required this.userId,
    required this.cardCode,
    required this.trickNumber,
    required this.playedAt,
    required this.moveType,
  });

  final int seq;
  final int userId;
  final String cardCode;
  final int trickNumber;
  final DateTime playedAt;

  /// 'play' | 'cut' | 'auto' (server auto-played on timeout)
  final String moveType;

  factory MoveModel.fromJson(Map<String, dynamic> json) => MoveModel(
        seq: json['seq'] as int,
        userId: json['user_id'] as int,
        cardCode: json['card_code'] as String,
        trickNumber: json['trick_number'] as int,
        playedAt: DateTime.parse(json['played_at'] as String),
        moveType: json['move_type'] as String? ?? 'play',
      );
}

/// Full replay data for a completed match.
class ReplayModel {
  const ReplayModel({
    required this.matchId,
    required this.playerOrder,
    required this.initialHands,
    required this.moves,
    required this.tricks,
    required this.donkeyId,
    required this.finalRanks,
  });

  final int matchId;
  final List<int> playerOrder;
  final Map<int, List<String>> initialHands; // userId → initial hand
  final List<MoveModel> moves;
  final List<TrickModel> tricks;
  final int donkeyId;
  final List<Map<String, dynamic>> finalRanks;

  factory ReplayModel.fromJson(Map<String, dynamic> json) {
    final movesJson = json['moves'] as List? ?? [];
    final handsRaw = json['initial_hands'] as Map<String, dynamic>? ?? {};
    final orderRaw = json['player_order'] as List? ?? [];

    final initialHands = handsRaw.map((k, v) {
      return MapEntry(int.parse(k), List<String>.from(v as List));
    });

    return ReplayModel(
      matchId: json['match_id'] as int,
      playerOrder: orderRaw.map((e) => int.parse(e.toString())).toList(),
      initialHands: initialHands,
      moves: movesJson
          .map((m) => MoveModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      tricks: const [],
      donkeyId: json['donkey_id'] as int,
      finalRanks: List<Map<String, dynamic>>.from(
          json['final_ranks'] as List? ?? []),
    );
  }
}

/// Bot difficulty level
enum BotDifficulty { easy, medium, hard }

/// Bot personality types
enum BotPersonality {
  beginner,
  conservative,
  aggressive,
  smart,
  trickHunter,
  escapeArtist,
  adaptive,
  master
}

/// Configuration for a bot player slot.
class BotPlayerModel {
  const BotPlayerModel({
    required this.userId,
    required this.name,
    required this.difficulty,
    this.personality = BotPersonality.beginner,
  });

  final int userId;
  final String name;
  final BotDifficulty difficulty;
  final BotPersonality personality;
}
