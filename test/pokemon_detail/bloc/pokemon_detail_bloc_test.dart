import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kraken_pokedex/src/core/init/network/chopper_client.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/repository/pokemon_repository.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/service/pokemon_api_service.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon_detail.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/bloc/pokemon_detail_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers.dart';

class PokemonRepositoryMock extends Mock implements PokemonRepository {}

void main() {
  late PokemonRepositoryMock pokemonRepository;
  const pokemonId = 1;
  late ChopperClient chopperClient;

  setUp(() {
    pokemonRepository = PokemonRepositoryMock();
  });

  group('PokemonDetail Bloc', () {
    test('initial state is PokemonDetailStatus.initial', () {
      expect(PokemonDetailBloc(pokemonRepository, pokemonId: pokemonId).state.status, PokemonDetailStatus.initial);
    });

    blocTest<PokemonDetailBloc, PokemonDetailState>(
      'emits failure status when get exception',
      setUp: () {
        when(() => pokemonRepository.fetchPokemonDetails(pokemonId: pokemonId)).thenThrow(Exception());
      },
      build: () => PokemonDetailBloc(pokemonRepository, pokemonId: pokemonId),
      act: (bloc) => bloc.add(PokemonDetailFetched()),
      expect: () => <PokemonDetailState>[
        const PokemonDetailState(
          status: PokemonDetailStatus.failure,
        ),
      ],
      verify: (_) {
        verify(() => pokemonRepository.fetchPokemonDetails(pokemonId: pokemonId)).called(1);
      },
    );

    blocTest<PokemonDetailBloc, PokemonDetailState>(
      'chopper fetches details, bloc emits successful status',
      setUp: () {
        final httpClient = MockClient((request) async {
          return http.Response(
            pokemonDetailMockData,
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
      build: () => PokemonDetailBloc(PokemonRepository(PokemonApiService.create(chopperClient)), pokemonId: pokemonId),
      act: (bloc) => bloc.add(PokemonDetailFetched()),
      wait: const Duration(milliseconds: 200),
      expect: () => <PokemonDetailState>[
        PokemonDetailState(
          status: PokemonDetailStatus.fetched,
          detail: PokemonDetail.fromJson(jsonDecode(pokemonDetailMockData) as Map<String, dynamic>),
        )
      ],
    );
  });
}
