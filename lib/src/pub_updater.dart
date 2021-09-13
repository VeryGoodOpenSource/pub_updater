import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:process/process.dart';
import 'package:pub_updater/pub_updater.dart';

/// Exception thrown when the HTTP request fails.
class PackageInfoRequestFailure implements Exception {}

/// Exception thrown when the provided package information is not found.
class PackageInfoNotFoundFailue implements Exception {}

/// {@template pub_update}
/// A Dart package which enables checking whether a package is up to date.
/// {@endtemplate}
class PubUpdater {
  /// {@macro pub_update}
  PubUpdater([http.Client? client]) : _client = client;

  /// The pub.dev base url for querying package versions
  static const _baseUrl = 'https://pub.dev/packages/';
  final http.Client? _client;

  Future<http.Response> _get(Uri uri) => _client?.get(uri) ?? http.get(uri);

  /// Checks whether or not [currentVersion] is the latest version
  /// for the package associated with [packageName]
  Future<bool> isUpToDate({
    required String packageName,
    required String currentVersion,
  }) async {
    final uri = Uri.parse('$_baseUrl$packageName.json');
    final response = await _get(uri);

    if (response.statusCode != HttpStatus.ok) throw PackageInfoRequestFailure();

    final packageInfo = _getPackageInfo(response.body);

    final versionList = packageInfo.versions..sort();

    return versionList.last == currentVersion;
  }

  /// Updates the package associated with [packageName]
  Future<ProcessResult> update({
    required String packageName,
    ProcessManager processManager = const LocalProcessManager(),
  }) {
    return processManager
        .run(['dart', 'pub', 'global', 'activate', packageName]);
  }

  PackageInfo _getPackageInfo(String body) {
    final packageJson = jsonDecode(body) as Map<String, dynamic>;

    if (packageJson.isEmpty) {
      throw PackageInfoNotFoundFailue();
    }

    return PackageInfo.fromJson(packageJson);
  }
}
