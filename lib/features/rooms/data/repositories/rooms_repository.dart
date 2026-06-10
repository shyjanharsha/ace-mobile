import '../datasources/rooms_remote_datasource.dart';
import '../models/game_room_model.dart';

class RoomsRepository {
  final RoomsRemoteDataSource _remoteDataSource;

  RoomsRepository({required RoomsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<GameRoomModel> getRoom(int roomId) => _remoteDataSource.getRoom(roomId);

  Future<void> leaveRoom(int roomId) => _remoteDataSource.leaveRoom(roomId);

  Future<void> startGame(int roomId) => _remoteDataSource.startGame(roomId);

  Future<void> invitePlayer({required int roomId, required int receiverId}) =>
      _remoteDataSource.invitePlayer(roomId: roomId, receiverId: receiverId);
}
