class LoginIdAlreadyExistsException implements Exception {
  String cause;
  LoginIdAlreadyExistsException(this.cause);
}
