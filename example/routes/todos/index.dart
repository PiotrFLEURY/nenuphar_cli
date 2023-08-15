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
    case HttpMethod.head:
      String jsonPayload;
      // Get the completed query parameter
      final completed = context.request.uri.queryParameters['completed'];
      if (completed != null) {
        final todos = todosService.getTodosByCompleted(
          completed: completed == 'true',
        );
        jsonPayload = jsonEncode(todos);
      }
      jsonPayload = jsonEncode(todosService.todos);

      if (context.request.method == HttpMethod.head) {
        return Response(
          headers: {
            HttpHeaders.contentLengthHeader:
                utf8.encode(jsonPayload).length.toString(),
          },
        );
      }
      return Response(
        body: jsonPayload,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
    case HttpMethod.post:
      final jsonBody = await context.request.body();
      final todo = Todo.fromJson(jsonDecode(jsonBody) as Map<String, dynamic>);
      todosService.add(todo);
      return Response(body: jsonEncode(todosService.todos));

    case HttpMethod.options:
      return Response(
        statusCode: HttpStatus.noContent,
        headers: {
          HttpHeaders.allowHeader: [
            HttpMethod.get.value,
            HttpMethod.head.value,
            HttpMethod.post.value,
            HttpMethod.put.value,
            HttpMethod.patch.value,
            HttpMethod.options.value,
          ].join(', '),
        },
      );
    case HttpMethod.put:
    case HttpMethod.patch:
    case HttpMethod.delete:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
