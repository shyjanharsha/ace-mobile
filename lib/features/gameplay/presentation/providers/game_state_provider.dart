import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/engine/game_engine.dart';
import 'gameplay_providers.dart';

/// Derived providers computed from GameplayState — avoids prop-drilling
/// complex computed values into widgets.
///
/// These are all read-only, derived from the gameplay provider.

// -------------------------------------------------------
// Derived: sorted hand for display
// -------------------------------------------------------

/// Returns the current player's hand, sorted by suit then rank.
final sortedHandProvider = Provider.family<List<String>, int>((ref, matchId) {
  return ref.watch(gameplayProvider(matchId).select((s) => s.sortedHand));
});

// -------------------------------------------------------
// Derived: playable cards (for highlight)
// -------------------------------------------------------

/// Returns the set of cards the current player can legally play right now.
final playableCardsProvider = Provider.family<List<String>, int>((ref, matchId) {
  return ref.watch(gameplayProvider(matchId).select((s) => s.playableCards));
});

// -------------------------------------------------------
// Derived: is a specific card playable
// -------------------------------------------------------

/// Returns true if [cardCode] is currently playable in match [matchId].
final isCardPlayableProvider =
    Provider.family<bool Function(String), int>((ref, matchId) {
  final playable = ref.watch(playableCardsProvider(matchId));
  return (cardCode) => playable.contains(cardCode);
});

// -------------------------------------------------------
// Derived: suit display name of the leading suit
// -------------------------------------------------------

/// Returns a human-readable leading suit string like "♠ Spades" or null.
final leadingSuitDisplayProvider =
    Provider.family<String?, int>((ref, matchId) {
  final suit = ref.watch(gameplayProvider(matchId).select((s) => s.leadingSuit));
  if (suit == null) return null;
  return GameEngine.suitDisplayName(suit);
});

// -------------------------------------------------------
// Derived: trick pile as TrickPlay objects
// -------------------------------------------------------

// -------------------------------------------------------
// Derived: would this card cut?
// -------------------------------------------------------

/// Returns true if [cardCode] would cut the current trick.
final wouldCutProvider =
    Provider.family<bool Function(String), int>((ref, matchId) {
  final trickPile = ref.watch(
    gameplayProvider(matchId).select((s) => s.trickPile),
  );
  return (cardCode) {
    if (trickPile.isEmpty) return false;
    final leadingSuit = GameEngine.suitOf(trickPile.first['card'] as String? ?? '');
    return GameEngine.suitOf(cardCode) != leadingSuit;
  };
});

// -------------------------------------------------------
// Derived: current game phase
// -------------------------------------------------------

enum GamePhase { loading, dealing, playing, finished }

final gamePhaseProvider = Provider.family<GamePhase, int>((ref, matchId) {
  final s = ref.watch(gameplayProvider(matchId));
  if (s.match.isLoading) return GamePhase.loading;
  if (s.donkeyId != null) return GamePhase.finished;
  if (s.myHand.isEmpty && s.finishedPlayers.isEmpty) return GamePhase.dealing;
  return GamePhase.playing;
});

// -------------------------------------------------------
// Derived: disconnected player check
// -------------------------------------------------------

/// Returns true if [userId] is currently disconnected.
final isPlayerDisconnectedProvider =
    Provider.family<bool Function(int), int>((ref, matchId) {
  final disconnected = ref.watch(
    gameplayProvider(matchId).select((s) => s.disconnectedPlayers),
  );
  return (userId) => disconnected.contains(userId);
});
