// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friendship_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendshipModel {

 int get id; String get status;// pending, accepted, declined, blocked
 FriendshipUser get requester; FriendshipUser get receiver;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendshipModelCopyWith<FriendshipModel> get copyWith => _$FriendshipModelCopyWithImpl<FriendshipModel>(this as FriendshipModel, _$identity);

  /// Serializes this FriendshipModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendshipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.requester, requester) || other.requester == requester)&&(identical(other.receiver, receiver) || other.receiver == receiver)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,requester,receiver,createdAt);

@override
String toString() {
  return 'FriendshipModel(id: $id, status: $status, requester: $requester, receiver: $receiver, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FriendshipModelCopyWith<$Res>  {
  factory $FriendshipModelCopyWith(FriendshipModel value, $Res Function(FriendshipModel) _then) = _$FriendshipModelCopyWithImpl;
@useResult
$Res call({
 int id, String status, FriendshipUser requester, FriendshipUser receiver,@JsonKey(name: 'created_at') String createdAt
});


$FriendshipUserCopyWith<$Res> get requester;$FriendshipUserCopyWith<$Res> get receiver;

}
/// @nodoc
class _$FriendshipModelCopyWithImpl<$Res>
    implements $FriendshipModelCopyWith<$Res> {
  _$FriendshipModelCopyWithImpl(this._self, this._then);

  final FriendshipModel _self;
  final $Res Function(FriendshipModel) _then;

/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? requester = null,Object? receiver = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requester: null == requester ? _self.requester : requester // ignore: cast_nullable_to_non_nullable
as FriendshipUser,receiver: null == receiver ? _self.receiver : receiver // ignore: cast_nullable_to_non_nullable
as FriendshipUser,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FriendshipUserCopyWith<$Res> get requester {
  
  return $FriendshipUserCopyWith<$Res>(_self.requester, (value) {
    return _then(_self.copyWith(requester: value));
  });
}/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FriendshipUserCopyWith<$Res> get receiver {
  
  return $FriendshipUserCopyWith<$Res>(_self.receiver, (value) {
    return _then(_self.copyWith(receiver: value));
  });
}
}


/// Adds pattern-matching-related methods to [FriendshipModel].
extension FriendshipModelPatterns on FriendshipModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendshipModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendshipModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendshipModel value)  $default,){
final _that = this;
switch (_that) {
case _FriendshipModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendshipModel value)?  $default,){
final _that = this;
switch (_that) {
case _FriendshipModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String status,  FriendshipUser requester,  FriendshipUser receiver, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendshipModel() when $default != null:
return $default(_that.id,_that.status,_that.requester,_that.receiver,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String status,  FriendshipUser requester,  FriendshipUser receiver, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _FriendshipModel():
return $default(_that.id,_that.status,_that.requester,_that.receiver,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String status,  FriendshipUser requester,  FriendshipUser receiver, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FriendshipModel() when $default != null:
return $default(_that.id,_that.status,_that.requester,_that.receiver,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendshipModel implements FriendshipModel {
  const _FriendshipModel({required this.id, required this.status, required this.requester, required this.receiver, @JsonKey(name: 'created_at') required this.createdAt});
  factory _FriendshipModel.fromJson(Map<String, dynamic> json) => _$FriendshipModelFromJson(json);

@override final  int id;
@override final  String status;
// pending, accepted, declined, blocked
@override final  FriendshipUser requester;
@override final  FriendshipUser receiver;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendshipModelCopyWith<_FriendshipModel> get copyWith => __$FriendshipModelCopyWithImpl<_FriendshipModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendshipModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendshipModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.requester, requester) || other.requester == requester)&&(identical(other.receiver, receiver) || other.receiver == receiver)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,requester,receiver,createdAt);

@override
String toString() {
  return 'FriendshipModel(id: $id, status: $status, requester: $requester, receiver: $receiver, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FriendshipModelCopyWith<$Res> implements $FriendshipModelCopyWith<$Res> {
  factory _$FriendshipModelCopyWith(_FriendshipModel value, $Res Function(_FriendshipModel) _then) = __$FriendshipModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String status, FriendshipUser requester, FriendshipUser receiver,@JsonKey(name: 'created_at') String createdAt
});


@override $FriendshipUserCopyWith<$Res> get requester;@override $FriendshipUserCopyWith<$Res> get receiver;

}
/// @nodoc
class __$FriendshipModelCopyWithImpl<$Res>
    implements _$FriendshipModelCopyWith<$Res> {
  __$FriendshipModelCopyWithImpl(this._self, this._then);

  final _FriendshipModel _self;
  final $Res Function(_FriendshipModel) _then;

/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? requester = null,Object? receiver = null,Object? createdAt = null,}) {
  return _then(_FriendshipModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requester: null == requester ? _self.requester : requester // ignore: cast_nullable_to_non_nullable
as FriendshipUser,receiver: null == receiver ? _self.receiver : receiver // ignore: cast_nullable_to_non_nullable
as FriendshipUser,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FriendshipUserCopyWith<$Res> get requester {
  
  return $FriendshipUserCopyWith<$Res>(_self.requester, (value) {
    return _then(_self.copyWith(requester: value));
  });
}/// Create a copy of FriendshipModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FriendshipUserCopyWith<$Res> get receiver {
  
  return $FriendshipUserCopyWith<$Res>(_self.receiver, (value) {
    return _then(_self.copyWith(receiver: value));
  });
}
}


