// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_flow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthFlow _$OAuthFlowFromJson(Map<String, dynamic> json) => OAuthFlow(
      authorizationUrl: json['authorizationUrl'] as String?,
      tokenUrl: json['tokenUrl'] as String?,
      refreshUrl: json['refreshUrl'] as String?,
      scopes: (json['scopes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$OAuthFlowToJson(OAuthFlow instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('authorizationUrl', instance.authorizationUrl);
  writeNotNull('tokenUrl', instance.tokenUrl);
  writeNotNull('refreshUrl', instance.refreshUrl);
  val['scopes'] = instance.scopes;
  return val;
}
