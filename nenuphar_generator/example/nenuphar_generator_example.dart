import 'package:nenuphar_annotations/nenuphar_annotations.dart';

@jsonSchema
class ExampleClassModel {
  ExampleClassModel({
    this.str,
    this.intVal,
    this.doubleVal,
    this.boolVal,
    this.listDynamicVal,
    this.listStringVal,
    this.mapDynamicVal,
    this.mapStringIntVal,
  });

  final String? str;
  final int? intVal;
  final double? doubleVal;
  final bool? boolVal;
  final List? listDynamicVal;
  final List<String>? listStringVal;
  final Map? mapDynamicVal;
  final Map<String, int>? mapStringIntVal;
}
