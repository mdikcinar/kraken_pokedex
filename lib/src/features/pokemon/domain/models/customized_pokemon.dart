import 'package:equatable/equatable.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon.dart';

class CustomizedPokemon extends Equatable {
  const CustomizedPokemon({
    required this.pokemon,
    this.id,
    this.backgroundColor,
  });
  final Pokemon pokemon;
  final int? id;
  final String? backgroundColor;

  @override
  String toString() {
    return 'CustomizedPokemon(id: $id, name: ${pokemon.name}, url: ${pokemon.url}, backgroundColor: $backgroundColor)';
  }

  @override
  List<Object?> get props => [id, pokemon, backgroundColor];
}
