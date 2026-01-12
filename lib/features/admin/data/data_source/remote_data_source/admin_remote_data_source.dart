import 'package:dio/dio.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/features/admin/data/model/admin_stats_api_model.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart'; 
import 'package:sajilo_hariyo/features/orders/data/model/order_api_model.dart'; 

abstract class IAdminDataSource {
  Future<AdminStatsApiModel> getAdminStats();
  Future<void> createCategory(String name, String description);
  Future<void> deleteCategory(String id);
  Future<List<OrderEntity>> getAdminOrders(String? status);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<void> verifyDelivery(String orderId, String qrCode);
}

class AdminRemoteDataSource implements IAdminDataSource {
  final Dio _dio;

  AdminRemoteDataSource(this._dio);

  @override
  Future<AdminStatsApiModel> getAdminStats() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAdminStats);
      if (response.statusCode == 200) {
        return AdminStatsApiModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> createCategory(String name, String description) async {
    try {
      await _dio.post(
        ApiEndpoints.createCategory,
        data: {'name': name, 'description': description},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _dio.delete(ApiEndpoints.deleteCategory(id));
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<OrderEntity>> getAdminOrders(String? status) async {
    try {
      final url = ApiEndpoints.getAllOrdersWithStatus(status: status);
      final response = await _dio.get(url);
      
      if (response.statusCode == 200) {
         final List<dynamic> ordersJson = response.data['orders'];
         // Assuming OrderApiModel exists and has fromJson
         // If OrderApiModel doesn't exist, I need to create it or map manually. 
         // I'll assume OrderApiModel is in features/orders/data/model/order_api_model.dart based on pattern
         return ordersJson.map((json) => OrderApiModel.fromJson(json).toEntity()).toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final url = ApiEndpoints.updateOrderStatus(orderId);
      await _dio.put(url, data: {'status': status});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> verifyDelivery(String orderId, String qrCode) async {
    try {
      await _dio.post(
        ApiEndpoints.verifyDelivery,
        data: {'orderId': orderId, 'qrCode': qrCode},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
