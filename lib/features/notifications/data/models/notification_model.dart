import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int id,
    required String type,
    required String title,
    required String body,
    required Map<String, dynamic>? payload,
    required bool read,
    @JsonKey(name: 'actor_id') int? actorId,
    @JsonKey(name: 'sent_at') required String sent_at,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
