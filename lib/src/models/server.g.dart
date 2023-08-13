// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Server _$ServerFromJson(Map<String, dynamic> json) => Server(
      url: json['url'] as String? ?? 'http://localhost:8080',
      description: json['description'] as String? ?? 'Local server',
    );

Map<String, dynamic> _$ServerToJson(Server instance) => <String, dynamic>{
      'url': instance.url,
      'description': instance.description,
    };
