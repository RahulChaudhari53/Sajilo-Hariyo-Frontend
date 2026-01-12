import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/notification/domain/repository/notification_repository.dart';

class MarkAsReadParams {
  final String id;
  const MarkAsReadParams({required this.id});
}

class MarkAsReadUseCase implements UsecaseWithParams<void, MarkAsReadParams> {
  final INotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) async {
    return await repository.markAsRead(params.id);
  }
}
