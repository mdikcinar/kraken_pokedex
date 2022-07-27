import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/repository/base_pokemon_repository.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/customized_pokemon.dart';
import 'package:stream_transform/stream_transform.dart';

part 'pokemon_list_event.dart';
part 'pokemon_list_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  PokemonListBloc(this._pokemonRepository) : super(const PokemonListState()) {
    on<PokemonListFetched>(
      _onPokemonListFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }
  final IPokemonRepository _pokemonRepository;

  final throttleDuration = const Duration(milliseconds: 200);

  ///max count of items to be get
  int _postLimit = 12;

  ///max number of items the state will receive
  final _maxPostCount = 50;

  ///current item offset for GET request
  int _offset = 0;

  Future<void> _onPokemonListFetched(PokemonListFetched event, Emitter<PokemonListState> emit) async {
    if (state.isMaxLimitReached) return;
    try {
      if (_offset + _postLimit >= _maxPostCount) {
        _postLimit = _maxPostCount - _offset;
      }
      if (_postLimit == 0) {
        emit(state.copyWith(isMaxLimitReached: true));
        return;
      }
      if (state.pokemonList.isNotEmpty) emit(state.copyWith(status: PokemonListStatus.loading));
      final pokemonList = await _pokemonRepository.fetchPokemonList(offset: _offset, postLimit: _postLimit);
      _offset += _postLimit;
      pokemonList == null && pokemonList!.isEmpty
          ? emit(
              state.copyWith(
                isMaxLimitReached: true,
                status: PokemonListStatus.fetched,
              ),
            )
          : emit(
              state.copyWith(
                status: PokemonListStatus.fetched,
                pokemonList: List.of(state.pokemonList)..addAll(pokemonList),
                isMaxLimitReached: false,
              ),
            );
    } catch (exception) {
      emit(state.copyWith(status: PokemonListStatus.failure));
    }
  }
}
