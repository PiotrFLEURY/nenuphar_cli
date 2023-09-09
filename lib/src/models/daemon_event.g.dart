// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daemon_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DartFrogDaemonEvent _$DartFrogDaemonEventFromJson(Map<String, dynamic> json) =>
    DartFrogDaemonEvent(
      id: json['id'] as String?,
      result: json['result'] == null
          ? null
          : DaemonEventResult.fromJson(json['result'] as Map<String, dynamic>),
      event: json['event'] as String?,
      params: json['params'] == null
          ? null
          : DartFrogDaemonEventParams.fromJson(
              json['params'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DartFrogDaemonEventToJson(DartFrogDaemonEvent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('result', instance.result);
  writeNotNull('event', instance.event);
  writeNotNull('params', instance.params);
  return val;
}

DartFrogDaemonEventParams _$DartFrogDaemonEventParamsFromJson(
        Map<String, dynamic> json) =>
    DartFrogDaemonEventParams(
      watcherId: json['watcherId'] as String?,
      versionId: json['versionId'] as String?,
      processId: json['processId'] as int?,
    );

Map<String, dynamic> _$DartFrogDaemonEventParamsToJson(
    DartFrogDaemonEventParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('watcherId', instance.watcherId);
  writeNotNull('versionId', instance.versionId);
  writeNotNull('processId', instance.processId);
  return val;
}

DaemonEventResult _$DaemonEventResultFromJson(Map<String, dynamic> json) =>
    DaemonEventResult(
      watcherId: json['watcherId'] as String?,
    );

Map<String, dynamic> _$DaemonEventResultToJson(DaemonEventResult instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('watcherId', instance.watcherId);
  return val;
}
