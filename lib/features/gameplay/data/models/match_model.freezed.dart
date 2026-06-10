// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchPlayerModel {

@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'seat_position') int get seatPosition;@JsonKey(name: 'is_donkey') bool get isDonkey;@JsonKey(name: 'final_rank') int? get finalRank;@JsonKey(name: 'tricks_won') int get tricksWon;@JsonKey(name: 'coins_won') int get coinsWon;
/// Create a copy of MatchPlayerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchPlayerModelCopyWith<MatchPlayerModel> get copyWith => _$MatchPlayerModelCopyWithImpl<MatchPlayerModel>(this as MatchPlayerModel, _$identity);

  /// Serializes this MatchPlayerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchPlayerModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.seatPosition, seatPosition) || other.seatPosition == seatPosition)&&(identical(other.isDonkey, isDonkey) || other.isDonkey == isDonkey)&&(identical(other.finalRank, finalRank) || other.finalRank == finalRank)&&(identical(other.tricksWon, tricksWon) || other.tricksWon == tricksWon)&&(identical(other.coinsWon, coinsWon) || other.coinsWon == coinsWon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,seatPosition,isDonkey,finalRank,tricksWon,coinsWon);

@override
String toString() {
  return 'MatchPlayerModel(userId: $userId, seatPosition: $seatPosition, isDonkey: $isDonkey, finalRank: $finalRank, tricksWon: $tricksWon, coinsWon: $coinsWon)';
}


}

