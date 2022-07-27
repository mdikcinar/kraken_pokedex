import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/customized_pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon_detail.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/bloc/pokemon_detail_bloc.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/view/pokemon_detail_view.dart';
import 'package:mocktail/mocktail.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../helpers.dart';

class MockPokemonDetailBloc extends MockBloc<PokemonDetailEvent, PokemonDetailState> implements PokemonDetailBloc {}

extension on WidgetTester {
  Future<void> pumpPokemonDetail(PokemonDetailBloc bloc, CustomizedPokemon pokemon) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider<PokemonDetailBloc>(
          create: (context) => bloc,
          child: Scaffold(
            body: PokemonDetailView(pokemon: pokemon),
          ),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PokemonDetailBloc pokemonDetailBloc;
  const mockPokemon = CustomizedPokemon(
    id: 1,
    pokemon: Pokemon(name: 'pokemon', url: ''),
    backgroundColor: '4292538865',
  );
  final mockPokemonDetail = PokemonDetail.fromJson(jsonDecode(pokemonDetailMockData) as Map<String, dynamic>);

  setUpAll(() => HttpOverrides.global = null);

  setUp(() {
    pokemonDetailBloc = MockPokemonDetailBloc();
  });
  group('Detail View', () {
    testWidgets('displays shimmers and correct initial state', (tester) async {
      when(() => pokemonDetailBloc.state).thenReturn(const PokemonDetailState());
      await tester.pumpPokemonDetail(pokemonDetailBloc, mockPokemon);
      final nameAndTypesShimmer = find.byKey(const Key('nameAndTypesShimmer'));
      final statsShimmer = find.byKey(const Key('statsShimmer'));
      final statText = find.byKey(const Key('statText'));
      final abilitiesText = find.byKey(const Key('abilitiesText'));
      final detailText = find.byKey(const Key('movesText'));

      expect(nameAndTypesShimmer, findsOneWidget);
      expect(statsShimmer, findsOneWidget);
      expect(statText, findsOneWidget);
      expect(abilitiesText, findsOneWidget);
      expect(detailText, findsOneWidget);
    });

    group('Data loaded', () {
      testWidgets('displays details when loaded', (tester) async {
        when(() => pokemonDetailBloc.state).thenReturn(
          PokemonDetailState(
            status: PokemonDetailStatus.fetched,
            detail: mockPokemonDetail,
          ),
        );
        await tester.pumpPokemonDetail(pokemonDetailBloc, mockPokemon);
        final pokemonNameText = find.text('Bulbasaur');
        final typeText = find.text('Grass');
        final hpStatText = find.text('hp');
        final hpStatValueText = find.text('45');
        final linearPercentIndicator = find.byType(LinearPercentIndicator);
        expect(pokemonNameText, findsOneWidget);
        expect(typeText, findsOneWidget);
        expect(hpStatText, findsOneWidget);
        expect(hpStatValueText, findsOneWidget);
        expect(linearPercentIndicator, findsOneWidget);
      });
    });
    testWidgets('displays abilities when tab bar tapped', (tester) async {
      when(() => pokemonDetailBloc.state).thenReturn(
        PokemonDetailState(
          status: PokemonDetailStatus.fetched,
          detail: mockPokemonDetail,
        ),
      );
      final abilitiesText = find.byKey(const Key('abilitiesText'));
      await tester.pumpPokemonDetail(pokemonDetailBloc, mockPokemon);
      await tester.tap(abilitiesText);
      await tester.pumpAndSettle();
      final abilityText = find.text('Overgrow');
      expect(abilityText, findsOneWidget);
    });
    testWidgets('displays moves when tab bar tapped', (tester) async {
      when(() => pokemonDetailBloc.state).thenReturn(
        PokemonDetailState(
          status: PokemonDetailStatus.fetched,
          detail: mockPokemonDetail,
        ),
      );
      final movesText = find.byKey(const Key('movesText'));
      final movesListView = find.byKey(const Key('movesListView'));
      await tester.pumpPokemonDetail(pokemonDetailBloc, mockPokemon);
      await tester.tap(movesText);
      await tester.pumpAndSettle();
      final moveText = find.text('Razor-wind');
      expect(movesListView, findsOneWidget);
      expect(moveText, findsOneWidget);
    });
  });
}
