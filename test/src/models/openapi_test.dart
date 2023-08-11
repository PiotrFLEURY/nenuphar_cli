import 'dart:convert';

import 'package:nenuphar_cli/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  test('jsonEncode openApi', () {
    // GIVEN
    const openApi = OpenApi(
      info: Info(
        title: 'Todo API',
        version: '1.0.0',
        contact: Contact(
          name: 'John Doe',
          email: '',
          url: 'https://example.com',
        ),
        license: License(
          name: 'MIT',
          url: 'https://opensource.org/licenses/MIT',
        ),
      ),
      paths: {
        '/todo': Paths(
          get: Method(
            responses: {
              200: ResponseBody(
                description: 'A list of todos.',
              ),
            },
          ),
        ),
      },
    );

    // WHEN
    final json = jsonEncode(openApi.toJson());

    // THEN
    expect(json, isNotEmpty);
  });
}
