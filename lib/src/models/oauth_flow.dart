import 'package:json_annotation/json_annotation.dart';

part 'oauth_flow.g.dart';

///
/// https://swagger.io/specification/v3/#oauth-flow-object
///
/// Configuration details for a supported OAuth Flow
///
@JsonSerializable()
class OAuthFlow {
  const OAuthFlow({
    this.authorizationUrl,
    this.tokenUrl,
    this.refreshUrl,
    this.scopes = const {},
  });

  factory OAuthFlow.fromJson(Map<String, dynamic> json) =>
      _$OAuthFlowFromJson(json);

  /// REQUIRED. The authorization URL to be used for this flow.
  /// This MUST be in the form of a URL.
  /// apply for implicit, authorizationCode type.
  final String? authorizationUrl;

  /// REQUIRED. The token URL to be used for this flow.
  /// This MUST be in the form of a URL.
  /// apply for password, clientCredentials, authorizationCode type.
  final String? tokenUrl;

  /// The URL to be used for obtaining refresh tokens.
  /// This MUST be in the form of a URL.
  final String? refreshUrl;

  /// REQUIRED. The available scopes for the OAuth2 security scheme.
  /// A map between the scope name and a short description for it.
  /// The map MAY be empty.
  final Map<String, String> scopes;

  Map<String, dynamic> toJson() => _$OAuthFlowToJson(this);
}
