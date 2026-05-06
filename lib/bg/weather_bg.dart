import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_cloud_bg.dart';
import 'package:flutter_weather_bg/bg/weather_color_bg.dart';
import 'package:flutter_weather_bg/bg/weather_night_star_bg.dart';
import 'package:flutter_weather_bg/bg/weather_rain_snow_bg.dart';
import 'package:flutter_weather_bg/bg/weather_thunder_bg.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

/// 最核心的入口 widget —— 组合背景 / 云 / 雷 / 雨雪 / 晴晚星空五层画面。
///
/// - 通过 [weatherType] 切换场景；两次切换之间会有 300ms 淡入淡出过渡。
/// - 通过 [width] / [height] 指定画布尺寸；尺寸变化会重新触发粒子系统初始化。
class WeatherBg extends StatelessWidget {
  final WeatherType weatherType;
  final double width;
  final double height;

  const WeatherBg({
    super.key,
    required this.weatherType,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizeInherited(
      size: Size(width, height),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: WeatherItemBg(
          // 让 AnimatedSwitcher 在类型变化时认为是不同 child
          key: ValueKey(weatherType),
          weatherType: weatherType,
          width: width,
          height: height,
        ),
      ),
    );
  }
}

/// 单个天气场景，由多层 widget 叠加组成：颜色背景 + 云 + 雨雪 + 雷 + 晴晚。
///
/// 这个类是内部实现（通过 `hide` 从 barrel 导出中排除）。
class WeatherItemBg extends StatelessWidget {
  final WeatherType weatherType;
  final double width;
  final double height;

  const WeatherItemBg({
    super.key,
    required this.weatherType,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: Stack(
          children: [
            WeatherColorBg(weatherType: weatherType),
            WeatherCloudBg(weatherType: weatherType),
            if (WeatherUtil.isSnowRain(weatherType))
              WeatherRainSnowBg(
                weatherType: weatherType,
                viewWidth: width,
                viewHeight: height,
              ),
            if (weatherType == WeatherType.thunder)
              WeatherThunderBg(weatherType: weatherType),
            if (weatherType == WeatherType.sunnyNight)
              WeatherNightStarBg(weatherType: weatherType),
          ],
        ),
      ),
    );
  }
}

/// 用 InheritedWidget 把画布尺寸传给下面的绘制层（云 / 雨雪 / 雷 / 星空）。
class SizeInherited extends InheritedWidget {
  final Size size;

  const SizeInherited({
    super.key,
    required super.child,
    required this.size,
  });

  static SizeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SizeInherited>();
  }

  @override
  bool updateShouldNotify(SizeInherited old) => old.size != size;
}
