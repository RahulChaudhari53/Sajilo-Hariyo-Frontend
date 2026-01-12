import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/notification/data/data_source/remote_data_source/notification_remote_data_source.dart';
import 'package:sajilo_hariyo/features/notification/domain/entity/notification_entity.dart';
import 'package:sajilo_hariyo/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final INotificationDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final models = await _remoteDataSource.getNotifications();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _remoteDataSource.markAsRead(id);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _remoteDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
