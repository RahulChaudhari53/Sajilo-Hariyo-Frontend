import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/user_repository.dart';

class ToggleWishlistUseCase implements UsecaseWithParams<bool, String> {
  final IUserRepository repository;
  ToggleWishlistUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(String productId) {
    return repository.toggleWishlist(productId);
  }
}
