import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'method.g.dart';

/// Describes a single API operation on a path.
@JsonSerializable()
class Method {
  const Method({
    this.description,
    this.summary,
    this.operationId,
    this.tags = const [],
    this.requestBody,
    this.responses = const {},
    this.parameters,
    this.security = const [],
  });

  factory Method.fromJson(Map<String, dynamic> json) => _$MethodFromJson(json);

  /// A verbose explanation of the operation behavior.
  /// CommonMark syntax MAY be used for rich text representation.
  final String? description;

  /// A short summary of what the operation does.
  final String? summary;

  /// Unique string used to identify the operation. The id MUST be unique among
  ///  all operations described in the API.
  /// The operationId value is case-sensitive.
  /// Tools and libraries MAY use the operationId to uniquely identify an
  /// operation, therefore, it is RECOMMENDED to follow common programming
  /// naming conventions.
  final String? operationId;

  /// A list of tags for API documentation control. Tags can be used for logical
  ///  grouping of operations by resources or any other qualifier.
  final List<String> tags;

  /// The request body applicable for this operation. The requestBody is only
  /// supported in HTTP methods where the HTTP 1.1 specification RFC7231 has
  /// explicitly defined semantics for request bodies. In other cases where
  /// the HTTP spec is vague, requestBody SHALL be ignored by consumers.
  final RequestBody? requestBody;

  /// REQUIRED. The list of possible responses as they are returned from
  /// executing this operation.
  final Map<int, ResponseBody> responses;

  /// A list of parameters that are applicable for this operation.
  /// If a parameter is already defined at the Path Item,
  /// the new definition will override it but can never remove it.
  /// The list MUST NOT include duplicated parameters.
  /// A unique parameter is defined by a combination of a name and location.
  /// The list can use the Reference Object to link to parameters that are
  /// defined at the OpenAPI Object's components/parameters.
  final List<Parameter>? parameters;

  /// A declaration of which security mechanisms can be used for this operation.
  ///  The list of values includes alternative security requirement objects
  /// that can be used. Only one of the security requirement objects need to
  /// be satisfied to authorize a request.
  /// To make security optional, an empty security requirement ({}) can be
  /// included in the array. This definition overrides any declared top-level
  /// security. To remove a top-level security declaration, an empty array
  /// can be used.
  final List<Map<String, List<String>>> security;

  Map<String, dynamic> toJson() => _$MethodToJson(this);
}
