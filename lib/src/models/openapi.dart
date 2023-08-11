import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'openapi.g.dart';

@JsonSerializable()
class OpenApi {
  const OpenApi({
    this.openapi = '3.0.3',
    this.info = const Info(),
    // TODO(piotr): externalDocs object
    // TODO(piotr): servers object
    this.tags,
    this.paths = const {},
    this.components,
  });

  factory OpenApi.fromJson(Map<String, dynamic> json) =>
      _$OpenApiFromJson(json);

  final String openapi;
  final Info info;
  final List<Tag>? tags;
  final Components? components;

  final Map<String, Paths> paths;

  Map<String, dynamic> toJson() => _$OpenApiToJson(this);
}
