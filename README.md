# Custom Widgets

A collection of reusable Flutter UI widgets designed to help developers build clean, consistent, and scalable user interfaces faster.

---

## ✨ Features

- Reusable and customizable Flutter widgets
- Clean and simple API
- Easy to integrate into any Flutter project
- Production-ready components

---

## 🚀 Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  nbp_custom_widgets: ^0.0.1
```

Then run:

```bash
flutter pub get
```

Import the package:

```dart
import 'package:nbp_custom_widgets/nbp_custom_widgets.dart';
```

---

## 📦 Dependencies

This package internally uses the following Flutter packages:

- `url_launcher`
- `chewie`
- `video_player`
- `visibility_detector`

Please refer to their respective documentation for advanced or platform-specific configuration.

---

## ⚙️ Platform Setup

This package uses `video_player` and `chewie`, which require platform setup in the host application.

### Android

Ensure your `minSdkVersion` is **21 or higher**:

```gradle
defaultConfig {
    minSdkVersion 21
}
```

---

### iOS

For playing remote video URLs, add the following to your `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

---

## 📄 License

This project is licensed under the **MIT License**.

---

## 🔖 Third-party Licenses

This package depends on open-source packages licensed under their respective licenses.
