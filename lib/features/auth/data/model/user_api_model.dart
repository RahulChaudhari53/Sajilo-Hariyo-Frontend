import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_hariyo/features/profile/data/model/address_api_model.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  final String name;
  final String email;
  final String phone;
  final String? password;
  final String? role;
  
  @JsonKey(name: 'profileImage')
  final String? profileImage;

  final List<AddressApiModel>? addresses;
  final List<String>? wishlist;

  const UserApiModel({
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

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    phone: phone,
    password: password,
    role: role,
    profileImage: profileImage,
    addresses: addresses?.map((e) => e.toEntity()).toList(),
    wishlist: wishlist,
  );

  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      password: entity.password,
      role: entity.role,
      profileImage: entity.profileImage,
      addresses: entity.addresses?.map((e) => AddressApiModel.fromEntity(e)).toList(),
      wishlist: entity.wishlist,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, password, role, profileImage, addresses, wishlist];
}
