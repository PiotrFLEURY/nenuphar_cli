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

    test('Fail if nenuphar.json does not exists', () async {
      // GIVEN
      final nenupharJson = memoryFileSystem.file('nenuphar.json');
      if (nenupharJson.existsSync()) {
        nenupharJson.deleteSync();
      }

      memoryFileSystem.file('/routes/index.dart').createSync(recursive: true);

      // WHEN
      final result = await commandRunner.run(['gen']);

      // THEN
      expect(result, equals(ExitCode.usage.code));
    });

    test('Contains no operation if only / route exists', () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }
      memoryFileSystem.file('nenuphar.json')
        ..createSync()
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(OpenApi()),
        );

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

    test(
        'Contains OPTION HEAD GET POST PUT PATCH for /todos route (no components)',
        () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }
      memoryFileSystem.file('nenuphar.json')
        ..createSync()
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(OpenApi()),
        );

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
      expect(openApi.paths['/todos']?.delete, isNotNull);
      expect(openApi.paths['/todos']?.get, isNotNull);
      expect(openApi.paths['/todos']?.head, isNotNull);
      expect(openApi.paths['/todos']?.options, isNotNull);
      expect(openApi.paths['/todos']?.patch, isNotNull);
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
      memoryFileSystem.file('nenuphar.json')
        ..createSync()
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(OpenApi()),
        );

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

    test('Generates query params if @Query tag exists', () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }
      memoryFileSystem.file('nenuphar.json')
        ..createSync()
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(OpenApi()),
        );

      memoryFileSystem.file('/routes/index.dart').createSync(recursive: true);

      const todosFileContent = '''
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

/// @Query(completed)
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
        equals('completed'),
      );
      expect(
        openApi.paths['/todos']?.get?.parameters?[0].inLocation,
        equals(InLocation.query),
      );
      expect(
        openApi.paths['/todos']?.get?.parameters?[0].required,
        equals(false),
      );
    });

    test('Generates only allowed methods if @Allow tag exists', () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }
      memoryFileSystem.file('nenuphar.json')
        ..createSync()
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(OpenApi()),
        );

      memoryFileSystem.file('/routes/index.dart').createSync(recursive: true);

      const todosFileContent = '''
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

