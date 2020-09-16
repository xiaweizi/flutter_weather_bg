
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWeatherBg {
  static const MethodChannel _channel =
      const MethodChannel('flutter_weather_bg');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
