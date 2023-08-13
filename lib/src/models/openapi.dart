import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'openapi.g.dart';

@JsonSerializable()
class OpenApi {
  OpenApi({
    this.openapi = '3.0.3',
    this.info = const Info(),
    this.externalDocs = const ExternalDocumentation(),
    this.servers = const [Server()],
    this.tags,
    this.paths = const {},
    this.components,
  });

  factory OpenApi.fromJson(Map<String, dynamic> json) =>
      _$OpenApiFromJson(json);

  final String openapi;
  final Info info;
  final ExternalDocumentation externalDocs;
  final List<Server> servers;
  List<Tag>? tags;
  Components? components;

  Map<String, Paths> paths;

  Map<String, dynamic> toJson() => _$OpenApiToJson(this);
}
