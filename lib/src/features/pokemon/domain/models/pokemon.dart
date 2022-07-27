import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:kraken_pokedex/src/core/models/base_model.dart';

part 'pokemon.g.dart';

@JsonSerializable(createToJson: false)
class Pokemon extends Equatable with BaseModel<Pokemon> {
  const Pokemon({this.name, this.url});
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return _$PokemonFromJson(json);
  }

  final String? name;
  final String? url;

  @override
  Pokemon fromJson(Map<String, dynamic> json) => Pokemon.fromJson(json);

  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }

  @override
  String toString() {
    return 'Pokemon( name: $name, url: $url, )';
  }

  @override
  List<Object?> get props => [name, url];
}
