import '../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationsRemoteDataSource {
  final ApiClient _apiClient;

  NotificationsRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get('/api/v1/notifications');
    final list = response.data['data'] as List? ?? [];
    return list.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> markAsRead({int? notificationId}) async {
    await _apiClient.patch(
      '/api/v1/notifications/mark_read',
      data: notificationId != null ? {'notification_id': notificationId} : null,
    );
  }
}
