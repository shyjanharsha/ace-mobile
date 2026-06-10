// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      payload: json['payload'] as Map<String, dynamic>?,
      read: json['read'] as bool,
      actorId: (json['actor_id'] as num?)?.toInt(),
      sent_at: json['sent_at'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'payload': instance.payload,
      'read': instance.read,
      'actor_id': instance.actorId,
      'sent_at': instance.sent_at,
    };
