import 'package:authentication/authentication.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kraken_pokedex/src/utils/language/locale_keys.g.dart';

extension LogInWithGoogleFailureLocales on LogInWithGoogleFailure {
  String get fromCode {
    switch (code) {
      case 'account-exists-with-different-credential':
        return LocaleKeys.account_exists_with_different_credential.tr();
      case 'invalid-credential':
        return LocaleKeys.invalid_credential.tr();
      case 'operation-not-allowed':
        return LocaleKeys.operation_not_allowed.tr();
      case 'user-disabled':
        return LocaleKeys.user_disabled.tr();
      case 'user-not-found':
        return LocaleKeys.user_not_found.tr();
      case 'wrong-password':
        return LocaleKeys.wrong_password.tr();
      case 'invalid-verification-code':
        return LocaleKeys.invalid_verification_code.tr();
      case 'invalid-verification-id':
        return LocaleKeys.invalid_verification_id.tr();
      default:
        return LocaleKeys.unknown_error.tr();
    }
  }
}

extension LogInWithFacebookFailureFailureLocales on LogInWithFacebookFailure {
  String get fromCode {
    switch (code) {
      default:
        return LocaleKeys.unknown_error.tr();
    }
  }
}

extension LogInAnonymouslyFailureFailureLocales on LogInAnonymouslyFailure {
  String get fromCode {
    switch (code) {
      default:
        return LocaleKeys.unknown_error.tr();
    }
  }
}
