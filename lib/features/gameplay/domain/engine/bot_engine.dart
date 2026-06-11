import 'dart:math';
import '../../data/models/card_model.dart';
import '../../data/models/game_data_models.dart';
import 'card_engine.dart';
import 'trick_engine.dart';


/// Bot strategy interface
abstract class BotStrategy {
  /// Choose a card to play given the current game context.
  ///
  /// - [hand]           — bot's current hand
  /// - [leadingSuit]    — current leading suit (null = first play of trick)
  /// - [trickPile]      — cards already played in this trick
  /// - [activePlayers]  — list of active player IDs
  /// - [cardCounts]     — userId → card count for other players
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
  });
}

// -------------------------------------------------------
// Easy Bot — plays any valid random card
// -------------------------------------------------------
class EasyBot implements BotStrategy {
  EasyBot({int? seed}) : _random = Random(seed);

  final Random _random;

  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
  }) {
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);
    return playable[_random.nextInt(playable.length)];
  }
}

// -------------------------------------------------------
// Medium Bot — basic strategic play
// -------------------------------------------------------
class MediumBot implements BotStrategy {
  MediumBot();

  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
  }) {
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);

    // Strategy 1: If it's the first play (no leading suit), lead with lowest card
    // to keep strong cards for later.
    if (leadingSuit == null) {
      return _lowestCard(playable);
    }

    // Strategy 2: If we must follow suit, play lowest of that suit
    final suitMatches = playable.where(
      (c) => CardEngine.suitOf(c) == leadingSuit,
    ).toList();

    if (suitMatches.isNotEmpty) {
      // If currently winning the trick, play the minimum needed to stay winning.
      final currentLeader = TrickEngine.currentLeader(trickPile, leadingSuit);
      if (currentLeader == null) {
        // No one winning yet — play the lowest card of that suit
        return _lowestCard(suitMatches);
      }
      // Otherwise play lowest since we can't control outcome anyway
      return _lowestCard(suitMatches);
    }

    // Strategy 3: If we can cut, prefer to cut with a non-valuable card
    // to dump it and avoid becoming the loser.
    return _lowestCard(playable);
  }

  String _lowestCard(List<String> cards) {
    return cards.reduce((a, b) {
      final rA = CardEngine.parseCard(a).rank.value;
      final rB = CardEngine.parseCard(b).rank.value;
      return rA <= rB ? a : b;
    });
  }
}

// -------------------------------------------------------
// Hard Bot — advanced strategic play
// -------------------------------------------------------
class HardBot implements BotStrategy {
  HardBot({int? seed}) : _random = Random(seed);

  final Random _random;

  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
  }) {
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);

    // --- If we're starting the trick (no leading suit) ---
    if (leadingSuit == null) {
      return _chooseLead(playable, hand, activePlayers, cardCounts);
    }

    // --- Must follow suit ---
    final suitMatches = playable.where(
      (c) => CardEngine.suitOf(c) == leadingSuit,
    ).toList();

    if (suitMatches.isNotEmpty) {
      return _chooseFollowCard(suitMatches, trickPile, leadingSuit);
    }

    // --- Cannot follow — can cut ---
    return _chooseCutCard(playable, hand);
  }

  /// When leading, prefer non-Ace, non-King cards to avoid being penalized.
  /// Dump the weakest card unless we're confident we can win cleanly.
  String _chooseLead(
    List<String> playable,
    List<String> hand,
    List<int> activePlayers,
    Map<int, int> cardCounts,
  ) {
    // Group by suit
    final bySuit = <String, List<String>>{};
    for (final c in playable) {
      final s = CardEngine.suitOf(c);
      bySuit.putIfAbsent(s, () => []).add(c);
    }

    // Prefer to lead with a suit where we have many cards (dump faster)
    // Avoid leading Aces unless it's the only card of that suit
    String? best;
    int bestScore = -1;

    for (final entry in bySuit.entries) {
      final suitCards = entry.value;
      // Score: favor larger suit groups, avoid aces
      final hasAce = suitCards.any((c) => CardEngine.parseCard(c).rank == Rank.ace);
      final score = suitCards.length * 10 - (hasAce ? 5 : 0);
      if (score > bestScore) {
        bestScore = score;
        // Play the lowest of this suit
        best = suitCards.reduce((a, b) {
          final rA = CardEngine.parseCard(a).rank.value;
          final rB = CardEngine.parseCard(b).rank.value;
          return rA <= rB ? a : b;
        });
      }
    }

    return best ?? playable[_random.nextInt(playable.length)];
  }

  /// When following suit: if we're already winning, play the minimum possible.
  /// If we're losing, and we have a winning card, consider whether to win.
  String _chooseFollowCard(
    List<String> suitCards,
    List<TrickPlay> trickPile,
    String leadingSuit,
  ) {
    final sorted = List<String>.from(suitCards)
      ..sort((a, b) => CardEngine.parseCard(a).rank.value
          .compareTo(CardEngine.parseCard(b).rank.value));

    final currentLeader = TrickEngine.currentLeader(trickPile, leadingSuit);
    if (currentLeader == null) {
      // Nobody leading yet — play lowest
      return sorted.first;
    }

    // Play the lowest card since server decides outcome
    return sorted.first;
  }

  /// When cutting: dump the highest non-valuable card to get rid of a burden.
  /// Avoid keeping high-rank cards of any suit that might force a penalty.
  String _chooseCutCard(List<String> playable, List<String> hand) {
    // Sort ascending and play the median card — not too high, not wasting low
    final sorted = List<String>.from(playable)
      ..sort((a, b) => CardEngine.parseCard(a).rank.value
          .compareTo(CardEngine.parseCard(b).rank.value));

    // Cut with the middle card as a balanced strategy
    return sorted[sorted.length ~/ 2];
  }
}

/// Factory to create a bot strategy by difficulty.
class BotEngine {
  BotEngine._();

  static BotStrategy create(BotDifficulty difficulty, {int? seed}) {
    switch (difficulty) {
      case BotDifficulty.easy:
        return EasyBot(seed: seed);
      case BotDifficulty.medium:
        return MediumBot();
      case BotDifficulty.hard:
        return HardBot(seed: seed);
    }
  }
}
