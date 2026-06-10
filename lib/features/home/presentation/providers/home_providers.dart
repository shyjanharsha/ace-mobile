import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:donkey_card_game/core/di/injection.dart';
import 'package:donkey_card_game/features/home/data/repositories/home_repository.dart';
import 'package:donkey_card_game/features/rooms/data/models/game_room_model.dart';
import 'package:donkey_card_game/features/home/data/models/friend_presence_model.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => getIt<HomeRepository>(),
);

final friendPresencesProvider = FutureProvider.autoDispose<List<FriendPresenceModel>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getFriendPresences();
});

final publicRoomsProvider = FutureProvider.autoDispose<List<GameRoomModel>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getPublicRooms();
});

// A notifier to manage room creation/joining operations
class RoomActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<GameRoomModel?> createRoom({
    required String roomType,
    required int maxPlayers,
    required int minPlayers,
    required int betCoins,
    required int moveTimeout,
    required bool allowSpectators,
  }) async {
    state = const AsyncValue.loading();
    GameRoomModel? room;
    state = await AsyncValue.guard(() async {
      room = await ref.read(homeRepositoryProvider).createRoom(
        roomType: roomType,
        maxPlayers: maxPlayers,
        minPlayers: minPlayers,
        betCoins: betCoins,
        moveTimeout: moveTimeout,
        allowSpectators: allowSpectators,
      );
    });
    return room;
  }

  Future<GameRoomModel?> joinRoomByCode(String code) async {
    state = const AsyncValue.loading();
    GameRoomModel? room;
    state = await AsyncValue.guard(() async {
      room = await ref.read(homeRepositoryProvider).joinRoomByCode(code);
    });
    return room;
  }

  Future<GameRoomModel?> joinRoom(int roomId) async {
    state = const AsyncValue.loading();
    GameRoomModel? room;
    state = await AsyncValue.guard(() async {
      room = await ref.read(homeRepositoryProvider).joinRoom(roomId);
    });
    return room;
  }
}

final roomActionProvider = AsyncNotifierProvider<RoomActionNotifier, void>(
  RoomActionNotifier.new,
);
