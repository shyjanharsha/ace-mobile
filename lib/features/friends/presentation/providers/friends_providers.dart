import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/friendship_model.dart';
import '../../data/repositories/friends_repository.dart';

final friendsRepositoryProvider = Provider<FriendsRepository>(
  (ref) => getIt<FriendsRepository>(),
);

final friendshipsProvider = FutureProvider.autoDispose<List<FriendshipModel>>((ref) async {
  final repository = ref.watch(friendsRepositoryProvider);
  return repository.getFriendships();
});

class UserSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String val) {
    state = val;
  }
}

final userSearchQueryProvider = NotifierProvider.autoDispose<UserSearchQueryNotifier, String>(
  UserSearchQueryNotifier.new,
);

final userSearchProvider = FutureProvider.autoDispose<List<FriendshipUser>>((ref) async {
  final query = ref.watch(userSearchQueryProvider).trim();
  if (query.isEmpty) {
    return const [];
  }
  final repository = ref.watch(friendsRepositoryProvider);
  return repository.searchUsers(query);
});

// A notifier to manage friendships mutation operations
class FriendActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> sendFriendRequest(int receiverId) async {
    state = const AsyncValue.loading();
    bool success = false;
    state = await AsyncValue.guard(() async {
      await ref.read(friendsRepositoryProvider).sendFriendRequest(receiverId);
      success = true;
      ref.invalidate(friendshipsProvider);
    });
    return success;
  }

  Future<bool> respondToFriendRequest({
    required int friendshipId,
    required String actionType, // accept, decline, block
  }) async {
    state = const AsyncValue.loading();
    bool success = false;
    state = await AsyncValue.guard(() async {
      await ref.read(friendsRepositoryProvider).respondToFriendRequest(
            friendshipId: friendshipId,
            actionType: actionType,
          );
      success = true;
      ref.invalidate(friendshipsProvider);
    });
    return success;
  }

  Future<bool> removeFriend(int friendshipId) async {
    state = const AsyncValue.loading();
    bool success = false;
    state = await AsyncValue.guard(() async {
      await ref.read(friendsRepositoryProvider).removeFriend(friendshipId);
      success = true;
      ref.invalidate(friendshipsProvider);
    });
    return success;
  }
}

final friendActionProvider = AsyncNotifierProvider<FriendActionNotifier, void>(
  FriendActionNotifier.new,
);
