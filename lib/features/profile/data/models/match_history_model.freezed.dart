// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchHistoryModel {

@JsonKey(name: 'match_id') int get matchId;@JsonKey(name: 'played_at') String get playedAt;@JsonKey(name: 'is_donkey') bool get isDonkey;@JsonKey(name: 'final_rank') int? get finalRank;@JsonKey(name: 'tricks_won') int get tricksWon;@JsonKey(name: 'coins_won') int get coinsWon;@JsonKey(name: 'match_status') String get matchStatus;
/// Create a copy of MatchHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchHistoryModelCopyWith<MatchHistoryModel> get copyWith => _$MatchHistoryModelCopyWithImpl<MatchHistoryModel>(this as MatchHistoryModel, _$identity);

  /// Serializes this MatchHistoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchHistoryModel&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.isDonkey, isDonkey) || other.isDonkey == isDonkey)&&(identical(other.finalRank, finalRank) || other.finalRank == finalRank)&&(identical(other.tricksWon, tricksWon) || other.tricksWon == tricksWon)&&(identical(other.coinsWon, coinsWon) || other.coinsWon == coinsWon)&&(identical(other.matchStatus, matchStatus) || other.matchStatus == matchStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,playedAt,isDonkey,finalRank,tricksWon,coinsWon,matchStatus);

@override
String toString() {
  return 'MatchHistoryModel(matchId: $matchId, playedAt: $playedAt, isDonkey: $isDonkey, finalRank: $finalRank, tricksWon: $tricksWon, coinsWon: $coinsWon, matchStatus: $matchStatus)';
}


}

