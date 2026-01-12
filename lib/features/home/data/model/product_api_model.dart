import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';

part 'product_api_model.g.dart';

@JsonSerializable()
class ProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String? botanicalName;
  final String? family;
  final dynamic category; 
  final String? description; 
  final double price;
  final double? discountPrice;
  final int stock;
  final String? image; 
  final List<String>? images; 
  final String? arModel;
  final Map<String, dynamic>? careProfile;
  final Map<String, dynamic>? details;
  final Map<String, dynamic>? tags;

  const ProductApiModel({
    this.id,
    required this.name,
    this.botanicalName,
    this.family,
    this.category,
    this.description,
    required this.price,
    this.discountPrice,
    required this.stock,
    this.image,
    this.images,
    this.arModel,
    this.careProfile,
    this.details,
    this.tags,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);

  // Mapper: API Model -> Domain Entity
  ProductEntity toEntity() {
    String? catName;
    String? catId;
    if (category is Map) {
      catName = category['name'];
      catId = category['_id'];
    } else {
      catId = category?.toString();
    }

    return ProductEntity(
      id: id,
      name: name,
      botanicalName: botanicalName,
      categoryName: catName,
      categoryId: catId,
      description: description ?? '', 
      price: price.toDouble(),
      discountPrice: discountPrice?.toDouble(),
      stock: stock,
      image: image ?? '', 
      images: images ?? [], 
      arModel: arModel,
      difficulty: careProfile?['difficulty'],
      light: careProfile?['light'],
      water: careProfile?['water'],
      temperature: careProfile?['temperature'],
      humidity: careProfile?['humidity'],
      family: family,
      height: details?['height'],
      potSize: details?['potSize'],
      isPetFriendly: tags?['isPetFriendly'],
      isAirPurifying: tags?['isAirPurifying'],
      isTrending: tags?['isTrending'],
    );
  }

  @override
  List<Object?> get props => [id, name, price, stock, image, arModel];
}
