import 'package:dio/dio.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/features/notification/data/model/notification_api_model.dart';
import 'package:sajilo_hariyo/features/notification/domain/entity/notification_entity.dart';

abstract class INotificationDataSource {
  Future<List<NotificationApiModel>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class NotificationRemoteDataSource implements INotificationDataSource {
  final Dio _dio;
  NotificationRemoteDataSource(this._dio);

  @override
  Future<List<NotificationApiModel>> getNotifications() async {
    try {
      final response = await _dio.get(ApiEndpoints.getNotifications);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data']['notifications'];
        return jsonList
            .map((e) => NotificationApiModel.fromJson(e))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      await _dio.patch(ApiEndpoints.markNotificationRead(id));
      // No return value needed, just success
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _dio.patch(ApiEndpoints.markAllNotificationsRead);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
