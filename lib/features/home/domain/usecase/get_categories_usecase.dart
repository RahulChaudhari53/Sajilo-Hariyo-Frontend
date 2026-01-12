import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/features/home/data/repository/remote_repository/category_entity.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/product_repository.dart';

class GetCategoriesUseCase
    implements UsecaseWithoutParams<List<CategoryEntity>> {
  final IProductRepository repository;
  GetCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}
