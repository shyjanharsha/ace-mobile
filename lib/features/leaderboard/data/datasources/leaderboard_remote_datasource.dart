import '../../../../core/network/api_client.dart';
import '../models/leaderboard_model.dart';

class LeaderboardRemoteDataSource {
  final ApiClient _apiClient;

  LeaderboardRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<LeaderboardUserModel>> getLeaderboard({
    required String type,
    required String period,
  }) async {
    final response = await _apiClient.get(
      '/api/v1/leaderboard',
      queryParameters: {
        'type': type,
        'period': period,
      },
    );
    final list = response.data['data'] as List? ?? [];
    return list.map((e) => LeaderboardUserModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
