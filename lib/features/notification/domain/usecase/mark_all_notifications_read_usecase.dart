import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/notification_repository.dart';

class MarkAllNotificationsReadUseCase implements UsecaseWithoutParams<void> {
  final INotificationRepository repository;
  MarkAllNotificationsReadUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call() {
    return repository.markAllAsRead();
  }
}
