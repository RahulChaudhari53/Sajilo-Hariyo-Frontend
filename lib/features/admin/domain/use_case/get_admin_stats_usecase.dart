import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/admin/domain/entity/admin_stats_entity.dart';
import 'package:sajilo_hariyo/features/admin/domain/repository/admin_repository.dart';

class GetAdminStatsUseCase implements UsecaseWithoutParams<AdminStatsEntity> {
  final IAdminRepository repository;

  GetAdminStatsUseCase(this.repository);

  @override
  Future<Either<Failure, AdminStatsEntity>> call() async {
    return await repository.getAdminStats();
  }
}