/// @Allow(GET, post, Put, DeLeTe)
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
      expect(openApi.paths['/todos']?.delete, isNotNull);
      expect(openApi.paths['/todos']?.head, isNull);
      expect(openApi.paths['/todos']?.options, isNull);
      expect(openApi.paths['/todos']?.patch, isNull);
      expect(openApi.paths['/todos']?.trace, isNull);
    });

    test(
        'Contains OPTION GET HEAD POST PUT PATCH for /todos route (with components)',
        () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }
      memoryFileSystem.file('nenuphar.json')
        ..createSync()
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(OpenApi()),
        );

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
      expect(openApi.paths['/todos']?.delete, isNotNull);
      expect(openApi.paths['/todos']?.get, isNotNull);
      expect(openApi.paths['/todos']?.head, isNotNull);
      expect(openApi.paths['/todos']?.options, isNotNull);
      expect(openApi.paths['/todos']?.patch, isNotNull);
      expect(openApi.paths['/todos']?.post, isNotNull);
      expect(openApi.paths['/todos']?.put, isNotNull);
      expect(openApi.paths['/todos']?.trace, isNull);

      expect(openApi.components?.schemas, isNotEmpty);
      expect(openApi.components?.schemas['todos'], isNotNull);
    });

    test(
        'Contains OPTION GET HEAD POST DELETE for /todos/[title] route (with components)',
        () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }
      memoryFileSystem.file('nenuphar.json')
        ..createSync()
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(OpenApi()),
        );

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
      expect(openApi.paths['/todos']?.delete, isNotNull);
      expect(openApi.paths['/todos']?.get, isNotNull);
      expect(openApi.paths['/todos']?.head, isNotNull);
      expect(openApi.paths['/todos']?.options, isNotNull);
      expect(openApi.paths['/todos']?.patch, isNotNull);
      expect(openApi.paths['/todos']?.post, isNotNull);
      expect(openApi.paths['/todos']?.put, isNotNull);
      expect(openApi.paths['/todos']?.trace, isNull);

      expect(openApi.paths['/todos/{title}']?.delete, isNotNull);
      expect(openApi.paths['/todos/{title}']?.get, isNotNull);
      expect(openApi.paths['/todos/{title}']?.head, isNotNull);
      expect(openApi.paths['/todos/{title}']?.options, isNotNull);
      expect(openApi.paths['/todos/{title}']?.patch, isNotNull);
      expect(openApi.paths['/todos/{title}']?.post, isNotNull);
      expect(openApi.paths['/todos/{title}']?.put, isNotNull);
      expect(openApi.paths['/todos/{title}']?.trace, isNull);

      expect(openApi.components?.schemas, isNotEmpty);
      expect(openApi.components?.schemas['todos'], isNotNull);
    });

    test(
        'routes/[message].dart should generate OpenApi with no tag (issue #23)',
        () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }
      memoryFileSystem.file('nenuphar.json')
        ..createSync()
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(OpenApi()),
        );

      const messageFileContent = '''
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context, String message) {
  return Response(body: message);
}
''';

      memoryFileSystem.file('/routes/[message].dart')
        ..createSync(recursive: true)
        ..writeAsStringSync(messageFileContent);

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

      expect(openApi.paths['/{message}']?.delete, isNotNull);
      expect(openApi.paths['/{message}']?.get, isNotNull);
      expect(openApi.paths['/{message}']?.head, isNotNull);
      expect(openApi.paths['/{message}']?.options, isNotNull);
      expect(openApi.paths['/{message}']?.patch, isNotNull);
      expect(openApi.paths['/{message}']?.post, isNotNull);
      expect(openApi.paths['/{message}']?.put, isNotNull);
      expect(openApi.paths['/{message}']?.trace, isNull);

      expect(openApi.paths['/{message}']?.delete?.tags, ['']);
      expect(openApi.paths['/{message}']?.get?.tags, ['']);
      expect(openApi.paths['/{message}']?.head?.tags, ['']);
      expect(openApi.paths['/{message}']?.options?.tags, ['']);
      expect(openApi.paths['/{message}']?.patch?.tags, ['']);
      expect(openApi.paths['/{message}']?.post?.tags, ['']);
      expect(openApi.paths['/{message}']?.put?.tags, ['']);
    });

    test('Should generate for auth routes (issue #21)', () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory(Uri.directory('public'));
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }
      memoryFileSystem.file(Uri.file('nenuphar.json'))
        ..createSync()
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(OpenApi()),
        );

      const loginFileContent = '''
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:travel_plan/controller/auth/auth_controller.dart';

///
/// The /api/auth/login routes
///
/// @Allow(POST) - Allow only POST methods
///
/// @Header(User-Name) - The user name header
///
///
Future<Response> onRequest(RequestContext context) async {
  return switch(context.request.method) {
    HttpMethod.post => AuthController.instance.login(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}
''';

      memoryFileSystem.file(Uri.file('routes/api/auth/login.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync(loginFileContent);

      const registerFileContent = '''
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:travel_plan/controller/auth/auth_controller.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch(context.request.method) {
    HttpMethod.post => AuthController.instance.register(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}
''';

      memoryFileSystem.file(Uri.file('routes/api/auth/register.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync(registerFileContent);

      // WHEN
      final result = await commandRunner.run(['gen']);

      // THEN
      expect(result, equals(ExitCode.success.code));
      final openApiFile =
          memoryFileSystem.file(Uri.file('/public/openapi.json'));
      expect(openApiFile.existsSync(), isTrue);
    });
  });
}
