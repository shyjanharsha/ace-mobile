import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/leaderboard_model.dart';
import '../../data/repositories/leaderboard_repository.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>(
  (ref) => getIt<LeaderboardRepository>(),
);

class LeaderboardState {
  final String type;
  final String period;
  final AsyncValue<List<LeaderboardUserModel>> players;

  const LeaderboardState({
    required this.type,
    required this.period,
    required this.players,
  });

  LeaderboardState copyWith({
    String? type,
    String? period,
    AsyncValue<List<LeaderboardUserModel>>? players,
  }) {
    return LeaderboardState(
      type: type ?? this.type,
      period: period ?? this.period,
      players: players ?? this.players,
    );
  }
}

class LeaderboardNotifier extends Notifier<LeaderboardState> {
  LeaderboardRepository get _repository => ref.read(leaderboardRepositoryProvider);

  @override
  LeaderboardState build() {
    // Return initial state and trigger fetch
    Future.microtask(() => fetchLeaderboard());
    return const LeaderboardState(
      type: 'wins',
      period: 'all_time',
      players: AsyncValue.loading(),
    );
  }

  Future<void> fetchLeaderboard() async {
    state = state.copyWith(players: const AsyncValue.loading());
    try {
      final list = await _repository.getLeaderboard(
        type: state.type,
        period: state.period,
      );
      state = state.copyWith(players: AsyncValue.data(list));
    } catch (e, stack) {
      state = state.copyWith(players: AsyncValue.error(e, stack));
    }
  }

  void setType(String type) {
    if (state.type == type) return;
    state = state.copyWith(type: type);
    fetchLeaderboard();
  }

  void setPeriod(String period) {
    if (state.period == period) return;
    state = state.copyWith(period: period);
    fetchLeaderboard();
  }
}

final leaderboardProvider = NotifierProvider<LeaderboardNotifier, LeaderboardState>(LeaderboardNotifier.new);
