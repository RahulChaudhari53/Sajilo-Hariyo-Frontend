import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/admin/domain/repository/admin_repository.dart';

class CreateCategoryParams {
  final String name;
  final String description;

  const CreateCategoryParams({required this.name, required this.description});
}

class CreateCategoryUseCase implements UsecaseWithParams<void, CreateCategoryParams> {
  final IAdminRepository repository;

  CreateCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateCategoryParams params) async {
    return await repository.createCategory(params.name, params.description);
  }
}
