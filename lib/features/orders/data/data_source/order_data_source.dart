import '../model/order_api_model.dart';
import '../../domain/entity/order_entity.dart';

abstract interface class IOrderDataSource {
  // Customer Methods
  Future<void> placeOrder(OrderEntity order);
  Future<List<OrderApiModel>> getMyOrders(String filter);
  Future<OrderApiModel> getOrderById(String id);
  Future<void> cancelOrder(String id);
  Future<String> getDeliveryQR(String id);

  // Admin Methods (Centralized here)
  Future<List<OrderApiModel>> getAllOrders({String? status});
}
