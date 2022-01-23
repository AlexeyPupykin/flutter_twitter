class DisableUserFailure implements Exception {
  const DisableUserFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  final String message;
}
