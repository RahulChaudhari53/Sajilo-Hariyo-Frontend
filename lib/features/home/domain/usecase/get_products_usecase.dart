import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/product_entity.dart';
import '../repository/product_repository.dart';

class GetProductsParams extends Equatable {
  final String? category;
  final String? search;

  const GetProductsParams({this.category, this.search});

  @override
  List<Object?> get props => [category, search];
}

class GetProductsUseCase
    implements UsecaseWithParams<List<ProductEntity>, GetProductsParams> {
  final IProductRepository repository;
  GetProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(GetProductsParams params) {
    return repository.getProducts(
      category: params.category,
      search: params.search,
    );
  }
}
