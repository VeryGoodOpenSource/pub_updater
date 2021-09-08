# pub_updater

[![Pub](https://img.shields.io/pub/v/pub_updater.svg)](https://pub.dev/packages/pub_updater)
[![build](https://github.com/VeryGoodOpenSource/pub_updater/actions/workflows/pub_updater.yaml/badge.svg?branch=main)](https://github.com/VeryGoodOpenSource/pub_updater/actions/workflows)
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

    // Check whether or not version 0.1.0 is the latest version of myPackage
    final isUpToDate = pubUpdater.isUpToDate(packageName: 'myPackage', currentVersion: '0.1.0'); 
    
    // Trigger an upgrade to the latest version if myPackage is not up to date
    if (!isUpToDate) {
        pubUpdater.update(packageName: 'myPackage');
    }
}
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
