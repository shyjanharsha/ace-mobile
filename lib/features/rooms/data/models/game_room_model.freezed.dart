// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameRoomModel {

 int get id; String get code; String get status;@JsonKey(name: 'room_type') String get roomType;@JsonKey(name: 'host_id') int get hostId;@JsonKey(name: 'max_players') int get maxPlayers;@JsonKey(name: 'bet_coins') int get betCoins;@JsonKey(name: 'player_count') int get playerCount; List<RoomPlayerModel>? get players;
/// Create a copy of GameRoomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameRoomModelCopyWith<GameRoomModel> get copyWith => _$GameRoomModelCopyWithImpl<GameRoomModel>(this as GameRoomModel, _$identity);

  /// Serializes this GameRoomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameRoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers)&&(identical(other.betCoins, betCoins) || other.betCoins == betCoins)&&(identical(other.playerCount, playerCount) || other.playerCount == playerCount)&&const DeepCollectionEquality().equals(other.players, players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,status,roomType,hostId,maxPlayers,betCoins,playerCount,const DeepCollectionEquality().hash(players));

@override
String toString() {
  return 'GameRoomModel(id: $id, code: $code, status: $status, roomType: $roomType, hostId: $hostId, maxPlayers: $maxPlayers, betCoins: $betCoins, playerCount: $playerCount, players: $players)';
}


}

