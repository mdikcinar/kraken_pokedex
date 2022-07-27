import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/customized_pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/bloc/pokemon_list_bloc.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/view/pokemon_list.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers.dart';

class MockPokemonListBloc extends MockBloc<PokemonListEvent, PokemonListState> implements PokemonListBloc {}

class FakePokemonListState extends Fake implements PokemonListState {}

extension on WidgetTester {
  Future<void> pumpPokemonList(PokemonListBloc bloc) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider<PokemonListBloc>(
          create: (context) => bloc,
          child: const Scaffold(
            body: PokemonList(),
          ),
        ),
      ),
    );
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PokemonListBloc pokemonListBloc;

  setUpAll(() {
    registerFallbackValue(FakePokemonListState());
  });

  setUp(() {
    pokemonListBloc = MockPokemonListBloc();
  });
  group('Pokemon List', () {
    testWidgets(
        'renders CircularProgressIndicator while '
        'waiting for initial items to load', (tester) async {
      when(() => pokemonListBloc.state).thenReturn(const PokemonListState());
      await tester.pumpPokemonList(pokemonListBloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets(
        'renders bottom CircularProgressIndicator while '
        'waiting for paginated items to load', (tester) async {
      when(() => pokemonListBloc.state).thenReturn(const PokemonListState(status: PokemonListStatus.loading));
      await tester.pumpPokemonList(pokemonListBloc);
      expect(find.byKey(const Key('bottomLoader')), findsOneWidget);
    });
    testWidgets('lists pokemon cards', (tester) async {
      when(() => pokemonListBloc.state).thenReturn(
        PokemonListState(
          status: PokemonListStatus.fetched,
          pokemonList: List.generate(
            2,
            (i) => CustomizedPokemon(
              id: i,
              pokemon: Pokemon(
                name: 'pokemon name $i',
              ),
            ),
          ),
        ),
      );
      await tester.pumpPokemonList(pokemonListBloc);
      expect(find.byKey(const Key('pokemonCard0')), findsOneWidget);
      expect(find.byKey(const Key('pokemonCard1')), findsOneWidget);
    });
    testWidgets('fetches pokemons when scrolled bottom', (tester) async {
      when(() => pokemonListBloc.state).thenReturn(
        PokemonListState(
          status: PokemonListStatus.fetched,
          pokemonList: List.generate(
            12,
            (i) => CustomizedPokemon(
              id: i,
              pokemon: Pokemon(
                name: 'pokemon name $i',
              ),
            ),
          ),
        ),
      );
      await tester.pumpPokemonList(pokemonListBloc);
      await tester.drag(find.byType(GridView), const Offset(0, -1700));
      verify(() => pokemonListBloc.add(PokemonListFetched())).called(1);
    });
  });

  group('Pokemon Card', () {
    testWidgets('displays pokemon name,id and image', (tester) async {
      const pokemon = CustomizedPokemon(
        id: 1,
        pokemon: Pokemon(name: 'pokemon name 1'),
      );
      await tester.pumpWidget(
        createWidgetUnderTest(
          Scaffold(
            body: pokemonCard(pokemon),
          ),
        ),
      );
      expect(find.byKey(const Key('pokemonName')), findsOneWidget);
      expect(find.text('Pokemon name 1'), findsOneWidget);
      expect(find.byKey(const Key('pokemonId')), findsOneWidget);
      expect(find.byKey(const Key('pokemonImage')), findsOneWidget);
    });
  });
}
