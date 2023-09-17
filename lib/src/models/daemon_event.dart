import 'package:json_annotation/json_annotation.dart';

part 'daemon_event.g.dart';

@JsonSerializable()
class DartFrogDaemonEvent {
  DartFrogDaemonEvent({
    this.id,
    this.result,
    this.event,
    this.params,
  });

  factory DartFrogDaemonEvent.fromJson(dynamic json) =>
      _$DartFrogDaemonEventFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$DartFrogDaemonEventToJson(this);

  static const String eventDaemonReady = 'daemon.ready';
  static const String eventWatcherStarted = 'route_configuration.watcherStart';
  static const String eventWatcherStopped = 'route_configuration.watcherStop';
  static const String eventRouteConfigurationChanged =
      'route_configuration.changed';

  final String? id;
  final DaemonEventResult? result;
  final String? event;
  final DartFrogDaemonEventParams? params;
}

@JsonSerializable()
class DartFrogDaemonEventParams {
  DartFrogDaemonEventParams({
    this.watcherId,
    this.versionId,
    this.processId,
  });

  factory DartFrogDaemonEventParams.fromJson(Map<String, dynamic> json) =>
      _$DartFrogDaemonEventParamsFromJson(json);

  Map<String, dynamic> toJson() => _$DartFrogDaemonEventParamsToJson(this);

  final String? watcherId;
  final String? versionId;
  final int? processId;
}

@JsonSerializable()
class DaemonEventResult {
  DaemonEventResult({
    this.watcherId,
  });

  factory DaemonEventResult.fromJson(Map<String, dynamic> json) =>
      _$DaemonEventResultFromJson(json);

  Map<String, dynamic> toJson() => _$DaemonEventResultToJson(this);

  final String? watcherId;
}
