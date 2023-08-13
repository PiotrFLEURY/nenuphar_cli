// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openapi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApi _$OpenApiFromJson(Map<String, dynamic> json) => OpenApi(
      openapi: json['openapi'] as String? ?? '3.0.3',
      info: json['info'] == null
          ? const Info()
          : Info.fromJson(json['info'] as Map<String, dynamic>),
      externalDocs: json['externalDocs'] == null
          ? const ExternalDocumentation()
          : ExternalDocumentation.fromJson(
              json['externalDocs'] as Map<String, dynamic>),
      servers: (json['servers'] as List<dynamic>?)
              ?.map((e) => Server.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [Server()],
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      paths: (json['paths'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Paths.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      components: json['components'] == null
          ? null
          : Components.fromJson(json['components'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OpenApiToJson(OpenApi instance) {
  final val = <String, dynamic>{
    'openapi': instance.openapi,
    'info': instance.info,
    'externalDocs': instance.externalDocs,
    'servers': instance.servers,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tags', instance.tags);
  writeNotNull('components', instance.components);
  val['paths'] = instance.paths;
  return val;
}
