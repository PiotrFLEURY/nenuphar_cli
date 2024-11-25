import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:nenuphar_annotations/nenuphar_annotations.dart';
import 'package:nenuphar_generator/src/delegates/json_schema_generator_delegate.dart';
import 'package:source_gen/source_gen.dart';

class JsonSchemaBuilder extends Builder {
  final JsonSchemaGeneratorDelegate delegate =
      const JsonSchemaGeneratorDelegate();

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.json'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    print('JsonSchemaBuilder: ${buildStep.inputId.path}');
    final inputId = buildStep.inputId;

    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final lib = LibraryReader(await buildStep.inputLibrary);
    final exportAnnotation = TypeChecker.fromRuntime(JsonSchema);

    lib.annotatedWith(exportAnnotation).forEach(
      (element) {
        final classElement = element.element as ClassElement;
        _generateJsonSchema(
          classElement,
          buildStep,
          inputId.changeExtension('.json'),
        );
      },
    );
  }

  Future<void> _generateJsonSchema(
    ClassElement element,
    BuildStep buildStep,
    AssetId outputId,
  ) async {
    final jsonSchema = delegate.generateSchema(element);
    buildStep.writeAsString(
      outputId,
      jsonEncode(jsonSchema),
    );
  }
}
