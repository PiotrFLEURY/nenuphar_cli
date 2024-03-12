import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_annotations/nenuphar_annotations.dart';

part 'todos.g.dart';

/// Todo model
@JsonSerializable()
@jsonSchema
class Todo {
  ///
  /// Constructor
  /// [id] technical id
  /// [name] task name
  /// [completed] defines if the task is completed
  ///
  const Todo({
    this.id = 0,
    this.name = '',
    this.completed = false,
  });

  /// Creates a new Todo from a json
  /// [json] json
  /// Returns a new Todo
  /// Throws an exception if the json is not valid
  static Todo fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  /// Technical id
  final int id;

  /// task name
  final String name;

  /// Defines if the task is completed
  final bool completed;

  /// Converts the Todo to a json
  /// Returns a json
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
