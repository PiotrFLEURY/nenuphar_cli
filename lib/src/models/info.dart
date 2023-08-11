import 'package:json_annotation/json_annotation.dart';
import 'package:nenuphar_cli/src/models/contact.dart';
import 'package:nenuphar_cli/src/models/license.dart';

part 'info.g.dart';

@JsonSerializable()
class Info {
  const Info({
    this.title = 'A sample API',
    this.description = 'A sample API',
    this.termsOfService = 'http://localhost',
    this.contact = const Contact(),
    this.license = const License(),
    this.version = '0.0.0',
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

  final String? title;
  final String? description;
  final String? termsOfService;
  final Contact? contact;
  final License? license;
  final String? version;

  Map<String, dynamic> toJson() => _$InfoToJson(this);
}
