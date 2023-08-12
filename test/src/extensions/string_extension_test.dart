import 'package:nenuphar_cli/src/extensions/string_extension.dart';
import 'package:test/test.dart';

void main() {
  group('endsWithPathParam', () {
    test('route path should return false', () {
      // GIVEN
      const path = '/';

      // WHEN
      final result = path.endsWithPathParam();

      // THEN
      expect(result, isFalse);
    });
    test('path not ending with param should return false', () {
      // GIVEN
      const path = '/todos';

      // WHEN
      final result = path.endsWithPathParam();

      // THEN
      expect(result, isFalse);
    });
    test('path ending with param should return true', () {
      // GIVEN
      const path = '/todos/{id}';

      // WHEN
      final result = path.endsWithPathParam();

      // THEN
      expect(result, isTrue);
    });
    test('path containing param in the middle should return false', () {
      // GIVEN
      const path = '/todos/{id}/comments';

      // WHEN
      final result = path.endsWithPathParam();

      // THEN
      expect(result, isFalse);
    });
  });
}
