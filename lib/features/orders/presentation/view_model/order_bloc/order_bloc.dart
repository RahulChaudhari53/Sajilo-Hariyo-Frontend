import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/orders/domain/usecase/place_order_usecase.dart';
import 'package:sajilo_hariyo/features/orders/domain/usecase/get_my_orders_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/repository/user_repository.dart';
import 'order_event.dart';
import 'package:sajilo_hariyo/features/orders/domain/usecase/cancel_order_usecase.dart';
import 'package:sajilo_hariyo/features/orders/domain/usecase/get_delivery_qr_usecase.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetMyOrdersUseCase _getMyOrdersUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  final GetDeliveryQRUseCase _getDeliveryQRUseCase;
  final IUserRepository _userRepository;

  OrderBloc({
    required PlaceOrderUseCase placeOrderUseCase,
    required GetMyOrdersUseCase getMyOrdersUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
    required GetDeliveryQRUseCase getDeliveryQRUseCase,
    required IUserRepository userRepository,
  }) : _placeOrderUseCase = placeOrderUseCase,
       _getMyOrdersUseCase = getMyOrdersUseCase,
       _cancelOrderUseCase = cancelOrderUseCase,
       _getDeliveryQRUseCase = getDeliveryQRUseCase,
       _userRepository = userRepository,
       super(OrderState.initial()) {
    on<FetchUserAddresses>(_onFetchAddresses);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<GetMyOrders>(_onGetMyOrders);
    on<CancelOrderEvent>(_onCancelOrder);
    on<GetDeliveryQREvent>(_onGetDeliveryQR);
  }

  Future<void> _onFetchAddresses(
    FetchUserAddresses event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userRepository.getProfile();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (user) => emit(
        state.copyWith(isLoading: false, addresses: user.addresses ?? []),
      ),
    );
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _placeOrderUseCase(event.order);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, isSuccess: true)),
    );
  }

  Future<void> _onGetMyOrders(
    GetMyOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    final result = await _getMyOrdersUseCase(event.filter);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (orders) => emit(state.copyWith(isLoading: false, orders: orders)),
    );
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, orderCanceled: false));
    final result = await _cancelOrderUseCase(event.orderId);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, orderCanceled: true)),
    );
  }

  Future<void> _onGetDeliveryQR(
    GetDeliveryQREvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearDeliveryQR: true));
    final result = await _getDeliveryQRUseCase(event.orderId);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (qrCode) => emit(state.copyWith(isLoading: false, deliveryQR: qrCode)),
    );
  }
}
