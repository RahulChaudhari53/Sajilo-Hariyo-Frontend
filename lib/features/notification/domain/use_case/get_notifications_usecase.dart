import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/notification/domain/entity/notification_entity.dart';
import 'package:sajilo_hariyo/features/notification/domain/repository/notification_repository.dart';

class GetNotificationsUseCase
    implements UsecaseWithoutParams<List<NotificationEntity>> {
  final INotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}
