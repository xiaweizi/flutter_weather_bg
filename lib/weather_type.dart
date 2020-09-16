import 'package:flutter/cupertino.dart';

enum WeatherType {
  sunny,
  cloudy,
  overcast,
  lightRainy,
  middleRainy,
  heavyRainy,
  thunder,
  hazy, // 霾
  foggy, // 雾
  lightSnow,
  middleSnow,
  heavySnow,
  dusty, // 浮尘
  sunnyNight,
  cloudyNight,
}

class WeatherUtil {

  static bool isSnowRain(WeatherType weatherType) {
    return isRainy(weatherType) || isSnow(weatherType);
  }

  static bool isRainy(WeatherType weatherType) {
    return weatherType == WeatherType.lightRainy ||
        weatherType == WeatherType.middleRainy ||
        weatherType == WeatherType.heavyRainy ||
        weatherType == WeatherType.thunder;
  }

  static bool isSnow(WeatherType weatherType) {
    return weatherType == WeatherType.lightSnow ||
        weatherType == WeatherType.middleSnow ||
        weatherType == WeatherType.heavySnow;
  }

  static List<Color> getColor(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.sunny:
        return [Color(0xFF0071D1), Color(0xFF6DA6E4)];
      case WeatherType.sunnyNight:
        return [Color(0xFF061E74), Color(0xFF275E9A)];
      case WeatherType.cloudy:
        return [Color(0xFF5C82C1), Color(0xFF95B1DB)];
      case WeatherType.cloudyNight:
        return [Color(0xFF2C3A60), Color(0xFF4B6685)];
      case WeatherType.overcast:
        return [Color(0xFF8FA3C0), Color(0xFF8C9FB1)];
      case WeatherType.lightRainy:
        return [Color(0xFF556782), Color(0xFF7c8b99)];
      case WeatherType.middleRainy:
        return [Color(0xFF3A4B65), Color(0xFF495764)];
      case WeatherType.heavyRainy:
      case WeatherType.thunder:
        return [Color(0xFF3B434E), Color(0xFF565D66)];
      case WeatherType.hazy:
        return [Color(0xFF989898), Color(0xFF4B4B4B)];
      case WeatherType.foggy:
        return [Color(0xFFA6B3C2), Color(0xFF737F88)];
      case WeatherType.lightSnow:
        return [Color(0xFF6989BA), Color(0xFF9DB0CE)];
      case WeatherType.middleSnow:
        return [Color(0xFF8595AD), Color(0xFF95A4BF)];
      case WeatherType.heavySnow:
        return [Color(0xFF98A2BC), Color(0xFFA7ADBF)];
      case WeatherType.dusty:
        return [Color(0xFFB99D79), Color(0xFF6C5635)];
      default:
        return [Color(0xFF0071D1), Color(0xFF6DA6E4)];
    }
  }

}