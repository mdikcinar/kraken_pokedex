import 'package:bloc_test/bloc_test.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kraken_pokedex/src/core/init/network/chopper_client.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/repository/pokemon_repository.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/service/pokemon_api_service.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/customized_pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/bloc/pokemon_list_bloc.dart';
import 'package:mocktail/mocktail.dart';

class PokemonRepositoryMock extends Mock implements PokemonRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PokemonRepositoryMock pokemonRepository;

  setUp(() {
    pokemonRepository = PokemonRepositoryMock();
  });
  group('Pokemon List Bloc test', () {
    test('initial state is PokemonListState', () {
      expect(PokemonListBloc(pokemonRepository).state, const PokemonListState());
    });

    group('Pokemons Fetched', () {
      late ChopperClient chopperClient;
      blocTest<PokemonListBloc, PokemonListState>(
        'emits nothing when pokemonList has reached maximum amount',
        build: () => PokemonListBloc(pokemonRepository),
        seed: () => const PokemonListState(isMaxLimitReached: true),
        act: (bloc) => bloc.add(PokemonListFetched()),
        expect: () => <PokemonListState>[],
      );
      blocTest<PokemonListBloc, PokemonListState>(
        'emits failure status when get exception',
        setUp: () {
          when(
            () => pokemonRepository.fetchPokemonList(offset: 0, postLimit: 12),
          ).thenThrow(
            Exception(),
          );
        },
        build: () => PokemonListBloc(pokemonRepository),
        act: (bloc) => bloc.add(PokemonListFetched()),
        seed: () => const PokemonListState(),
        expect: () => <PokemonListState>[
          const PokemonListState(
            status: PokemonListStatus.failure,
          )
        ],
      );

      blocTest<PokemonListBloc, PokemonListState>(
        'chopper fetches pokemon list, bloc generates background color and emits successful status',
        setUp: () {
          final httpClient = MockClient((request) async {
            return http.Response(
              '''
            {              
                "count": 1154,
                "next": "https://pokeapi.co/api/v2/pokemon?offset=10&limit=10",
                "previous": null,
                "results": [
                  {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/1/"
                    }
                ]
            }
            ''',
              200,
            );
          });
          chopperClient = ChopperClientBuilder.buildChopperClient(
            [
              PokemonApiService.create(),
            ],
            httpClient,
          );
        },
        build: () => PokemonListBloc(PokemonRepository(PokemonApiService.create(chopperClient))),
        act: (bloc) => bloc.add(PokemonListFetched()),
        wait: const Duration(milliseconds: 200),
        expect: () => <PokemonListState>[
          const PokemonListState(
            status: PokemonListStatus.fetched,
            pokemonList: [
              CustomizedPokemon(
                id: 1,
                pokemon: Pokemon(
                  name: 'bulbasaur',
                  url: 'https://pokeapi.co/api/v2/pokemon/1/',
                ),
                backgroundColor: '4292538865',
              ),
            ],
          )
        ],
      );
    });
  });
}
