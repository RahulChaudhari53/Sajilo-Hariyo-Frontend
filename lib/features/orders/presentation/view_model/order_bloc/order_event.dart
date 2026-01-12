import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class FetchUserAddresses extends OrderEvent {}

class PlaceOrderEvent extends OrderEvent {
  final OrderEntity order;
  const PlaceOrderEvent(this.order);
}

class GetMyOrders extends OrderEvent {
  final String filter; // 'active' or 'history' (or empty for all/default)
  const GetMyOrders({this.filter = 'active'});
}

class CancelOrderEvent extends OrderEvent {
  final String orderId;
  const CancelOrderEvent(this.orderId);
  @override
  List<Object?> get props => [orderId];
}

class GetDeliveryQREvent extends OrderEvent {
  final String orderId;
  const GetDeliveryQREvent(this.orderId);
  @override
  List<Object?> get props => [orderId];
}
