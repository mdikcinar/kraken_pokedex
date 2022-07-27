import 'package:easy_localization/easy_localization.dart';
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
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/helpers/localization_helper.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/helpers/stat_color_extension.dart';
import 'package:kraken_pokedex/src/utils/language/locale_keys.g.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DetailsTabBarView extends StatefulWidget {
  const DetailsTabBarView({super.key, required this.pokemon});
  final CustomizedPokemon? pokemon;

  @override
  State<DetailsTabBarView> createState() => _DetailsTabBarViewState();
}

class _DetailsTabBarViewState extends State<DetailsTabBarView> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: widget.pokemon?.backgroundColor != null
              ? Color(int.parse(widget.pokemon!.backgroundColor!))
              : Colors.grey,
          tabs: [
            Tab(child: CustomText(LocaleKeys.detail_page_stats_title.tr(), key: const Key('statText'))),
            Tab(child: CustomText(LocaleKeys.detail_page_abilities_title.tr(), key: const Key('abilitiesText'))),
            Tab(child: CustomText(LocaleKeys.detail_page_moves_title.tr(), key: const Key('movesText')))
          ],
        ),
        SizedBox(height: context.normalPadding),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.highPadding),
            child: TabBarView(
              controller: _tabController,
              children: const [
                _StatsTab(),
                _AbilitiesTab(key: Key('abilitiesTab')),
                _MovesTab(key: Key('movesTab')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsTab extends StatelessWidget {
  const _StatsTab();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
      buildWhen: (previous, current) => current.status == PokemonDetailStatus.fetched,
      builder: (context, state) {
        return state.status == PokemonDetailStatus.initial
            ? const _StatsTabShimmer(key: Key('statsShimmer'))
            : Column(
                children: [
                  for (Stats stat in state.detail?.stats ?? <Stats>[]) _StatWidget(stat: stat),
                ],
              );
      },
    );
  }
}

class _StatsTabShimmer extends StatelessWidget {
  const _StatsTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Column(
        children: [
          for (var i = 0; i < 5; i++)
            Padding(
              padding: EdgeInsets.all(context.normalPadding),
              child: Row(
                children: [
                  Skelton(height: context.highTextSize, width: context.width * 0.3),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Skelton(height: context.highTextSize, width: context.width * 0.1),
                        SizedBox(width: context.normalPadding),
                        Skelton(height: context.highTextSize, width: context.width * 0.4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatWidget extends StatelessWidget {
  const _StatWidget({required this.stat});
  final Stats stat;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.lowPadding),
      child: Row(
        children: [
          CustomText(stat.stat?.name?.localizeStatName),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(stat.baseStat?.toString()),
                LinearPercentIndicator(
                  width: context.width * 0.5,
                  animation: true,
                  barRadius: Radius.circular(context.lowRadius),
                  percent: calculatePercent(stat.baseStat),
                  progressColor: stat.baseStat.statColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculatePercent(int? stat) {
    if (stat != null && stat > 100) return 1;
    final percent = 1 - ((100 - (stat ?? 0)) / 100);
    if (percent < 0 || percent > 1) return 0;
    return percent;
  }
}

class _AbilitiesTab extends StatelessWidget {
  const _AbilitiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
      buildWhen: (previous, current) => current.status == PokemonDetailStatus.fetched,
      builder: (context, state) {
        return Column(
          children: [
            for (Abilities ability in state.detail?.abilities ?? <Abilities>[])
              Chip(label: CustomText(ability.ability?.name?.capitalize())),
          ],
        );
      },
    );
  }
}

class _MovesTab extends StatelessWidget {
  const _MovesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
      buildWhen: (previous, current) => current.status == PokemonDetailStatus.fetched,
      builder: (context, state) {
        final moves = state.detail?.moves;
        return ListView.builder(
          key: const Key('movesListView'),
          padding: EdgeInsets.zero,
          itemCount: moves?.length,
          itemBuilder: (context, index) {
            final move = moves?[index];
            var learnedLevel = 0;
            for (final groupDetail in move?.versionGroupDetails ?? <VersionGroupDetails>[]) {
              if (groupDetail.levelLearnedAt != null && groupDetail.levelLearnedAt! > learnedLevel) {
                learnedLevel = groupDetail.levelLearnedAt!;
                break;
              }
            }
            return ListTile(
              title: CustomText(move?.move?.name?.capitalize()),
              subtitle: learnedLevel > 0 ? CustomText.low('Level ${learnedLevel.toString()}') : null,
            );
          },
        );
      },
    );
  }
}
