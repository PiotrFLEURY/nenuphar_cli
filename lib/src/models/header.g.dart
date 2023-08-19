// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Header _$HeaderFromJson(Map<String, dynamic> json) => Header(
      description: json['description'] as String,
      schema: Schema.fromJson(json['schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HeaderToJson(Header instance) => <String, dynamic>{
      'description': instance.description,
      'schema': instance.schema,
    };
