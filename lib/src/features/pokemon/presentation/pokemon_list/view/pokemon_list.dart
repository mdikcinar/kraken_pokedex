import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kraken_pokedex/src/core/extensions/context_extension.dart';
import 'package:kraken_pokedex/src/core/extensions/string_extension.dart';
import 'package:kraken_pokedex/src/core/init/navigation/app_routes.dart';
import 'package:kraken_pokedex/src/core/init/navigation/navigation_service.dart';
import 'package:kraken_pokedex/src/core/widgets/buttons/custom_inkwell.dart';
import 'package:kraken_pokedex/src/core/widgets/text/custom_text.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/customized_pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/bloc/pokemon_list_bloc.dart';
import 'package:kraken_pokedex/src/utils/constants/app_constants.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.normalPadding),
      child: BlocBuilder<PokemonListBloc, PokemonListState>(
        builder: (context, state) {
          if (state.status == PokemonListStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: context.extraLowPadding,
                    mainAxisSpacing: context.extraLowPadding,
                  ),
                  itemCount: state.pokemonList.length,
                  itemBuilder: (context, index) {
                    final pokemon = state.pokemonList[index];
                    return _PokemonCard(key: Key('pokemonCard${pokemon.id}'), pokemon: pokemon);
                  },
                ),
              ),
              if (state.status == PokemonListStatus.loading)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.highPadding),
                  child: const CircularProgressIndicator(key: Key('bottomLoader')),
                ),
            ],
          );
        },
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<PokemonListBloc>().add(PokemonListFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

@visibleForTesting
Widget pokemonCard(CustomizedPokemon pokemon) => _PokemonCard(pokemon: pokemon);

class _PokemonCard extends StatelessWidget {
  const _PokemonCard({
    super.key,
    required this.pokemon,
  });
  final CustomizedPokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return CustomInkwell(
      onTap: () => NavigationService.instance.toNamed(AppRoutes.details, arguments: pokemon),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.height * 0.05),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.normalRadius)),
              color: pokemon.backgroundColor != null ? Color(int.parse(pokemon.backgroundColor!)) : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText('#${pokemon.id.toString().padLeft(2, '0')}', key: const Key('pokemonId')),
                  CustomText('${pokemon.pokemon.name}'.capitalize(), key: const Key('pokemonName')),
                  SizedBox(height: context.highPadding),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              '${AppConstants.pokemonImagesPath.value}/${pokemon.id ?? 0}.png',
              key: const Key('pokemonImage'),
            ),
          ),
        ],
      ),
    );
  }
}
