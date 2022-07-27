import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kraken_pokedex/src/core/init/network/chopper_client.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/service/pokemon_api_service.dart';
import 'package:kraken_pokedex/src/utils/constants/app_constants.dart';

Widget createWidgetUnderTest(Widget widget) {
  return MaterialApp(
    home: widget,
  );
}

Widget createLocalizedWidgetForTesting({required Widget child}) {
  return EasyLocalization(
    supportedLocales: const [Locale('en', 'US')],
    path: AppConstants.localizationsPath.value,
    fallbackLocale: const Locale('en', 'US'),
    child: child,
  );
}

final helperHttpClientMock = MockClient((request) async {
  return http.Response('get response', 200);
});

final helperChopperClient = ChopperClientBuilder.buildChopperClient(
  [
    PokemonApiService.create(),
  ],
  helperHttpClientMock,
);

const pokemonDetailMockData = '''
{
   "name":"bulbasaur",
   "abilities":[
      {
         "ability":{
            "name":"overgrow",
            "url":"https://pokeapi.co/api/v2/ability/65/"
         },
         "is_hidden":false,
         "slot":1
      }
   ],
   "moves":[
      {
         "move":{
            "name":"razor-wind",
            "url":"https://pokeapi.co/api/v2/move/13/"
         },
         "version_group_details":[
            {
               "level_learned_at":0
            }
         ]
      }
   ],
   "sprites":{
      "other":{
         "home":{
            "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png"
         }
      }
   },
   "stats":[
      {
         "base_stat":45,
         "effort":0,
         "stat":{
            "name":"hp",
            "url":"https://pokeapi.co/api/v2/stat/1/"
         }
      }
   ],
   "types":[
      {
         "slot":1,
         "type":{
            "name":"grass",
            "url":"https://pokeapi.co/api/v2/type/12/"
         }
      }
   ]
}
''';
