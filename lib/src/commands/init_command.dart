import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:nenuphar_cli/src/models/models.dart';

/// {@template sample_command}
///
/// `nenuphar init`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class InitCommand extends Command<int> {
  /// {@macro sample_command}
  InitCommand({
    required Logger logger,
    required FileSystem fileSystem,
  })  : _logger = logger,
        _fileSystem = fileSystem {
    argParser
      ..addOption(
        'url',
        abbr: 'u',
        help: 'Specify the url of the OpenAPI file',
      )
      ..addFlag(
        'override',
        abbr: 'o',
        negatable: false,
        help: 'Override existing index.html file',
      );
  }

  final FileSystem _fileSystem;

  @override
  String get description => 'Sub command to initialize Swagger index.html';

  @override
  String get name => 'init';

  final indexHtml = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta
    name="description"
    content="SwaggerUI"
  />
  <title>SwaggerUI</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui.css" />
</head>
<body>
<div id="swagger-ui"></div>
<script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-bundle.js" crossorigin></script>
<script>
  window.onload = () => {
    window.ui = SwaggerUIBundle({
      url: '___OPENAPI_FILE_URL___',
      dom_id: '#swagger-ui',
    });
  };
</script>
</body>
</html>
  ''';

  final Logger _logger;

  @override
  Future<int> run() async {
    // Write index.html in public/index.html
    final file = _fileSystem.file('public/index.html');
    final override = argResults!['override'] as bool? ?? false;
    if (!override && file.existsSync()) {
      _logger.alert('public/index.html already exists');
      return ExitCode.ioError.code;
    } else {
      file.createSync(recursive: true);
    }
    await file.writeAsString(
      indexHtml.replaceFirst(
        '___OPENAPI_FILE_URL___',
        'http://localhost:8080/openapi.json',
      ),
    );

    _logger.info('Generated public/index.html file');

    final nenupharJson = _fileSystem.file('nenuphar.json');
    if (!override && nenupharJson.existsSync()) {
      _logger.alert('nenuphar.json already exists');
      return ExitCode.ioError.code;
    } else {
      nenupharJson
        ..createSync()
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(OpenApi()),
        );
    }

    return ExitCode.success.code;
  }
}
