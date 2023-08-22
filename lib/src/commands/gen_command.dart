import 'dart:convert';
import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:nenuphar_cli/src/extensions/string_extension.dart';
import 'package:nenuphar_cli/src/models/models.dart';
import 'package:nenuphar_cli/src/tooling.dart';

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
    final routes = _locateRoutes(
      _fileSystem.currentDirectory.childDirectory('routes').path,
    );

    _logger.info('Found ${routes.join('\n')} routes');

    try {
      final openApi = _generateOpenApi(routes);

      final json = jsonPrettyEncoder.convert(openApi.toJson());

      // save to file
      final output = argResults?['output'] ?? 'public/openapi.json';
      final file = _fileSystem.file(output.toString());
      await file.writeAsString(json);

      return ExitCode.success.code;
    } catch (e) {
      _logger.alert('Failed to generate OpenAPI file: $e');
      return ExitCode.usage.code;
    }
  }

  OpenApi _generateOpenApi(List<String> routes) {
    final paths = <String, Paths>{};
    final tags = <Tag>[];
    final schemas = <String, Schema>{};

    for (final route in routes) {
      _parseRoute(route, tags, paths, schemas);
    }

    // Read nenuphar.json file
    final nenupharJsonFile = _fileSystem.file('nenuphar.json');
    if (!nenupharJsonFile.existsSync()) {
      _logger.alert(
        'nenuphar.json file not found. Please run nenuphar init first',
      );
      throw Exception('nenuphar.json file not found');
    }

    final openAPiBase = OpenApi.fromJson(
      jsonDecode(
        nenupharJsonFile.readAsStringSync(),
      ) as Map<String, dynamic>,
    );

    final securityJsonFile =
        _fileSystem.directory('components').childFile('_security.json');
    var securitySchemes = <String, SecurityScheme>{};
    if (securityJsonFile.existsSync()) {
      final securityJson = jsonDecode(
        securityJsonFile.readAsStringSync(),
      ) as Map<String, dynamic>;
      securitySchemes = securityJson.map(
        (name, scheme) => MapEntry(
          name,
          SecurityScheme.fromJson(
            scheme as Map<String, dynamic>,
          ),
        ),
      );
    }

    return openAPiBase
      ..tags = tags
      ..paths = paths
      ..components = Components(
        schemas: schemas,
        securitySchemes: securitySchemes,
      );
  }

  void _parseRoute(
    String route,
    List<Tag> tags,
    Map<String, Paths> paths,
    Map<String, Schema> schemas,
  ) {
    _logger.info(' parsing route: $route');

    final path = route
        .replaceFirst(
          _fileSystem.currentDirectory.childDirectory('routes').path,
          '',
        )
        .replaceAll(r'\', '/')
        .replaceFirst('/index.dart', '')
        .replaceFirst('.dart', '')
        .replaceAll('[', '{')
        .replaceAll(']', '}');

    if (path.isEmpty) {
      return;
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
            .lastOrNull ??
        '';

    if (!schemas.containsKey(tag)) {
      _generateComponent(schemas, tag);
    }

    if (!tags.any((e) => e.name == tag)) {
      tags.add(
        Tag(
          name: tag,
          description: 'Operations about $tag',
        ),
      );
    }

    final pathParams = _extractPathParams(path);
    final headerParams = _extractHeaderParams(route);
    final queryParams = _extractQueryParams(route);
    final allowedMethods = _extractAllowMethods(route);
    final securityNames = _extractSecurityNames(route);
    final securityScopes = _extractSecurityScopes(route);

    if (allowedMethods.isEmpty) {
      _logger.info('No allowed methods found for $path');

      allowedMethods.addAll([
        'options',
        'get',
        'head',
        'post',
        'put',
        'patch',
        'delete',
      ]);

      _logger.info('Using default allowed methods: $allowedMethods');
    }

    paths[path] = Paths(
      options: _generateOptionMethod(
        path: path,
        pathParams: pathParams,
        headerParams: headerParams,
        tag: tag,
        methodAllowed: allowedMethods.contains('options'),
        securityNames: securityNames,
        securityScopes: securityScopes,
      ),
      get: _generateGetMethod(
        path: path,
        pathParams: pathParams,
        headerParams: headerParams,
        queryParams: queryParams,
        tag: tag,
        existingSchema: schemas.containsKey(tag),
        methodAllowed: allowedMethods.contains('get'),
        securityNames: securityNames,
        securityScopes: securityScopes,
      ),
      head: _generateHeadMethod(
        path: path,
        pathParams: pathParams,
        headerParams: headerParams,
        tag: tag,
        methodAllowed: allowedMethods.contains('head'),
        securityNames: securityNames,
        securityScopes: securityScopes,
      ),
      post: _generatePostMethod(
        path: path,
        pathParams: pathParams,
        headerParams: headerParams,
        queryParams: queryParams,
        tag: tag,
        existingSchema: schemas.containsKey(tag),
        methodAllowed: allowedMethods.contains('post'),
        securityNames: securityNames,
        securityScopes: securityScopes,
      ),
      put: _generatePutMethod(
        path: path,
        pathParams: pathParams,
        headerParams: headerParams,
        queryParams: queryParams,
        tag: tag,
        existingSchema: schemas.containsKey(tag),
        methodAllowed: allowedMethods.contains('put'),
        securityNames: securityNames,
        securityScopes: securityScopes,
      ),
      patch: _generatePutMethod(
        path: path,
        pathParams: pathParams,
        headerParams: headerParams,
        queryParams: queryParams,
        tag: tag,
        existingSchema: schemas.containsKey(tag),
        methodAllowed: allowedMethods.contains('patch'),
        securityNames: securityNames,
        securityScopes: securityScopes,
      ),
      delete: _generateDeleteMethod(
        path: path,
        pathParams: pathParams,
        headerParams: headerParams,
        queryParams: queryParams,
        tag: tag,
        methodAllowed: allowedMethods.contains('delete'),
        securityNames: securityNames,
        securityScopes: securityScopes,
      ),
    );
  }

  void _generateComponent(Map<String, Schema> schemas, String tag) {
    // Read file
    final file = _fileSystem.file(
      '${_fileSystem.currentDirectory.path}/components/$tag.json',
    );
    if (file.existsSync()) {
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final schema = Schema.fromJson(json);
      schemas[tag] = schema;
    }
  }

  ///
  /// Generate a DELETE method for [path]
  ///
  Method? _generateDeleteMethod({
    required String path,
    required List<String> pathParams,
    required List<String> headerParams,
    required List<String> queryParams,
    required String tag,
    required bool methodAllowed,
    required List<String> securityNames,
    required List<String> securityScopes,
  }) {
    if (methodAllowed) {
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
            .toList()
          ..addAll(
            headerParams.map(
              (e) => Parameter(
                name: e,
                inLocation: InLocation.header,
                schema: const Schema(
                  type: 'string',
                ),
              ),
            ),
          )
          ..addAll(
            queryParams.map(
              (e) => Parameter(
                name: e,
                schema: const Schema(
                  type: 'string',
                ),
              ),
            ),
          ),
        responses: {
          204: const ResponseBody(
            description: 'Deleted',
          ),
        },
        security: securityNames
            .map(
              (name) => {name: securityScopes},
            )
            .toList(),
      );
    }
    return null;
  }

  ///
  /// Generate a POST method for [path]
  ///
  Method? _generatePostMethod({
    required String path,
    required List<String> pathParams,
    required List<String> headerParams,
    required List<String> queryParams,
    required String tag,
    required bool existingSchema,
    required bool methodAllowed,
    required List<String> securityNames,
    required List<String> securityScopes,
  }) {
    if (methodAllowed) {
      final schemaReference = existingSchema
          ? Schema(ref: '#/components/schemas/$tag')
          : Schema.emptyObject();

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
            .toList()
          ..addAll(
            headerParams.map(
              (e) => Parameter(
                name: e,
                inLocation: InLocation.header,
                schema: const Schema(
                  type: 'string',
                ),
              ),
            ),
          )
          ..addAll(
            queryParams.map(
              (e) => Parameter(
                name: e,
                schema: const Schema(
                  type: 'string',
                ),
              ),
            ),
          ),
        requestBody: RequestBody(
          content: {
            'application/json': MediaType(
              schema: schemaReference,
            ),
          },
        ),
        responses: {
          201: ResponseBody(
            description: 'Created $tag.',
          ),
        },
        security: securityNames
            .map(
              (name) => {name: securityScopes},
            )
            .toList(),
      );
    }
    return null;
  }

  ///
  /// Generate a PUT method for [path]
  ///
  Method? _generatePutMethod({
    required String path,
    required List<String> pathParams,
    required List<String> headerParams,
    required List<String> queryParams,
    required String tag,
    required bool existingSchema,
    required bool methodAllowed,
    required List<String> securityNames,
    required List<String> securityScopes,
  }) {
    if (methodAllowed) {
      final schemaReference = existingSchema
          ? Schema(ref: '#/components/schemas/$tag')
          : Schema.emptyObject();

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
            .toList()
          ..addAll(
            headerParams.map(
              (e) => Parameter(
                name: e,
                inLocation: InLocation.header,
                schema: const Schema(
                  type: 'string',
                ),
              ),
            ),
          )
          ..addAll(
            queryParams.map(
              (e) => Parameter(
                name: e,
                schema: const Schema(
                  type: 'string',
                ),
              ),
            ),
          ),
        requestBody: RequestBody(
          content: {
            'application/json': MediaType(
              schema: schemaReference,
            ),
          },
        ),
        responses: {
          200: ResponseBody(
            description: 'A list of $tag.',
            content: {
              'application/json': MediaType(
                schema: schemaReference,
              ),
            },
          ),
        },
        security: securityNames
            .map(
              (name) => {name: securityScopes},
            )
            .toList(),
      );
    }
    return null;
  }

  ///
  /// Generate a GET method for [path]
  ///
  Method? _generateGetMethod({
    required String path,
    required List<String> pathParams,
    required List<String> headerParams,
    required List<String> queryParams,
    required String tag,
    required bool existingSchema,
    required bool methodAllowed,
    required List<String> securityNames,
    required List<String> securityScopes,
  }) {
    final isList = !path.endsWithPathParam();

    final schemaReference = existingSchema
        ? Schema(ref: '#/components/schemas/$tag')
        : Schema.emptyObject();

    if (!methodAllowed) {
      return null;
    }

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
          .toList()
        ..addAll(
          headerParams.map(
            (e) => Parameter(
              name: e,
              inLocation: InLocation.header,
              schema: const Schema(
                type: 'string',
              ),
            ),
          ),
        )
        ..addAll(
          queryParams.map(
            (e) => Parameter(
              name: e,
              schema: const Schema(
                type: 'string',
              ),
            ),
          ),
        ),
      responses: {
        200: ResponseBody(
          description: isList ? 'A list of $tag.' : 'A $tag.',
          content: {
            'application/json': MediaType(
              schema: isList
                  ? Schema(
                      type: 'array',
                      items: schemaReference,
                    )
                  : schemaReference,
            ),
          },
        ),
      },
      security: securityNames
          .map(
            (name) => {name: securityScopes},
          )
          .toList(),
    );
  }

  ///
  /// Generate a HEAD method for [path]
  ///
  Method? _generateHeadMethod({
    required String path,
    required List<String> pathParams,
    required List<String> headerParams,
    required String tag,
    required bool methodAllowed,
    required List<String> securityNames,
    required List<String> securityScopes,
  }) {
    if (!methodAllowed) {
      return null;
    }

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
          .toList()
        ..addAll(
          headerParams.map(
            (e) => Parameter(
              name: e,
              inLocation: InLocation.header,
              schema: const Schema(
                type: 'string',
              ),
            ),
          ),
        ),
      responses: {
        200: ResponseBody(
          description: 'Meta informations about $tag.',
        ),
      },
      security: securityNames
          .map(
            (name) => {name: securityScopes},
          )
          .toList(),
    );
  }

  ///
  /// Generate a OPTION method for [path]
  ///
  Method? _generateOptionMethod({
    required String path,
    required List<String> pathParams,
    required List<String> headerParams,
    required String tag,
    required bool methodAllowed,
    required List<String> securityNames,
    required List<String> securityScopes,
  }) {
    if (!methodAllowed) {
      return null;
    }
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
          .toList()
        ..addAll(
          headerParams.map(
            (e) => Parameter(
              name: e,
              inLocation: InLocation.header,
              schema: const Schema(
                type: 'string',
              ),
            ),
          ),
        ),
      responses: {
        204: ResponseBody(
          description: 'Allowed HTTP methods for $path',
          headers: {
            'Allow': Header(
              description: 'Allowed HTTP methods for $path',
              schema: const Schema(
                type: 'string',
              ),
            ),
          },
        ),
      },
      security: securityNames
          .map(
            (name) => {name: securityScopes},
          )
          .toList(),
    );
  }

  ///
  /// Extract security scopes from [routeFile]
  /// like /// @Scope(scope_name)
  /// will return ['scope_name']
  /// if no security scope is found, return an empty list
  ///
  List<String> _extractSecurityScopes(String routeFile) {
    final file = _fileSystem.file(routeFile);
    final content = file.readAsStringSync();
    final matches = RegExp(r'///\s*@Scope\((.*)\)').allMatches(content);
    return matches
        .map((e) => e.group(1)!)
        .map((it) => it.split(','))
        .expand((it) => it) // flatten List<List<String>> => List<String>
        .toList();
  }

  ///
  /// Extract security names from [routeFile]
  /// like /// @Security(api_key)
  /// will return ['api_key']
  /// if no security name is found, return an empty list
  ///
  List<String> _extractSecurityNames(String routeFile) {
    final file = _fileSystem.file(routeFile);
    final content = file.readAsStringSync();
    final matches = RegExp(r'///\s*@Security\((.*)\)').allMatches(content);
    return matches
        .map((e) => e.group(1)!)
        .map((it) => it.split(','))
        .expand((it) => it) // flatten List<List<String>> => List<String>
        .toList();
  }

  ///
  /// Extract allowed methods from [routeFile]
  /// like /// @Allow(OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE)
  /// will return ['options', 'get', 'head', 'post', 'put', 'patch', 'delete']
  /// if no allowed methods is found, return an empty list
  ///
  List<String> _extractAllowMethods(String routeFile) {
    final file = _fileSystem.file(routeFile);
    final content = file.readAsStringSync();
    final matches = RegExp(r'///\s*@Allow\((.*)\)').allMatches(content);
    return matches
        .map(
          (e) => e.group(1)!,
        ) // Match found group (@Allow(OPTIONS, GET) => OPTIONS, GET)
        .map((it) => it.split(','))
        .expand((it) => it) // flatten List<List<String>> => List<String>
        .map((it) => it.trim().toLowerCase()) // lowercase (GET => get)
        .toList();
  }

  ///
  /// Extract query parameters from [routeFile]
  /// like /// @Query(completed)
  /// will return ['completed']
  /// if no query is found, return an empty list
  ///
  List<String> _extractQueryParams(String routeFile) {
    final file = _fileSystem.file(routeFile);
    final content = file.readAsStringSync();
    final matches = RegExp(r'///\s*@Query\((.*)\)').allMatches(content);
    return matches.map((e) => e.group(1)!).toList();
  }

  ///
  /// Extract header parameters from [routeFile]
  /// like /// @Header(Authorization)
  /// will return ['Authorization']
  /// if no header is found, return an empty list
  ///
  List<String> _extractHeaderParams(String routeFile) {
    final file = _fileSystem.file(routeFile);
    final content = file.readAsStringSync();
    final matches = RegExp(r'///\s*@Header\((.*)\)').allMatches(content);
    return matches.map((e) => e.group(1)!).toList();
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
