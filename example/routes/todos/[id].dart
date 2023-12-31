import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:example/services/todo_service.dart';

///
/// The /todos/[id] routes
///
/// @Allow(GET, DELETE) - Allow only GET and DELETE methods
///
/// @Header(User-Name) - The user name header
///
/// @Security(todos_api_key) - The api key security scheme defined in
///   components/_security.dart
///
Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  final todosService = context.read<TodoService>();

  switch (context.request.method) {
    case HttpMethod.get:
      return Response(body: jsonEncode(todosService.getById(int.parse(id))));
    case HttpMethod.delete:
      todosService.removeById(int.parse(id));
      return Response(body: jsonEncode(todosService.todos));
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