/// @nodoc
abstract mixin class $MatchPlayerModelCopyWith<$Res>  {
  factory $MatchPlayerModelCopyWith(MatchPlayerModel value, $Res Function(MatchPlayerModel) _then) = _$MatchPlayerModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'seat_position') int seatPosition,@JsonKey(name: 'is_donkey') bool isDonkey,@JsonKey(name: 'final_rank') int? finalRank,@JsonKey(name: 'tricks_won') int tricksWon,@JsonKey(name: 'coins_won') int coinsWon
});




}
/// @nodoc
class _$MatchPlayerModelCopyWithImpl<$Res>
    implements $MatchPlayerModelCopyWith<$Res> {
  _$MatchPlayerModelCopyWithImpl(this._self, this._then);

  final MatchPlayerModel _self;
  final $Res Function(MatchPlayerModel) _then;

/// Create a copy of MatchPlayerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? seatPosition = null,Object? isDonkey = null,Object? finalRank = freezed,Object? tricksWon = null,Object? coinsWon = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,seatPosition: null == seatPosition ? _self.seatPosition : seatPosition // ignore: cast_nullable_to_non_nullable
as int,isDonkey: null == isDonkey ? _self.isDonkey : isDonkey // ignore: cast_nullable_to_non_nullable
as bool,finalRank: freezed == finalRank ? _self.finalRank : finalRank // ignore: cast_nullable_to_non_nullable
as int?,tricksWon: null == tricksWon ? _self.tricksWon : tricksWon // ignore: cast_nullable_to_non_nullable
as int,coinsWon: null == coinsWon ? _self.coinsWon : coinsWon // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchPlayerModel].
extension MatchPlayerModelPatterns on MatchPlayerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchPlayerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchPlayerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchPlayerModel value)  $default,){
final _that = this;
switch (_that) {
case _MatchPlayerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchPlayerModel value)?  $default,){
final _that = this;
switch (_that) {
case _MatchPlayerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'seat_position')  int seatPosition, @JsonKey(name: 'is_donkey')  bool isDonkey, @JsonKey(name: 'final_rank')  int? finalRank, @JsonKey(name: 'tricks_won')  int tricksWon, @JsonKey(name: 'coins_won')  int coinsWon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchPlayerModel() when $default != null:
return $default(_that.userId,_that.seatPosition,_that.isDonkey,_that.finalRank,_that.tricksWon,_that.coinsWon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'seat_position')  int seatPosition, @JsonKey(name: 'is_donkey')  bool isDonkey, @JsonKey(name: 'final_rank')  int? finalRank, @JsonKey(name: 'tricks_won')  int tricksWon, @JsonKey(name: 'coins_won')  int coinsWon)  $default,) {final _that = this;
switch (_that) {
case _MatchPlayerModel():
return $default(_that.userId,_that.seatPosition,_that.isDonkey,_that.finalRank,_that.tricksWon,_that.coinsWon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'seat_position')  int seatPosition, @JsonKey(name: 'is_donkey')  bool isDonkey, @JsonKey(name: 'final_rank')  int? finalRank, @JsonKey(name: 'tricks_won')  int tricksWon, @JsonKey(name: 'coins_won')  int coinsWon)?  $default,) {final _that = this;
switch (_that) {
case _MatchPlayerModel() when $default != null:
return $default(_that.userId,_that.seatPosition,_that.isDonkey,_that.finalRank,_that.tricksWon,_that.coinsWon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchPlayerModel implements MatchPlayerModel {
  const _MatchPlayerModel({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'seat_position') required this.seatPosition, @JsonKey(name: 'is_donkey') required this.isDonkey, @JsonKey(name: 'final_rank') this.finalRank, @JsonKey(name: 'tricks_won') required this.tricksWon, @JsonKey(name: 'coins_won') required this.coinsWon});
  factory _MatchPlayerModel.fromJson(Map<String, dynamic> json) => _$MatchPlayerModelFromJson(json);

@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'seat_position') final  int seatPosition;
@override@JsonKey(name: 'is_donkey') final  bool isDonkey;
@override@JsonKey(name: 'final_rank') final  int? finalRank;
@override@JsonKey(name: 'tricks_won') final  int tricksWon;
@override@JsonKey(name: 'coins_won') final  int coinsWon;

/// Create a copy of MatchPlayerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchPlayerModelCopyWith<_MatchPlayerModel> get copyWith => __$MatchPlayerModelCopyWithImpl<_MatchPlayerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchPlayerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchPlayerModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.seatPosition, seatPosition) || other.seatPosition == seatPosition)&&(identical(other.isDonkey, isDonkey) || other.isDonkey == isDonkey)&&(identical(other.finalRank, finalRank) || other.finalRank == finalRank)&&(identical(other.tricksWon, tricksWon) || other.tricksWon == tricksWon)&&(identical(other.coinsWon, coinsWon) || other.coinsWon == coinsWon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,seatPosition,isDonkey,finalRank,tricksWon,coinsWon);

@override
String toString() {
  return 'MatchPlayerModel(userId: $userId, seatPosition: $seatPosition, isDonkey: $isDonkey, finalRank: $finalRank, tricksWon: $tricksWon, coinsWon: $coinsWon)';
}


}

/// @nodoc
abstract mixin class _$MatchPlayerModelCopyWith<$Res> implements $MatchPlayerModelCopyWith<$Res> {
  factory _$MatchPlayerModelCopyWith(_MatchPlayerModel value, $Res Function(_MatchPlayerModel) _then) = __$MatchPlayerModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'seat_position') int seatPosition,@JsonKey(name: 'is_donkey') bool isDonkey,@JsonKey(name: 'final_rank') int? finalRank,@JsonKey(name: 'tricks_won') int tricksWon,@JsonKey(name: 'coins_won') int coinsWon
});




}
/// @nodoc
class __$MatchPlayerModelCopyWithImpl<$Res>
    implements _$MatchPlayerModelCopyWith<$Res> {
  __$MatchPlayerModelCopyWithImpl(this._self, this._then);

  final _MatchPlayerModel _self;
  final $Res Function(_MatchPlayerModel) _then;

/// Create a copy of MatchPlayerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? seatPosition = null,Object? isDonkey = null,Object? finalRank = freezed,Object? tricksWon = null,Object? coinsWon = null,}) {
  return _then(_MatchPlayerModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,seatPosition: null == seatPosition ? _self.seatPosition : seatPosition // ignore: cast_nullable_to_non_nullable
as int,isDonkey: null == isDonkey ? _self.isDonkey : isDonkey // ignore: cast_nullable_to_non_nullable
as bool,finalRank: freezed == finalRank ? _self.finalRank : finalRank // ignore: cast_nullable_to_non_nullable
as int?,tricksWon: null == tricksWon ? _self.tricksWon : tricksWon // ignore: cast_nullable_to_non_nullable
as int,coinsWon: null == coinsWon ? _self.coinsWon : coinsWon // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MatchRoomModel {

 int get id; String get code;
/// Create a copy of MatchRoomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchRoomModelCopyWith<MatchRoomModel> get copyWith => _$MatchRoomModelCopyWithImpl<MatchRoomModel>(this as MatchRoomModel, _$identity);

  /// Serializes this MatchRoomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchRoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code);

@override
String toString() {
  return 'MatchRoomModel(id: $id, code: $code)';
}


}

/// @nodoc
abstract mixin class $MatchRoomModelCopyWith<$Res>  {
  factory $MatchRoomModelCopyWith(MatchRoomModel value, $Res Function(MatchRoomModel) _then) = _$MatchRoomModelCopyWithImpl;
@useResult
$Res call({
 int id, String code
});




}
/// @nodoc
class _$MatchRoomModelCopyWithImpl<$Res>
    implements $MatchRoomModelCopyWith<$Res> {
  _$MatchRoomModelCopyWithImpl(this._self, this._then);

  final MatchRoomModel _self;
  final $Res Function(MatchRoomModel) _then;

/// Create a copy of MatchRoomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchRoomModel].
extension MatchRoomModelPatterns on MatchRoomModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchRoomModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchRoomModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchRoomModel value)  $default,){
final _that = this;
switch (_that) {
case _MatchRoomModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchRoomModel value)?  $default,){
final _that = this;
switch (_that) {
case _MatchRoomModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchRoomModel() when $default != null:
return $default(_that.id,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code)  $default,) {final _that = this;
switch (_that) {
case _MatchRoomModel():
return $default(_that.id,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code)?  $default,) {final _that = this;
switch (_that) {
case _MatchRoomModel() when $default != null:
return $default(_that.id,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchRoomModel implements MatchRoomModel {
  const _MatchRoomModel({required this.id, required this.code});
  factory _MatchRoomModel.fromJson(Map<String, dynamic> json) => _$MatchRoomModelFromJson(json);

@override final  int id;
@override final  String code;

/// Create a copy of MatchRoomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchRoomModelCopyWith<_MatchRoomModel> get copyWith => __$MatchRoomModelCopyWithImpl<_MatchRoomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchRoomModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchRoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code);

@override
String toString() {
  return 'MatchRoomModel(id: $id, code: $code)';
}


}

/// @nodoc
abstract mixin class _$MatchRoomModelCopyWith<$Res> implements $MatchRoomModelCopyWith<$Res> {
  factory _$MatchRoomModelCopyWith(_MatchRoomModel value, $Res Function(_MatchRoomModel) _then) = __$MatchRoomModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String code
});




}
/// @nodoc
class __$MatchRoomModelCopyWithImpl<$Res>
    implements _$MatchRoomModelCopyWith<$Res> {
  __$MatchRoomModelCopyWithImpl(this._self, this._then);

  final _MatchRoomModel _self;
  final $Res Function(_MatchRoomModel) _then;

/// Create a copy of MatchRoomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,}) {
  return _then(_MatchRoomModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MatchModel {

 int get id; String get status;@JsonKey(name: 'started_at') String? get startedAt;@JsonKey(name: 'ended_at') String? get endedAt;@JsonKey(name: 'duration_s') int? get durationS; MatchRoomModel get room;@JsonKey(name: 'winner_id') int? get winnerId; List<MatchPlayerModel> get players;
/// Create a copy of MatchModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchModelCopyWith<MatchModel> get copyWith => _$MatchModelCopyWithImpl<MatchModel>(this as MatchModel, _$identity);

  /// Serializes this MatchModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.room, room) || other.room == room)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&const DeepCollectionEquality().equals(other.players, players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,startedAt,endedAt,durationS,room,winnerId,const DeepCollectionEquality().hash(players));

@override
String toString() {
  return 'MatchModel(id: $id, status: $status, startedAt: $startedAt, endedAt: $endedAt, durationS: $durationS, room: $room, winnerId: $winnerId, players: $players)';
}


}

/// @nodoc
abstract mixin class $MatchModelCopyWith<$Res>  {
  factory $MatchModelCopyWith(MatchModel value, $Res Function(MatchModel) _then) = _$MatchModelCopyWithImpl;
@useResult
$Res call({
 int id, String status,@JsonKey(name: 'started_at') String? startedAt,@JsonKey(name: 'ended_at') String? endedAt,@JsonKey(name: 'duration_s') int? durationS, MatchRoomModel room,@JsonKey(name: 'winner_id') int? winnerId, List<MatchPlayerModel> players
});


$MatchRoomModelCopyWith<$Res> get room;

}
/// @nodoc
class _$MatchModelCopyWithImpl<$Res>
    implements $MatchModelCopyWith<$Res> {
  _$MatchModelCopyWithImpl(this._self, this._then);

  final MatchModel _self;
  final $Res Function(MatchModel) _then;

/// Create a copy of MatchModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? startedAt = freezed,Object? endedAt = freezed,Object? durationS = freezed,Object? room = null,Object? winnerId = freezed,Object? players = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as String?,durationS: freezed == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int?,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as MatchRoomModel,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as int?,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<MatchPlayerModel>,
  ));
}
/// Create a copy of MatchModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchRoomModelCopyWith<$Res> get room {
  
  return $MatchRoomModelCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}
}


/// Adds pattern-matching-related methods to [MatchModel].
extension MatchModelPatterns on MatchModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchModel value)  $default,){
final _that = this;
switch (_that) {
case _MatchModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchModel value)?  $default,){
final _that = this;
switch (_that) {
case _MatchModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String status, @JsonKey(name: 'started_at')  String? startedAt, @JsonKey(name: 'ended_at')  String? endedAt, @JsonKey(name: 'duration_s')  int? durationS,  MatchRoomModel room, @JsonKey(name: 'winner_id')  int? winnerId,  List<MatchPlayerModel> players)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchModel() when $default != null:
return $default(_that.id,_that.status,_that.startedAt,_that.endedAt,_that.durationS,_that.room,_that.winnerId,_that.players);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String status, @JsonKey(name: 'started_at')  String? startedAt, @JsonKey(name: 'ended_at')  String? endedAt, @JsonKey(name: 'duration_s')  int? durationS,  MatchRoomModel room, @JsonKey(name: 'winner_id')  int? winnerId,  List<MatchPlayerModel> players)  $default,) {final _that = this;
switch (_that) {
case _MatchModel():
return $default(_that.id,_that.status,_that.startedAt,_that.endedAt,_that.durationS,_that.room,_that.winnerId,_that.players);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String status, @JsonKey(name: 'started_at')  String? startedAt, @JsonKey(name: 'ended_at')  String? endedAt, @JsonKey(name: 'duration_s')  int? durationS,  MatchRoomModel room, @JsonKey(name: 'winner_id')  int? winnerId,  List<MatchPlayerModel> players)?  $default,) {final _that = this;
switch (_that) {
case _MatchModel() when $default != null:
return $default(_that.id,_that.status,_that.startedAt,_that.endedAt,_that.durationS,_that.room,_that.winnerId,_that.players);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchModel implements MatchModel {
  const _MatchModel({required this.id, required this.status, @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'ended_at') this.endedAt, @JsonKey(name: 'duration_s') this.durationS, required this.room, @JsonKey(name: 'winner_id') this.winnerId, required final  List<MatchPlayerModel> players}): _players = players;
  factory _MatchModel.fromJson(Map<String, dynamic> json) => _$MatchModelFromJson(json);

@override final  int id;
@override final  String status;
@override@JsonKey(name: 'started_at') final  String? startedAt;
@override@JsonKey(name: 'ended_at') final  String? endedAt;
@override@JsonKey(name: 'duration_s') final  int? durationS;
@override final  MatchRoomModel room;
@override@JsonKey(name: 'winner_id') final  int? winnerId;
 final  List<MatchPlayerModel> _players;
@override List<MatchPlayerModel> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}


/// Create a copy of MatchModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchModelCopyWith<_MatchModel> get copyWith => __$MatchModelCopyWithImpl<_MatchModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.room, room) || other.room == room)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&const DeepCollectionEquality().equals(other._players, _players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,startedAt,endedAt,durationS,room,winnerId,const DeepCollectionEquality().hash(_players));

@override
String toString() {
  return 'MatchModel(id: $id, status: $status, startedAt: $startedAt, endedAt: $endedAt, durationS: $durationS, room: $room, winnerId: $winnerId, players: $players)';
}


}

