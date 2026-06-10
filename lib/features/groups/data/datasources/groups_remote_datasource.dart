import '../../../../core/network/api_client.dart';
import '../models/group_model.dart';

class GroupsRemoteDataSource {
  final ApiClient _apiClient;

  GroupsRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<GroupModel>> getGroups() async {
    final response = await _apiClient.get('/api/v1/groups');
    final list = response.data['data'] as List? ?? [];
    return list.map((e) => GroupModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<GroupModel> createGroup({
    required String name,
    String? description,
    String? avatarUrl,
    String? groupType,
  }) async {
    final response = await _apiClient.post(
      '/api/v1/groups',
      data: {
        'name': name,
        if (description != null) 'description': description,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (groupType != null) 'group_type': groupType,
      },
    );
    return GroupModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<GroupModel> getGroupDetails(int groupId) async {
    final response = await _apiClient.get('/api/v1/groups/$groupId');
    return GroupModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<GroupModel> updateGroup({
    required int groupId,
    String? name,
    String? description,
    String? avatarUrl,
    String? groupType,
  }) async {
    final response = await _apiClient.patch(
      '/api/v1/groups/$groupId',
      data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (groupType != null) 'group_type': groupType,
      },
    );
    return GroupModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteGroup(int groupId) async {
    await _apiClient.delete('/api/v1/groups/$groupId');
  }

  Future<GroupMemberModel> addMember({
    required int groupId,
    int? userId,
    String? inviteCode,
  }) async {
    final response = await _apiClient.post(
      '/api/v1/groups/$groupId/members',
      data: {
        if (userId != null) 'user_id': userId,
        if (inviteCode != null) 'invite_code': inviteCode,
      },
    );
    return GroupMemberModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> removeMember({required int groupId, required int membershipId}) async {
    await _apiClient.delete('/api/v1/groups/$groupId/members/$membershipId');
  }
}
