# flutter_weather_bg

[![Pub Version](https://img.shields.io/pub/v/flutter_weather_bg?style=plastic)](https://pub.dev/packages/flutter_weather_bg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=plastic)](https://github.com/xiaweizi/flutter_weather_bg/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS-blue.svg?style=plastic)](https://github.com/xiaweizi/flutter_weather_bg)

A rich and cool weather dynamic background plug-in, supporting 15 weather types.

[中文文档](https://github.com/xiaweizi/flutter_weather_bg/blob/main/README_ZH.md)

**Used by [SimplicityWeather](https://github.com/xiaweizi/SimplicityWeather) to render weather backgrounds. If you want to try the app directly, [download the APK here](http://xiaweizi.top/SimplicityWeather-2_6.apk).**

## Features

- 15 weather types: sunny, sunny night, cloudy, cloudy night, overcast, light/middle/heavy rain, light/middle/heavy snow, foggy, hazy, dusty and thunder
- Dynamic width/height — the scene adapts automatically
- Smooth cross-fade transition when the weather type changes
- Pure Dart implementation (no native code); renders with `CustomPainter` on Flutter canvas

## Supported platforms

| Platform | Status |
| -------- | ------ |
| Android  | ✅ |
| iOS      | ✅ |
| Web      | ✅ |
| macOS    | ✅ |
| Windows  | Not tested |
| Linux    | Not tested |

## Requirements

- Flutter `>= 3.0.0`
- Dart SDK `>= 3.0.0 < 4.0.0` (null-safety)

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_weather_bg: ^3.0.0
```

Then run:

```bash
flutter pub get
```

And import it wherever you need:

```dart
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
```

## Usage

Drop a `WeatherBg` into your widget tree, and pass the desired `weatherType` together with a width and a height:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

class WeatherDemo extends StatelessWidget {
  const WeatherDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WeatherBg(
        weatherType: WeatherType.thunder,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
```

Switching `weatherType` at runtime will automatically trigger a cross-fade animation.

A full demo (covering `PageView`, `ListView`, `GridView`, size animation and type switching) lives in [`example/`](./example).

## Preview

Regular `PageView` effect

![home](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/92cbc9dbbd19419793ffec0e9f04457b~tplv-k3u1fbpfcp-zoom-1.image)

`ListView` effect

![list](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e6076f6ca3af4d3a8778313006ab9663~tplv-k3u1fbpfcp-zoom-1.image)

`GridView` effect with a dynamically-switchable column count

![grid](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d2e396e151764a7e8f86e798282833b9~tplv-k3u1fbpfcp-zoom-1.image)

Dynamic size demonstration

![width_height](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c8a4002423db4b77b0d2374f6da1c055~tplv-k3u1fbpfcp-zoom-1.image)

Weather type cross-fade transition

![transition](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5c4e75165cbb4a87b8176baa636c432d~tplv-k3u1fbpfcp-zoom-1.image)

## Contributing

Issues and pull requests are welcome — feel free to open one on the
[issue tracker](https://github.com/xiaweizi/flutter_weather_bg/issues).

If you want to run the example locally:

```bash
git clone https://github.com/xiaweizi/flutter_weather_bg.git
cd flutter_weather_bg/example
flutter pub get
flutter run              # or: flutter run -d chrome
```

## License

Released under the [MIT License](./LICENSE). Copyright © 2020-2026 xiaweizi.
