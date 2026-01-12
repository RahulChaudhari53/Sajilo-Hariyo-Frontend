import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/notification/data/data_source/notification_data_source.dart';
import 'package:sajilo_hariyo/features/notification/domain/entity/notification_entity.dart';
import 'package:sajilo_hariyo/features/notification/domain/repository/notification_repository.dart';

class NotificationRemoteRepository implements INotificationRepository {
  final INotificationDataSource _notificationRemoteDataSource;

  NotificationRemoteRepository(this._notificationRemoteDataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final notificationApiModels = await _notificationRemoteDataSource
          .getNotifications();
      // Map API Models to Domain Entities
      final notificationEntities = notificationApiModels
          .map((model) => model.toEntity())
          .toList();
      return Right(notificationEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _notificationRemoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _notificationRemoteDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
