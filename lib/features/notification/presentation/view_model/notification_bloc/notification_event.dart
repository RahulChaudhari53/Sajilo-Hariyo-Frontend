import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {}

class MarkAsReadEvent extends NotificationEvent {
  final String id;
  const MarkAsReadEvent(this.id);

  @override
  List<Object> get props => [id];
}

class MarkAllAsReadEvent extends NotificationEvent {}
