import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String? id;
  final String title;
  final String message;
  final String type; // order, promo, system, info
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, isRead, createdAt];
}