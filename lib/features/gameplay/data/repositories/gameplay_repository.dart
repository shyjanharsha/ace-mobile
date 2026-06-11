import '../datasources/gameplay_remote_datasource.dart';
import '../models/match_model.dart';
import '../models/game_data_models.dart';

class GameplayRepository {
  final GameplayRemoteDataSource _dataSource;

  GameplayRepository({required GameplayRemoteDataSource dataSource})
      : _dataSource = dataSource;

  Future<MatchModel> getMatch(int matchId) {
    return _dataSource.getMatch(matchId);
  }

  Future<void> playCard({
    required int matchId,
    required String cardCode,
    required int moveSeq,
  }) {
    return _dataSource.playCard(
      matchId: matchId,
      cardCode: cardCode,
      moveSeq: moveSeq,
    );
  }

  Future<void> reconnectGame(int matchId) {
    return _dataSource.reconnectGame(matchId);
  }

  Future<ReplayModel> getReplay(int matchId) {
    return _dataSource.getReplay(matchId);
  }

  Future<Map<String, dynamic>> getGameState(int matchId) {
    return _dataSource.getGameState(matchId);
  }
}
