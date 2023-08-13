import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:example/models/todos.dart';
import 'package:example/services/todo_service.dart';

///
/// The /todos routes
///
/// @Header(User-Name) - The user name header
///
/// @Query(completed) - The completed query parameter
///
Future<Response> onRequest(RequestContext context) async {
  final todosService = context.read<TodoService>();

  switch (context.request.method) {
    case HttpMethod.get:
      // Get the completed query parameter
      final completed = context.request.uri.queryParameters['completed'];
      if (completed != null) {
        final todos = todosService.getTodosByCompleted(
          completed: completed == 'true',
        );
        return Response(body: jsonEncode(todos));
      }
      return Response(body: jsonEncode(todosService.todos));
    case HttpMethod.post:
      final jsonBody = await context.request.body();
      final todo = Todo.fromJson(jsonDecode(jsonBody) as Map<String, dynamic>);
      todosService.add(todo);
      return Response(body: jsonEncode(todosService.todos));
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.delete:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