/// @nodoc
abstract mixin class $GameRoomModelCopyWith<$Res>  {
  factory $GameRoomModelCopyWith(GameRoomModel value, $Res Function(GameRoomModel) _then) = _$GameRoomModelCopyWithImpl;
@useResult
$Res call({
 int id, String code, String status,@JsonKey(name: 'room_type') String roomType,@JsonKey(name: 'host_id') int hostId,@JsonKey(name: 'max_players') int maxPlayers,@JsonKey(name: 'bet_coins') int betCoins,@JsonKey(name: 'player_count') int playerCount, List<RoomPlayerModel>? players
});




}
/// @nodoc
class _$GameRoomModelCopyWithImpl<$Res>
    implements $GameRoomModelCopyWith<$Res> {
  _$GameRoomModelCopyWithImpl(this._self, this._then);

  final GameRoomModel _self;
  final $Res Function(GameRoomModel) _then;

/// Create a copy of GameRoomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? status = null,Object? roomType = null,Object? hostId = null,Object? maxPlayers = null,Object? betCoins = null,Object? playerCount = null,Object? players = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,roomType: null == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as int,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,betCoins: null == betCoins ? _self.betCoins : betCoins // ignore: cast_nullable_to_non_nullable
as int,playerCount: null == playerCount ? _self.playerCount : playerCount // ignore: cast_nullable_to_non_nullable
as int,players: freezed == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<RoomPlayerModel>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameRoomModel].
extension GameRoomModelPatterns on GameRoomModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameRoomModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameRoomModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameRoomModel value)  $default,){
final _that = this;
switch (_that) {
case _GameRoomModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameRoomModel value)?  $default,){
final _that = this;
switch (_that) {
case _GameRoomModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  String status, @JsonKey(name: 'room_type')  String roomType, @JsonKey(name: 'host_id')  int hostId, @JsonKey(name: 'max_players')  int maxPlayers, @JsonKey(name: 'bet_coins')  int betCoins, @JsonKey(name: 'player_count')  int playerCount,  List<RoomPlayerModel>? players)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameRoomModel() when $default != null:
return $default(_that.id,_that.code,_that.status,_that.roomType,_that.hostId,_that.maxPlayers,_that.betCoins,_that.playerCount,_that.players);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  String status, @JsonKey(name: 'room_type')  String roomType, @JsonKey(name: 'host_id')  int hostId, @JsonKey(name: 'max_players')  int maxPlayers, @JsonKey(name: 'bet_coins')  int betCoins, @JsonKey(name: 'player_count')  int playerCount,  List<RoomPlayerModel>? players)  $default,) {final _that = this;
switch (_that) {
case _GameRoomModel():
return $default(_that.id,_that.code,_that.status,_that.roomType,_that.hostId,_that.maxPlayers,_that.betCoins,_that.playerCount,_that.players);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  String status, @JsonKey(name: 'room_type')  String roomType, @JsonKey(name: 'host_id')  int hostId, @JsonKey(name: 'max_players')  int maxPlayers, @JsonKey(name: 'bet_coins')  int betCoins, @JsonKey(name: 'player_count')  int playerCount,  List<RoomPlayerModel>? players)?  $default,) {final _that = this;
switch (_that) {
case _GameRoomModel() when $default != null:
return $default(_that.id,_that.code,_that.status,_that.roomType,_that.hostId,_that.maxPlayers,_that.betCoins,_that.playerCount,_that.players);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameRoomModel implements GameRoomModel {
  const _GameRoomModel({required this.id, required this.code, required this.status, @JsonKey(name: 'room_type') required this.roomType, @JsonKey(name: 'host_id') required this.hostId, @JsonKey(name: 'max_players') required this.maxPlayers, @JsonKey(name: 'bet_coins') required this.betCoins, @JsonKey(name: 'player_count') required this.playerCount, final  List<RoomPlayerModel>? players}): _players = players;
  factory _GameRoomModel.fromJson(Map<String, dynamic> json) => _$GameRoomModelFromJson(json);

@override final  int id;
@override final  String code;
@override final  String status;
@override@JsonKey(name: 'room_type') final  String roomType;
@override@JsonKey(name: 'host_id') final  int hostId;
@override@JsonKey(name: 'max_players') final  int maxPlayers;
@override@JsonKey(name: 'bet_coins') final  int betCoins;
@override@JsonKey(name: 'player_count') final  int playerCount;
 final  List<RoomPlayerModel>? _players;
@override List<RoomPlayerModel>? get players {
  final value = _players;
  if (value == null) return null;
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GameRoomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameRoomModelCopyWith<_GameRoomModel> get copyWith => __$GameRoomModelCopyWithImpl<_GameRoomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameRoomModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameRoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers)&&(identical(other.betCoins, betCoins) || other.betCoins == betCoins)&&(identical(other.playerCount, playerCount) || other.playerCount == playerCount)&&const DeepCollectionEquality().equals(other._players, _players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,status,roomType,hostId,maxPlayers,betCoins,playerCount,const DeepCollectionEquality().hash(_players));

@override
String toString() {
  return 'GameRoomModel(id: $id, code: $code, status: $status, roomType: $roomType, hostId: $hostId, maxPlayers: $maxPlayers, betCoins: $betCoins, playerCount: $playerCount, players: $players)';
}


}

/// @nodoc
abstract mixin class _$GameRoomModelCopyWith<$Res> implements $GameRoomModelCopyWith<$Res> {
  factory _$GameRoomModelCopyWith(_GameRoomModel value, $Res Function(_GameRoomModel) _then) = __$GameRoomModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String status,@JsonKey(name: 'room_type') String roomType,@JsonKey(name: 'host_id') int hostId,@JsonKey(name: 'max_players') int maxPlayers,@JsonKey(name: 'bet_coins') int betCoins,@JsonKey(name: 'player_count') int playerCount, List<RoomPlayerModel>? players
});




}
/// @nodoc
class __$GameRoomModelCopyWithImpl<$Res>
    implements _$GameRoomModelCopyWith<$Res> {
  __$GameRoomModelCopyWithImpl(this._self, this._then);

  final _GameRoomModel _self;
  final $Res Function(_GameRoomModel) _then;

/// Create a copy of GameRoomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? status = null,Object? roomType = null,Object? hostId = null,Object? maxPlayers = null,Object? betCoins = null,Object? playerCount = null,Object? players = freezed,}) {
  return _then(_GameRoomModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,roomType: null == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as int,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,betCoins: null == betCoins ? _self.betCoins : betCoins // ignore: cast_nullable_to_non_nullable
as int,playerCount: null == playerCount ? _self.playerCount : playerCount // ignore: cast_nullable_to_non_nullable
as int,players: freezed == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<RoomPlayerModel>?,
  ));
}


}

// dart format on
