import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/notification_entity.dart';

part 'notification_api_model.g.dart';

@JsonSerializable()
class NotificationApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  @JsonKey(name: 'message')
  final String body; // backend calls it 'message', UI uses 'body'
  final String type;
  final bool isRead;
  final String createdAt;

  const NotificationApiModel({
    this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationApiModelToJson(this);

  // Mapper: API Model -> Domain Entity
  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    title: title,
    message: body,
    type: type,
    isRead: isRead,
    createdAt: DateTime.parse(createdAt),
  );

  @override
  List<Object?> get props => [id, title, isRead, createdAt];
}
