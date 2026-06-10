import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/match_history_model.dart';
import '../../data/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => getIt<ProfileRepository>(),
);

// -------------------------------------------------------
// Match History Provider
// -------------------------------------------------------
class MatchHistoryNotifier extends Notifier<AsyncValue<List<MatchHistoryModel>>> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  AsyncValue<List<MatchHistoryModel>> build() {
    Future.microtask(() => fetchMatches());
    return const AsyncValue.loading();
  }

  Future<void> fetchMatches() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getMyMatches();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final matchHistoryProvider =
    NotifierProvider<MatchHistoryNotifier, AsyncValue<List<MatchHistoryModel>>>(MatchHistoryNotifier.new);

// -------------------------------------------------------
// Profile Statistics Provider
// -------------------------------------------------------
final userStatisticsProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, userId) {
  final repo = ref.read(profileRepositoryProvider);
  return repo.getUserStatistics(userId);
});

// -------------------------------------------------------
// Profile Update Provider
// -------------------------------------------------------
class ProfileUpdateNotifier extends Notifier<AsyncValue<void>> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> updateProfile({required String displayName, required String avatarUrl}) async {
    state = const AsyncValue.loading();
    try {
      final updatedUser = await _repository.updateProfile(
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
      ref.read(authStateProvider.notifier).updateSessionUser(updatedUser);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

final profileUpdateProvider =
    NotifierProvider<ProfileUpdateNotifier, AsyncValue<void>>(ProfileUpdateNotifier.new);

// -------------------------------------------------------
// Contact Sync Provider
// -------------------------------------------------------
class ContactSyncState {
  final bool isLoading;
  final List<dynamic> matchedContacts;
  final int totalSynced;
  final String? error;

  const ContactSyncState({
    this.isLoading = false,
    this.matchedContacts = const [],
    this.totalSynced = 0,
    this.error,
  });

  ContactSyncState copyWith({
    bool? isLoading,
    List<dynamic>? matchedContacts,
    int? totalSynced,
    String? error,
  }) {
    return ContactSyncState(
      isLoading: isLoading ?? this.isLoading,
      matchedContacts: matchedContacts ?? this.matchedContacts,
      totalSynced: totalSynced ?? this.totalSynced,
      error: error,
    );
  }
}

class ContactSyncNotifier extends Notifier<ContactSyncState> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  ContactSyncState build() {
    return const ContactSyncState();
  }

  Future<void> syncContacts(List<String> phoneNumbers) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repository.syncContacts(phoneNumbers);
      state = state.copyWith(
        isLoading: false,
        matchedContacts: data['matched_contacts'] as List? ?? [],
        totalSynced: data['total_synced'] as int? ?? 0,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final contactSyncProvider =
    NotifierProvider<ContactSyncNotifier, ContactSyncState>(ContactSyncNotifier.new);
