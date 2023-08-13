import 'package:json_annotation/json_annotation.dart';

part 'external_documentation.g.dart';

@JsonSerializable()
class ExternalDocumentation {
  const ExternalDocumentation({
    this.description = '',
    this.url = 'http://localhost/',
  });

  factory ExternalDocumentation.fromJson(Map<String, dynamic> json) =>
      _$ExternalDocumentationFromJson(json);

  final String? description;
  final String? url;

  Map<String, dynamic> toJson() => _$ExternalDocumentationToJson(this);
}
