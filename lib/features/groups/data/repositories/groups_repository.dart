import '../datasources/groups_remote_datasource.dart';
import '../models/group_model.dart';

class GroupsRepository {
  final GroupsRemoteDataSource _remoteDataSource;

  GroupsRepository({required GroupsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<GroupModel>> getGroups() => _remoteDataSource.getGroups();

  Future<GroupModel> createGroup({
    required String name,
    String? description,
    String? avatarUrl,
    String? groupType,
  }) =>
      _remoteDataSource.createGroup(
        name: name,
        description: description,
        avatarUrl: avatarUrl,
        groupType: groupType,
      );

  Future<GroupModel> getGroupDetails(int groupId) =>
      _remoteDataSource.getGroupDetails(groupId);

  Future<GroupModel> updateGroup({
    required int groupId,
    String? name,
    String? description,
    String? avatarUrl,
    String? groupType,
  }) =>
      _remoteDataSource.updateGroup(
        groupId: groupId,
        name: name,
        description: description,
        avatarUrl: avatarUrl,
        groupType: groupType,
      );

  Future<void> deleteGroup(int groupId) => _remoteDataSource.deleteGroup(groupId);

  Future<GroupMemberModel> addMember({
    required int groupId,
    int? userId,
    String? inviteCode,
  }) =>
      _remoteDataSource.addMember(groupId: groupId, userId: userId, inviteCode: inviteCode);

  Future<void> removeMember({required int groupId, required int membershipId}) =>
      _remoteDataSource.removeMember(groupId: groupId, membershipId: membershipId);
}
