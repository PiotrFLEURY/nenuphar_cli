/// Authentication service used by the / _middleware
class AuthService {
  /// Assert that the user is authenticated
  void authGuard(
    String? userName,
  ) {
    if (userName == null) {
      throw Exception('Unauthorized');
    }
  }
}
