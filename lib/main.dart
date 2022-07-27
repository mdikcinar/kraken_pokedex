import 'package:authentication/authentication.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kraken_pokedex/firebase_options.dart';
import 'package:kraken_pokedex/src/app.dart';
import 'package:kraken_pokedex/src/core/bloc/bloc_observer.dart';
import 'package:kraken_pokedex/src/core/init/network/chopper_client.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/service/pokemon_api_service.dart';
import 'package:kraken_pokedex/src/utils/constants/app_constants.dart';

void main() async {
  final chopperClient = ChopperClientBuilder.buildChopperClient(
    [
      PokemonApiService.create(),
    ],
  );
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final authRepository = AuthRepository();
      runApp(
        EasyLocalization(
          supportedLocales: const [
            Locale('en', 'US'),
          ],
          path: AppConstants.localizationsPath.value,
          fallbackLocale: const Locale('en', 'US'),
          child: App(authRepository, chopperClient),
        ),
      );
    },
    blocObserver: AppBlocObserver(),
  );
}
