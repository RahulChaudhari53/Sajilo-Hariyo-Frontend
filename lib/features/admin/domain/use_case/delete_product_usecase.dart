import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/home/domain/repository/product_repository.dart';

class DeleteProductUseCase implements UsecaseWithParams<void, String> {
  final IProductRepository _repository;

  DeleteProductUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String productId) async {
    return await _repository.deleteProduct(productId);
  }
}
