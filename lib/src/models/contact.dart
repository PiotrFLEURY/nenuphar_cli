import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  const Contact({
    this.name = 'none',
    this.url = 'http://localhost',
    this.email = 'none@api.com',
  });

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  final String? name;
  final String? url;
  final String? email;

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
