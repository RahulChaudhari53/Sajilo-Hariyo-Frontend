import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/notification_repository.dart';

class MarkNotificationReadUseCase implements UsecaseWithParams<void, String> {
  final INotificationRepository repository;
  MarkNotificationReadUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}
