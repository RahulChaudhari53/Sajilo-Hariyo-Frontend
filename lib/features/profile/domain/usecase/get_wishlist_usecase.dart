import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../../../home/domain/entity/product_entity.dart';
import '../repository/user_repository.dart';

class GetWishlistUseCase implements UsecaseWithoutParams<List<ProductEntity>> {
  final IUserRepository repository;
  GetWishlistUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call() {
    return repository.getWishlist();
  }
}
