import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:process/process.dart';
import 'package:pub_updater/src/models/models.dart';

/// Exception thrown when the HTTP request fails.
class PackageInfoRequestFailure implements Exception {}

/// Exception thrown when the provided package information is not found.
class PackageInfoNotFoundFailure implements Exception {}

/// The pub.dev base url for querying package versions
const _defaultBaseUrl = 'https://pub.dev/api/packages/';

/// {@template pub_update}
/// A Dart package which enables checking whether a package is up to date.
/// {@endtemplate}
class PubUpdater {
  /// {@macro pub_update}
  PubUpdater([http.Client? client, String baseUrl = _defaultBaseUrl])
      : _client = client,
        _baseUrl = baseUrl;

  final http.Client? _client;
  final String _baseUrl;

  Future<http.Response> _get(Uri uri) => _client?.get(uri) ?? http.get(uri);

  /// Checks whether or not [currentVersion] is the latest version
  /// for the package associated with [packageName]
  Future<bool> isUpToDate({
    required String packageName,
    required String currentVersion,
  }) async {
    final latestVersion = await getLatestVersion(packageName);

    return currentVersion == latestVersion;
  }

  /// Returns the latest published version of [packageName].
  Future<String> getLatestVersion(String packageName) async {
    final packageInfo = await _getPackageInfo(packageName);
    return packageInfo.latest;
  }

  /// Updates the package associated with [packageName]
  Future<ProcessResult> update({
    required String packageName,
    ProcessManager processManager = const LocalProcessManager(),
    String? versionConstraint,
  }) {
    return processManager.run(
      [
        'dart',
        'pub',
        'global',
        'activate',
        packageName,
        if (versionConstraint != null) versionConstraint,
      ],
    );
  }

  Future<PackageInfo> _getPackageInfo(String packageName) async {
    final uri = Uri.parse('$_baseUrl$packageName');
    final response = await _get(uri);

    if (response.statusCode != HttpStatus.ok) throw PackageInfoRequestFailure();

    return _decodePackageInfo(response.body);
  }

  PackageInfo _decodePackageInfo(String body) {
    final packageJson = jsonDecode(body) as Map<String, dynamic>;

    if (packageJson.isEmpty) throw PackageInfoNotFoundFailure();

    return PackageInfo.fromJson(packageJson);
  }
}
