import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';

class OrderState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final List<AddressEntity> addresses;
  final List<OrderEntity> orders; // Added orders list
  final String? errorMessage;

  final bool orderCanceled;
  final String? deliveryQR;

  const OrderState({
    required this.isLoading,
    required this.isSuccess,
    required this.addresses,
    this.orders = const [],
    this.errorMessage,
    this.orderCanceled = false,
    this.deliveryQR,
  });

  factory OrderState.initial() => const OrderState(
    isLoading: false,
    isSuccess: false,
    addresses: [],
    orders: [],
    errorMessage: null,
    orderCanceled: false,
    deliveryQR: null,
  );

  OrderState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<AddressEntity>? addresses,
    List<OrderEntity>? orders,
    String? errorMessage,
    bool? orderCanceled,
    String? deliveryQR,
    bool clearDeliveryQR = false,
    bool clearErrorMessage = false,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      addresses: addresses ?? this.addresses,
      orders: orders ?? this.orders,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      orderCanceled: orderCanceled ?? this.orderCanceled,
      deliveryQR: clearDeliveryQR ? null : (deliveryQR ?? this.deliveryQR),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    addresses,
    orders,
    errorMessage,
    orderCanceled,
    deliveryQR,
  ];
}
