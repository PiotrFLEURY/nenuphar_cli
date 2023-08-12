import 'dart:convert';
import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:nenuphar_cli/src/extensions/string_extension.dart';
import 'package:nenuphar_cli/src/models/models.dart';

/// {@template sample_command}
///
/// `nenuphar gen`
/// A [Command] to generate OpenAPI file
/// {@endtemplate}
class GenCommand extends Command<int> {
  /// {@macro sample_command}
  GenCommand({
    required Logger logger,
    required FileSystem fileSystem,
  })  : _logger = logger,
        _fileSystem = fileSystem {
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'Specify the output file',
    );
  }

  @override
  String get description => 'Sub command that generated OpenAPI file';

  @override
  String get name => 'gen';

  final Logger _logger;

  final FileSystem _fileSystem;

  /// A regex to find multiple {parameter} in path
  /// like /todos/{id}/comments/{commentId}
  final pathParamGroups = RegExp(r'\{([a-zA-Z]+)\}+');

  @override
  Future<int> run() async {
    _logger
      ..info('Will generate OpenAPI file')
      ..info('input is: ${_fileSystem.currentDirectory.path}');
    if (argResults?['output'] != null) {
      _logger.info(
        'output is: ${lightCyan.wrap(argResults!['output'].toString())!}',
      );
    }

    // List every *.dart files in routes folder
    final routes = _locateRoutes('${_fileSystem.currentDirectory.path}/routes');

    _logger.info('Found ${routes.join('\n')} routes');

    final openApi = _generateOpenApi(routes);

    final json = jsonEncode(openApi.toJson());

    // save to file
    final output = argResults?['output'] ?? 'public/openapi.json';
    final file = _fileSystem.file(output.toString());
    await file.writeAsString(json);

    _logger.info('Generated OpenAPI file: $json');

    return ExitCode.success.code;
  }

  OpenApi _generateOpenApi(List<String> routes) {
    final paths = <String, Paths>{};
    final tags = <Tag>[];

    for (final route in routes) {
      final path = route
          .replaceFirst('${_fileSystem.currentDirectory.path}/routes', '')
          .replaceFirst('/index.dart', '')
          .replaceFirst('.dart', '')
          .replaceAll('[', '{')
          .replaceAll(']', '}');

      if (path.isEmpty) {
        continue;
      }

      _logger.info(' evaluating path: $path');

      final tag = path
          .split('/')
          .where((segment) => segment.isNotEmpty)
          .where(
            (segment) => !segment.contains(
              RegExp(r'\{.*\}*'),
            ),
          )
          .last;

      if (!tags.any((e) => e.name == tag)) {
        tags.add(
          Tag(
            name: tag,
            description: 'Operations about $tag',
          ),
        );
      }

      paths[path] = Paths(
        get: _generateGetMethod(
          path,
          tag,
        ),
        post: _generatePostMethod(
          path,
          tag,
        ),
        put: _generatePutMethod(
          path,
          tag,
        ),
        delete: _generateDeleteMethod(
          path,
          tag,
        ),
      );
    }

    return OpenApi(
      info: const Info(
        title: 'Nenuphar API Documentation',
        version: '1.0.0',
      ),
      tags: tags,
      paths: paths,
      components: _generateComponents(tags),
    );
  }

  ///
  /// Generate components from [tags]
  /// by reading files from components/ folder
  /// and generate schemas from them
  /// and return a [Components] object
  ///
  Components _generateComponents(List<Tag> tags) {
    // Read components files from components/ folder
    // and generate schemas from them

    final schemas = <String, Schema>{};

    for (final tag in tags) {
      // Read file
      final file = _fileSystem.file(
        '${_fileSystem.currentDirectory.path}/components/${tag.name}.json',
      );
      if (file.existsSync()) {
        final json =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        final schema = Schema.fromJson(json);
        schemas[tag.name] = schema;
      }
    }

    return Components(schemas: schemas);
  }

  ///
  /// Generate a DELETE method for [path] and [tag]
  ///
  Method? _generateDeleteMethod(String path, String tag) {
    if (path.endsWithPathParam()) {
      final pathParams = _extractPathParams(path);

      return Method(
        tags: [tag],
        parameters: pathParams
            .map(
              (e) => Parameter(
                name: e,
                inLocation: InLocation.path,
                required: true,
                schema: const Schema(
                  type: 'string',
                ),
              ),
            )
            .toList(),
        responses: {
          204: const ResponseBody(
            description: 'Deleted',
          ),
        },
      );
    }
    return null;
  }

  ///
  /// Generate a POST method for [path] and [tag]
  ///
  Method? _generatePostMethod(String path, String tag) {
    if (!path.endsWithPathParam()) {
      final pathParams = _extractPathParams(path);

      return Method(
        tags: [tag],
        parameters: pathParams
            .map(
              (e) => Parameter(
                name: e,
                inLocation: InLocation.path,
                required: true,
                schema: const Schema(
                  type: 'string',
                ),
              ),
            )
            .toList(),
        requestBody: RequestBody(
          content: {
            'application/json': MediaType(
              schema: Schema(
                ref: '#/components/schemas/$tag',
              ),
            ),
          },
        ),
        responses: {
          201: ResponseBody(
            description: 'Created $tag.',
          ),
        },
      );
    }
    return null;
  }

  ///
  /// Generate a PUT method for [path] and [tag]
  ///
  Method? _generatePutMethod(String path, String tag) {
    if (!path.endsWithPathParam()) {
      final pathParams = _extractPathParams(path);
      return Method(
        tags: [tag],
        parameters: pathParams
            .map(
              (e) => Parameter(
                name: e,
                inLocation: InLocation.path,
                required: true,
                schema: const Schema(
                  type: 'string',
                ),
              ),
            )
            .toList(),
        requestBody: RequestBody(
          content: {
            'application/json': MediaType(
              schema: Schema(
                ref: '#/components/schemas/$tag',
              ),
            ),
          },
        ),
        responses: {
          200: ResponseBody(
            description: 'A list of $tag.',
            content: {
              'application/json': MediaType(
                schema: Schema(
                  ref: '#/components/schemas/$tag',
                ),
              ),
            },
          ),
        },
      );
    }
    return null;
  }

  ///
  /// Generate a GET method for [path] and [tag]
  ///
  Method _generateGetMethod(
    String path,
    String tag,
  ) {
    final pathParams = _extractPathParams(path);
    final isList = !path.endsWithPathParam();

    return Method(
      tags: [tag],
      parameters: pathParams
          .map(
            (e) => Parameter(
              name: e,
              inLocation: InLocation.path,
              required: true,
              schema: const Schema(
                type: 'string',
              ),
            ),
          )
          .toList(),
      responses: {
        200: ResponseBody(
          description: isList ? 'A list of $tag.' : 'A $tag.',
          content: {
            'application/json': MediaType(
              schema: isList
                  ? Schema(
                      type: 'array',
                      items: Schema(
                        ref: '#/components/schemas/$tag',
                      ),
                    )
                  : Schema(
                      ref: '#/components/schemas/$tag',
                    ),
            ),
          },
        ),
      },
    );
  }

  ///
  /// Extract path parameters from [path]
  /// like /todos/{id}/comments/{commentId}
  /// will return ['id', 'commentId']
  ///
  List<String> _extractPathParams(String path) {
    final matches = pathParamGroups.allMatches(path);
    final pathParams = matches.map((e) => e.group(1)!).toList();
    return pathParams;
  }

  ///
  /// Recursively list every *.dart files in [path] folder
  /// and return a list of their paths
  ///
  /// middleware files are ignored
  ///
  List<String> _locateRoutes(String path) {
    final entities = _fileSystem.directory(path).listSync();

    final routes = entities
        .where((e) => e.path.endsWith('.dart'))
        .where((e) => !e.path.endsWith('_middleware.dart'))
        .map((e) => e.path)
        .toList();

    final directories = entities.whereType<Directory>();
    for (final dir in directories) {
      routes.addAll(_locateRoutes(dir.path));
    }

    return routes;
  }
}
