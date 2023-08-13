import 'package:example/models/todos.dart';

/// Manage the todos
class TodoService {
  final _todos = <Todo>[];

  /// Add a todo to the list
  void add(Todo todo) {
    _todos.add(todo);
  }

  /// Get the todo list
  List<Todo> get todos => _todos;

  /// Get the todo list filtered by completed
  List<Todo> getTodosByCompleted({
    bool completed = false,
  }) {
    return _todos.where((todo) => todo.completed == completed).toList();
  }

  /// Get a todo by id
  Todo getById(int id) {
    return _todos.firstWhere((todo) => todo.id == id, orElse: Todo.new);
  }

  /// Remove a todo by id
  void removeById(int id) {
    _todos.removeWhere((todo) => todo.id == id);
  }

  /// Update a todo
  void update(Todo todo) {
    final index = _todos.indexWhere((element) => element.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
    }
  }
}
