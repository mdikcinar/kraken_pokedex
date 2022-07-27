import 'package:authentication/authentication.dart';
import 'package:chopper/chopper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kraken_pokedex/src/core/bloc/app_bloc.dart';
import 'package:kraken_pokedex/src/core/init/navigation/navigation_route.dart';
import 'package:kraken_pokedex/src/core/init/navigation/navigation_service.dart';
import 'package:kraken_pokedex/src/features/routes/routes.dart';
import 'package:kraken_pokedex/src/utils/theme/app_themes.dart';

class App extends StatelessWidget {
  const App(
    this._authRepository,
    this._chopperClient, {
    super.key,
  });
  final AuthRepository _authRepository;
  final ChopperClient _chopperClient;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: BlocProvider<AppBloc>(
        create: (context) => AppBloc(_authRepository),
        child: RepositoryProvider(
          create: (context) => _chopperClient,
          child: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kraken Pokedex',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppThemes.light,
      navigatorKey: NavigationService.instance.navigatorKey,
      onGenerateRoute: NavigationRoute.instance.generateRoute,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
