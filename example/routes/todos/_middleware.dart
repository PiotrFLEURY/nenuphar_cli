import 'package:dart_frog/dart_frog.dart';
import 'package:example/services/todo_service.dart';

final TodoService _todoService = TodoService();

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(todoService());
}

Middleware todoService() {
  return provider<TodoService>((context) => _todoService);
}
