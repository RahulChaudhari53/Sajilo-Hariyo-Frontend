import '../model/admin_stats_api_model.dart';

abstract interface class IAdminDataSource {
  Future<AdminStatsApiModel> getAdminStats();
  Future<void> createCategory(String name);
  Future<void> deleteCategory(String id);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<void> verifyDelivery(String orderId, String qrCode);
}
