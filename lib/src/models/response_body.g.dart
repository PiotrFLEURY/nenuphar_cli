// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseBody _$ResponseBodyFromJson(Map<String, dynamic> json) => ResponseBody(
      description: json['description'] as String? ?? '',
      content: (json['content'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, MediaType.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$ResponseBodyToJson(ResponseBody instance) =>
    <String, dynamic>{
      'description': instance.description,
      'content': instance.content,
    };
