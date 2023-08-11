// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paths.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paths _$PathsFromJson(Map<String, dynamic> json) => Paths(
      get: json['get'] == null
          ? null
          : Method.fromJson(json['get'] as Map<String, dynamic>),
      post: json['post'] == null
          ? null
          : Method.fromJson(json['post'] as Map<String, dynamic>),
      put: json['put'] == null
          ? null
          : Method.fromJson(json['put'] as Map<String, dynamic>),
      delete: json['delete'] == null
          ? null
          : Method.fromJson(json['delete'] as Map<String, dynamic>),
      patch: json['patch'] == null
          ? null
          : Method.fromJson(json['patch'] as Map<String, dynamic>),
      head: json['head'] == null
          ? null
          : Method.fromJson(json['head'] as Map<String, dynamic>),
      options: json['options'] == null
          ? null
          : Method.fromJson(json['options'] as Map<String, dynamic>),
      trace: json['trace'] == null
          ? null
          : Method.fromJson(json['trace'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PathsToJson(Paths instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('get', instance.get);
  writeNotNull('post', instance.post);
  writeNotNull('put', instance.put);
  writeNotNull('delete', instance.delete);
  writeNotNull('patch', instance.patch);
  writeNotNull('head', instance.head);
  writeNotNull('options', instance.options);
  writeNotNull('trace', instance.trace);
  return val;
}
