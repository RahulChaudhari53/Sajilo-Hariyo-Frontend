import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_hariyo/features/home/domain/repository/product_repository.dart';

class SearchProductsParams {
  final String? search;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  SearchProductsParams({
    this.search,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });
}

class SearchProductsUseCase
    implements UsecaseWithParams<List<ProductEntity>, SearchProductsParams> {
  final IProductRepository _productRepository;

  SearchProductsUseCase(this._productRepository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    SearchProductsParams params,
  ) async {
    return await _productRepository.getProducts(
      search: params.search,
      category: params.category,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      sort: params.sort,
    );
  }
}
