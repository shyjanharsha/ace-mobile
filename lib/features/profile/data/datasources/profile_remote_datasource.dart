import '../../../../core/network/api_client.dart';
import '../../data/models/match_history_model.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<MatchHistoryModel>> getMyMatches() async {
    final response = await _apiClient.get('/api/v1/users/me/matches');
    final list = response.data['data'] as List? ?? [];
    return list.map((e) => MatchHistoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> getUserStatistics(int userId) async {
    final response = await _apiClient.get('/api/v1/users/$userId/statistics');
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<UserModel> updateProfile({String? displayName, String? avatarUrl}) async {
    final response = await _apiClient.patch(
      '/api/v1/users/me',
      data: {
        if (displayName != null) 'display_name': displayName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      },
    );
    return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> syncContacts(List<String> phoneNumbers) async {
    final response = await _apiClient.post(
      '/api/v1/contacts/sync',
      data: {'phone_numbers': phoneNumbers},
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
