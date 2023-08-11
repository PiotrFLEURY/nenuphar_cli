import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/media_type.dart';

part 'response_body.g.dart';

@JsonSerializable()
class ResponseBody {
  const ResponseBody({
    this.description = '',
    this.content = const {},
  });

  factory ResponseBody.fromJson(Map<String, dynamic> json) =>
      _$ResponseBodyFromJson(json);

  final String description;
  final Map<String, MediaType> content;

  Map<String, dynamic> toJson() => _$ResponseBodyToJson(this);
}
