// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationApiModel _$NotificationApiModelFromJson(
  Map<String, dynamic> json,
) => NotificationApiModel(
  id: json['_id'] as String?,
  title: json['title'] as String,
  body: json['message'] as String,
  type: json['type'] as String,
  isRead: json['isRead'] as bool,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$NotificationApiModelToJson(
  NotificationApiModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'message': instance.body,
  'type': instance.type,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt,
};
