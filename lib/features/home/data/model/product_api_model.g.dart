// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductApiModel _$ProductApiModelFromJson(Map<String, dynamic> json) =>
    ProductApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      botanicalName: json['botanicalName'] as String?,
      category: json['category'],
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      stock: (json['stock'] as num).toInt(),
      image: json['image'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      arModel: json['arModel'] as String?,
      careProfile: json['careProfile'] as Map<String, dynamic>?,
      details: json['details'] as Map<String, dynamic>?,
      tags: json['tags'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'botanicalName': instance.botanicalName,
      'category': instance.category,
      'description': instance.description,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'stock': instance.stock,
      'image': instance.image,
      'images': instance.images,
      'arModel': instance.arModel,
      'careProfile': instance.careProfile,
      'details': instance.details,
      'tags': instance.tags,
    };
