/// Card suit enumeration
enum Suit {
  spades('S'),
  hearts('H'),
  diamonds('D'),
  clubs('C');

  const Suit(this.code);
  final String code;
}

/// Card rank enumeration (values 2–14, Ace high)
enum Rank {
  two('2', 2),
  three('3', 3),
  four('4', 4),
  five('5', 5),
  six('6', 6),
  seven('7', 7),
  eight('8', 8),
  nine('9', 9),
  ten('T', 10),
  jack('J', 11),
  queen('Q', 12),
  king('K', 13),
  ace('A', 14);

  const Rank(this.code, this.value);
  final String code;
  final int value;
}

/// Immutable representation of a single playing card.
class PlayingCard {
  const PlayingCard({required this.suit, required this.rank});

  final Suit suit;
  final Rank rank;

  /// E.g. "AS", "KH", "2C", "TD"
  String get code => '${rank.code}${suit.code}';

  @override
  bool operator ==(Object other) =>
      other is PlayingCard && other.suit == suit && other.rank == rank;

  @override
  int get hashCode => Object.hash(suit, rank);

  @override
  String toString() => code;
}
