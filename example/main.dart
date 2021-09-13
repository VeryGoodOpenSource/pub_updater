import 'package:pub_updater/pub_updater.dart';

Future<void> main() async {
  // Initialize an instance of PubUpdater.
  final pubUpdater = PubUpdater();

  // Check whether a package is up to date.
  final isUpToDate = await pubUpdater.isUpToDate(
    packageName: 'my_package',
    currentVersion: '0.1.0',
  );

  if (!isUpToDate) {
    // Upgrade to the latest version if not up to date.
    await pubUpdater.update(packageName: 'my_package');
  }
}
