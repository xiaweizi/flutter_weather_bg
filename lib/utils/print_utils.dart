import 'package:flutter/widgets.dart';

/// 定义打印函数
typedef WeatherPrint = void Function(String message,
    {int wrapWidth, String tag});

const DEBUG = true;

WeatherPrint weatherPrint = debugPrintThrottled;

// 统一方法进行打印
void debugPrintThrottled(String message, {int wrapWidth, String tag}) {
  if (DEBUG) {
    debugPrint("flutter-weather: $tag: $message", wrapWidth: wrapWidth);
  }
}
