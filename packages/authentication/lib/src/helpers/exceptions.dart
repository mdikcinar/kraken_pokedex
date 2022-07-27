class LogInWithGoogleFailure implements Exception {
  const LogInWithGoogleFailure([
    this.code = 'unknown-error',
  ]);
  final String code;
}

class LogInWithFacebookFailure implements Exception {
  const LogInWithFacebookFailure([
    this.code = 'unknown-error',
  ]);

  final String code;
}

class LogInAnonymouslyFailure implements Exception {
  const LogInAnonymouslyFailure([
    this.code = 'unknown-error',
  ]);

  final String code;
}

class LogOutFailure implements Exception {}
