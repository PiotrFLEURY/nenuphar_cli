import 'package:json_annotation/json_annotation.dart';

part 'daemon_message.g.dart';

@JsonSerializable()
class DartFrogDaemonMessage {
  DartFrogDaemonMessage({
    required this.method,
    required this.params,
    required this.id,
  });

  factory DartFrogDaemonMessage.fromJson(Map<String, dynamic> json) =>
      _$DartFrogDaemonMessageFromJson(json);

  Map<String, dynamic> toJson() => _$DartFrogDaemonMessageToJson(this);

  static const String startWatchMethod = 'route_configuration.watcherStart';

  static const String stopWatchMethod = 'route_configuration.watcherStop';

  final String method;
  final DartFrogDaemonMessageParams params;
  final String id;
}

@JsonSerializable()
class DartFrogDaemonMessageParams {
  DartFrogDaemonMessageParams({
    this.workingDirectory,
    this.watcherId,
  });

  factory DartFrogDaemonMessageParams.fromJson(Map<String, dynamic> json) =>
      _$DartFrogDaemonMessageParamsFromJson(json);

  Map<String, dynamic> toJson() => _$DartFrogDaemonMessageParamsToJson(this);

  final String? workingDirectory;
  final String? watcherId;
}
