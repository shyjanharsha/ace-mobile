import 'dart:math';
import '../../data/models/card_model.dart';
import '../../data/models/game_data_models.dart';
import 'card_engine.dart';
import 'trick_engine.dart';

/// Game memory for advanced bots to track state
class GameMemory {
  final Set<String> playedCards = {};
  final Map<int, int> playerHandSizes = {};
  final Map<String, int> suitCountsPlayed = {
    'S': 0, 'H': 0, 'D': 0, 'C': 0
  };

  void updateMemory(String cardCode, int playerId, int newHandSize) {
    playedCards.add(cardCode);
    playerHandSizes[playerId] = newHandSize;
    suitCountsPlayed[CardEngine.suitOf(cardCode)] = 
        (suitCountsPlayed[CardEngine.suitOf(cardCode)] ?? 0) + 1;
  }
  
  void reset() {
    playedCards.clear();
    playerHandSizes.clear();
    suitCountsPlayed.updateAll((key, value) => 0);
  }
}

/// Bot strategy interface
abstract class BotStrategy {
  /// Choose a card to play given the current game context.
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
    required GameMemory memory,
  });
}

// -------------------------------------------------------
// 1. Beginner Bot (Easy)
// -------------------------------------------------------
class BeginnerBot implements BotStrategy {
  BeginnerBot({int? seed}) : _random = Random(seed);
  final Random _random;

  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
    required GameMemory memory,
  }) {
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);
    return playable[_random.nextInt(playable.length)];
  }
}

// -------------------------------------------------------
// 2. Conservative Bot (Medium)
// -------------------------------------------------------
class ConservativeBot implements BotStrategy {
  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
    required GameMemory memory,
  }) {
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);
    if (leadingSuit == null) return _lowestCard(playable);
    
    final suitMatches = playable.where((c) => CardEngine.suitOf(c) == leadingSuit).toList();
    if (suitMatches.isNotEmpty) {
      return _lowestCard(suitMatches);
    }
    // If cutting, play lowest valid to avoid risk
    return _lowestCard(playable);
  }

  String _lowestCard(List<String> cards) {
    return cards.reduce((a, b) {
      return CardEngine.parseCard(a).rank.value <= CardEngine.parseCard(b).rank.value ? a : b;
    });
  }
}

// -------------------------------------------------------
// 3. Aggressive Bot (Medium)
// -------------------------------------------------------
class AggressiveBot implements BotStrategy {
  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
    required GameMemory memory,
  }) {
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);
    if (leadingSuit == null) {
      // Lead with highest to try winning trick
      return _highestCard(playable);
    }
    
    final suitMatches = playable.where((c) => CardEngine.suitOf(c) == leadingSuit).toList();
    if (suitMatches.isNotEmpty) {
      return _highestCard(suitMatches);
    }
    
    // Cutting: dump highest card
    return _highestCard(playable);
  }

  String _highestCard(List<String> cards) {
    return cards.reduce((a, b) {
      return CardEngine.parseCard(a).rank.value >= CardEngine.parseCard(b).rank.value ? a : b;
    });
  }
}

// -------------------------------------------------------
// 4. Smart Bot (Medium)
// -------------------------------------------------------
class SmartBot implements BotStrategy {
  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
    required GameMemory memory,
  }) {
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);
    if (leadingSuit == null) {
      return _lowestCard(playable);
    }
    
    final suitMatches = playable.where((c) => CardEngine.suitOf(c) == leadingSuit).toList();
    if (suitMatches.isNotEmpty) {
      final currentLeader = TrickEngine.currentLeader(trickPile, leadingSuit);
      if (currentLeader == null) return _lowestCard(suitMatches);
      return _lowestCard(suitMatches); // Play safe
    }
    
    // Cutting: dump highest card to lower hand value
    return _highestCard(playable);
  }

  String _lowestCard(List<String> cards) {
    return cards.reduce((a, b) => CardEngine.parseCard(a).rank.value <= CardEngine.parseCard(b).rank.value ? a : b);
  }
  String _highestCard(List<String> cards) {
    return cards.reduce((a, b) => CardEngine.parseCard(a).rank.value >= CardEngine.parseCard(b).rank.value ? a : b);
  }
}

// -------------------------------------------------------
// 5. Trick Hunter Bot (Medium)
// -------------------------------------------------------
class TrickHunterBot implements BotStrategy {
  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
    required GameMemory memory,
  }) {
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);
    return playable.reduce((a, b) => CardEngine.parseCard(a).rank.value >= CardEngine.parseCard(b).rank.value ? a : b);
  }
}

