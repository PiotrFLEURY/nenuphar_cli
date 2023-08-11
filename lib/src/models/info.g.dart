// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      title: json['title'] as String? ?? 'A sample API',
      description: json['description'] as String? ?? 'A sample API',
      termsOfService: json['termsOfService'] as String? ?? 'http://localhost',
      contact: json['contact'] == null
          ? const Contact()
          : Contact.fromJson(json['contact'] as Map<String, dynamic>),
      license: json['license'] == null
          ? const License()
          : License.fromJson(json['license'] as Map<String, dynamic>),
      version: json['version'] as String? ?? '0.0.0',
    );

Map<String, dynamic> _$InfoToJson(Info instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('description', instance.description);
  writeNotNull('termsOfService', instance.termsOfService);
  writeNotNull('contact', instance.contact);
  writeNotNull('license', instance.license);
  writeNotNull('version', instance.version);
  return val;
}
