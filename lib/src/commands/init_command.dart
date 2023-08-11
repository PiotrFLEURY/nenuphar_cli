import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template sample_command}
///
/// `nenuphar init`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class InitCommand extends Command<int> {
  /// {@macro sample_command}
  InitCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser.addOption(
      'url',
      abbr: 'u',
      help: 'Specify the url of the OpenAPI file',
    );
  }

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
    // Ensure public folder exists
    final publicDir = Directory('public');
    if (!publicDir.existsSync()) {
      publicDir.createSync();
    }

    // Write index.html in public/index.html
    final file = File('public/index.html');
    await file.writeAsString(
      indexHtml.replaceFirst(
        '___OPENAPI_FILE_URL___',
        'http://localhost:8080/openapi.json',
      ),
    );

    _logger.info('Generated public/index.html file');

    return ExitCode.success.code;
  }
}
