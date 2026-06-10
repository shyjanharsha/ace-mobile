import '../datasources/profile_remote_datasource.dart';
import '../../data/models/match_history_model.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository({required ProfileRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<MatchHistoryModel>> getMyMatches() => _remoteDataSource.getMyMatches();

  Future<Map<String, dynamic>> getUserStatistics(int userId) =>
      _remoteDataSource.getUserStatistics(userId);

  Future<UserModel> updateProfile({String? displayName, String? avatarUrl}) =>
      _remoteDataSource.updateProfile(displayName: displayName, avatarUrl: avatarUrl);

  Future<Map<String, dynamic>> syncContacts(List<String> phoneNumbers) =>
      _remoteDataSource.syncContacts(phoneNumbers);
}
