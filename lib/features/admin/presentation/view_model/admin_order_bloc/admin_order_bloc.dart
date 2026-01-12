import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/admin/domain/use_case/get_admin_orders_usecase.dart';
import 'package:sajilo_hariyo/features/admin/domain/use_case/update_order_status_usecase.dart';
import 'package:sajilo_hariyo/features/admin/domain/usecase/verify_delivery_usecase.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_order_bloc/admin_order_event.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_order_bloc/admin_order_state.dart';

class AdminOrderBloc extends Bloc<AdminOrderEvent, AdminOrderState> {
  final GetAdminOrdersUseCase _getAdminOrdersUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final VerifyDeliveryUseCase _verifyDeliveryUseCase;

  AdminOrderBloc({
    required GetAdminOrdersUseCase getAdminOrdersUseCase,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
    required VerifyDeliveryUseCase verifyDeliveryUseCase,
  }) : _getAdminOrdersUseCase = getAdminOrdersUseCase,
       _updateOrderStatusUseCase = updateOrderStatusUseCase,
       _verifyDeliveryUseCase = verifyDeliveryUseCase,
       super(const AdminOrderState()) {
    on<LoadAdminOrdersEvent>(_onLoadAdminOrders);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<VerifyDeliveryQREvent>(_onVerifyDeliveryQR);
  }

  Future<void> _onLoadAdminOrders(
    LoadAdminOrdersEvent event,
    Emitter<AdminOrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, currentFilter: event.status));
    final result = await _getAdminOrdersUseCase(
      event.status == "New Orders" ? "Pending" : event.status,
    ); // Map UI tab name to API param if needed

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (orders) => emit(state.copyWith(isLoading: false, orders: orders)),
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<AdminOrderState> emit,
  ) async {
    // Optimistic or loading? Let's do loading for safer UX
    emit(state.copyWith(isLoading: true));
    final result = await _updateOrderStatusUseCase(
      UpdateOrderStatusParams(orderId: event.orderId, status: event.status),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) {
        // Success
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: "Order Updated Successfully",
          ),
        );
        // Refresh the list
        add(LoadAdminOrdersEvent(status: state.currentFilter));
      },
    );
  }

  Future<void> _onVerifyDeliveryQR(
    VerifyDeliveryQREvent event,
    Emitter<AdminOrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _verifyDeliveryUseCase(
      VerifyDeliveryParams(orderId: event.orderId, qrCode: event.qrCode),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) {
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: "Delivery Verified Successfully",
          ),
        );
        add(LoadAdminOrdersEvent(status: state.currentFilter));
      },
    );
  }
}
