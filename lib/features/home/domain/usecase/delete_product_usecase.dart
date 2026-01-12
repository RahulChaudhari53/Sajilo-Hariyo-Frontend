import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/product_repository.dart';

class DeleteProductUseCase implements UsecaseWithParams<void, String> {
  final IProductRepository repository;
  DeleteProductUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String productId) {
    return repository.deleteProduct(productId);
  }
}
