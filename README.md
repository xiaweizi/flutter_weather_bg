# flutter_weather_bg

![Pub Version](https://img.shields.io/pub/v/flutter_weather_bg?style=plastic)

A rich and cool weather dynamic background plug-in, supporting 15 weather types. [README_ZH](/README_ZH.md)

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

Add  `flutter_weather_bg: ^2.6.0` to your `pubspec.yaml` dependencies. And import it:

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

![image1](/ScreenShot/image1.gif)



List `listview` display effect

![image2](/ScreenShot/image2.gif)



The grid` GridView`displays the effect and supports the dynamic switching of the grid number

![image3](/ScreenShot/image3.gif)



Dynamic reduction example demonstration

![image4](/ScreenShot/image4.gif)



Toggle weather type transition animation

![image5](/ScreenShot/image5.gif)



## License 

MIT