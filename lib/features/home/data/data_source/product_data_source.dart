import 'package:sajilo_hariyo/features/home/data/model/category_api_model.dart';

import '../model/product_api_model.dart';
import '../../domain/entity/product_entity.dart';
import 'dart:io';

abstract interface class IProductDataSource {
  Future<List<ProductApiModel>> getProducts({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sort,
  });
  Future<ProductApiModel> getProductById(String id);
  Future<void> createProduct(
    ProductEntity product,
    File image,
    File? arModel,
    List<File>? gallery,
  );
  Future<void> updateProduct(
    ProductEntity product, {
    File? image,
    File? arModel,
    List<File>? gallery,
  });
  Future<void> deleteProduct(String id);
  Future<List<CategoryApiModel>> getCategories();
}
