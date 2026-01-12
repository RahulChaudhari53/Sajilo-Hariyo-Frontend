import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/notification/domain/entity/notification_entity.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final List<NotificationEntity> notifications;
  final String? error;

  const NotificationState({
    required this.isLoading,
    required this.notifications,
    this.error,
  });

  factory NotificationState.initial() {
    return const NotificationState(
      isLoading: false,
      notifications: [],
      error: null,
    );
  }

  NotificationState copyWith({
    bool? isLoading,
    List<NotificationEntity>? notifications,
    String? error,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, notifications, error];
}
