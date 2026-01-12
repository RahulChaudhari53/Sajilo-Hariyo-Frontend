import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/orders/domain/entity/order_entity.dart';

class AdminOrderState extends Equatable {
  final List<OrderEntity> orders;
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final String currentFilter; // Store current filter to refresh list after update

  const AdminOrderState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.currentFilter = 'All',
  });

  AdminOrderState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    String? error,
    String? successMessage,
    String? currentFilter,
  }) {
    return AdminOrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Should clear error on new state usually, but this is simple copyWith
      successMessage: successMessage, // Same for success message
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, error, successMessage, currentFilter];
}
