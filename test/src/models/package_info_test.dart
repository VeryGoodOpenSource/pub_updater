import 'package:pub_updater/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('LatestVersionConverter', () {
    test('to/from json works', () {
      const converter = LatestVersionConverter();
      final latestVersion = {'version': '1.0.0'};
      expect(
        converter.toJson(converter.fromJson(latestVersion)),
        equals(latestVersion),
      );
    });
  });
}
