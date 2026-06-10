// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaderboardUserModel {

@JsonKey(name: 'user_id') int get userId; String get username;@JsonKey(name: 'display_name') String? get displayName;@JsonKey(name: 'avatar_url') String? get avatarUrl; int get level; int get wins;@JsonKey(name: 'donkey_count') int get donkeyCount;@JsonKey(name: 'best_streak') int get bestStreak;@JsonKey(name: 'total_games') int get totalGames; dynamic get value;
/// Create a copy of LeaderboardUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardUserModelCopyWith<LeaderboardUserModel> get copyWith => _$LeaderboardUserModelCopyWithImpl<LeaderboardUserModel>(this as LeaderboardUserModel, _$identity);

  /// Serializes this LeaderboardUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardUserModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.donkeyCount, donkeyCount) || other.donkeyCount == donkeyCount)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.totalGames, totalGames) || other.totalGames == totalGames)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,displayName,avatarUrl,level,wins,donkeyCount,bestStreak,totalGames,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'LeaderboardUserModel(userId: $userId, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, level: $level, wins: $wins, donkeyCount: $donkeyCount, bestStreak: $bestStreak, totalGames: $totalGames, value: $value)';
}


}

/// @nodoc
abstract mixin class $LeaderboardUserModelCopyWith<$Res>  {
  factory $LeaderboardUserModelCopyWith(LeaderboardUserModel value, $Res Function(LeaderboardUserModel) _then) = _$LeaderboardUserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') int userId, String username,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'avatar_url') String? avatarUrl, int level, int wins,@JsonKey(name: 'donkey_count') int donkeyCount,@JsonKey(name: 'best_streak') int bestStreak,@JsonKey(name: 'total_games') int totalGames, dynamic value
});




}
/// @nodoc
class _$LeaderboardUserModelCopyWithImpl<$Res>
    implements $LeaderboardUserModelCopyWith<$Res> {
  _$LeaderboardUserModelCopyWithImpl(this._self, this._then);

  final LeaderboardUserModel _self;
  final $Res Function(LeaderboardUserModel) _then;

/// Create a copy of LeaderboardUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? level = null,Object? wins = null,Object? donkeyCount = null,Object? bestStreak = null,Object? totalGames = null,Object? value = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,donkeyCount: null == donkeyCount ? _self.donkeyCount : donkeyCount // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,totalGames: null == totalGames ? _self.totalGames : totalGames // ignore: cast_nullable_to_non_nullable
as int,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardUserModel].
extension LeaderboardUserModelPatterns on LeaderboardUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardUserModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  int level,  int wins, @JsonKey(name: 'donkey_count')  int donkeyCount, @JsonKey(name: 'best_streak')  int bestStreak, @JsonKey(name: 'total_games')  int totalGames,  dynamic value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardUserModel() when $default != null:
return $default(_that.userId,_that.username,_that.displayName,_that.avatarUrl,_that.level,_that.wins,_that.donkeyCount,_that.bestStreak,_that.totalGames,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  int level,  int wins, @JsonKey(name: 'donkey_count')  int donkeyCount, @JsonKey(name: 'best_streak')  int bestStreak, @JsonKey(name: 'total_games')  int totalGames,  dynamic value)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardUserModel():
return $default(_that.userId,_that.username,_that.displayName,_that.avatarUrl,_that.level,_that.wins,_that.donkeyCount,_that.bestStreak,_that.totalGames,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  int userId,  String username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  int level,  int wins, @JsonKey(name: 'donkey_count')  int donkeyCount, @JsonKey(name: 'best_streak')  int bestStreak, @JsonKey(name: 'total_games')  int totalGames,  dynamic value)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardUserModel() when $default != null:
return $default(_that.userId,_that.username,_that.displayName,_that.avatarUrl,_that.level,_that.wins,_that.donkeyCount,_that.bestStreak,_that.totalGames,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardUserModel implements LeaderboardUserModel {
  const _LeaderboardUserModel({@JsonKey(name: 'user_id') required this.userId, required this.username, @JsonKey(name: 'display_name') this.displayName, @JsonKey(name: 'avatar_url') this.avatarUrl, required this.level, required this.wins, @JsonKey(name: 'donkey_count') required this.donkeyCount, @JsonKey(name: 'best_streak') required this.bestStreak, @JsonKey(name: 'total_games') required this.totalGames, required this.value});
  factory _LeaderboardUserModel.fromJson(Map<String, dynamic> json) => _$LeaderboardUserModelFromJson(json);

@override@JsonKey(name: 'user_id') final  int userId;
@override final  String username;
@override@JsonKey(name: 'display_name') final  String? displayName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override final  int level;
@override final  int wins;
@override@JsonKey(name: 'donkey_count') final  int donkeyCount;
@override@JsonKey(name: 'best_streak') final  int bestStreak;
@override@JsonKey(name: 'total_games') final  int totalGames;
@override final  dynamic value;

/// Create a copy of LeaderboardUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardUserModelCopyWith<_LeaderboardUserModel> get copyWith => __$LeaderboardUserModelCopyWithImpl<_LeaderboardUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardUserModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.donkeyCount, donkeyCount) || other.donkeyCount == donkeyCount)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.totalGames, totalGames) || other.totalGames == totalGames)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,displayName,avatarUrl,level,wins,donkeyCount,bestStreak,totalGames,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'LeaderboardUserModel(userId: $userId, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, level: $level, wins: $wins, donkeyCount: $donkeyCount, bestStreak: $bestStreak, totalGames: $totalGames, value: $value)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardUserModelCopyWith<$Res> implements $LeaderboardUserModelCopyWith<$Res> {
  factory _$LeaderboardUserModelCopyWith(_LeaderboardUserModel value, $Res Function(_LeaderboardUserModel) _then) = __$LeaderboardUserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') int userId, String username,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'avatar_url') String? avatarUrl, int level, int wins,@JsonKey(name: 'donkey_count') int donkeyCount,@JsonKey(name: 'best_streak') int bestStreak,@JsonKey(name: 'total_games') int totalGames, dynamic value
});




}
/// @nodoc
class __$LeaderboardUserModelCopyWithImpl<$Res>
    implements _$LeaderboardUserModelCopyWith<$Res> {
  __$LeaderboardUserModelCopyWithImpl(this._self, this._then);

  final _LeaderboardUserModel _self;
  final $Res Function(_LeaderboardUserModel) _then;

/// Create a copy of LeaderboardUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? level = null,Object? wins = null,Object? donkeyCount = null,Object? bestStreak = null,Object? totalGames = null,Object? value = freezed,}) {
  return _then(_LeaderboardUserModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,donkeyCount: null == donkeyCount ? _self.donkeyCount : donkeyCount // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,totalGames: null == totalGames ? _self.totalGames : totalGames // ignore: cast_nullable_to_non_nullable
as int,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
