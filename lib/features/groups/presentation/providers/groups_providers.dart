import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/group_model.dart';
import '../../data/repositories/groups_repository.dart';

final groupsRepositoryProvider = Provider<GroupsRepository>(
  (ref) => getIt<GroupsRepository>(),
);

// -------------------------------------------------------
// List of Groups Provider
// -------------------------------------------------------
class GroupsNotifier extends Notifier<AsyncValue<List<GroupModel>>> {
  GroupsRepository get _repository => ref.read(groupsRepositoryProvider);

  @override
  AsyncValue<List<GroupModel>> build() {
    Future.microtask(() => fetchGroups());
    return const AsyncValue.loading();
  }

  Future<void> fetchGroups() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getGroups();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<GroupModel?> createGroup({
    required String name,
    String? description,
    String? avatarUrl,
    String? groupType,
  }) async {
    try {
      final newGroup = await _repository.createGroup(
        name: name,
        description: description,
        avatarUrl: avatarUrl,
        groupType: groupType,
      );
      final currentList = state.value ?? [];
      state = AsyncValue.data([newGroup, ...currentList]);
      return newGroup;
    } catch (e) {
      return null;
    }
  }
}

final groupsProvider =
    NotifierProvider<GroupsNotifier, AsyncValue<List<GroupModel>>>(GroupsNotifier.new);

// -------------------------------------------------------
// Group Details Provider (Family)
// -------------------------------------------------------
class GroupDetailsNotifier extends Notifier<AsyncValue<GroupModel>> {
  GroupDetailsNotifier(this._groupId);
  final int _groupId;

  GroupsRepository get _repository => ref.read(groupsRepositoryProvider);

  @override
  AsyncValue<GroupModel> build() {
    Future.microtask(() => fetchDetails());
    return const AsyncValue.loading();
  }

  Future<void> fetchDetails() async {
    state = const AsyncValue.loading();
    try {
      final details = await _repository.getGroupDetails(_groupId);
      state = AsyncValue.data(details);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> inviteUser(int userId) async {
    try {
      final current = state.value;
      if (current == null) return false;

      final newMember = await _repository.addMember(groupId: _groupId, userId: userId);
      final updatedMembers = <GroupMemberModel>[...(current.members ?? []), newMember];
      
      state = AsyncValue.data(current.copyWith(
        members: updatedMembers,
        membersCount: updatedMembers.length,
      ));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> joinWithInviteCode(String inviteCode) async {
    try {
      final current = state.value;
      if (current == null) return false;

      final newMember = await _repository.addMember(groupId: _groupId, inviteCode: inviteCode);
      final updatedMembers = <GroupMemberModel>[...(current.members ?? []), newMember];
      
      state = AsyncValue.data(current.copyWith(
        members: updatedMembers,
        membersCount: updatedMembers.length,
      ));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeOrLeaveMember(int membershipId) async {
    try {
      final current = state.value;
      if (current == null) return false;

      await _repository.removeMember(groupId: _groupId, membershipId: membershipId);
      final updatedMembers = (current.members ?? []).where((m) => m.id != membershipId).toList();
      
      state = AsyncValue.data(current.copyWith(
        members: updatedMembers,
        membersCount: updatedMembers.length,
      ));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateGroupDetails({
    String? name,
    String? description,
    String? avatarUrl,
    String? groupType,
  }) async {
    try {
      final current = state.value;
      if (current == null) return false;

      final updated = await _repository.updateGroup(
        groupId: _groupId,
        name: name,
        description: description,
        avatarUrl: avatarUrl,
        groupType: groupType,
      );
      
      state = AsyncValue.data(current.copyWith(
        name: updated.name,
        description: updated.description,
        avatarUrl: updated.avatarUrl,
        groupType: updated.groupType,
      ));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteGroup() async {
    try {
      await _repository.deleteGroup(_groupId);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final groupDetailsProvider =
    NotifierProvider.family<GroupDetailsNotifier, AsyncValue<GroupModel>, int>(GroupDetailsNotifier.new);
