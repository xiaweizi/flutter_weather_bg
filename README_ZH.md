# flutter_weather_bg

![Pub Version](https://img.shields.io/pub/v/flutter_weather_bg?style=plastic)

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

常规的 `PageView` 展示效果

![image1](/ScreenShot/image1.gif)



列表 `ListView` 展示效果

![image2](/ScreenShot/image2.gif)



宫格 `GridView` 展示效果，并支持动态切换宫格列数

![image3](/ScreenShot/image3.gif)



动态缩小例子师范

![image4](/ScreenShot/image4.gif)



切换天气类型过度动画

![image5](/ScreenShot/image5.gif)



## License 

MIT