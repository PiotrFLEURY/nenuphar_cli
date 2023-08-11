import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'method.g.dart';

@JsonSerializable()
class Method {
  const Method({
    this.description,
    this.summary,
    this.operationId,
    this.tags = const [],
    this.requestBody,
    this.responses = const {},
    this.parameters,
  });

  factory Method.fromJson(Map<String, dynamic> json) => _$MethodFromJson(json);

  final String? description;
  final String? summary;
  final String? operationId;
  final List<String> tags;
  final RequestBody? requestBody;
  final Map<int, ResponseBody> responses;
  final List<Parameter>? parameters;

  Map<String, dynamic> toJson() => _$MethodToJson(this);
}
