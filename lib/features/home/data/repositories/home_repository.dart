import 'package:donkey_card_game/features/rooms/data/models/game_room_model.dart';
import 'package:donkey_card_game/features/home/data/models/friend_presence_model.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepository({required HomeRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<FriendPresenceModel>> getFriendPresences() =>
      _remoteDataSource.getFriendPresences();

  Future<List<GameRoomModel>> getPublicRooms() =>
      _remoteDataSource.getPublicRooms();

  Future<GameRoomModel> createRoom({
    required String roomType,
    required int maxPlayers,
    required int minPlayers,
    required int betCoins,
    required int moveTimeout,
    required bool allowSpectators,
  }) =>
      _remoteDataSource.createRoom(
        roomType: roomType,
        maxPlayers: maxPlayers,
        minPlayers: minPlayers,
        betCoins: betCoins,
        moveTimeout: moveTimeout,
        allowSpectators: allowSpectators,
      );

  Future<GameRoomModel> joinRoom(int roomId) =>
      _remoteDataSource.joinRoom(roomId);

  Future<GameRoomModel> joinRoomByCode(String code) =>
      _remoteDataSource.joinRoomByCode(code);
}
