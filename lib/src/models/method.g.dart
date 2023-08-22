// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Method _$MethodFromJson(Map<String, dynamic> json) => Method(
      description: json['description'] as String?,
      summary: json['summary'] as String?,
      operationId: json['operationId'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      requestBody: json['requestBody'] == null
          ? null
          : RequestBody.fromJson(json['requestBody'] as Map<String, dynamic>),
      responses: (json['responses'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                int.parse(k), ResponseBody.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      parameters: (json['parameters'] as List<dynamic>?)
          ?.map((e) => Parameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      security: (json['security'] as List<dynamic>?)
              ?.map((e) => (e as Map<String, dynamic>).map(
                    (k, e) => MapEntry(k,
                        (e as List<dynamic>).map((e) => e as String).toList()),
                  ))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MethodToJson(Method instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('summary', instance.summary);
  writeNotNull('operationId', instance.operationId);
  val['tags'] = instance.tags;
  writeNotNull('requestBody', instance.requestBody);
  val['responses'] =
      instance.responses.map((k, e) => MapEntry(k.toString(), e));
  writeNotNull('parameters', instance.parameters);
  val['security'] = instance.security;
  return val;
}
