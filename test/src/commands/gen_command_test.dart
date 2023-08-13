import 'dart:convert';

import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nenuphar_cli/src/command_runner.dart';
import 'package:nenuphar_cli/src/models/openapi.dart';
import 'package:nenuphar_cli/src/models/parameter.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  group('gen', () {
    late Logger logger;
    late NenupharCliCommandRunner commandRunner;
    late FileSystem memoryFileSystem;

    setUp(() {
      logger = _MockLogger();
      memoryFileSystem = MemoryFileSystem();
      commandRunner = NenupharCliCommandRunner(
        logger: logger,
        fileSystem: memoryFileSystem,
      );
    });

    test('Contains no operation if only / route exists', () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }

      memoryFileSystem.file('/routes/index.dart').createSync(recursive: true);

      // WHEN
      final result = await commandRunner.run(['gen']);

      // THEN
      expect(result, equals(ExitCode.success.code));
      final openApiFile = memoryFileSystem.file('/public/openapi.json');
      expect(openApiFile.existsSync(), isTrue);
      final openApi = OpenApi.fromJson(
        jsonDecode(
          openApiFile.readAsStringSync(),
        ) as Map<String, dynamic>,
      );
      expect(openApi.tags, isEmpty);
      expect(openApi.paths, isEmpty);
      expect(openApi.components?.schemas, isEmpty);
    });

    test('Contains GET POST PUT for /todos route (no components)', () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }

      memoryFileSystem.file('/routes/index.dart').createSync(recursive: true);
      memoryFileSystem.file('/routes/todos.dart').createSync(recursive: true);

      // WHEN
      final result = await commandRunner.run(['gen']);

      // THEN
      expect(result, equals(ExitCode.success.code));
      final openApiFile = memoryFileSystem.file('/public/openapi.json');
      expect(openApiFile.existsSync(), isTrue);
      final openApi = OpenApi.fromJson(
        jsonDecode(
          openApiFile.readAsStringSync(),
        ) as Map<String, dynamic>,
      );
      expect(openApi.tags, isNotEmpty);
      expect(openApi.tags![0].name, equals('todos'));

      expect(openApi.paths, isNotEmpty);
      expect(openApi.paths['/todos']?.delete, isNull);
      expect(openApi.paths['/todos']?.get, isNotNull);
      expect(openApi.paths['/todos']?.head, isNull);
      expect(openApi.paths['/todos']?.options, isNull);
      expect(openApi.paths['/todos']?.patch, isNull);
      expect(openApi.paths['/todos']?.post, isNotNull);
      expect(openApi.paths['/todos']?.put, isNotNull);
      expect(openApi.paths['/todos']?.trace, isNull);

      expect(openApi.components?.schemas, isEmpty);
    });

    test('Generates header params if @Header tag exists', () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }

      memoryFileSystem.file('/routes/index.dart').createSync(recursive: true);

      const todosFileContent = '''
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

/// @Header(Authorization)
Future<Response> onRequest(RequestContext context) async {
  return Response(statusCode: HttpStatus.ok);
}
''';

      memoryFileSystem.file('/routes/todos.dart')
        ..createSync(recursive: true)
        ..writeAsStringSync(todosFileContent);

      // WHEN
      final result = await commandRunner.run(['gen']);

      // THEN
      expect(result, equals(ExitCode.success.code));
      final openApiFile = memoryFileSystem.file('/public/openapi.json');
      expect(openApiFile.existsSync(), isTrue);
      final openApi = OpenApi.fromJson(
        jsonDecode(
          openApiFile.readAsStringSync(),
        ) as Map<String, dynamic>,
      );

      expect(openApi.paths, isNotEmpty);
      expect(openApi.paths['/todos']?.get, isNotNull);
      expect(openApi.paths['/todos']?.post, isNotNull);
      expect(openApi.paths['/todos']?.put, isNotNull);

      expect(openApi.paths['/todos']?.get?.parameters, isNotEmpty);
      expect(
        openApi.paths['/todos']?.get?.parameters?[0].name,
        equals('Authorization'),
      );
      expect(
        openApi.paths['/todos']?.get?.parameters?[0].inLocation,
        equals(InLocation.header),
      );
      expect(
        openApi.paths['/todos']?.get?.parameters?[0].required,
        equals(false),
      );
    });

    test('Contains GET POST PUT for /todos route (with components)', () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }

      memoryFileSystem.file('/routes/index.dart').createSync(recursive: true);
      memoryFileSystem.file('/routes/todos.dart').createSync(recursive: true);

      const componentJson = '''
{
    "type": "object",
    "properties": {
        "title": {
            "type": "string"
        },
        "completed": {
            "type": "boolean"
        }
    }
}
''';
      memoryFileSystem.file('/components/todos.json')
        ..createSync(recursive: true)
        ..writeAsStringSync(componentJson);

      // WHEN
      final result = await commandRunner.run(['gen']);

      // THEN
      expect(result, equals(ExitCode.success.code));
      final openApiFile = memoryFileSystem.file('/public/openapi.json');
      expect(openApiFile.existsSync(), isTrue);
      final openApi = OpenApi.fromJson(
        jsonDecode(
          openApiFile.readAsStringSync(),
        ) as Map<String, dynamic>,
      );
      expect(openApi.tags, isNotEmpty);
      expect(openApi.tags![0].name, equals('todos'));

      expect(openApi.paths, isNotEmpty);
      expect(openApi.paths['/todos']?.delete, isNull);
      expect(openApi.paths['/todos']?.get, isNotNull);
      expect(openApi.paths['/todos']?.head, isNull);
      expect(openApi.paths['/todos']?.options, isNull);
      expect(openApi.paths['/todos']?.patch, isNull);
      expect(openApi.paths['/todos']?.post, isNotNull);
      expect(openApi.paths['/todos']?.put, isNotNull);
      expect(openApi.paths['/todos']?.trace, isNull);

      expect(openApi.components?.schemas, isNotEmpty);
      expect(openApi.components?.schemas['todos'], isNotNull);
    });

    test(
        'Contains GET POST PUT DELETE for /todos/[title] route (with components)',
        () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }

      memoryFileSystem.file('/routes/index.dart').createSync(recursive: true);
      memoryFileSystem
          .file('/routes/todos/index.dart')
          .createSync(recursive: true);
      memoryFileSystem
          .file('/routes/todos/[title].dart')
          .createSync(recursive: true);

      const componentJson = '''
{
    "type": "object",
    "properties": {
        "title": {
            "type": "string"
        },
        "completed": {
            "type": "boolean"
        }
    }
}
''';
      memoryFileSystem.file('/components/todos.json')
        ..createSync(recursive: true)
        ..writeAsStringSync(componentJson);

      // WHEN
      final result = await commandRunner.run(['gen']);

      // THEN
      expect(result, equals(ExitCode.success.code));
      final openApiFile = memoryFileSystem.file('/public/openapi.json');
      expect(openApiFile.existsSync(), isTrue);
      final openApi = OpenApi.fromJson(
        jsonDecode(
          openApiFile.readAsStringSync(),
        ) as Map<String, dynamic>,
      );
      expect(openApi.tags, isNotEmpty);
      expect(openApi.tags![0].name, equals('todos'));

      expect(openApi.paths, isNotEmpty);
      expect(openApi.paths['/todos']?.delete, isNull);
      expect(openApi.paths['/todos']?.get, isNotNull);
      expect(openApi.paths['/todos']?.head, isNull);
      expect(openApi.paths['/todos']?.options, isNull);
      expect(openApi.paths['/todos']?.patch, isNull);
      expect(openApi.paths['/todos']?.post, isNotNull);
      expect(openApi.paths['/todos']?.put, isNotNull);
      expect(openApi.paths['/todos']?.trace, isNull);

      expect(openApi.paths['/todos/{title}']?.delete, isNotNull);
      expect(openApi.paths['/todos/{title}']?.get, isNotNull);
      expect(openApi.paths['/todos/{title}']?.head, isNull);
      expect(openApi.paths['/todos/{title}']?.options, isNull);
      expect(openApi.paths['/todos/{title}']?.patch, isNull);
      expect(openApi.paths['/todos/{title}']?.post, isNull);
      expect(openApi.paths['/todos/{title}']?.put, isNull);
      expect(openApi.paths['/todos/{title}']?.trace, isNull);

      expect(openApi.components?.schemas, isNotEmpty);
      expect(openApi.components?.schemas['todos'], isNotNull);
    });
  });
}
