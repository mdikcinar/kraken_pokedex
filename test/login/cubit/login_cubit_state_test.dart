import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/cubit/login_cubit.dart';

void main() {
  group('Login Cubit State', () {
    test('has correct error status', () {
      const state = LoginError(message: 'error');
      expect(state.message, 'error');
    });
  });
}
