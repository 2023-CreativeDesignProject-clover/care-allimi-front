class ResidentAlreadyExistsException implements Exception {
  String cause;
  ResidentAlreadyExistsException(this.cause);
}
