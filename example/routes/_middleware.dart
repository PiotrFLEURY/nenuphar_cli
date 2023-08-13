import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:example/services/auth_service.dart';

final AuthService authService = AuthService();

Handler middleware(Handler handler) {
  return (context) async {
    // Get the user name header
    final userName = context.request.headers['User-Name'];

    try {
      authService.authGuard(
        userName,
      );
    } catch (e) {
      return Response(statusCode: HttpStatus.unauthorized);
    }

    return handler(context);
  };
}
