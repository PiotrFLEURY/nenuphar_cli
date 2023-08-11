import 'package:json_annotation/json_annotation.dart';

part 'license.g.dart';

@JsonSerializable()
class License {
  const License({
    this.name = '',
    this.url = '',
  });

  factory License.fromJson(Map<String, dynamic> json) =>
      _$LicenseFromJson(json);

  final String name;
  final String url;

  Map<String, dynamic> toJson() => _$LicenseToJson(this);
}
