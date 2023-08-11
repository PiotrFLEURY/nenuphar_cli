import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'media_type.g.dart';

@JsonSerializable()
class MediaType {
  const MediaType({
    this.schema,
  });

  factory MediaType.fromJson(Map<String, dynamic> json) =>
      _$MediaTypeFromJson(json);

  final Schema? schema;

  Map<String, dynamic> toJson() => _$MediaTypeToJson(this);
}
