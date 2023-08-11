// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Parameter _$ParameterFromJson(Map<String, dynamic> json) => Parameter(
      name: json['name'] as String,
      inLocation: $enumDecodeNullable(_$InLocationEnumMap, json['in']) ??
          InLocation.query,
      description: json['description'] as String?,
      required: json['required'] as bool? ?? false,
      deprecated: json['deprecated'] as bool? ?? false,
      allowEmptyValue: json['allowEmptyValue'] as bool? ?? false,
      schema: json['schema'] == null
          ? null
          : Schema.fromJson(json['schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParameterToJson(Parameter instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'in': _$InLocationEnumMap[instance.inLocation]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  val['required'] = instance.required;
  val['deprecated'] = instance.deprecated;
  val['allowEmptyValue'] = instance.allowEmptyValue;
  writeNotNull('schema', instance.schema);
  return val;
}

const _$InLocationEnumMap = {
  InLocation.query: 'query',
  InLocation.header: 'header',
  InLocation.path: 'path',
  InLocation.cookie: 'cookie',
};
