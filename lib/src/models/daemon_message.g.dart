// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daemon_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DartFrogDaemonMessage _$DartFrogDaemonMessageFromJson(
        Map<String, dynamic> json) =>
    DartFrogDaemonMessage(
      method: json['method'] as String,
      params: DartFrogDaemonMessageParams.fromJson(
          json['params'] as Map<String, dynamic>),
      id: json['id'] as String,
    );

Map<String, dynamic> _$DartFrogDaemonMessageToJson(
        DartFrogDaemonMessage instance) =>
    <String, dynamic>{
      'method': instance.method,
      'params': instance.params,
      'id': instance.id,
    };

DartFrogDaemonMessageParams _$DartFrogDaemonMessageParamsFromJson(
        Map<String, dynamic> json) =>
    DartFrogDaemonMessageParams(
      workingDirectory: json['workingDirectory'] as String?,
      watcherId: json['watcherId'] as String?,
    );

Map<String, dynamic> _$DartFrogDaemonMessageParamsToJson(
    DartFrogDaemonMessageParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('workingDirectory', instance.workingDirectory);
  writeNotNull('watcherId', instance.watcherId);
  return val;
}
