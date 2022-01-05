# Pub Updater

[![Very Good Ventures][logo_white]][very_good_ventures_link_dark]
[![Very Good Ventures][logo_black]][very_good_ventures_link_light]

Developed with 💙 by [Very Good Ventures][very_good_ventures_link] 🦄

[![Pub][pub_badge]][pub_link]
[![build][ci_badge]][ci_link]
[![coverage][coverage_badge]][ci_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

---

A Dart package which enables checking whether packages are up to date and supports updating them.

Intended for use in CLIs for prompting users to auto-update.

## Usage

```dart
import 'package:pub_updater/pub_updater.dart';

void main() async {
  // Create an instance of PubUpdater
  final pubUpdater = PubUpdater();

  // Check whether or not version 0.1.0 is the latest version of my_package
  final isUpToDate = await pubUpdater.isUpToDate(
    packageName: 'my_package',
    currentVersion: '0.1.0',
  );

  // Trigger an upgrade to the latest version if my_package is not up to date
  if (!isUpToDate) {
    await pubUpdater.update(packageName: 'my_package');
  }

  // You can also query the latest version available for a specific package.
  final latestVersion = await pubUpdater.getLatestVersion('my_package');
}
```

[ci_badge]: https://github.com/VeryGoodOpenSource/pub_updater/actions/workflows/pub_updater.yaml/badge.svg?branch=main
[ci_link]: https://github.com/VeryGoodOpenSource/pub_updater/actions/workflows
[coverage_badge]: https://raw.githubusercontent.com/VeryGoodOpenSource/pub_updater/main/coverage_badge.svg
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[pub_badge]: https://img.shields.io/pub/v/pub_updater.svg
[pub_link]: https://pub.dev/packages/pub_updater
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
