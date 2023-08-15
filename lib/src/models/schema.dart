import 'package:json_annotation/json_annotation.dart';

part 'schema.g.dart';

@JsonSerializable()
class Schema {
  const Schema({
    this.type,
    this.format,
    this.requiredProperties,
    this.properties,
    this.ref,
    this.items,
    this.minimum,
    this.maximum,
  });

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);

  factory Schema.emptyObject() => const Schema(type: 'object');

  final String? type;
  final String? format;

  @JsonKey(name: 'required')
  final List<String>? requiredProperties;
  final Map<String, Schema>? properties;

  @JsonKey(name: r'$ref')
  final String? ref;

  final Schema? items;

  final int? minimum;

  final int? maximum;

  Map<String, dynamic> toJson() => _$SchemaToJson(this);
}
