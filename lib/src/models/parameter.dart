import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'parameter.g.dart';

@JsonSerializable()
class Parameter {
  const Parameter({
    required this.name,
    this.inLocation = InLocation.query,
    this.description,
    this.required = false,
    this.deprecated = false,
    this.allowEmptyValue = false,
    this.schema,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) =>
      _$ParameterFromJson(json);

  final String name;
  @JsonKey(name: 'in')
  final InLocation inLocation;
  final String? description;
  final bool required;
  final bool deprecated;
  final bool allowEmptyValue;
  final Schema? schema;

  Map<String, dynamic> toJson() => _$ParameterToJson(this);
}

// Enum InLocation
// possible values are "query", "header", "path", "cookie"
enum InLocation {
  query,
  header,
  path,
  cookie,
}
