import 'dart:developer';

import 'package:pub_updater/pub_updater.dart';

Future<void> main() async {
  const packageName = 'my_package';
  const currentVersion = '0.1.0';

  // Initialize an instance of PubUpdater.
  final pubUpdater = PubUpdater();

  // Check whether a package is up to date.
  final isUpToDate = await pubUpdater.isUpToDate(
    packageName: packageName,
    currentVersion: currentVersion,
  );

  if (!isUpToDate) {
    // Upgrade to the latest version if not up to date.
    await pubUpdater.update(packageName: packageName);
  }

  // You can also query the latest version available for a specific package.
  final latestVersion = await pubUpdater.getLatestVersion(packageName);
  log(latestVersion);
}
