import 'dart:math';
import '../../data/models/card_model.dart';


/// Pure-Dart card engine — no Flutter, no IO.
/// Handles deck construction, parsing, hand management, and card selection.
class CardEngine {
  CardEngine._();

  // -------------------------------------------------------
  // Deck
  // -------------------------------------------------------

  /// Builds a standard 52-card deck in suit/rank order.
  static List<PlayingCard> buildDeck() {
    return [
      for (final suit in Suit.values)
        for (final rank in Rank.values) PlayingCard(suit: suit, rank: rank),
    ];
  }

  /// Shuffles a copy of the deck and returns it.
  static List<PlayingCard> shuffleDeck({int? seed}) {
    final deck = buildDeck();
    deck.shuffle(seed != null ? Random(seed) : Random());
    return deck;
  }

  /// Deals [deck] evenly into [playerCount] hands.
  /// Returns a list where index = player index.
  static List<List<PlayingCard>> dealCards(
    List<PlayingCard> deck,
    int playerCount,
  ) {
    final hands = List.generate(playerCount, (_) => <PlayingCard>[]);
    for (var i = 0; i < deck.length; i++) {
      hands[i % playerCount].add(deck[i]);
    }
    return hands;
  }

  // -------------------------------------------------------
  // Parsing
  // -------------------------------------------------------

  /// Parses a 2-char card code like "AS", "KH", "TD", "2C".
  static PlayingCard parseCard(String code) {
    if (code.length < 2) throw ArgumentError('Invalid card code: $code');
    final rankCode = code.substring(0, code.length - 1);
    final suitCode = code[code.length - 1];

    final suit = Suit.values.firstWhere(
      (s) => s.code == suitCode,
      orElse: () => throw ArgumentError('Unknown suit: $suitCode in "$code"'),
    );
    final rank = Rank.values.firstWhere(
      (r) => r.code == rankCode,
      orElse: () => throw ArgumentError('Unknown rank: $rankCode in "$code"'),
    );
    return PlayingCard(suit: suit, rank: rank);
  }

  /// Converts a [PlayingCard] to its 2-char string code.
  static String cardToCode(PlayingCard card) => card.code;

  // -------------------------------------------------------
  // Rank / Suit helpers
  // -------------------------------------------------------

  /// Returns the numeric value of a rank (2–14).
  static int rankValue(Rank rank) => rank.value;

  /// Returns the suit character for a card code.
  static String suitOf(String code) => code[code.length - 1];

  // -------------------------------------------------------
  // Hand management
  // -------------------------------------------------------

  /// Sorts a list of card codes: grouped by suit (S>H>D>C), then by rank asc.
  static List<String> sortHand(List<String> hand) {
    const suitOrder = {'S': 0, 'H': 1, 'D': 2, 'C': 3};
    final copy = List<String>.from(hand);
    copy.sort((a, b) {
      final suitA = suitOrder[suitOf(a)] ?? 4;
      final suitB = suitOrder[suitOf(b)] ?? 4;
      if (suitA != suitB) return suitA.compareTo(suitB);
      final cardA = parseCard(a);
      final cardB = parseCard(b);
      return cardA.rank.value.compareTo(cardB.rank.value);
    });
    return copy;
  }

  /// Returns all cards in [hand] that are legal to play given [leadingSuit].
  ///
  /// Rules:
  /// - If no leading suit has been set (first play of trick), all cards are playable.
  /// - If the player has one or more cards of the leading suit, only those may be played.
  /// - If the player has no cards of the leading suit, all cards are playable (cut).
  static List<String> getPlayableCards(
    List<String> hand,
    String? leadingSuit,
  ) {
    if (leadingSuit == null) return List.from(hand);

    final suitCards = hand.where((c) => suitOf(c) == leadingSuit).toList();
    return suitCards.isNotEmpty ? suitCards : List.from(hand);
  }

  /// Returns whether [hand] contains at least one card of [suit].
  static bool hasSuit(List<String> hand, String suit) {
    return hand.any((c) => suitOf(c) == suit);
  }

  /// Finds the Ace of Spades holder from a map of userId → hand.
  static int? findAceOfSpadesHolder(Map<int, List<String>> hands) {
    for (final entry in hands.entries) {
      if (entry.value.contains('AS')) return entry.key;
    }
    return null;
  }

  // -------------------------------------------------------
  // Card comparison
  // -------------------------------------------------------

  /// Returns the higher card between two, considering only [leadingSuit].
  /// If neither is the leading suit, returns null (no winner yet from these two).
  static String? higherCard(
    String cardA,
    String cardB,
    String leadingSuit,
  ) {
    final sA = suitOf(cardA);
    final sB = suitOf(cardB);
    final aIsLeading = sA == leadingSuit;
    final bIsLeading = sB == leadingSuit;

    if (aIsLeading && !bIsLeading) return cardA;
    if (!aIsLeading && bIsLeading) return cardB;
    if (!aIsLeading && !bIsLeading) return null;

    // Both are leading suit — compare rank
    final rA = parseCard(cardA).rank.value;
    final rB = parseCard(cardB).rank.value;
    return rA >= rB ? cardA : cardB;
  }
}
