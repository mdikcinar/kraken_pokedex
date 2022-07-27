// ignore_for_file: must_be_immutable

import 'package:authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

const _mockFirebaseUserUid = 'mock-uid';
const _mockFirebaseUserEmail = 'mock-email';

mixin LegacyEquality {
  @override
  bool operator ==(dynamic other) => false;

  @override
  int get hashCode => 0;
}

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockFacebookAuth extends Mock implements FacebookAuth {}

class MockFirebaseUser extends Mock implements firebase_auth.User {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock with LegacyEquality implements GoogleSignInAccount {}

class MockFacebookLoginResult extends Mock with LegacyEquality implements LoginResult {}

class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}

class FakeAuthProvider extends Fake implements AuthProvider {}

class FakeFacebookAuthProvider extends Fake implements FacebookAuthProvider {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const user = User(
    id: _mockFirebaseUserUid,
    email: _mockFirebaseUserEmail,
  );

  group('AuthRepository', () {
    late firebase_auth.FirebaseAuth firebaseAuth;
    late FacebookAuth facebookAuth;
    late GoogleSignIn googleSignIn;
    late AuthRepository authenticationRepository;

    setUpAll(() async {
      registerFallbackValue(FakeAuthCredential());
      registerFallbackValue(FakeAuthProvider());
      registerFallbackValue(FakeFacebookAuthProvider());
    });

    setUp(() {
      facebookAuth = MockFacebookAuth();
      firebaseAuth = MockFirebaseAuth();
      googleSignIn = MockGoogleSignIn();
      authenticationRepository = AuthRepository(
        facebookAuth: facebookAuth,
        firebaseAuth: firebaseAuth,
        googleSignIn: googleSignIn,
      );
    });

    group('signInWithFacebook', () {
      setUp(() {
        final loginResult = MockFacebookLoginResult();
        when(() => loginResult.accessToken).thenReturn(
          AccessToken.fromJson(
            {
              'token': 'fake_token',
              'userId': '123456',
              'expires': 1646057049123,
              'lastRefresh': 1646057049123,
              'applicationId': '1646057049123',
              'isExpired': false,
              'permissions': ['email'],
              'declinedPermissions': []
            },
          ),
        );
        when(() => facebookAuth.login()).thenAnswer((_) async => loginResult);
        when(() => firebaseAuth.signInWithCredential(any())).thenAnswer((_) => Future.value(MockUserCredential()));
        when(() => firebaseAuth.signInWithPopup(any())).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signIn authentication, and signInWithCredential', () async {
        await authenticationRepository.signInWithFacebook();
        verify(() => facebookAuth.login()).called(1);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('succeeds when signIn succeeds', () {
        expect(authenticationRepository.signInWithFacebook(), completes);
      });

      test('throws LogInWithFacebookFailure when exception occurs', () async {
        when(() => firebaseAuth.signInWithCredential(any())).thenThrow(Exception());
        expect(
          authenticationRepository.signInWithFacebook(),
          throwsA(isA<LogInWithFacebookFailure>()),
        );
      });
    });
    group('signInWithGoogle', () {
      const accessToken = 'access-token';
      const idToken = 'id-token';

      setUp(() {
        final googleSignInAuthentication = MockGoogleSignInAuthentication();
        final googleSignInAccount = MockGoogleSignInAccount();
        when(() => googleSignInAuthentication.accessToken).thenReturn(accessToken);
        when(() => googleSignInAuthentication.idToken).thenReturn(idToken);
        when(() => googleSignInAccount.authentication).thenAnswer((_) async => googleSignInAuthentication);
        when(() => googleSignIn.signIn()).thenAnswer((_) async => googleSignInAccount);
        when(() => firebaseAuth.signInWithCredential(any())).thenAnswer((_) => Future.value(MockUserCredential()));
        when(() => firebaseAuth.signInWithPopup(any())).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signIn authentication, and signInWithCredential', () async {
        await authenticationRepository.signInWithGoogle();
        verify(() => googleSignIn.signIn()).called(1);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test(
          'throws LogInWithGoogleFailure and calls signIn authentication, and '
          'signInWithPopup when authCredential is null and kIsWeb is true', () async {
        authenticationRepository.isWeb = true;
        await expectLater(
          () => authenticationRepository.signInWithGoogle(),
          throwsA(isA<LogInWithGoogleFailure>()),
        );
        verifyNever(() => googleSignIn.signIn());
        verify(() => firebaseAuth.signInWithPopup(any())).called(1);
      });

      test(
          'successfully calls signIn authentication, and '
          'signInWithPopup when authCredential is not null and kIsWeb is true', () async {
        final credential = MockUserCredential();
        when(() => firebaseAuth.signInWithPopup(any())).thenAnswer((_) async => credential);
        when(() => credential.credential).thenReturn(FakeAuthCredential());
        authenticationRepository.isWeb = true;
        await expectLater(
          authenticationRepository.signInWithGoogle(),
          completes,
        );
        verifyNever(() => googleSignIn.signIn());
        verify(() => firebaseAuth.signInWithPopup(any())).called(1);
      });

      test('succeeds when signIn succeeds', () {
        expect(authenticationRepository.signInWithGoogle(), completes);
      });

      test('throws LogInWithGoogleFailure when exception occurs', () async {
        when(() => firebaseAuth.signInWithCredential(any())).thenThrow(Exception());
        expect(
          authenticationRepository.signInWithGoogle(),
          throwsA(isA<LogInWithGoogleFailure>()),
        );
      });
    });

    group('signInAnonymously', () {
      setUp(() {
        when(() => firebaseAuth.signInAnonymously()).thenAnswer((_) => Future.value(MockUserCredential()));
        when(() => firebaseAuth.signInWithPopup(any())).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signIn authentication, and signInAnonymously', () async {
        await authenticationRepository.signInAnonymously();
        verify(() => firebaseAuth.signInAnonymously()).called(1);
      });

      test('succeeds when signIn succeeds', () {
        expect(authenticationRepository.signInAnonymously(), completes);
      });

      test('throws LogInAnonymouslyFailure when exception occurs', () async {
        when(() => firebaseAuth.signInAnonymously()).thenThrow(Exception());
        expect(
          authenticationRepository.signInAnonymously(),
          throwsA(isA<LogInAnonymouslyFailure>()),
        );
      });
    });
    group('logOut', () {
      test('calls signOut', () async {
        when(() => facebookAuth.logOut()).thenAnswer((_) async {});
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
        when(() => googleSignIn.signOut()).thenAnswer((_) async => null);
        await authenticationRepository.logOut();
        verify(() => facebookAuth.logOut()).called(1);
        verify(() => firebaseAuth.signOut()).called(1);
        verify(() => googleSignIn.signOut()).called(1);
      });

      test('throws LogOutFailure when signOut throws', () async {
        when(() => firebaseAuth.signOut()).thenThrow(Exception());
        expect(
          authenticationRepository.logOut(),
          throwsA(isA<LogOutFailure>()),
        );
      });
    });

    group('user', () {
      test('emits User.empty when firebase user is null', () async {
        when(() => firebaseAuth.authStateChanges()).thenAnswer((_) => Stream.value(null));
        await expectLater(
          authenticationRepository.user,
          emitsInOrder(const <User>[User.empty]),
        );
      });

      test('emits User when firebase user is not null', () async {
        final firebaseUser = MockFirebaseUser();
        when(() => firebaseUser.uid).thenReturn(_mockFirebaseUserUid);
        when(() => firebaseUser.email).thenReturn(_mockFirebaseUserEmail);
        when(() => firebaseUser.photoURL).thenReturn(null);
        when(() => firebaseAuth.authStateChanges()).thenAnswer((_) => Stream.value(firebaseUser));
        await expectLater(
          authenticationRepository.user,
          emitsInOrder(const <User>[user]),
        );
      });
    });
  });
}
