import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';

enum AddressStatus { initial, loading, success, failure }

class AddressState extends Equatable {
  final AddressStatus status;
  final List<AddressEntity> addresses;
  final String? message;

  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.message,
  });

  AddressState copyWith({
    AddressStatus? status,
    List<AddressEntity>? addresses,
    String? message,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, addresses, message];
}
