import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kraken_pokedex/src/core/extensions/context_extension.dart';
import 'package:kraken_pokedex/src/core/extensions/string_extension.dart';
import 'package:kraken_pokedex/src/core/widgets/card/skelton.dart';
import 'package:kraken_pokedex/src/core/widgets/other/custom_shimmer.dart';
import 'package:kraken_pokedex/src/core/widgets/text/custom_text.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/customized_pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon_detail.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/bloc/pokemon_detail_bloc.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/view/details_tabbar_view.dart';

class PokemonDetailView extends StatelessWidget {
  const PokemonDetailView({super.key, required this.pokemon});
  final CustomizedPokemon? pokemon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: pokemon?.backgroundColor != null ? Color(int.parse(pokemon!.backgroundColor!)) : Colors.grey),
        Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.height * 0.07),
                  topRight: Radius.circular(context.height * 0.07),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: context.theme.scaffoldBackgroundColor),
                  child: SizedBox(
                    height: context.height * 0.7,
                    width: context.width,
                    child: Padding(
                      padding: EdgeInsets.only(top: context.height * 0.08),
                      child: Column(
                        children: [
                          _NameAndTypeColumn(pokemon: pokemon),
                          SizedBox(height: context.normalPadding),
                          Expanded(
                            child: DetailsTabBarView(
                              pokemon: pokemon,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: context.height * 0.02),
                child: const _PokemonImage(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PokemonImage extends StatelessWidget {
  const _PokemonImage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
      buildWhen: (previous, current) => current.status == PokemonDetailStatus.fetched,
      builder: (context, state) {
        return Image.network(
          state.detail?.imageUrl ?? '',
          height: context.height * 0.35,
          errorBuilder: (_, __, ___) => const _ImageShimmer(key: Key('imageShimmer')),
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : const _ImageShimmer(key: Key('imageShimmer')),
        );
      },
    );
  }
}

class _ImageShimmer extends StatelessWidget {
  const _ImageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.height * 0.1),
      child: const CustomShimmer(
        child: Skelton(height: 200, width: 200),
      ),
    );
  }
}

class _NameAndTypeColumn extends StatelessWidget {
  const _NameAndTypeColumn({required this.pokemon});

  final CustomizedPokemon? pokemon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
      buildWhen: (previous, current) => current.status == PokemonDetailStatus.fetched,
      builder: (context, state) {
        return state.status == PokemonDetailStatus.initial
            ? const _NameAndTypesShimmer(key: Key('nameAndTypesShimmer'))
            : Column(
                children: [
                  CustomText.custom(
                    state.detail?.name?.capitalize() ?? '      ',
                    textSize: context.height * 0.035,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (Types type in state.detail?.types ?? <Types>[])
                        Chip(
                          label: CustomText(type.type?.name?.capitalize()),
                          backgroundColor:
                              pokemon?.backgroundColor != null ? Color(int.parse(pokemon!.backgroundColor!)) : null,
                        ),
                    ],
                  ),
                ],
              );
      },
    );
  }
}

class _NameAndTypesShimmer extends StatelessWidget {
  const _NameAndTypesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Column(
        children: [
          Skelton(height: context.height * 0.055, width: 100),
          SizedBox(height: context.normalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Skelton(height: context.height * 0.04, width: 50),
              Skelton(height: context.height * 0.04, width: 50),
            ],
          )
        ],
      ),
    );
  }
}
