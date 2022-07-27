import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/customized_pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/bloc/pokemon_list_bloc.dart';

void main() {
  group('Pokemon List Bloc State', () {
    test('has correct status', () {
      const state = PokemonListState(status: PokemonListStatus.loading);
      expect(state.status, PokemonListStatus.loading);
    });
    test('has correct copy with', () {
      const state = PokemonListState();
      final newState = state.copyWith(
        status: PokemonListStatus.fetched,
        pokemonList: const [CustomizedPokemon(pokemon: Pokemon())],
        isMaxLimitReached: true,
      );
      expect(newState.status, PokemonListStatus.fetched);
      expect(newState.pokemonList, const [CustomizedPokemon(pokemon: Pokemon())]);
      expect(newState.isMaxLimitReached, true);
    });
  });
}
