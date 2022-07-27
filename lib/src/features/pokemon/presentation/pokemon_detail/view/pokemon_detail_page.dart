import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/repository/pokemon_repository.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/service/pokemon_api_service.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/customized_pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/bloc/pokemon_detail_bloc.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/view/pokemon_detail_view.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    CustomizedPokemon? pokemon;
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is CustomizedPokemon) pokemon = arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: BlocProvider<PokemonDetailBloc>(
        create: (context) => PokemonDetailBloc(
          PokemonRepository(context.read<ChopperClient>().getService<PokemonApiService>()),
          pokemonId: pokemon?.id ?? 1,
        )..add(PokemonDetailFetched()),
        child: PokemonDetailView(
          pokemon: pokemon,
        ),
      ),
    );
  }
}
