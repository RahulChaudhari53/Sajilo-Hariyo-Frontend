import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/notification_entity.dart';
import '../repository/notification_repository.dart';

class GetNotificationsUseCase
    implements UsecaseWithoutParams<List<NotificationEntity>> {
  final INotificationRepository repository;
  GetNotificationsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<NotificationEntity>>> call() {
    return repository.getNotifications();
  }
}
