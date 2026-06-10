// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupMemberModel {

 int get id;@JsonKey(name: 'user_id') int get userId; String get username;@JsonKey(name: 'display_name') String? get displayName;@JsonKey(name: 'avatar_url') String? get avatarUrl; String get role;@JsonKey(name: 'joined_at') String get joinedAt;
/// Create a copy of GroupMemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupMemberModelCopyWith<GroupMemberModel> get copyWith => _$GroupMemberModelCopyWithImpl<GroupMemberModel>(this as GroupMemberModel, _$identity);

  /// Serializes this GroupMemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,username,displayName,avatarUrl,role,joinedAt);

@override
String toString() {
  return 'GroupMemberModel(id: $id, userId: $userId, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, role: $role, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $GroupMemberModelCopyWith<$Res>  {
  factory $GroupMemberModelCopyWith(GroupMemberModel value, $Res Function(GroupMemberModel) _then) = _$GroupMemberModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId, String username,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'avatar_url') String? avatarUrl, String role,@JsonKey(name: 'joined_at') String joinedAt
});




}
/// @nodoc
class _$GroupMemberModelCopyWithImpl<$Res>
    implements $GroupMemberModelCopyWith<$Res> {
  _$GroupMemberModelCopyWithImpl(this._self, this._then);

  final GroupMemberModel _self;
  final $Res Function(GroupMemberModel) _then;

/// Create a copy of GroupMemberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? username = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? role = null,Object? joinedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupMemberModel].
extension GroupMemberModelPatterns on GroupMemberModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupMemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupMemberModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupMemberModel value)  $default,){
final _that = this;
switch (_that) {
case _GroupMemberModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupMemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _GroupMemberModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String role, @JsonKey(name: 'joined_at')  String joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupMemberModel() when $default != null:
return $default(_that.id,_that.userId,_that.username,_that.displayName,_that.avatarUrl,_that.role,_that.joinedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String role, @JsonKey(name: 'joined_at')  String joinedAt)  $default,) {final _that = this;
switch (_that) {
case _GroupMemberModel():
return $default(_that.id,_that.userId,_that.username,_that.displayName,_that.avatarUrl,_that.role,_that.joinedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  int userId,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String role, @JsonKey(name: 'joined_at')  String joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupMemberModel() when $default != null:
return $default(_that.id,_that.userId,_that.username,_that.displayName,_that.avatarUrl,_that.role,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupMemberModel implements GroupMemberModel {
  const _GroupMemberModel({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.username, @JsonKey(name: 'display_name') this.displayName, @JsonKey(name: 'avatar_url') this.avatarUrl, required this.role, @JsonKey(name: 'joined_at') required this.joinedAt});
  factory _GroupMemberModel.fromJson(Map<String, dynamic> json) => _$GroupMemberModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  int userId;
@override final  String username;
@override@JsonKey(name: 'display_name') final  String? displayName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override final  String role;
@override@JsonKey(name: 'joined_at') final  String joinedAt;

/// Create a copy of GroupMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupMemberModelCopyWith<_GroupMemberModel> get copyWith => __$GroupMemberModelCopyWithImpl<_GroupMemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupMemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,username,displayName,avatarUrl,role,joinedAt);

@override
String toString() {
  return 'GroupMemberModel(id: $id, userId: $userId, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, role: $role, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$GroupMemberModelCopyWith<$Res> implements $GroupMemberModelCopyWith<$Res> {
  factory _$GroupMemberModelCopyWith(_GroupMemberModel value, $Res Function(_GroupMemberModel) _then) = __$GroupMemberModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId, String username,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'avatar_url') String? avatarUrl, String role,@JsonKey(name: 'joined_at') String joinedAt
});




}
/// @nodoc
class __$GroupMemberModelCopyWithImpl<$Res>
    implements _$GroupMemberModelCopyWith<$Res> {
  __$GroupMemberModelCopyWithImpl(this._self, this._then);

  final _GroupMemberModel _self;
  final $Res Function(_GroupMemberModel) _then;

/// Create a copy of GroupMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? username = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? role = null,Object? joinedAt = null,}) {
  return _then(_GroupMemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GroupModel {

 int get id; String get name; String? get description;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'group_type') String get groupType;@JsonKey(name: 'invite_code') String? get inviteCode;@JsonKey(name: 'owner_id') int get ownerId;@JsonKey(name: 'owner_name') String get ownerName;@JsonKey(name: 'members_count') int get membersCount;@JsonKey(name: 'created_at') String get createdAt; List<GroupMemberModel>? get members;
/// Create a copy of GroupModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupModelCopyWith<GroupModel> get copyWith => _$GroupModelCopyWithImpl<GroupModel>(this as GroupModel, _$identity);

  /// Serializes this GroupModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.groupType, groupType) || other.groupType == groupType)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,avatarUrl,groupType,inviteCode,ownerId,ownerName,membersCount,createdAt,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'GroupModel(id: $id, name: $name, description: $description, avatarUrl: $avatarUrl, groupType: $groupType, inviteCode: $inviteCode, ownerId: $ownerId, ownerName: $ownerName, membersCount: $membersCount, createdAt: $createdAt, members: $members)';
}


}

/// @nodoc
abstract mixin class $GroupModelCopyWith<$Res>  {
  factory $GroupModelCopyWith(GroupModel value, $Res Function(GroupModel) _then) = _$GroupModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'group_type') String groupType,@JsonKey(name: 'invite_code') String? inviteCode,@JsonKey(name: 'owner_id') int ownerId,@JsonKey(name: 'owner_name') String ownerName,@JsonKey(name: 'members_count') int membersCount,@JsonKey(name: 'created_at') String createdAt, List<GroupMemberModel>? members
});




}
/// @nodoc
class _$GroupModelCopyWithImpl<$Res>
    implements $GroupModelCopyWith<$Res> {
  _$GroupModelCopyWithImpl(this._self, this._then);

  final GroupModel _self;
  final $Res Function(GroupModel) _then;

/// Create a copy of GroupModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? avatarUrl = freezed,Object? groupType = null,Object? inviteCode = freezed,Object? ownerId = null,Object? ownerName = null,Object? membersCount = null,Object? createdAt = null,Object? members = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,groupType: null == groupType ? _self.groupType : groupType // ignore: cast_nullable_to_non_nullable
as String,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as int,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,membersCount: null == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,members: freezed == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<GroupMemberModel>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupModel].
extension GroupModelPatterns on GroupModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupModel value)  $default,){
final _that = this;
switch (_that) {
case _GroupModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupModel value)?  $default,){
final _that = this;
switch (_that) {
case _GroupModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? description, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'group_type')  String groupType, @JsonKey(name: 'invite_code')  String? inviteCode, @JsonKey(name: 'owner_id')  int ownerId, @JsonKey(name: 'owner_name')  String ownerName, @JsonKey(name: 'members_count')  int membersCount, @JsonKey(name: 'created_at')  String createdAt,  List<GroupMemberModel>? members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.avatarUrl,_that.groupType,_that.inviteCode,_that.ownerId,_that.ownerName,_that.membersCount,_that.createdAt,_that.members);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? description, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'group_type')  String groupType, @JsonKey(name: 'invite_code')  String? inviteCode, @JsonKey(name: 'owner_id')  int ownerId, @JsonKey(name: 'owner_name')  String ownerName, @JsonKey(name: 'members_count')  int membersCount, @JsonKey(name: 'created_at')  String createdAt,  List<GroupMemberModel>? members)  $default,) {final _that = this;
switch (_that) {
case _GroupModel():
return $default(_that.id,_that.name,_that.description,_that.avatarUrl,_that.groupType,_that.inviteCode,_that.ownerId,_that.ownerName,_that.membersCount,_that.createdAt,_that.members);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? description, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'group_type')  String groupType, @JsonKey(name: 'invite_code')  String? inviteCode, @JsonKey(name: 'owner_id')  int ownerId, @JsonKey(name: 'owner_name')  String ownerName, @JsonKey(name: 'members_count')  int membersCount, @JsonKey(name: 'created_at')  String createdAt,  List<GroupMemberModel>? members)?  $default,) {final _that = this;
switch (_that) {
case _GroupModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.avatarUrl,_that.groupType,_that.inviteCode,_that.ownerId,_that.ownerName,_that.membersCount,_that.createdAt,_that.members);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupModel implements GroupModel {
  const _GroupModel({required this.id, required this.name, this.description, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'group_type') required this.groupType, @JsonKey(name: 'invite_code') this.inviteCode, @JsonKey(name: 'owner_id') required this.ownerId, @JsonKey(name: 'owner_name') required this.ownerName, @JsonKey(name: 'members_count') required this.membersCount, @JsonKey(name: 'created_at') required this.createdAt, final  List<GroupMemberModel>? members}): _members = members;
  factory _GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'group_type') final  String groupType;
