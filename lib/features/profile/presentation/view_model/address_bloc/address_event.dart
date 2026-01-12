import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';

sealed class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class LoadAddressesEvent extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final AddressEntity address;
  const AddAddressEvent(this.address);

  @override
  List<Object> get props => [address];
}

class UpdateAddressEvent extends AddressEvent {
  final AddressEntity address;
  const UpdateAddressEvent(this.address);

  @override
  List<Object> get props => [address];
}

class DeleteAddressEvent extends AddressEvent {
  final String addressId;
  const DeleteAddressEvent(this.addressId);

  @override
  List<Object> get props => [addressId];
}
