import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/schema.dart';

part 'header.g.dart';

@JsonSerializable()
class Header {
  const Header({
    required this.description,
    required this.schema,
  });

  factory Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);

  final String description;
  final Schema schema;

  Map<String, dynamic> toJson() => _$HeaderToJson(this);
}
