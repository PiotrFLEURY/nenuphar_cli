// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_documentation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalDocumentation _$ExternalDocumentationFromJson(
        Map<String, dynamic> json) =>
    ExternalDocumentation(
      description: json['description'] as String? ?? '',
      url: json['url'] as String? ?? 'http://localhost/',
    );

Map<String, dynamic> _$ExternalDocumentationToJson(
    ExternalDocumentation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('url', instance.url);
  return val;
}
