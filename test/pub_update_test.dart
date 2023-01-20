// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:http/http.dart' show Client, Response;
import 'package:mocktail/mocktail.dart';
import 'package:process/process.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';

import 'fixtures/valid_package_info_response.dart';

class MockClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

class MockProcessManager extends Mock implements ProcessManager {}

class FakeProcessResult extends Fake implements ProcessResult {}

const emptyResponseBody = '{}';

const command = [
  'dart',
  'pub',
  'global',
  'activate',
  'very_good_cli',
];
const commandWithConstraint = [
  'dart',
  'pub',
  'global',
  'activate',
  'very_good_cli',
  '>=0.4.0',
];

const customBaseUrl = 'https://custom-domain.com/api/packages/';

void main() {
  group('PubUpdater', () {
    late Client client;
    late Response response;
    late PubUpdater pubUpdater;
    late ProcessManager processManager;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      client = MockClient();
      response = MockResponse();
      pubUpdater = PubUpdater(client);
      processManager = MockProcessManager();

      when(() => client.get(any())).thenAnswer((_) async => response);
      when(() => response.statusCode).thenReturn(HttpStatus.ok);
      when(() => response.body).thenReturn(validPackageInfoResponseBody);

      when(() => processManager.run(any()))
          .thenAnswer((_) => Future.value(FakeProcessResult()));
    });

    test('can be instantiated without an explicit http client', () {
      expect(PubUpdater(), isNotNull);
    });

    test('can be instantiated with a custom base url', () {
      expect(PubUpdater(null, customBaseUrl), isNotNull);
    });

    group('isUpToDate', () {
      test('makes correct http request', () async {
        when(() => response.body).thenReturn(emptyResponseBody);

        try {
          await pubUpdater.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '0.3.3',
          );
        } catch (_) {}

        verify(
          () => client.get(
            Uri.https(
              'pub.dev',
              '/api/packages/very_good_cli',
            ),
          ),
        ).called(1);
      });

      test('makes correct http request with a custom base url', () async {
        when(() => response.body).thenReturn(emptyResponseBody);
        pubUpdater = PubUpdater(client, customBaseUrl);

        try {
          await pubUpdater.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '0.3.3',
          );
        } catch (_) {}

        verify(
          () => client.get(
            Uri.parse('${customBaseUrl}very_good_cli'),
          ),
        ).called(1);
      });

      test('returns false when currentVersion < latestVersion', () async {
        expect(
          await pubUpdater.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '3.0.0',
          ),
          false,
        );
      });

      test('returns true when currentVersion == latestVersion', () async {
        expect(
          await pubUpdater.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '0.4.6',
          ),
          true,
        );
      });

      test('throws PackageInfoRequestFailure on non-200 response', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.notFound);
        await expectLater(
          pubUpdater.isUpToDate(
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
          pubUpdater.isUpToDate(
            packageName: 'very_good_cli',
            currentVersion: '3.0.0',
          ),
          throwsA(isA<PackageInfoNotFoundFailure>()),
        );
      });
    });

    group('getLatestVersion', () {
      test('makes correct http request', () async {
        when(() => response.body).thenReturn(emptyResponseBody);

        try {
          await pubUpdater.getLatestVersion('very_good_cli');
        } catch (_) {}

        verify(
          () => client.get(
            Uri.https(
              'pub.dev',
              '/api/packages/very_good_cli',
            ),
          ),
        ).called(1);
      });

      test('makes correct http request with a custom base url', () async {
        when(() => response.body).thenReturn(emptyResponseBody);
        pubUpdater = PubUpdater(client, customBaseUrl);

        try {
          await pubUpdater.getLatestVersion('very_good_cli');
        } catch (_) {}

        verify(
          () => client.get(
            Uri.parse('${customBaseUrl}very_good_cli'),
          ),
        ).called(1);
      });

      test('returns correct version', () async {
        when(() => response.body).thenReturn(validPackageInfoResponseBody);
        expect(
          await pubUpdater.getLatestVersion('very_good_cli'),
          equals('0.4.6'),
        );
      });

      test('throws PackageInfoRequestFailure on non-200 response', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.notFound);
        await expectLater(
          pubUpdater.getLatestVersion('very_good_cli'),
          throwsA(isA<PackageInfoRequestFailure>()),
        );
      });

      test('throws PackageInfoNotFoundFailure when response body is empty',
          () async {
        when(() => response.body).thenReturn(emptyResponseBody);
        await expectLater(
          pubUpdater.getLatestVersion('very_good_cli'),
          throwsA(isA<PackageInfoNotFoundFailure>()),
        );
      });
    });

    group('update', () {
      test('makes correct call to process.run', () async {
        await pubUpdater.update(
          packageName: 'very_good_cli',
          processManager: processManager,
        );
        verify(() => processManager.run(command)).called(1);
      });

      test('makes correct call to process.run with version constraint',
          () async {
        await pubUpdater.update(
          packageName: 'very_good_cli',
          processManager: processManager,
          versionConstraint: '>=0.4.0',
        );
        verify(() => processManager.run(commandWithConstraint)).called(1);
      });
    });
  });
}
