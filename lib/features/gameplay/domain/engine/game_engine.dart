import '../../data/models/game_data_models.dart';
import 'card_engine.dart';
import 'trick_engine.dart';
import 'turn_engine.dart';
import 'move_validator.dart';
import 'bot_engine.dart';

/// The top-level game engine orchestrator.
///
/// Composes CardEngine, TrickEngine, TurnEngine, MoveValidator, and BotEngine.
/// Used by the GameplayNotifier to compute derived state from server events,
/// pre-validate moves for UX feedback, and drive bot players.
///
/// IMPORTANT: This engine NEVER directly modifies game state.
/// All actual state changes come from the server via WebSocket events.
class GameEngine {
  GameEngine._();

  // -------------------------------------------------------
  // Hand management
  // -------------------------------------------------------

  /// Returns a sorted version of [hand] for display.
  static List<String> sortHand(List<String> hand) {
    return CardEngine.sortHand(hand);
  }

  /// Returns all currently playable cards for the local player.
  static List<String> getPlayableCards({
    required List<String> hand,
    required String? leadingSuit,
    required bool isMyTurn,
  }) {
    return MoveValidator.getPlayableCards(
      hand: hand,
      leadingSuit: leadingSuit,
      isMyTurn: isMyTurn,
    );
  }

  /// Returns true if [cardCode] is currently playable.
  static bool isCardPlayable({
    required String cardCode,
    required List<String> hand,
    required String? leadingSuit,
    required bool isMyTurn,
  }) {
    return MoveValidator.isCardPlayable(
      cardCode: cardCode,
      hand: hand,
      leadingSuit: leadingSuit,
      isMyTurn: isMyTurn,
    );
  }

  // -------------------------------------------------------
  // Move validation
  // -------------------------------------------------------

  /// Pre-validates a move before submitting to server.
  /// Returns a [ValidationResult] with human-readable error if invalid.
  static ValidationResult validateMove({
    required List<String> hand,
    required String cardCode,
    required String? leadingSuit,
    required bool isMyTurn,
    bool isGameActive = true,
  }) {
    return MoveValidator.validate(
      hand: hand,
      cardCode: cardCode,
      leadingSuit: leadingSuit,
      isMyTurn: isMyTurn,
      isGameActive: isGameActive,
    );
  }

  // -------------------------------------------------------
  // Trick logic
  // -------------------------------------------------------

  /// Returns the current leading suit from the trick pile.
  static String? detectLeadingSuit(List<TrickPlay> trickPile) {
    return TrickEngine.detectLeadingSuit(trickPile);
  }

  /// Returns true if [cardCode] would cut the current trick.
  static bool wouldCut(String cardCode, List<TrickPlay> trickPile) {
    return TrickEngine.wouldCut(cardCode, trickPile);
  }

  /// Returns the userId currently "winning" the in-progress trick.
  static int? currentTrickLeader(
    List<TrickPlay> trickPile,
    String leadingSuit,
  ) {
    return TrickEngine.currentLeader(trickPile, leadingSuit);
  }

  /// Resolves a complete trick.
  static TrickResult resolveTrick(
    List<TrickPlay> trickPile,
    String leadingSuit,
  ) {
    return TrickEngine.resolveTrick(trickPile, leadingSuit);
  }

  // -------------------------------------------------------
  // Turn management
  // -------------------------------------------------------

  /// Returns the next active player after [currentId].
  static int? nextPlayer({
    required int currentId,
    required List<int> playerOrder,
    required List<int> activePlayers,
  }) {
    if (activePlayers.isEmpty) return null;
    return TurnEngine.nextPlayer(currentId, playerOrder, activePlayers);
  }

  /// Returns the donkey (last player with cards), or null if game is ongoing.
  static int? detectDonkey({
    required Map<int, int> cardCounts,
    required List<int> activePlayers,
  }) {
    return TurnEngine.detectDonkey(cardCounts, activePlayers);
  }

  /// Returns whether the game is over.
  static bool isGameOver({
    required Map<int, int> cardCounts,
    required List<int> activePlayers,
  }) {
    return TurnEngine.isGameOver(cardCounts, activePlayers);
  }

  // -------------------------------------------------------
  // Bot support
  // -------------------------------------------------------

  /// Creates a bot strategy for the given difficulty.
  static BotStrategy createBot(BotDifficulty difficulty) {
    return BotEngine.create(difficulty);
  }

  /// Asks the bot to choose a card to play.
  static String botChooseCard({
    required BotStrategy bot,
    required List<String> hand,
    required String? leadingSuit,
    required List<TrickPlay> trickPile,
    required List<int> activePlayers,
    required Map<int, int> cardCounts,
  }) {
    return bot.chooseCard(
      hand: hand,
      leadingSuit: leadingSuit,
      trickPile: trickPile,
      activePlayers: activePlayers,
      cardCounts: cardCounts,
    );
  }

  // -------------------------------------------------------
  // Card info helpers
  // -------------------------------------------------------

  /// Returns the suit of a card code (e.g., "AS" → "S")
  static String suitOf(String code) => CardEngine.suitOf(code);

  /// Returns the display name for a suit character.
  static String suitDisplayName(String suit) {
    switch (suit) {
      case 'S': return '♠ Spades';
      case 'H': return '♥ Hearts';
      case 'D': return '♦ Diamonds';
      case 'C': return '♣ Clubs';
      default:  return suit;
    }
  }

  /// Returns the suit symbol character.
  static String suitSymbol(String suit) {
    switch (suit) {
      case 'S': return '♠';
      case 'H': return '♥';
      case 'D': return '♦';
      case 'C': return '♣';
      default:  return suit;
    }
  }
}
