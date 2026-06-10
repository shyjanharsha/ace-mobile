import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String username,
    @JsonKey(name: 'display_name') String? displayName,
    String? email,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default(false) @JsonKey(name: 'is_guest') bool isGuest,
    @Default(false) bool verified,
    @Default(1000) int coins,
    @Default(0) int xp,
    @Default(1) int level,
    @Default('offline') String status,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