// -------------------------------------------------------
// 6. Escape Artist Bot (Medium)
// -------------------------------------------------------
class EscapeArtistBot implements BotStrategy {
  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
    required GameMemory memory,
  }) {
    // Goal: Empty hand quickly. Prefers dumping highest valid card.
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);
    return playable.reduce((a, b) => CardEngine.parseCard(a).rank.value >= CardEngine.parseCard(b).rank.value ? a : b);
  }
}

// -------------------------------------------------------
// 7. Adaptive Bot (Hard)
// -------------------------------------------------------
class AdaptiveBot implements BotStrategy {
  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
    required GameMemory memory,
  }) {
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);
    if (leadingSuit == null) {
      // Early game: conservative. Late game: aggressive
      if (hand.length > 5) return _lowestCard(playable);
      return _highestCard(playable);
    }
    
    final suitMatches = playable.where((c) => CardEngine.suitOf(c) == leadingSuit).toList();
    if (suitMatches.isNotEmpty) {
      return _lowestCard(suitMatches);
    }
    
    return _highestCard(playable);
  }

  String _lowestCard(List<String> cards) => cards.reduce((a, b) => CardEngine.parseCard(a).rank.value <= CardEngine.parseCard(b).rank.value ? a : b);
  String _highestCard(List<String> cards) => cards.reduce((a, b) => CardEngine.parseCard(a).rank.value >= CardEngine.parseCard(b).rank.value ? a : b);
}

// -------------------------------------------------------
// 8. Master Bot (Hard)
// -------------------------------------------------------
class MasterBot implements BotStrategy {
  MasterBot({int? seed}) : _random = Random(seed);
  final Random _random;

  @override
  String chooseCard({
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
    required GameMemory memory,
  }) {
    final playable = CardEngine.getPlayableCards(hand, leadingSuit);

    if (leadingSuit == null) {
      return _chooseLead(playable, hand, activePlayers, cardCounts, memory);
    }

    final suitMatches = playable.where((c) => CardEngine.suitOf(c) == leadingSuit).toList();
    if (suitMatches.isNotEmpty) {
      return _chooseFollowCard(suitMatches, trickPile, leadingSuit, memory);
    }

    return _chooseCutCard(playable, hand);
  }

  String _chooseLead(List<String> playable, List<String> hand, List<int> activePlayers, Map<int, int> cardCounts, GameMemory memory) {
    final bySuit = <String, List<String>>{};
    for (final c in playable) {
      bySuit.putIfAbsent(CardEngine.suitOf(c), () => []).add(c);
    }

    String? best;
    int bestScore = -1;

    for (final entry in bySuit.entries) {
      final suitCards = entry.value;
      final hasAce = suitCards.any((c) => CardEngine.parseCard(c).rank == Rank.ace);
      final score = suitCards.length * 10 - (hasAce ? 5 : 0);
      if (score > bestScore) {
        bestScore = score;
        best = suitCards.reduce((a, b) => CardEngine.parseCard(a).rank.value <= CardEngine.parseCard(b).rank.value ? a : b);
      }
    }
    return best ?? playable[_random.nextInt(playable.length)];
  }

  String _chooseFollowCard(List<String> suitCards, List<TrickPlay> trickPile, String leadingSuit, GameMemory memory) {
    final sorted = List<String>.from(suitCards)
      ..sort((a, b) => CardEngine.parseCard(a).rank.value.compareTo(CardEngine.parseCard(b).rank.value));
    return sorted.first;
  }

  String _chooseCutCard(List<String> playable, List<String> hand) {
    final sorted = List<String>.from(playable)
      ..sort((a, b) => CardEngine.parseCard(a).rank.value.compareTo(CardEngine.parseCard(b).rank.value));
    return sorted[sorted.length ~/ 2]; // Medium dump
  }
}

/// Factory to create a bot strategy by personality.
class BotEngine {
  BotEngine._();

  static BotStrategy create(BotPersonality personality, {int? seed}) {
    switch (personality) {
      case BotPersonality.beginner:
        return BeginnerBot(seed: seed);
      case BotPersonality.conservative:
        return ConservativeBot();
      case BotPersonality.aggressive:
        return AggressiveBot();
      case BotPersonality.smart:
        return SmartBot();
      case BotPersonality.trickHunter:
        return TrickHunterBot();
      case BotPersonality.escapeArtist:
        return EscapeArtistBot();
      case BotPersonality.adaptive:
        return AdaptiveBot();
      case BotPersonality.master:
        return MasterBot(seed: seed);
    }
  }
}
