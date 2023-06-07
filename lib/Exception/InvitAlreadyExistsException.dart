class InvitAlreadyExistsException implements Exception {
  String cause;
  InvitAlreadyExistsException(this.cause);
}
