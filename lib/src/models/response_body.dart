import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/models.dart';

part 'response_body.g.dart';

@JsonSerializable()
class ResponseBody {
  const ResponseBody({
    this.description = '',
    this.headers = const {},
    this.content = const {},
  });

  factory ResponseBody.fromJson(Map<String, dynamic> json) =>
      _$ResponseBodyFromJson(json);

  final String description;
  final Map<String, Header> headers;
  final Map<String, MediaType> content;

  Map<String, dynamic> toJson() => _$ResponseBodyToJson(this);
}
