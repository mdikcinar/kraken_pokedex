part of 'pokemon_list_bloc.dart';

enum PokemonListStatus { initial, loading, fetched, failure }

class PokemonListState extends Equatable {
  const PokemonListState({
    this.status = PokemonListStatus.initial,
    this.pokemonList = const <CustomizedPokemon>[],
    this.isMaxLimitReached = false,
  });

  final PokemonListStatus status;
  final List<CustomizedPokemon> pokemonList;
  final bool isMaxLimitReached;

  PokemonListState copyWith({
    PokemonListStatus? status,
    List<CustomizedPokemon>? pokemonList,
    bool? isMaxLimitReached,
  }) {
    return PokemonListState(
      status: status ?? this.status,
      pokemonList: pokemonList ?? this.pokemonList,
      isMaxLimitReached: isMaxLimitReached ?? this.isMaxLimitReached,
    );
  }

  @override
  List<Object> get props => [status, pokemonList, isMaxLimitReached];
}
