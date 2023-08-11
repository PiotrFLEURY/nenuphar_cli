import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'request_body.g.dart';

@JsonSerializable()
class RequestBody {
  const RequestBody({
    this.description = '',
    this.required = false,
    this.content = const {},
  });

  factory RequestBody.fromJson(Map<String, dynamic> json) =>
      _$RequestBodyFromJson(json);

  final String? description;
  final bool required;
  final Map<String, MediaType> content;

  Map<String, dynamic> toJson() => _$RequestBodyToJson(this);
}
