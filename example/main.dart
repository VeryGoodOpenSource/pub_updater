import 'package:pub_update/pub_update.dart';

Future<void> main() async {
  // Initialize an instance of PubUpdate.
  final pubUpdate = PubUpdate();

  // Check whether a package is up to date.
  final upToDate = await pubUpdate.isUpToDate(
      packageName: 'myPackage', currentVersion: '0.1.0');

  if (!upToDate) {
    // Upgrade to the latest version if not up to date.
    await pubUpdate.update(packageName: 'myPackage');
  }
}
