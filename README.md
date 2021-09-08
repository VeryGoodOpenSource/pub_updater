# pub_update

[![Pub](https://img.shields.io/badge/pub__update-v0.1.0-orange)](https://pub.dev/packages/pub_update)
[![build](https://github.com/VeryGoodOpenSource/pub_update/actions/workflows/pub_update.yaml/badge.svg?branch=main)](https://github.com/VeryGoodOpenSource/pub_update/actions/workflows)
[![License: MIT][license_badge]][license_link]

---

A Dart package which enables checking whether packages are up to date and updating them.

Intended for use in CLIs for prompting users to auto-update.

## Usage

```dart
import 'package:pub_update/pub_update.dart';

void main() async {
    // Create an instance of PubUpdate
    final pubUpdate = PubUpdate();

    // Check whether or not version 0.1.0 is the latest version of myPackage
    final upToDate = pubUpdate.isUpToDate(packageName: 'myPackage', currentVersion: '0.1.0'); 
    
    // Trigger an upgrade to the latest version if myPackage is not up to date
    if (!upToDate) {
        pubUpdate.update(packageName: 'myPackage');
    }
}
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis