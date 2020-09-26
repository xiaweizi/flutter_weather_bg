# flutter_weather_bg

[![Pub Version](https://img.shields.io/pub/v/flutter_weather_bg?style=plastic)](https://pub.flutter-io.cn/packages/flutter_weather_bg)

A rich and cool weather dynamic background plug-in, supporting 15 weather types. [README_ZH](https://github.com/xiaweizi/flutter_weather_bg/blob/master/README_ZH.md)

> Use this plug-in to complete the weather background animation effect in your own project [SimplicityWeather](https://github.com/xiaweizi/SimplicityWeather).

## Features 

- It supports 15 weather types: sunny, sunny evening, cloudy, cloudy evening, overcast, small to medium heavy rain, small to medium heavy snow, fog, haze, floating dust and thunderstorm
- Support dynamic scale size, adapt to multi scene display
- Supports over animation when switching weather types

## Supported platforms 

- Flutter Android
- Flutter iOS
- Flutter web
- Flutter desktop

## Installation

Add  `flutter_weather_bg: ^2.8.0` to your `pubspec.yaml` dependencies. And import it:

```dar
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
```

## How to use 

To configure the weather type by creating `WeatherBg`, you need to pass in the width and height to complete the final display

```dart
WeatherBg(weatherType: _weatherType,width: _width,height: _height,)
```

## Preview

Regular `pageview` display effect

![home](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/92cbc9dbbd19419793ffec0e9f04457b~tplv-k3u1fbpfcp-zoom-1.image)



List `listview` display effect

![list](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e6076f6ca3af4d3a8778313006ab9663~tplv-k3u1fbpfcp-zoom-1.image)



The grid` GridView`displays the effect and supports the dynamic switching of the grid number

![check](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5c4e75165cbb4a87b8176baa636c432d~tplv-k3u1fbpfcp-zoom-1.image)


Dynamic reduction example demonstration

![width_height](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c8a4002423db4b77b0d2374f6da1c055~tplv-k3u1fbpfcp-zoom-1.image)



Toggle weather type transition animation

![check](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5c4e75165cbb4a87b8176baa636c432d~tplv-k3u1fbpfcp-zoom-1.image)



## License 

MIT