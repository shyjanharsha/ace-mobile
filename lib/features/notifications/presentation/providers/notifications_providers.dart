import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => getIt<NotificationsRepository>(),
);

class NotificationsNotifier extends Notifier<AsyncValue<List<NotificationModel>>> {
  NotificationsRepository get _repository => ref.read(notificationsRepositoryProvider);

  @override
  AsyncValue<List<NotificationModel>> build() {
    Future.microtask(() => fetchNotifications());
    return const AsyncValue.loading();
  }

  Future<void> fetchNotifications() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getNotifications();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _repository.markAsRead(notificationId: notificationId);
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((n) => n.id == notificationId ? n.copyWith(read: true) : n).toList(),
      );
    } catch (_) {
      // Keep state as is on failure
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAsRead();
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((n) => n.copyWith(read: true)).toList(),
      );
    } catch (_) {
      // Keep state as is on failure
    }
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, AsyncValue<List<NotificationModel>>>(NotificationsNotifier.new);
