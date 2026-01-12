// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
  id: json['_id'] as String?,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  password: json['password'] as String?,
  role: json['role'] as String?,
  profileImage: json['profileImage'] as String?,
  addresses: (json['addresses'] as List<dynamic>?)
      ?.map((e) => AddressApiModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  wishlist: (json['wishlist'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'role': instance.role,
      'profileImage': instance.profileImage,
      'addresses': instance.addresses,
      'wishlist': instance.wishlist,
    };
