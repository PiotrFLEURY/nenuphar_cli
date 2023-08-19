import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'components.g.dart';

/// Holds a set of reusable objects for different aspects of the OAS.
/// All objects defined within the components object will have no effect on
/// the API unless they are explicitly referenced from properties outside
/// the components object.
@JsonSerializable()
class Components {
  const Components({
    this.schemas = const {},
    this.securitySchemes = const {},
  });

  factory Components.fromJson(Map<String, dynamic> json) =>
      _$ComponentsFromJson(json);

  /// An object to hold reusable Schema Objects.
  final Map<String, Schema> schemas;

  /// An object to hold reusable Security Scheme Objects.
  final Map<String, SecurityScheme> securitySchemes;

  Map<String, dynamic> toJson() => _$ComponentsToJson(this);
}
