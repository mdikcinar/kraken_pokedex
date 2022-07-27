import 'package:authentication/authentication.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/view/login_page.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/view/login_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

void main() {
  late AuthRepository authRepository;

  setUp(() {
    authRepository = AuthRepositoryMock();
  });

  group('Login Page', () {
    testWidgets('displays Login view', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          RepositoryProvider(
            create: (context) => authRepository,
            child: RepositoryProvider<ChopperClient>(
              create: (context) => helperChopperClient,
              child: const LoginPage(),
            ),
          ),
        ),
      );
      expect(find.byType(LoginView), findsOneWidget);
    });
  });
}
