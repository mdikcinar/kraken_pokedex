import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/repository/base_pokemon_repository.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon_detail.dart';

part 'pokemon_detail_event.dart';
part 'pokemon_detail_state.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  PokemonDetailBloc(this._pokemonRepository, {required int pokemonId})
      : _pokemonId = pokemonId,
        super(const PokemonDetailState()) {
    on<PokemonDetailFetched>(_onPokemonDetailFetched);
  }
  final IPokemonRepository _pokemonRepository;
  final int _pokemonId;

  Future<void> _onPokemonDetailFetched(PokemonDetailFetched event, Emitter<PokemonDetailState> emit) async {
    try {
      final pokemonDetails = await _pokemonRepository.fetchPokemonDetails(pokemonId: _pokemonId);
      emit(
        state.copyWith(
          status: PokemonDetailStatus.fetched,
          detail: pokemonDetails,
        ),
      );
    } catch (exception) {
      emit(state.copyWith(status: PokemonDetailStatus.failure));
    }
  }
}
