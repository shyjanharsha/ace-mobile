import 'package:donkey_card_game/core/network/api_client.dart';
import 'package:donkey_card_game/core/constants/api_constants.dart';
import 'package:donkey_card_game/core/errors/app_exception.dart';
import 'package:donkey_card_game/features/friends/data/models/friendship_model.dart';

class FriendsRemoteDataSource {
  final ApiClient _apiClient;

  FriendsRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<List<FriendshipModel>> getFriendships() async {
    try {
      final response = await _apiClient.get(ApiConstants.friendships);
      final list = (response.data as Map<String, dynamic>)['data'] as List;
      return list
          .map((json) => FriendshipModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<FriendshipUser>> searchUsers(String query) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.users,
        queryParameters: {'query': query},
      );
      final list = (response.data as Map<String, dynamic>)['data'] as List;
      return list
          .map((json) => FriendshipUser.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<FriendshipModel> sendFriendRequest(int receiverId) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.friendships,
        data: {'receiver_id': receiverId},
      );
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return FriendshipModel.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<FriendshipModel> respondToFriendRequest({
    required int friendshipId,
    required String actionType, // accept, decline, block
  }) async {
    try {
      final response = await _apiClient.patch(
        ApiConstants.friendship(friendshipId),
        data: {'action_type': actionType},
      );
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return FriendshipModel.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> removeFriend(int friendshipId) async {
    try {
      await _apiClient.delete(ApiConstants.friendship(friendshipId));
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
