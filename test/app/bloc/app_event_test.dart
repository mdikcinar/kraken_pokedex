import 'package:authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/core/bloc/app_bloc.dart';
import 'package:mocktail/mocktail.dart';

class UserMock extends Mock implements User {}

void main() {
  group('App Event', () {
    group('AppUserChanged', () {
      final user = UserMock();
      test('supports value comparisons', () {
        expect(
          AppUserChanged(user),
          AppUserChanged(user),
        );
      });
    });

    group('AppLogoutRequested', () {
      test('supports value comparisons', () {
        expect(
          AppLogoutRequested(),
          AppLogoutRequested(),
        );
      });
    });
  });
}
