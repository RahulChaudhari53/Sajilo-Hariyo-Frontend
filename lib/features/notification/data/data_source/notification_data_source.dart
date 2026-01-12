import '../model/notification_api_model.dart';

abstract interface class INotificationDataSource {
  Future<List<NotificationApiModel>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}
