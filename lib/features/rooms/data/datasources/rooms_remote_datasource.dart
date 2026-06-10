import '../../../../core/network/api_client.dart';
import '../models/game_room_model.dart';

class RoomsRemoteDataSource {
  final ApiClient _apiClient;

  RoomsRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<GameRoomModel> getRoom(int roomId) async {
    final response = await _apiClient.get('/api/v1/rooms/$roomId');
    final data = response.data as Map<String, dynamic>;
    return GameRoomModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<void> leaveRoom(int roomId) async {
    await _apiClient.delete('/api/v1/rooms/$roomId/leave');
  }

  Future<void> startGame(int roomId) async {
    await _apiClient.post('/api/v1/rooms/$roomId/start');
  }

  Future<void> invitePlayer({required int roomId, required int receiverId}) async {
    await _apiClient.post('/api/v1/invitations', data: {
      'room_id': roomId,
      'receiver_id': receiverId,
    });
  }
}
