import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/address_entity.dart';

part 'address_api_model.g.dart';

String? _readId(Map<dynamic, dynamic> json, String key) {
  return json['_id'] as String? ??
      json['id'] as String? ??
      json['addressId'] as String?;
}

@JsonSerializable()
class AddressApiModel extends Equatable {
  @JsonKey(name: '_id', readValue: _readId)
  final String? id;
  final String label;
  final String street;
  final String city;
  final String detail;
  final String phone;

  const AddressApiModel({
    this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.detail,
    required this.phone,
  });

  factory AddressApiModel.fromJson(Map<String, dynamic> json) =>
      _$AddressApiModelFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$AddressApiModelToJson(this);
    json.removeWhere((key, value) => value == null);
    return json;
  }

  // Mapper: API Model -> Domain Entity
  AddressEntity toEntity() => AddressEntity(
    id: id,
    label: label,
    street: street,
    city: city,
    detail: detail,
    phone: phone,
  );

  // Mapper: Domain Entity -> API Model (Useful for POST/PATCH requests)
  factory AddressApiModel.fromEntity(AddressEntity entity) {
    return AddressApiModel(
      id: entity.id,
      label: entity.label,
      street: entity.street,
      city: entity.city,
      detail: entity.detail,
      phone: entity.phone,
    );
  }

  @override
  List<Object?> get props => [id, label, street, city, detail, phone];
}
