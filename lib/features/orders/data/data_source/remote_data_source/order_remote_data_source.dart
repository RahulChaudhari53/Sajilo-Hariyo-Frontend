import 'package:dio/dio.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/features/orders/data/model/order_api_model.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';

import '../order_data_source.dart';

class OrderRemoteDataSource implements IOrderDataSource {
  final Dio _dio;

  OrderRemoteDataSource(this._dio);

  @override
  Future<void> placeOrder(OrderEntity order) async {
    try {
      // Map domain entity to the structure backend expects
      final Map<String, dynamic> orderData = {
        "orderItems": order.items
            .map(
              (item) => {
                "name": item.name,
                "qty": item.quantity,
                "image": item.image,
                "price": item.price,
                "product": item.productId,
              },
            )
            .toList(),
        "shippingInfo": {
          "address": order.shippingAddress,
          "city": order.city,
          "phone": order.phone,
        },
        "paymentInfo": {
          "status": "unpaid",
          "method": "COD", // Hardcoded as per your requirement
        },
        "totalAmount": order.totalAmount,
      };

      var response = await _dio.post(ApiEndpoints.placeOrder, data: orderData);

      if (response.statusCode != 201) {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<OrderApiModel>> getMyOrders(String filter) async {
    try {
      final url = ApiEndpoints.getMyOrdersWithFilter(filter: filter);
      var response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic>? ordersJson = response.data['orders'];
        if (ordersJson == null) return [];
        return ordersJson.map((json) => OrderApiModel.fromJson(json)).toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<OrderApiModel> getOrderById(String id) async {
    try {
      var response = await _dio.get(ApiEndpoints.getOrderById(id));
      if (response.statusCode == 200) {
        return OrderApiModel.fromJson(response.data['order']);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> cancelOrder(String id) async {
    try {
      var response = await _dio.put(ApiEndpoints.cancelOrder(id));
      if (response.statusCode != 200) {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<String> getDeliveryQR(String id) async {
    try {
      var response = await _dio.get(ApiEndpoints.getDeliveryQR(id));
      if (response.statusCode == 200) {
        // Backend returns: { status: "success", data: { deliveryCode: "..." } }
        return response.data['data']['deliveryCode'].toString();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<OrderApiModel>> getAllOrders({String? status}) async {
    try {
      final url = ApiEndpoints.getAllOrdersWithStatus(status: status);
      var response = await _dio.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = response.data['orders'];
        return ordersJson.map((json) => OrderApiModel.fromJson(json)).toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
