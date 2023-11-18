import 'package:nenuphar_annotations/nenuphar_annotations.dart';
import 'package:test/test.dart';

void main() {
  group('JsonSchema', () {
    test('Annotation can be used', () {
      expect(JsonSchema(), isNotNull);
    });

    test('Annotation constant can be used', () {
      expect(jsonSchema, isNotNull);
    });
  });
}
