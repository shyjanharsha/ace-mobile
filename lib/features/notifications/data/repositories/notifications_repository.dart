import '../datasources/notifications_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationsRepository({required NotificationsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<NotificationModel>> getNotifications() => _remoteDataSource.getNotifications();

  Future<void> markAsRead({int? notificationId}) =>
      _remoteDataSource.markAsRead(notificationId: notificationId);
}
