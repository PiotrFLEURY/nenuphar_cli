import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'components.g.dart';

@JsonSerializable()
class Components {
  const Components({
    this.schemas = const {},
  });

  factory Components.fromJson(Map<String, dynamic> json) =>
      _$ComponentsFromJson(json);

  final Map<String, Schema> schemas;

  Map<String, dynamic> toJson() => _$ComponentsToJson(this);
}
