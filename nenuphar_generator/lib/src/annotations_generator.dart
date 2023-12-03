import 'package:build/build.dart';
import 'package:nenuphar_annotations/nenuphar_annotations.dart';
import 'package:source_gen/source_gen.dart';

class AnnotationBuilder extends Builder {
  final generatedDisclaimer = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
''';

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.nenuphar.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final outputId = inputId.changeExtension('.nenuphar.dart');
    final libraryName = outputId.pathSegments.last
        .split('.')
        .first
        .replaceAll(RegExp(r'[\[\]]'), '');

    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final lib = LibraryReader(await buildStep.inputLibrary);

    final allowAnnotation = TypeChecker.fromRuntime(Allow);
    final allowSpecs = lib.annotatedWith(allowAnnotation).map(
      (AnnotatedElement element) {
        return _generateSpecs(
          element.annotation,
          'Allow',
          'methods',
        );
      },
    );

    final headerAnnotation = TypeChecker.fromRuntime(Header);
    final headerSpecs = lib.annotatedWith(headerAnnotation).map(
      (AnnotatedElement element) {
        return _generateSpecs(
          element.annotation,
          'Header',
          'headers',
        );
      },
    );

    final queryAnnotation = TypeChecker.fromRuntime(Query);
    final querySpecs = lib.annotatedWith(queryAnnotation).map(
      (AnnotatedElement element) {
        return _generateSpecs(
          element.annotation,
          'Query',
          'queryParams',
        );
      },
    );

    final securityAnnotation = TypeChecker.fromRuntime(Security);
    final securitySpecs = lib.annotatedWith(securityAnnotation).map(
      (AnnotatedElement element) {
        return _generateSpecs(
          element.annotation,
          'Security',
          'securitySchemes',
        );
      },
    );

    final scopeAnnotation = TypeChecker.fromRuntime(Scope);
    final scopeSpecs = lib.annotatedWith(scopeAnnotation).map(
      (AnnotatedElement element) {
        return _generateSpecs(
          element.annotation,
          'Scope',
          'scopes',
        );
      },
    );

    final body = '''
${allowSpecs.join('\n')}
${headerSpecs.join('\n')}
${querySpecs.join('\n')}
${securitySpecs.join('\n')}
${scopeSpecs.join('\n')}
''';

    if (body.trim().isEmpty) return;

    final content = '''
$generatedDisclaimer
$body
library $libraryName;
''';
    await buildStep.writeAsString(outputId, content);
  }

  String _generateSpecs(
    ConstantReader annotation,
    String annotationName,
    String parameterName,
  ) {
    final values = annotation
            .peek(parameterName)
            ?.listValue
            .map((e) => e.toStringValue())
            .toList() ??
        [];

    return '/// @$annotationName(${values.join(', ')})';
  }
}
