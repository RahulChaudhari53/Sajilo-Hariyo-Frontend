import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/admin/domain/repository/admin_repository.dart';

class DeleteCategoryUseCase implements UsecaseWithParams<void, String> {
  final IAdminRepository repository;

  DeleteCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteCategory(id);
  }
}
