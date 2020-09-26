# flutter_weather_bg

[![Pub Version](https://img.shields.io/pub/v/flutter_weather_bg?style=plastic)](https://pub.flutter-io.cn/packages/flutter_weather_bg)

一款丰富炫酷的天气动态背景插件，支持 **15** 种天气类型。

> 在自己做的项目 [简悦天气](https://github.com/xiaweizi/SimplicityWeather) 中使用此插件完成天气背景动画效果。

## 功能

- 支持 **15** 种 天气类型：晴、晴晚、多云、多云晚、阴、小中大雨、小中大雪、雾、霾、浮尘和雷暴
- 支持 动态缩放尺寸，适配多场景下展示
- 支持 切换天气类型时过度动画

## 支持的平台

- Flutter Android
- Flutter iOS
- Flutter web
- Flutter desktop

## 安装

添加 `flutter_weather_bg: ^2.7.0` 到 `pubspec.yaml` 文件中，并且导包：

```dar
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
```

## 使用

通过创建 `WeatherBg` 配置天气类型，需要传入宽高来完成最终展示

```dart
WeatherBg(weatherType: _weatherType,width: _width,height: _height,)
```

## 截图效果

全屏沉浸式翻页效果

![home](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/92cbc9dbbd19419793ffec0e9f04457b~tplv-k3u1fbpfcp-zoom-1.image)



城市管理列表效果

![list](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e6076f6ca3af4d3a8778313006ab9663~tplv-k3u1fbpfcp-zoom-1.image)



多样的宫格效果

![list](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d2e396e151764a7e8f86e798282833b9~tplv-k3u1fbpfcp-zoom-1.image)



切换天气类型时的过度动画效果

![check](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5c4e75165cbb4a87b8176baa636c432d~tplv-k3u1fbpfcp-zoom-1.image)



修改宽高的适配效果

![width_height](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c8a4002423db4b77b0d2374f6da1c055~tplv-k3u1fbpfcp-zoom-1.image)

## License 

MIT