/// @nodoc
abstract mixin class $MatchHistoryModelCopyWith<$Res>  {
  factory $MatchHistoryModelCopyWith(MatchHistoryModel value, $Res Function(MatchHistoryModel) _then) = _$MatchHistoryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'match_id') int matchId,@JsonKey(name: 'played_at') String playedAt,@JsonKey(name: 'is_donkey') bool isDonkey,@JsonKey(name: 'final_rank') int? finalRank,@JsonKey(name: 'tricks_won') int tricksWon,@JsonKey(name: 'coins_won') int coinsWon,@JsonKey(name: 'match_status') String matchStatus
});




}
/// @nodoc
class _$MatchHistoryModelCopyWithImpl<$Res>
    implements $MatchHistoryModelCopyWith<$Res> {
  _$MatchHistoryModelCopyWithImpl(this._self, this._then);

  final MatchHistoryModel _self;
  final $Res Function(MatchHistoryModel) _then;

/// Create a copy of MatchHistoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matchId = null,Object? playedAt = null,Object? isDonkey = null,Object? finalRank = freezed,Object? tricksWon = null,Object? coinsWon = null,Object? matchStatus = null,}) {
  return _then(_self.copyWith(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as String,isDonkey: null == isDonkey ? _self.isDonkey : isDonkey // ignore: cast_nullable_to_non_nullable
as bool,finalRank: freezed == finalRank ? _self.finalRank : finalRank // ignore: cast_nullable_to_non_nullable
as int?,tricksWon: null == tricksWon ? _self.tricksWon : tricksWon // ignore: cast_nullable_to_non_nullable
as int,coinsWon: null == coinsWon ? _self.coinsWon : coinsWon // ignore: cast_nullable_to_non_nullable
as int,matchStatus: null == matchStatus ? _self.matchStatus : matchStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchHistoryModel].
extension MatchHistoryModelPatterns on MatchHistoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchHistoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchHistoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchHistoryModel value)  $default,){
final _that = this;
switch (_that) {
case _MatchHistoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchHistoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _MatchHistoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'match_id')  int matchId, @JsonKey(name: 'played_at')  String playedAt, @JsonKey(name: 'is_donkey')  bool isDonkey, @JsonKey(name: 'final_rank')  int? finalRank, @JsonKey(name: 'tricks_won')  int tricksWon, @JsonKey(name: 'coins_won')  int coinsWon, @JsonKey(name: 'match_status')  String matchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchHistoryModel() when $default != null:
return $default(_that.matchId,_that.playedAt,_that.isDonkey,_that.finalRank,_that.tricksWon,_that.coinsWon,_that.matchStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'match_id')  int matchId, @JsonKey(name: 'played_at')  String playedAt, @JsonKey(name: 'is_donkey')  bool isDonkey, @JsonKey(name: 'final_rank')  int? finalRank, @JsonKey(name: 'tricks_won')  int tricksWon, @JsonKey(name: 'coins_won')  int coinsWon, @JsonKey(name: 'match_status')  String matchStatus)  $default,) {final _that = this;
switch (_that) {
case _MatchHistoryModel():
return $default(_that.matchId,_that.playedAt,_that.isDonkey,_that.finalRank,_that.tricksWon,_that.coinsWon,_that.matchStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'match_id')  int matchId, @JsonKey(name: 'played_at')  String playedAt, @JsonKey(name: 'is_donkey')  bool isDonkey, @JsonKey(name: 'final_rank')  int? finalRank, @JsonKey(name: 'tricks_won')  int tricksWon, @JsonKey(name: 'coins_won')  int coinsWon, @JsonKey(name: 'match_status')  String matchStatus)?  $default,) {final _that = this;
switch (_that) {
case _MatchHistoryModel() when $default != null:
return $default(_that.matchId,_that.playedAt,_that.isDonkey,_that.finalRank,_that.tricksWon,_that.coinsWon,_that.matchStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchHistoryModel implements MatchHistoryModel {
  const _MatchHistoryModel({@JsonKey(name: 'match_id') required this.matchId, @JsonKey(name: 'played_at') required this.playedAt, @JsonKey(name: 'is_donkey') required this.isDonkey, @JsonKey(name: 'final_rank') this.finalRank, @JsonKey(name: 'tricks_won') required this.tricksWon, @JsonKey(name: 'coins_won') required this.coinsWon, @JsonKey(name: 'match_status') required this.matchStatus});
  factory _MatchHistoryModel.fromJson(Map<String, dynamic> json) => _$MatchHistoryModelFromJson(json);

@override@JsonKey(name: 'match_id') final  int matchId;
@override@JsonKey(name: 'played_at') final  String playedAt;
@override@JsonKey(name: 'is_donkey') final  bool isDonkey;
@override@JsonKey(name: 'final_rank') final  int? finalRank;
@override@JsonKey(name: 'tricks_won') final  int tricksWon;
@override@JsonKey(name: 'coins_won') final  int coinsWon;
@override@JsonKey(name: 'match_status') final  String matchStatus;

/// Create a copy of MatchHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchHistoryModelCopyWith<_MatchHistoryModel> get copyWith => __$MatchHistoryModelCopyWithImpl<_MatchHistoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchHistoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchHistoryModel&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.isDonkey, isDonkey) || other.isDonkey == isDonkey)&&(identical(other.finalRank, finalRank) || other.finalRank == finalRank)&&(identical(other.tricksWon, tricksWon) || other.tricksWon == tricksWon)&&(identical(other.coinsWon, coinsWon) || other.coinsWon == coinsWon)&&(identical(other.matchStatus, matchStatus) || other.matchStatus == matchStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,playedAt,isDonkey,finalRank,tricksWon,coinsWon,matchStatus);

@override
String toString() {
  return 'MatchHistoryModel(matchId: $matchId, playedAt: $playedAt, isDonkey: $isDonkey, finalRank: $finalRank, tricksWon: $tricksWon, coinsWon: $coinsWon, matchStatus: $matchStatus)';
}


}

/// @nodoc
abstract mixin class _$MatchHistoryModelCopyWith<$Res> implements $MatchHistoryModelCopyWith<$Res> {
  factory _$MatchHistoryModelCopyWith(_MatchHistoryModel value, $Res Function(_MatchHistoryModel) _then) = __$MatchHistoryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'match_id') int matchId,@JsonKey(name: 'played_at') String playedAt,@JsonKey(name: 'is_donkey') bool isDonkey,@JsonKey(name: 'final_rank') int? finalRank,@JsonKey(name: 'tricks_won') int tricksWon,@JsonKey(name: 'coins_won') int coinsWon,@JsonKey(name: 'match_status') String matchStatus
});




}
/// @nodoc
class __$MatchHistoryModelCopyWithImpl<$Res>
    implements _$MatchHistoryModelCopyWith<$Res> {
  __$MatchHistoryModelCopyWithImpl(this._self, this._then);

  final _MatchHistoryModel _self;
  final $Res Function(_MatchHistoryModel) _then;

/// Create a copy of MatchHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? playedAt = null,Object? isDonkey = null,Object? finalRank = freezed,Object? tricksWon = null,Object? coinsWon = null,Object? matchStatus = null,}) {
  return _then(_MatchHistoryModel(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as String,isDonkey: null == isDonkey ? _self.isDonkey : isDonkey // ignore: cast_nullable_to_non_nullable
as bool,finalRank: freezed == finalRank ? _self.finalRank : finalRank // ignore: cast_nullable_to_non_nullable
as int?,tricksWon: null == tricksWon ? _self.tricksWon : tricksWon // ignore: cast_nullable_to_non_nullable
as int,coinsWon: null == coinsWon ? _self.coinsWon : coinsWon // ignore: cast_nullable_to_non_nullable
as int,matchStatus: null == matchStatus ? _self.matchStatus : matchStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