/// @nodoc
abstract mixin class _$MatchModelCopyWith<$Res> implements $MatchModelCopyWith<$Res> {
  factory _$MatchModelCopyWith(_MatchModel value, $Res Function(_MatchModel) _then) = __$MatchModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String status,@JsonKey(name: 'started_at') String? startedAt,@JsonKey(name: 'ended_at') String? endedAt,@JsonKey(name: 'duration_s') int? durationS, MatchRoomModel room,@JsonKey(name: 'winner_id') int? winnerId, List<MatchPlayerModel> players
});


@override $MatchRoomModelCopyWith<$Res> get room;

}
/// @nodoc
class __$MatchModelCopyWithImpl<$Res>
    implements _$MatchModelCopyWith<$Res> {
  __$MatchModelCopyWithImpl(this._self, this._then);

  final _MatchModel _self;
  final $Res Function(_MatchModel) _then;

/// Create a copy of MatchModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? startedAt = freezed,Object? endedAt = freezed,Object? durationS = freezed,Object? room = null,Object? winnerId = freezed,Object? players = null,}) {
  return _then(_MatchModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as String?,durationS: freezed == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int?,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as MatchRoomModel,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as int?,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<MatchPlayerModel>,
  ));
}

/// Create a copy of MatchModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchRoomModelCopyWith<$Res> get room {
  
  return $MatchRoomModelCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}
}

// dart format on
