import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

void main() {
  test('WeatherType enum exposes all 15 types', () {
    expect(WeatherType.values.length, 15);
  });

  test('WeatherUtil.getWeatherDesc returns 晴 for sunny', () {
    expect(WeatherUtil.getWeatherDesc(WeatherType.sunny), '晴');
  });
}
