// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_flows.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthFlows _$OAuthFlowsFromJson(Map<String, dynamic> json) => OAuthFlows(
      implicit: json['implicit'] == null
          ? null
          : OAuthFlow.fromJson(json['implicit'] as Map<String, dynamic>),
      password: json['password'] == null
          ? null
          : OAuthFlow.fromJson(json['password'] as Map<String, dynamic>),
      clientCredentials: json['clientCredentials'] == null
          ? null
          : OAuthFlow.fromJson(
              json['clientCredentials'] as Map<String, dynamic>),
      authorizationCode: json['authorizationCode'] == null
          ? null
          : OAuthFlow.fromJson(
              json['authorizationCode'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OAuthFlowsToJson(OAuthFlows instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('implicit', instance.implicit);
  writeNotNull('password', instance.password);
  writeNotNull('clientCredentials', instance.clientCredentials);
  writeNotNull('authorizationCode', instance.authorizationCode);
  return val;
}