/// @nodoc
mixin _$FriendshipUser {

 int get id; String get username;@JsonKey(name: 'display_name') String? get displayName;@JsonKey(name: 'avatar_url') String? get avatarUrl;
/// Create a copy of FriendshipUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendshipUserCopyWith<FriendshipUser> get copyWith => _$FriendshipUserCopyWithImpl<FriendshipUser>(this as FriendshipUser, _$identity);

  /// Serializes this FriendshipUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendshipUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,avatarUrl);

@override
String toString() {
  return 'FriendshipUser(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $FriendshipUserCopyWith<$Res>  {
  factory $FriendshipUserCopyWith(FriendshipUser value, $Res Function(FriendshipUser) _then) = _$FriendshipUserCopyWithImpl;
@useResult
$Res call({
 int id, String username,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'avatar_url') String? avatarUrl
});




}
/// @nodoc
class _$FriendshipUserCopyWithImpl<$Res>
    implements $FriendshipUserCopyWith<$Res> {
  _$FriendshipUserCopyWithImpl(this._self, this._then);

  final FriendshipUser _self;
  final $Res Function(FriendshipUser) _then;

/// Create a copy of FriendshipUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FriendshipUser].
extension FriendshipUserPatterns on FriendshipUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendshipUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendshipUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendshipUser value)  $default,){
final _that = this;
switch (_that) {
case _FriendshipUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendshipUser value)?  $default,){
final _that = this;
switch (_that) {
case _FriendshipUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendshipUser() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _FriendshipUser():
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _FriendshipUser() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendshipUser implements FriendshipUser {
  const _FriendshipUser({required this.id, required this.username, @JsonKey(name: 'display_name') this.displayName, @JsonKey(name: 'avatar_url') this.avatarUrl});
  factory _FriendshipUser.fromJson(Map<String, dynamic> json) => _$FriendshipUserFromJson(json);

@override final  int id;
@override final  String username;
@override@JsonKey(name: 'display_name') final  String? displayName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;

/// Create a copy of FriendshipUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendshipUserCopyWith<_FriendshipUser> get copyWith => __$FriendshipUserCopyWithImpl<_FriendshipUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendshipUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendshipUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,avatarUrl);

@override
String toString() {
  return 'FriendshipUser(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$FriendshipUserCopyWith<$Res> implements $FriendshipUserCopyWith<$Res> {
  factory _$FriendshipUserCopyWith(_FriendshipUser value, $Res Function(_FriendshipUser) _then) = __$FriendshipUserCopyWithImpl;
@override @useResult
$Res call({
 int id, String username,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'avatar_url') String? avatarUrl
});




}
/// @nodoc
class __$FriendshipUserCopyWithImpl<$Res>
    implements _$FriendshipUserCopyWith<$Res> {
  __$FriendshipUserCopyWithImpl(this._self, this._then);

  final _FriendshipUser _self;
  final $Res Function(_FriendshipUser) _then;

/// Create a copy of FriendshipUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_FriendshipUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
