/// Handles turn ordering, player lifecycle, and donkey detection.
/// All methods are pure — no state mutation.
class TurnEngine {
  TurnEngine._();

  // -------------------------------------------------------
  // Turn order
  // -------------------------------------------------------

  /// Returns the next active player after [currentId] in clockwise order.
  ///
  /// [playerOrder] — full clockwise seat order (never changes during a game).
  /// [activePlayers] — players who still have cards (subset of playerOrder).
  ///
  /// Throws [StateError] if no active players remain.
  static int nextPlayer(
    int currentId,
    List<int> playerOrder,
    List<int> activePlayers,
  ) {
    if (activePlayers.isEmpty) throw StateError('No active players');
    if (activePlayers.length == 1) return activePlayers.first;

    // Walk the ordered list clockwise from currentId
    final startIdx = playerOrder.indexOf(currentId);
    final total = playerOrder.length;

    for (var offset = 1; offset <= total; offset++) {
      final candidate = playerOrder[(startIdx + offset) % total];
      if (activePlayers.contains(candidate)) return candidate;
    }

    // Fallback — should not reach here
    return activePlayers.first;
  }

  // -------------------------------------------------------
  // Active player management
  // -------------------------------------------------------

  /// Returns true if [userId] is still an active player.
  static bool isPlayerActive(int userId, List<int> activePlayers) {
    return activePlayers.contains(userId);
  }

  /// Removes [userId] from [activePlayers] and returns the new list.
  static List<int> removePlayer(int userId, List<int> activePlayers) {
    return List<int>.from(activePlayers)..remove(userId);
  }

  /// Returns active players who still have cards.
  static List<int> playersWithCards(
    Map<int, int> cardCounts,
    List<int> activePlayers,
  ) {
    return activePlayers
        .where((id) => (cardCounts[id] ?? 0) > 0)
        .toList();
  }

  // -------------------------------------------------------
  // Elimination & donkey detection
  // -------------------------------------------------------

  /// Returns true if [userId] should be eliminated (hand is empty).
  static bool shouldEliminate(int userId, Map<int, int> cardCounts) {
    return (cardCounts[userId] ?? 0) == 0;
  }

  /// Returns the donkey (last remaining player with cards), or null if
  /// the game is not over yet.
  ///
  /// The donkey is identified when only 1 player still has cards.
  static int? detectDonkey(
    Map<int, int> cardCounts,
    List<int> activePlayers,
  ) {
    final remaining = playersWithCards(cardCounts, activePlayers);
    return remaining.length == 1 ? remaining.first : null;
  }

  /// Returns true if the game is over (0 or 1 active player with cards).
  static bool isGameOver(
    Map<int, int> cardCounts,
    List<int> activePlayers,
  ) {
    return playersWithCards(cardCounts, activePlayers).length <= 1;
  }

  // -------------------------------------------------------
  // Clockwise validation
  // -------------------------------------------------------

  /// Returns the expected next player strictly following the clockwise order
  /// from [afterId]. Used after a normal trick to validate server-reported next.
  static int expectedNextFromOrder(
    int afterId,
    List<int> playerOrder,
    List<int> activePlayers,
  ) {
    return nextPlayer(afterId, playerOrder, activePlayers);
  }
}
