import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/method.dart';

part 'paths.g.dart';

@JsonSerializable()
class Paths {
  const Paths({
    this.get,
    this.post,
    this.put,
    this.delete,
    this.patch,
    this.head,
    this.options,
    this.trace,
  });

  factory Paths.fromJson(Map<String, dynamic> json) => _$PathsFromJson(json);

  final Method? get;
  final Method? post;
  final Method? put;
  final Method? delete;
  final Method? patch;
  final Method? head;
  final Method? options;
  final Method? trace;

  Map<String, dynamic> toJson() => _$PathsToJson(this);
}