@override@JsonKey(name: 'invite_code') final  String? inviteCode;
@override@JsonKey(name: 'owner_id') final  int ownerId;
@override@JsonKey(name: 'owner_name') final  String ownerName;
@override@JsonKey(name: 'members_count') final  int membersCount;
@override@JsonKey(name: 'created_at') final  String createdAt;
 final  List<GroupMemberModel>? _members;
@override List<GroupMemberModel>? get members {
  final value = _members;
  if (value == null) return null;
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GroupModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupModelCopyWith<_GroupModel> get copyWith => __$GroupModelCopyWithImpl<_GroupModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.groupType, groupType) || other.groupType == groupType)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._members, _members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,avatarUrl,groupType,inviteCode,ownerId,ownerName,membersCount,createdAt,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'GroupModel(id: $id, name: $name, description: $description, avatarUrl: $avatarUrl, groupType: $groupType, inviteCode: $inviteCode, ownerId: $ownerId, ownerName: $ownerName, membersCount: $membersCount, createdAt: $createdAt, members: $members)';
}


}

/// @nodoc
abstract mixin class _$GroupModelCopyWith<$Res> implements $GroupModelCopyWith<$Res> {
  factory _$GroupModelCopyWith(_GroupModel value, $Res Function(_GroupModel) _then) = __$GroupModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'group_type') String groupType,@JsonKey(name: 'invite_code') String? inviteCode,@JsonKey(name: 'owner_id') int ownerId,@JsonKey(name: 'owner_name') String ownerName,@JsonKey(name: 'members_count') int membersCount,@JsonKey(name: 'created_at') String createdAt, List<GroupMemberModel>? members
});




}
/// @nodoc
class __$GroupModelCopyWithImpl<$Res>
    implements _$GroupModelCopyWith<$Res> {
  __$GroupModelCopyWithImpl(this._self, this._then);

  final _GroupModel _self;
  final $Res Function(_GroupModel) _then;

/// Create a copy of GroupModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? avatarUrl = freezed,Object? groupType = null,Object? inviteCode = freezed,Object? ownerId = null,Object? ownerName = null,Object? membersCount = null,Object? createdAt = null,Object? members = freezed,}) {
  return _then(_GroupModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,groupType: null == groupType ? _self.groupType : groupType // ignore: cast_nullable_to_non_nullable
as String,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as int,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,membersCount: null == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,members: freezed == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<GroupMemberModel>?,
  ));
}


}

// dart format on
