import 'package:json_annotation/json_annotation.dart';

part 'server.g.dart';

@JsonSerializable()
class Server {
  const Server({
    this.url = 'http://localhost:8080',
    this.description = 'Local server',
  });

  factory Server.fromJson(Map<String, dynamic> json) => _$ServerFromJson(json);

  final String url;
  final String description;

  Map<String, dynamic> toJson() => _$ServerToJson(this);
}
