import 'package:donkey_card_game/core/network/api_client.dart';
import 'package:donkey_card_game/core/constants/api_constants.dart';
import 'package:donkey_card_game/core/errors/app_exception.dart';
import 'package:donkey_card_game/features/rooms/data/models/game_room_model.dart';
import 'package:donkey_card_game/features/home/data/models/friend_presence_model.dart';

class HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<List<FriendPresenceModel>> getFriendPresences() async {
    try {
      final response = await _apiClient.get(ApiConstants.friendPresences);
      final list = (response.data as Map<String, dynamic>)['data'] as List;
      return list
          .map((json) => FriendPresenceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<GameRoomModel>> getPublicRooms() async {
    try {
      final response = await _apiClient.get(ApiConstants.rooms);
      final list = (response.data as Map<String, dynamic>)['data'] as List;
      return list
          .map((json) => GameRoomModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<GameRoomModel> createRoom({
    required String roomType,
    required int maxPlayers,
    required int minPlayers,
    required int betCoins,
    required int moveTimeout,
    required bool allowSpectators,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.rooms,
        data: {
          'room_type': roomType,
          'max_players': maxPlayers,
          'min_players': minPlayers,
          'bet_coins': betCoins,
          'move_timeout': moveTimeout,
          'allow_spectators': allowSpectators,
        },
      );
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return GameRoomModel.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<GameRoomModel> joinRoom(int roomId) async {
    try {
      final response = await _apiClient.post(ApiConstants.joinRoom(roomId));
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return GameRoomModel.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<GameRoomModel> joinRoomByCode(String code) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.joinByCode,
        data: {'code': code},
      );
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return GameRoomModel.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
