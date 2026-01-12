import 'package:equatable/equatable.dart';
import '../../../profile/domain/entity/address_entity.dart';

class UserEntity extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? password;
  final String? role;
  final String? profileImage;
  final List<AddressEntity>? addresses;
  final List<String>? wishlist; // List of Product IDs

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.password,
    this.role,
    this.profileImage,
    this.addresses,
    this.wishlist,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    role,
    profileImage,
    addresses,
    wishlist,
  ];
}
