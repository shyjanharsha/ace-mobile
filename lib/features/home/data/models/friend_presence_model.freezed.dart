// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_presence_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendPresenceModel {

 int get id; String get username;@JsonKey(name: 'display_name') String? get displayName;@JsonKey(name: 'avatar_url') String? get avatarUrl; String get status;@JsonKey(name: 'last_seen_at') DateTime? get lastSeenAt;
/// Create a copy of FriendPresenceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendPresenceModelCopyWith<FriendPresenceModel> get copyWith => _$FriendPresenceModelCopyWithImpl<FriendPresenceModel>(this as FriendPresenceModel, _$identity);

  /// Serializes this FriendPresenceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendPresenceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,avatarUrl,status,lastSeenAt);

@override
String toString() {
  return 'FriendPresenceModel(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, status: $status, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class $FriendPresenceModelCopyWith<$Res>  {
  factory $FriendPresenceModelCopyWith(FriendPresenceModel value, $Res Function(FriendPresenceModel) _then) = _$FriendPresenceModelCopyWithImpl;
@useResult
$Res call({
 int id, String username,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'avatar_url') String? avatarUrl, String status,@JsonKey(name: 'last_seen_at') DateTime? lastSeenAt
});




}
/// @nodoc
class _$FriendPresenceModelCopyWithImpl<$Res>
    implements $FriendPresenceModelCopyWith<$Res> {
  _$FriendPresenceModelCopyWithImpl(this._self, this._then);

  final FriendPresenceModel _self;
  final $Res Function(FriendPresenceModel) _then;

/// Create a copy of FriendPresenceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? status = null,Object? lastSeenAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FriendPresenceModel].
extension FriendPresenceModelPatterns on FriendPresenceModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendPresenceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendPresenceModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendPresenceModel value)  $default,){
final _that = this;
switch (_that) {
case _FriendPresenceModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendPresenceModel value)?  $default,){
final _that = this;
switch (_that) {
case _FriendPresenceModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String status, @JsonKey(name: 'last_seen_at')  DateTime? lastSeenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendPresenceModel() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.status,_that.lastSeenAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String status, @JsonKey(name: 'last_seen_at')  DateTime? lastSeenAt)  $default,) {final _that = this;
switch (_that) {
case _FriendPresenceModel():
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.status,_that.lastSeenAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String status, @JsonKey(name: 'last_seen_at')  DateTime? lastSeenAt)?  $default,) {final _that = this;
switch (_that) {
case _FriendPresenceModel() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.status,_that.lastSeenAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendPresenceModel implements FriendPresenceModel {
  const _FriendPresenceModel({required this.id, required this.username, @JsonKey(name: 'display_name') this.displayName, @JsonKey(name: 'avatar_url') this.avatarUrl, required this.status, @JsonKey(name: 'last_seen_at') this.lastSeenAt});
  factory _FriendPresenceModel.fromJson(Map<String, dynamic> json) => _$FriendPresenceModelFromJson(json);

@override final  int id;
@override final  String username;
@override@JsonKey(name: 'display_name') final  String? displayName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override final  String status;
@override@JsonKey(name: 'last_seen_at') final  DateTime? lastSeenAt;

/// Create a copy of FriendPresenceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendPresenceModelCopyWith<_FriendPresenceModel> get copyWith => __$FriendPresenceModelCopyWithImpl<_FriendPresenceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendPresenceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendPresenceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,avatarUrl,status,lastSeenAt);

@override
String toString() {
  return 'FriendPresenceModel(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, status: $status, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class _$FriendPresenceModelCopyWith<$Res> implements $FriendPresenceModelCopyWith<$Res> {
  factory _$FriendPresenceModelCopyWith(_FriendPresenceModel value, $Res Function(_FriendPresenceModel) _then) = __$FriendPresenceModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String username,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'avatar_url') String? avatarUrl, String status,@JsonKey(name: 'last_seen_at') DateTime? lastSeenAt
});




}
/// @nodoc
class __$FriendPresenceModelCopyWithImpl<$Res>
    implements _$FriendPresenceModelCopyWith<$Res> {
  __$FriendPresenceModelCopyWithImpl(this._self, this._then);

  final _FriendPresenceModel _self;
  final $Res Function(_FriendPresenceModel) _then;

/// Create a copy of FriendPresenceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? status = null,Object? lastSeenAt = freezed,}) {
  return _then(_FriendPresenceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
