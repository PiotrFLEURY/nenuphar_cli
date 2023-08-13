import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nenuphar_cli/src/command_runner.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  group('init', () {
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

    test('initialize index.html when public dir does not exists', () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (publicDir.existsSync()) {
        publicDir.deleteSync(recursive: true);
      }

      // WHEN
      final result = await commandRunner.run(['init']);

      // THEN
      expect(result, equals(ExitCode.success.code));
      final indexHtmlFile = memoryFileSystem.file('public/index.html');
      expect(indexHtmlFile.existsSync(), isTrue);
      final nenupharJsonFile = memoryFileSystem.file('nenuphar.json');
      expect(nenupharJsonFile.existsSync(), isTrue);
    });

    test('initialize index.html when public dir already exists', () async {
      // GIVEN
      final publicDir = memoryFileSystem.directory('public');
      if (!publicDir.existsSync()) {
        publicDir.createSync();
      }

      // WHEN
      final result = await commandRunner.run(['init']);

      // THEN
      expect(result, equals(ExitCode.success.code));
      final indexHtmlFile = memoryFileSystem.file('public/index.html');
      expect(indexHtmlFile.existsSync(), isTrue);
      final nenupharJsonFile = memoryFileSystem.file('nenuphar.json');
      expect(nenupharJsonFile.existsSync(), isTrue);
    });

    test('fail if public/index.html already exists', () async {
      // GIVEN
      final index = memoryFileSystem.file('public/index.html');
      if (!index.existsSync()) {
        index.createSync(recursive: true);
      }

      // WHEN
      final result = await commandRunner.run(['init']);

      // THEN
      expect(result, equals(ExitCode.ioError.code));
    });

    test('fail if nenuphar.json already exists', () async {
      // GIVEN
      final nenupharJsonFile = memoryFileSystem.file('nenuphar.json');
      if (!nenupharJsonFile.existsSync()) {
        nenupharJsonFile.createSync(recursive: true);
      }

      // WHEN
      final result = await commandRunner.run(['init']);

      // THEN
      expect(result, equals(ExitCode.ioError.code));
    });

    test('succeed if public/index.html already exists with -o flag', () async {
      // GIVEN
      final index = memoryFileSystem.file('public/index.html');
      if (!index.existsSync()) {
        index.createSync(recursive: true);
      }
      final nenupharJsonFile = memoryFileSystem.file('nenuphar.json');
      if (!nenupharJsonFile.existsSync()) {
        nenupharJsonFile.createSync(recursive: true);
      }

      // WHEN
      final result = await commandRunner.run(['init', '-o']);

      // THEN
      expect(result, equals(ExitCode.success.code));
      final indexHtmlFile = memoryFileSystem.file('public/index.html');
      expect(indexHtmlFile.existsSync(), isTrue);
      expect(nenupharJsonFile.existsSync(), isTrue);
    });
  });
}
