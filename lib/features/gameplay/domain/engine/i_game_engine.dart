import 'dart:async';
import '../../presentation/providers/gameplay_providers.dart';

abstract class IGameEngine {
  GameplayState get state;
  Stream<GameplayState> get stateStream;

  Future<void> init(int matchId, {List<dynamic>? offlineBots});
  Future<void> playCard(String cardCode);
  Future<void> reconnectGame();
  void clearError();
  void dispose();
}
