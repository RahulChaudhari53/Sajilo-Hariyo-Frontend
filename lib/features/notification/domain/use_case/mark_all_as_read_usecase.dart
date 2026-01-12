import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/notification/domain/repository/notification_repository.dart';

class MarkAllAsReadUseCase implements UsecaseWithoutParams<void> {
  final INotificationRepository repository;

  MarkAllAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.markAllAsRead();
  }
}
