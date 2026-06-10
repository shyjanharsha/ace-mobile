// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomPlayerModel {

@JsonKey(name: 'user_id') int get userId; String get username;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'seat_position') int get seatPosition; String get status; bool get ready;
/// Create a copy of RoomPlayerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomPlayerModelCopyWith<RoomPlayerModel> get copyWith => _$RoomPlayerModelCopyWithImpl<RoomPlayerModel>(this as RoomPlayerModel, _$identity);

  /// Serializes this RoomPlayerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomPlayerModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.seatPosition, seatPosition) || other.seatPosition == seatPosition)&&(identical(other.status, status) || other.status == status)&&(identical(other.ready, ready) || other.ready == ready));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,avatarUrl,seatPosition,status,ready);

@override
String toString() {
  return 'RoomPlayerModel(userId: $userId, username: $username, avatarUrl: $avatarUrl, seatPosition: $seatPosition, status: $status, ready: $ready)';
}


}

/// @nodoc
abstract mixin class $RoomPlayerModelCopyWith<$Res>  {
  factory $RoomPlayerModelCopyWith(RoomPlayerModel value, $Res Function(RoomPlayerModel) _then) = _$RoomPlayerModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') int userId, String username,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'seat_position') int seatPosition, String status, bool ready
});




}
/// @nodoc
class _$RoomPlayerModelCopyWithImpl<$Res>
    implements $RoomPlayerModelCopyWith<$Res> {
  _$RoomPlayerModelCopyWithImpl(this._self, this._then);

  final RoomPlayerModel _self;
  final $Res Function(RoomPlayerModel) _then;

/// Create a copy of RoomPlayerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = null,Object? avatarUrl = freezed,Object? seatPosition = null,Object? status = null,Object? ready = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,seatPosition: null == seatPosition ? _self.seatPosition : seatPosition // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomPlayerModel].
extension RoomPlayerModelPatterns on RoomPlayerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomPlayerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomPlayerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomPlayerModel value)  $default,){
final _that = this;
switch (_that) {
case _RoomPlayerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomPlayerModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoomPlayerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId,  String username, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'seat_position')  int seatPosition,  String status,  bool ready)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomPlayerModel() when $default != null:
return $default(_that.userId,_that.username,_that.avatarUrl,_that.seatPosition,_that.status,_that.ready);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId,  String username, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'seat_position')  int seatPosition,  String status,  bool ready)  $default,) {final _that = this;
switch (_that) {
case _RoomPlayerModel():
return $default(_that.userId,_that.username,_that.avatarUrl,_that.seatPosition,_that.status,_that.ready);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  int userId,  String username, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'seat_position')  int seatPosition,  String status,  bool ready)?  $default,) {final _that = this;
switch (_that) {
case _RoomPlayerModel() when $default != null:
return $default(_that.userId,_that.username,_that.avatarUrl,_that.seatPosition,_that.status,_that.ready);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomPlayerModel implements RoomPlayerModel {
  const _RoomPlayerModel({@JsonKey(name: 'user_id') required this.userId, required this.username, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'seat_position') required this.seatPosition, required this.status, required this.ready});
  factory _RoomPlayerModel.fromJson(Map<String, dynamic> json) => _$RoomPlayerModelFromJson(json);

@override@JsonKey(name: 'user_id') final  int userId;
@override final  String username;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'seat_position') final  int seatPosition;
@override final  String status;
@override final  bool ready;

/// Create a copy of RoomPlayerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomPlayerModelCopyWith<_RoomPlayerModel> get copyWith => __$RoomPlayerModelCopyWithImpl<_RoomPlayerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomPlayerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomPlayerModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.seatPosition, seatPosition) || other.seatPosition == seatPosition)&&(identical(other.status, status) || other.status == status)&&(identical(other.ready, ready) || other.ready == ready));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,avatarUrl,seatPosition,status,ready);

@override
String toString() {
  return 'RoomPlayerModel(userId: $userId, username: $username, avatarUrl: $avatarUrl, seatPosition: $seatPosition, status: $status, ready: $ready)';
}


}

/// @nodoc
abstract mixin class _$RoomPlayerModelCopyWith<$Res> implements $RoomPlayerModelCopyWith<$Res> {
  factory _$RoomPlayerModelCopyWith(_RoomPlayerModel value, $Res Function(_RoomPlayerModel) _then) = __$RoomPlayerModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') int userId, String username,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'seat_position') int seatPosition, String status, bool ready
});




}
/// @nodoc
class __$RoomPlayerModelCopyWithImpl<$Res>
    implements _$RoomPlayerModelCopyWith<$Res> {
  __$RoomPlayerModelCopyWithImpl(this._self, this._then);

  final _RoomPlayerModel _self;
  final $Res Function(_RoomPlayerModel) _then;

/// Create a copy of RoomPlayerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = null,Object? avatarUrl = freezed,Object? seatPosition = null,Object? status = null,Object? ready = null,}) {
  return _then(_RoomPlayerModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,seatPosition: null == seatPosition ? _self.seatPosition : seatPosition // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
