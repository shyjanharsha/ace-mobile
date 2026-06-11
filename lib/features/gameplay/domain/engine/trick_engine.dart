import '../../data/models/game_data_models.dart';
import 'card_engine.dart';

/// Result of a trick resolution — either normal win or cut.
class TrickResult {
  const TrickResult({
    required this.winnerId,
    this.penalizedPlayerId,
    required this.wasCut,
    required this.leadingSuit,
  });

  /// Player who starts the NEXT trick.
  /// If there was a cut, this is the cutter (not the highest-card holder).
  final int winnerId;

  /// When a cut happened: the player who held the highest card of the
  /// leading suit at the time of the cut. They collect the center pile.
  final int? penalizedPlayerId;

  final bool wasCut;
  final String leadingSuit;
}

/// Handles all trick-level logic: leading suit detection, cut detection,
/// winner calculation, and penalized player identification.
///
/// All methods are pure — they take explicit parameters and return results.
class TrickEngine {
  TrickEngine._();

  // -------------------------------------------------------
  // Leading suit
  // -------------------------------------------------------

  /// Returns the suit of the first card played in the trick pile.
  /// Returns null if the pile is empty (start of a new trick).
  static String? detectLeadingSuit(List<TrickPlay> plays) {
    if (plays.isEmpty) return null;
    return CardEngine.suitOf(plays.first.cardCode);
  }

  // -------------------------------------------------------
  // Cut detection
  // -------------------------------------------------------

  /// Returns true if [cardCode] does NOT match [leadingSuit].
  /// A null [leadingSuit] means it's the first play — never a cut.
  static bool isCut(String cardCode, String? leadingSuit) {
    if (leadingSuit == null) return false;
    return CardEngine.suitOf(cardCode) != leadingSuit;
  }

  /// Returns true if [plays] contains at least one cut (card not of leading suit),
  /// assuming [leadingSuit] is the suit of plays[0].
  static bool trickHasCut(List<TrickPlay> plays) {
    final leading = detectLeadingSuit(plays);
    if (leading == null) return false;
    return plays.any((p) => CardEngine.suitOf(p.cardCode) != leading);
  }

  // -------------------------------------------------------
  // Winner calculation
  // -------------------------------------------------------

  /// Resolves a complete trick (all players have played) and returns the result.
  ///
  /// Rules:
  /// - If no cut: player with the highest card of [leadingSuit] wins and leads next.
  /// - If cut: The cutter leads next; the player who currently holds the highest
  ///   leading-suit card is penalized (collects the center pile).
  ///
  /// Note: in Kazhutha Kali, only the FIRST cut in a trick matters for resolving
  /// the center pile. Subsequent plays after a cut are ignored for winner purposes.
  static TrickResult resolveTrick(List<TrickPlay> plays, String leadingSuit) {
    if (plays.isEmpty) {
      throw StateError('Cannot resolve an empty trick');
    }

    // Find the player with the highest card of the leading suit
    TrickPlay? bestLeadingPlay;
    for (final play in plays) {
      if (CardEngine.suitOf(play.cardCode) != leadingSuit) continue;
      if (bestLeadingPlay == null) {
        bestLeadingPlay = play;
      } else {
        final current = CardEngine.parseCard(bestLeadingPlay.cardCode).rank.value;
        final challenger = CardEngine.parseCard(play.cardCode).rank.value;
        if (challenger > current) bestLeadingPlay = play;
      }
    }

    // Find the first cut (if any)
    final firstCut = plays.firstWhere(
      (p) => CardEngine.suitOf(p.cardCode) != leadingSuit,
      orElse: () => plays.first, // sentinel — will check wasCut flag
    );
    final hasCut = plays.any((p) => CardEngine.suitOf(p.cardCode) != leadingSuit);

    if (!hasCut) {
      // Normal trick: highest leading-suit card wins
      return TrickResult(
        winnerId: bestLeadingPlay!.userId,
        wasCut: false,
        leadingSuit: leadingSuit,
      );
    } else {
      // Cut trick:
      // - Cutter leads next
      // - Player with highest leading-suit card is penalized (gets the pile)
      return TrickResult(
        winnerId: firstCut.userId, // cutter leads next
        penalizedPlayerId: bestLeadingPlay?.userId,
        wasCut: true,
        leadingSuit: leadingSuit,
      );
    }
  }

  // -------------------------------------------------------
  // Partial trick helpers (for UI)
  // -------------------------------------------------------

  /// Returns the userId of the player currently "winning" (holding highest
  /// leading-suit card) in an in-progress trick.
  static int? currentLeader(List<TrickPlay> plays, String leadingSuit) {
    TrickPlay? best;
    for (final play in plays) {
      if (CardEngine.suitOf(play.cardCode) != leadingSuit) continue;
      if (best == null) {
        best = play;
      } else {
        final current = CardEngine.parseCard(best.cardCode).rank.value;
        final challenger = CardEngine.parseCard(play.cardCode).rank.value;
        if (challenger > current) best = play;
      }
    }
    return best?.userId;
  }

  /// Returns true if [cardCode] would cut the current trick.
  static bool wouldCut(String cardCode, List<TrickPlay> plays) {
    final leading = detectLeadingSuit(plays);
    return isCut(cardCode, leading);
  }
}
