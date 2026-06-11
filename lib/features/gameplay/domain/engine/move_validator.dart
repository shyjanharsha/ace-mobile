import '../engine/card_engine.dart';

/// Result of a move validation.
class ValidationResult {
  const ValidationResult.valid()
      : isValid = true,
        errorCode = null,
        errorMessage = null;

  const ValidationResult.invalid(this.errorCode, this.errorMessage)
      : isValid = false;

  final bool isValid;

  /// Machine-readable error code for programmatic handling.
  final String? errorCode;

  /// Human-readable error message for snackbars / UI.
  final String? errorMessage;

  // Error code constants
  static const String errNotYourTurn = 'not_your_turn';
  static const String errCardNotInHand = 'card_not_in_hand';
  static const String errMustFollowSuit = 'must_follow_suit';
  static const String errInvalidCard = 'invalid_card';
  static const String errGameNotActive = 'game_not_active';
}

/// Client-side move validator — mirrors the server validation logic.
///
/// Used ONLY for:
/// - Highlighting playable cards in the UI
/// - Preventing obviously invalid drag-and-drops before the HTTP call
/// - Giving immediate user feedback
///
/// The server ALWAYS performs the authoritative validation.
/// This class should never be used to advance game state.
class MoveValidator {
  MoveValidator._();

  /// Validates whether [cardCode] can legally be played given the current state.
  ///
  /// Parameters:
  /// - [hand]         — the player's current hand
  /// - [cardCode]     — the card they want to play
  /// - [leadingSuit]  — the current leading suit (null = first play of trick)
  /// - [isMyTurn]     — whether it is currently this player's turn
  /// - [isGameActive] — whether the match is in playing state
  static ValidationResult validate({
    required List<String> hand,
    required String cardCode,
    required String? leadingSuit,
    required bool isMyTurn,
    bool isGameActive = true,
  }) {
    if (!isGameActive) {
      return const ValidationResult.invalid(
        ValidationResult.errGameNotActive,
        'The game is not active.',
      );
    }

    if (!isMyTurn) {
      return const ValidationResult.invalid(
        ValidationResult.errNotYourTurn,
        'It is not your turn.',
      );
    }

    // Validate the card code format
    try {
      CardEngine.parseCard(cardCode);
    } catch (_) {
      return const ValidationResult.invalid(
        ValidationResult.errInvalidCard,
        'Invalid card.',
      );
    }

    if (!hand.contains(cardCode)) {
      return const ValidationResult.invalid(
        ValidationResult.errCardNotInHand,
        'You do not have this card.',
      );
    }

    // If there is a leading suit and the player has that suit, they MUST follow
    if (leadingSuit != null) {
      final cardSuit = CardEngine.suitOf(cardCode);
      if (cardSuit != leadingSuit && CardEngine.hasSuit(hand, leadingSuit)) {
        return ValidationResult.invalid(
          ValidationResult.errMustFollowSuit,
          'You must follow the leading suit ($leadingSuit).',
        );
      }
    }

    return const ValidationResult.valid();
  }

  /// Returns all cards in [hand] that are currently legal to play.
  /// Useful for highlighting playable cards and locking non-playable ones.
  static List<String> getPlayableCards({
    required List<String> hand,
    required String? leadingSuit,
    required bool isMyTurn,
  }) {
    if (!isMyTurn) return [];
    return CardEngine.getPlayableCards(hand, leadingSuit);
  }

  /// Quick check: is this card playable?
  static bool isCardPlayable({
    required String cardCode,
    required List<String> hand,
    required String? leadingSuit,
    required bool isMyTurn,
  }) {
    return validate(
      hand: hand,
      cardCode: cardCode,
      leadingSuit: leadingSuit,
      isMyTurn: isMyTurn,
    ).isValid;
  }
}
