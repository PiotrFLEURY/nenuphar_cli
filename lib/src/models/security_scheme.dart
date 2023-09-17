import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'security_scheme.g.dart';

///
/// https://swagger.io/specification/v3/#security-scheme-object
///
/// Defines a security scheme that can be used by the operations.
/// Supported schemes are HTTP authentication,
/// an API key (either as a header, a cookie parameter or as a query parameter),
/// OAuth2's common flows (implicit, password, client credentials and
/// authorization code) as defined in RFC6749, and OpenID Connect Discovery.
///
/// Examples:
///
/// Basic Authentication Sample
///   type: http
///   scheme: basic
///
///
/// API Key Sample
///   type: apiKey
///   name: api_key
///   in: header
///
///
/// JWT Bearer Sample
///   type: http
///   scheme: bearer
///   bearerFormat: JWT
///
///
/// Implicit OAuth2 Sample
///   type: oauth2
///   flows:
///     implicit:
///       authorizationUrl: https://example.com/api/oauth/dialog
///       scopes:
///         write:pets: modify pets in your account
///         read:pets: read your pets
///
@JsonSerializable()
class SecurityScheme {
  const SecurityScheme({
    required this.type,
    this.description,
    this.name,
    this.inLocation,
    this.scheme,
    this.bearerFormat,
    this.flows,
    this.openIdConnectUrl,
  });

  factory SecurityScheme.fromJson(Map<String, dynamic> json) =>
      _$SecuritySchemeFromJson(json);

  /// REQUIRED. The type of the security scheme.
  /// Valid values are "apiKey", "http", "oauth2", "openIdConnect".
  /// apply for any type.
  final String type;

  /// A short description for security scheme.
  /// CommonMark syntax MAY be used for rich text representation.
  /// apply for any type.
  final String? description;

  /// REQUIRED. The name of the header, query or cookie parameter to be used.
  /// apply for apiKey type.
  final String? name;

  /// REQUIRED. The location of the API key.
  /// Valid values are "query", "header" or "cookie".
  /// apply for apiKey type.
  @JsonKey(name: 'in')
  final String? inLocation;

  /// REQUIRED. The name of the HTTP Authorization scheme to be used
  /// in the Authorization header as defined in RFC7235.
  /// The values used SHOULD be registered
  /// in the IANA Authentication Scheme registry.
  /// apply for http type.
  final String? scheme;

  /// A hint to the client to identify how the bearer token is formatted.
  /// Bearer tokens are usually generated by an authorization server,
  /// so this information is primarily for documentation purposes.
  /// apply for http type.
  final String? bearerFormat;

  /// REQUIRED. An object containing configuration information
  /// for the flow types supported.
  /// apply for oauth2 type.
  final OAuthFlows? flows;

  /// REQUIRED. OpenId Connect URL to discover OAuth2 configuration values.
  /// This MUST be in the form of a URL.
  /// apply for openIdConnect type.
  final String? openIdConnectUrl;

  Map<String, dynamic> toJson() => _$SecuritySchemeToJson(this);
}