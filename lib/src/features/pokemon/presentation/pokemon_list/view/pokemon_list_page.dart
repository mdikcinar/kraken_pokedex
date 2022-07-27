import 'package:chopper/chopper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kraken_pokedex/src/core/bloc/app_bloc.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/repository/pokemon_repository.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/service/pokemon_api_service.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/bloc/pokemon_list_bloc.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/view/pokemon_list.dart';
import 'package:kraken_pokedex/src/utils/language/locale_keys.g.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  static Page<dynamic> page() => const MaterialPage<void>(child: PokemonListPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.app_name.tr(), key: const Key('appNameText')),
        centerTitle: true,
        actions: [
          TextButton(
            key: const Key('logout-button'),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
            child: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: BlocProvider<PokemonListBloc>(
        create: (context) => PokemonListBloc(
          PokemonRepository(context.read<ChopperClient>().getService<PokemonApiService>()),
        )..add(PokemonListFetched()),
        child: const PokemonList(),
      ),
    );
  }
}
