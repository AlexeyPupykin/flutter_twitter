class LogOutFailure implements Exception {
  const LogOutFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  final String message;
}
