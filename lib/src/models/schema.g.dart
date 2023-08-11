// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schema _$SchemaFromJson(Map<String, dynamic> json) => Schema(
      type: json['type'] as String?,
      format: json['format'] as String?,
      requiredProperties: (json['required'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      properties: (json['properties'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Schema.fromJson(e as Map<String, dynamic>)),
      ),
      ref: json[r'$ref'] as String?,
      items: json['items'] == null
          ? null
          : Schema.fromJson(json['items'] as Map<String, dynamic>),
      minimum: json['minimum'] as int?,
      maximum: json['maximum'] as int?,
    );

Map<String, dynamic> _$SchemaToJson(Schema instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', instance.type);
  writeNotNull('format', instance.format);
  writeNotNull('required', instance.requiredProperties);
  writeNotNull('properties', instance.properties);
  writeNotNull(r'$ref', instance.ref);
  writeNotNull('items', instance.items);
  writeNotNull('minimum', instance.minimum);
  writeNotNull('maximum', instance.maximum);
  return val;
}
