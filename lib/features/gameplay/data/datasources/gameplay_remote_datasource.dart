import '../../../../core/network/api_client.dart';
import '../models/match_model.dart';
import '../models/game_data_models.dart';

class GameplayRemoteDataSource {
  final ApiClient _apiClient;

  GameplayRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<MatchModel> getMatch(int matchId) async {
    final response = await _apiClient.get('/api/v1/matches/$matchId');
    final data = response.data as Map<String, dynamic>;
    return MatchModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<void> playCard({
    required int matchId,
    required String cardCode,
    required int moveSeq,
  }) async {
    await _apiClient.post(
      '/api/v1/game/$matchId/play',
      data: {
        'card_code': cardCode,
        'move_seq': moveSeq,
      },
    );
  }

  Future<void> reconnectGame(int matchId) async {
    await _apiClient.post('/api/v1/game/$matchId/reconnect');
  }

  /// Fetch full replay data for a completed match.
  Future<ReplayModel> getReplay(int matchId) async {
    final response = await _apiClient.get('/api/v1/matches/$matchId/replay');
    final data = response.data as Map<String, dynamic>;
    return ReplayModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// Fetch current live game state (used for reconnect resync fallback).
  Future<Map<String, dynamic>> getGameState(int matchId) async {
    final response = await _apiClient.get('/api/v1/game/$matchId/state');
    final data = response.data as Map<String, dynamic>;
    return data['data'] as Map<String, dynamic>;
  }
}
