import 'package:donkey_card_game/features/friends/data/models/friendship_model.dart';
import '../datasources/friends_remote_datasource.dart';

class FriendsRepository {
  final FriendsRemoteDataSource _remoteDataSource;

  FriendsRepository({required FriendsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<FriendshipModel>> getFriendships() =>
      _remoteDataSource.getFriendships();

  Future<List<FriendshipUser>> searchUsers(String query) =>
      _remoteDataSource.searchUsers(query);

  Future<FriendshipModel> sendFriendRequest(int receiverId) =>
      _remoteDataSource.sendFriendRequest(receiverId);

  Future<FriendshipModel> respondToFriendRequest({
    required int friendshipId,
    required String actionType, // accept, decline, block
  }) =>
      _remoteDataSource.respondToFriendRequest(
        friendshipId: friendshipId,
        actionType: actionType,
      );

  Future<void> removeFriend(int friendshipId) =>
      _remoteDataSource.removeFriend(friendshipId);
}
