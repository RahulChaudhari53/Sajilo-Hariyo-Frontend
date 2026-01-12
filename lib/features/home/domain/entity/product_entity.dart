import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String name;
  final String? botanicalName;
  final String? categoryName;
  final String? categoryId;
  final String description;
  final double price;
  final double? discountPrice;
  final int stock;
  final String image; 
  final List<String> images; 
  final String? arModel; 

  final String? family;

  // Care Profile
  final String? difficulty;
  final String? light;
  final String? water;
  final String? temperature;
  final String? humidity;

  // Details
  final String? height;
  final String? potSize;

  // Tags
  final bool? isPetFriendly;
  final bool? isAirPurifying;
  final bool? isTrending;

  const ProductEntity({
    this.id,
    required this.name,
    this.botanicalName,
    this.family,
    this.categoryName,
    this.categoryId,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.stock,
    required this.image,
    required this.images,
    this.arModel,
    this.difficulty,
    this.light,
    this.water,
    this.temperature,
    this.humidity,
    this.height,
    this.potSize,
    this.isPetFriendly,
    this.isAirPurifying,
    this.isTrending,
  });

  @override
  List<Object?> get props => [id, name, price, image, arModel, stock, botanicalName];
}
