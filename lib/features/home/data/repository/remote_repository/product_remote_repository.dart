import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/home/data/data_source/product_data_source.dart';
import 'package:sajilo_hariyo/features/home/data/repository/remote_repository/category_entity.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_hariyo/features/home/domain/repository/product_repository.dart';

class ProductRemoteRepository implements IProductRepository {
  final IProductDataSource _productRemoteDataSource;

  ProductRemoteRepository(this._productRemoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    try {
      final productApiModels = await _productRemoteDataSource.getProducts(
        category: category,
        search: search,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sort: sort,
      );
      // Map the API Models to Domain Entities
      final productEntities = productApiModels
          .map((model) => model.toEntity())
          .toList();
      return Right(productEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      final productApiModel = await _productRemoteDataSource.getProductById(id);
      return Right(productApiModel.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> createProduct(
    ProductEntity product,
    File image,
    File? arModel,
    List<File>? gallery,
  ) async {
    try {
      await _productRemoteDataSource.createProduct(
        product,
        image,
        arModel,
        gallery,
      );
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(
    ProductEntity product, {
    File? image,
    File? arModel,
    List<File>? gallery,
  }) async {
    try {
      await _productRemoteDataSource.updateProduct(
        product,
        image: image,
        arModel: arModel,
        gallery: gallery,
      );
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _productRemoteDataSource.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categoryApiModels = await _productRemoteDataSource.getCategories();
      final categoryEntities = categoryApiModels
          .map((model) => model.toEntity())
          .toList();
      return Right(categoryEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
