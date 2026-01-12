import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/features/home/data/repository/remote_repository/category_entity.dart';
import '../../../../core/error/failure.dart';
import '../entity/product_entity.dart';

abstract interface class IProductRepository {
  // --- Customer Actions ---
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sort,
  });
  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  // --- Admin Actions ---
  Future<Either<Failure, void>> createProduct(
    ProductEntity product,
    File image,
    File? arModel,
    List<File>? gallery,
  );
  Future<Either<Failure, void>> updateProduct(
    ProductEntity product, {
    File? image,
    File? arModel,
    List<File>? gallery,
  });
  Future<Either<Failure, void>> deleteProduct(String id);
}
