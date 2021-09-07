// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:http/http.dart' show Client, Response;
import 'package:mocktail/mocktail.dart';
import 'package:process/process.dart';
import 'package:pub_update/pub_update.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

class MockProcessManager extends Mock implements ProcessManager {}

class FakeUri extends Fake implements Uri {}

class FakeProcessResult extends Fake implements ProcessResult {}

const responseBody = '''
{
  "name": "very_good_cli",
  "versions": ["3.0.0-nullsafety.1", "3.0.0-dev.2", "3.0.0-dev.1", "3.0.0", "3.0.0-nullsafety.0"]
}
''';

const devResponseBody = '''
{
  "name": "very_good_cli",
  "versions": ["3.0.0-dev.2", "3.0.0-dev.1", "3.0.0"]
}
''';

const nullSafetyReponseBody = '''
{
  "name": "very_good_cli",
  "versions": ["3.0.0-nullsafety.0", "3.0.0-nullsafety.1", "3.0.0"]
}
''';

const emptyResponseBody = '{}';

const command = ['dart', 'pub', 'global', 'activate', 'very_good_cli'];

void main() {
  group('PubUpdate', () {
    late Client client;
    late Response response;
    late PubUpdate pubUpdate;
    late ProcessManager processManager;
    setUpAll(() {
      registerFallbackValue<Uri>(FakeUri());
    });

    setUp(() {
      client = MockClient();
      response = MockResponse();
      pubUpdate = PubUpdate(client);
      processManager = MockProcessManager();

      when(() => client.get(any())).thenAnswer((_) async => response);
      when(() => response.statusCode).thenReturn(HttpStatus.ok);
      when(() => response.body).thenReturn(responseBody);

      when(() => processManager.run(any()))
          .thenAnswer((_) => Future.value(FakeProcessResult()));
    });

    test('can be instantiated without an explicit http client', () {
      expect(PubUpdate(), isNotNull);
    });

    group('isUpToDate', () {
      test('makes correct http request', () async {
        when(() => response.body).thenReturn(emptyResponseBody);

        try {
          await pubUpdate.isUpToDate(
              packageName: 'very_good_cli', currentVersion: '0.3.3');
        } catch (_) {
          verify(
            () => client.get(
              Uri.https(
                'pub.dev',
                '/packages/very_good_cli.json',
              ),
            ),
          ).called(1);
        }
      });

      test('returns false when currentVersion < latestVersion (dev)', () async {
        when(() => response.body).thenReturn(devResponseBody);
        expect(
          await pubUpdate.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '3.0.0',
          ),
          false,
        );
      });

      test('returns true when currentVersion == latestVersion (dev)', () async {
        when(() => response.body).thenReturn(devResponseBody);
        expect(
          await pubUpdate.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '3.0.0-dev.2',
          ),
          true,
        );
      });

      test('returns false when currentVersion < latestVersion (nullsafety)',
          () async {
        when(() => response.body).thenReturn(nullSafetyReponseBody);
        expect(
          await pubUpdate.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '3.0.0',
          ),
          false,
        );
      });

      test('returns true when currentVersion == latestVersion (nullsafety)',
          () async {
        when(() => response.body).thenReturn(nullSafetyReponseBody);
        expect(
          await pubUpdate.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '3.0.0-nullsafety.1',
          ),
          true,
        );
      });

      test('returns false when currentVersion < latestVersion (all)', () async {
        when(() => response.body).thenReturn(responseBody);
        expect(
          await pubUpdate.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '3.0.0-dev.2',
          ),
          false,
        );
      });

      test('returns true when currentVersion == latestVersion (all)', () async {
        when(() => response.body).thenReturn(responseBody);
        expect(
          await pubUpdate.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '3.0.0-nullsafety.1',
          ),
          true,
        );
      });

      test('throws PackageInfoRequestFailure on non-200 response', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.notFound);
        await expectLater(
          pubUpdate.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '3.0.0',
          ),
          throwsA(isA<PackageInfoRequestFailure>()),
        );
      });

      test('throws PackageInfoNotFoundFailure when response body is empty',
          () async {
        when(() => response.body).thenReturn(emptyResponseBody);
        await expectLater(
          pubUpdate.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '3.0.0',
          ),
          throwsA(isA<PackageInfoNotFoundFailue>()),
        );
      });
    });

    group('update', () {
      test('makes correct call to process.run', () async {
        await pubUpdate.update(
          packageName: 'very_good_cli',
          processManager: processManager,
        );
        verify(() => processManager.run(command)).called(1);
      });
    });
  });
}
