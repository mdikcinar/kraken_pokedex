import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon_detail.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/bloc/pokemon_detail_bloc.dart';

void main() {
  group('Pokemon Detail Bloc State', () {
    test('has correct status', () {
      const state = PokemonDetailState(status: PokemonDetailStatus.fetched);
      expect(state.status, PokemonDetailStatus.fetched);
    });
    test('has correct copy with', () {
      const state = PokemonDetailState();
      final newState = state.copyWith(
        status: PokemonDetailStatus.fetched,
        detail: PokemonDetail(),
      );
      expect(newState.status, PokemonDetailStatus.fetched);
      expect(newState.detail, PokemonDetail());
    });
  });
}
