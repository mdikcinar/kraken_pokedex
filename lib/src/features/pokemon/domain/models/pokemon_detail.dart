import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kraken_pokedex/src/core/models/base_model.dart';

part 'pokemon_detail.g.dart';

@JsonSerializable(createToJson: false)
class PokemonDetail extends Equatable with BaseModel<PokemonDetail> {
  PokemonDetail({
    this.abilities,
    this.moves,
    this.name,
    this.stats,
    this.types,
    this.imageUrl,
  });
  factory PokemonDetail.fromJson(Map<String, dynamic> json) => _$PokemonDetailFromJson(json);

  final List<Abilities>? abilities;
  final List<Moves>? moves;
  final String? name;
  final List<Stats>? stats;
  final List<Types>? types;
  @_ImageConverter()
  @JsonKey(name: 'sprites')
  final String? imageUrl;

  @override
  PokemonDetail fromJson(Map<String, dynamic> json) {
    return _$PokemonDetailFromJson(json);
  }

  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [abilities, moves, name, stats, types, imageUrl];
}

class _ImageConverter implements JsonConverter<String?, Map<String, dynamic>?> {
  const _ImageConverter();
  @override
  String? fromJson(Map<String, dynamic>? json) {
    if (json is! Map<String, dynamic>) return null;
    final string = json['other']?['home']?['front_default'] as String?;
    return string;
  }

  @override
  Map<String, dynamic>? toJson(String? object) => null;
}

@JsonSerializable(createToJson: false)
class Abilities extends Equatable with BaseModel<Abilities> {
  Abilities({this.ability, this.isHidden, this.slot});
  factory Abilities.fromJson(Map<String, dynamic> json) => _$AbilitiesFromJson(json);

  final Ability? ability;
  @JsonKey(name: 'is_hidden')
  final bool? isHidden;
  final int? slot;

  @override
  Abilities fromJson(Map<String, dynamic> json) {
    return _$AbilitiesFromJson(json);
  }

  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [ability, isHidden, slot];
}

@JsonSerializable(createToJson: false)
class Ability extends Equatable with BaseModel<Ability> {
  Ability({this.name, this.url});
  factory Ability.fromJson(Map<String, dynamic> json) => _$AbilityFromJson(json);

  final String? name;
  final String? url;

  @override
  Ability fromJson(Map<String, dynamic> json) {
    return _$AbilityFromJson(json);
  }

  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [name, url];
}

@JsonSerializable(createToJson: false)
class Moves extends Equatable with BaseModel<Moves> {
  Moves({this.move, this.versionGroupDetails});
  factory Moves.fromJson(Map<String, dynamic> json) => _$MovesFromJson(json);

  final Ability? move;
  @JsonKey(name: 'version_group_details')
  final List<VersionGroupDetails>? versionGroupDetails;

  @override
  Moves fromJson(Map<String, dynamic> json) {
    return _$MovesFromJson(json);
  }

  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [move, versionGroupDetails];
}

@JsonSerializable(createToJson: false)
class VersionGroupDetails extends Equatable with BaseModel<VersionGroupDetails> {
  VersionGroupDetails({this.levelLearnedAt, this.moveLearnMethod, this.versionGroup});
  factory VersionGroupDetails.fromJson(Map<String, dynamic> json) => _$VersionGroupDetailsFromJson(json);
  @JsonKey(name: 'level_learned_at')
  final int? levelLearnedAt;
  @JsonKey(name: 'more_learn_method')
  final Ability? moveLearnMethod;
  @JsonKey(name: 'version_group')
  final Ability? versionGroup;

  @override
  VersionGroupDetails fromJson(Map<String, dynamic> json) {
    return _$VersionGroupDetailsFromJson(json);
  }

  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [levelLearnedAt, moveLearnMethod, versionGroup];
}

@JsonSerializable(createToJson: false)
class Stats extends Equatable with BaseModel<Stats> {
  Stats({this.baseStat, this.effort, this.stat});
  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);
  @JsonKey(name: 'base_stat')
  final int? baseStat;
  final int? effort;
  final Ability? stat;

  @override
  Stats fromJson(Map<String, dynamic> json) {
    return _$StatsFromJson(json);
  }

  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [baseStat, effort, stat];
}

@JsonSerializable(createToJson: false)
class Types extends Equatable with BaseModel<Types> {
  Types({this.slot, this.type});
  factory Types.fromJson(Map<String, dynamic> json) => _$TypesFromJson(json);

  final int? slot;
  final Ability? type;

  @override
  Types fromJson(Map<String, dynamic> json) {
    return _$TypesFromJson(json);
  }

  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [slot, type];
}
