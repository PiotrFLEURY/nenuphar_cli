import 'package:dart_frog/dart_frog.dart';

/// The / route is ignored by nenuphar
Response onRequest(RequestContext context) {
  return Response(body: 'Welcome to Dart Frog!');
}
