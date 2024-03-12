import 'package:nenuphar_generator/src/annotations_generator.dart';
import 'package:nenuphar_generator/src/json_schema_generator.dart';
import 'package:build/build.dart';

Builder jsonSchemaBuilder(BuilderOptions options) => JsonSchemaBuilder();

Builder annotationBuilder(BuilderOptions options) => AnnotationBuilder();
