# flutter_weather_bg

[![Pub Version](https://img.shields.io/pub/v/flutter_weather_bg?style=plastic)](https://pub.dev/packages/flutter_weather_bg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=plastic)](https://github.com/xiaweizi/flutter_weather_bg/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS-blue.svg?style=plastic)](https://github.com/xiaweizi/flutter_weather_bg)

一款丰富炫酷的天气动态背景插件，支持 **15** 种天气类型。

[English README](https://github.com/xiaweizi/flutter_weather_bg/blob/main/README.md)

**在自己做的项目 [简悦天气](https://github.com/xiaweizi/SimplicityWeather) 中使用此插件完成天气背景动画效果；如果想直接体验请点击 [下载链接](http://xiaweizi.top/SimplicityWeather-2_6.apk) 下载 APK。**

## 功能

- 支持 **15** 种天气类型：晴、晴晚、多云、多云晚、阴、小/中/大雨、小/中/大雪、雾、霾、浮尘、雷暴
- 支持动态缩放尺寸，多场景下自适应展示
- 切换天气类型时自带淡入淡出过渡动画
- 纯 Dart 实现，无任何原生代码依赖，基于 `CustomPainter` 绘制

## 支持平台

| 平台    | 状态 |
| ------- | ---- |
| Android | ✅ |
| iOS     | ✅ |
| Web     | ✅ |
| macOS   | ✅ |
| Windows | 未验证 |
| Linux   | 未验证 |

## 运行要求

- Flutter `>= 3.0.0`
- Dart SDK `>= 3.0.0 < 4.0.0`（空安全）

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  flutter_weather_bg: ^2.9.0
```

然后执行：

```bash
flutter pub get
```

在需要使用的地方导入：

```dart
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
```

## 使用

在 Widget 树中放入 `WeatherBg`，传入 `weatherType`、`width`、`height` 即可：

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

运行时修改 `weatherType` 会自动触发淡入淡出过渡动画。

完整示例（包含 `PageView`、`ListView`、`GridView`、尺寸动画、类型切换）参考 [`example/`](./example) 目录。

## 截图效果

全屏沉浸式翻页效果

![home](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/92cbc9dbbd19419793ffec0e9f04457b~tplv-k3u1fbpfcp-zoom-1.image)

城市管理列表效果

![list](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e6076f6ca3af4d3a8778313006ab9663~tplv-k3u1fbpfcp-zoom-1.image)

多样的宫格效果

![grid](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d2e396e151764a7e8f86e798282833b9~tplv-k3u1fbpfcp-zoom-1.image)

修改宽高的适配效果

![width_height](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c8a4002423db4b77b0d2374f6da1c055~tplv-k3u1fbpfcp-zoom-1.image)

切换天气类型时的过渡动画效果

![transition](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5c4e75165cbb4a87b8176baa636c432d~tplv-k3u1fbpfcp-zoom-1.image)

## 参与贡献

欢迎提交 Issue 或 PR，可前往 [issue tracker](https://github.com/xiaweizi/flutter_weather_bg/issues) 反馈问题。

本地运行示例：

```bash
git clone https://github.com/xiaweizi/flutter_weather_bg.git
cd flutter_weather_bg/example
flutter pub get
flutter run              # 或 flutter run -d chrome
```

## 开源协议

基于 [MIT License](./LICENSE) 开源。Copyright © 2020-2026 xiaweizi。
