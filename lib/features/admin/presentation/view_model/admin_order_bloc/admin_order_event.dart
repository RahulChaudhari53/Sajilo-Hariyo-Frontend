import 'package:equatable/equatable.dart';

abstract class AdminOrderEvent extends Equatable {
  const AdminOrderEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminOrdersEvent extends AdminOrderEvent {
  final String? status;

  const LoadAdminOrdersEvent({this.status});

  @override
  List<Object> get props => [status ?? 'All'];
}

class UpdateOrderStatusEvent extends AdminOrderEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatusEvent({required this.orderId, required this.status});

  @override
  @override
  List<Object> get props => [orderId, status];
}

class VerifyDeliveryQREvent extends AdminOrderEvent {
  final String orderId;
  final String qrCode;

  const VerifyDeliveryQREvent({required this.orderId, required this.qrCode});

  @override
  List<Object> get props => [orderId, qrCode];
}
