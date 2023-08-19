import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'oauth_flows.g.dart';

///
/// https://swagger.io/specification/v3/#oauth-flows-object
///
/// Allows configuration of the supported OAuth Flows.
///
@JsonSerializable()
class OAuthFlows {
  const OAuthFlows({
    this.implicit,
    this.password,
    this.clientCredentials,
    this.authorizationCode,
  });

  factory OAuthFlows.fromJson(Map<String, dynamic> json) =>
      _$OAuthFlowsFromJson(json);

  /// Configuration for the OAuth Implicit flow
  final OAuthFlow? implicit;

  /// Configuration for the OAuth Resource Owner Password flow
  final OAuthFlow? password;

  /// Configuration for the OAuth Client Credentials flow.
  /// Previously called application in OpenAPI 2.0.
  final OAuthFlow? clientCredentials;

  /// Configuration for the OAuth Authorization Code flow.
  /// Previously called accessCode in OpenAPI 2.0.
  final OAuthFlow? authorizationCode;

  Map<String, dynamic> toJson() => _$OAuthFlowsToJson(this);
}
