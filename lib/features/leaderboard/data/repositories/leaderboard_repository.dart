import '../datasources/leaderboard_remote_datasource.dart';
import '../models/leaderboard_model.dart';

class LeaderboardRepository {
  final LeaderboardRemoteDataSource _remoteDataSource;

  LeaderboardRepository({required LeaderboardRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<LeaderboardUserModel>> getLeaderboard({
    required String type,
    required String period,
  }) =>
      _remoteDataSource.getLeaderboard(type: type, period: period);
}
