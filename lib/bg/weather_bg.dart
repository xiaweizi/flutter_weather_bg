import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_cloud_bg.dart';
import 'package:flutter_weather_bg/bg/weather_color_bg.dart';
import 'package:flutter_weather_bg/bg/weather_rain_snow_bg.dart';
import 'package:flutter_weather_bg/bg/weather_thunder_bg.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

/// 最核心的类，集合背景&雷&雨雪&晴晚&流星效果
/// 1. 支持动态切换大小
/// 2. 支持渐变过度
class WeatherBg extends StatefulWidget {
  final WeatherType weatherType;
  final double width;
  final double height;
  final Widget background;

  WeatherBg({
    Key key,
    this.weatherType,
    @required this.width,
    @required this.height,
    this.background,
  }) : super(key: key);

  @override
  _WeatherBgState createState() => _WeatherBgState();
}

class _WeatherBgState extends State<WeatherBg>
    with SingleTickerProviderStateMixin {
  WeatherType _oldWeatherType;
  bool needChange = false;
  var state = CrossFadeState.showSecond;

  @override
  void didUpdateWidget(WeatherBg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weatherType != oldWidget.weatherType) {
      // 如果类别发生改变，需要 start 渐变动画
      _oldWeatherType = oldWidget.weatherType;
      needChange = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var oldBgWidget;
    if (_oldWeatherType != null) {
      oldBgWidget = WeatherItemBg(
        weatherType: _oldWeatherType,
        width: widget.width,
        height: widget.height,
        background: widget.background,
      );
    }
    var currentBgWidget = WeatherItemBg(
      weatherType: widget.weatherType,
      width: widget.width,
      height: widget.height,
      background: widget.background,
    );
    if (oldBgWidget == null) {
      oldBgWidget = currentBgWidget;
    }
    var firstWidget = currentBgWidget;
    var secondWidget = currentBgWidget;
    if (needChange) {
      if (state == CrossFadeState.showSecond) {
        state = CrossFadeState.showFirst;
        firstWidget = currentBgWidget;
        secondWidget = oldBgWidget;
      } else {
        state = CrossFadeState.showSecond;
        secondWidget = currentBgWidget;
        firstWidget = oldBgWidget;
      }
    }
    needChange = false;
    return SizeInherited(
      child: AnimatedCrossFade(
        firstChild: firstWidget,
        secondChild: secondWidget,
        duration: Duration(milliseconds: 300),
        crossFadeState: state,
      ),
      size: Size(widget.width, widget.height),
    );
  }
}

class WeatherItemBg extends StatelessWidget {
  final WeatherType weatherType;
  final width;
  final height;
  final Widget background;

  WeatherItemBg({
    Key key,
    this.weatherType,
    this.width,
    this.height,
    this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ClipRect(
        child: Stack(
          children: [
            background ?? WeatherColorBg(weatherType: weatherType),
            WeatherCloudBg(weatherType: weatherType),
            if (WeatherUtil.isSnowRain(weatherType))
              WeatherRainSnowBg(
                weatherType: weatherType,
                viewWidth: width,
                viewHeight: height,
              ),
            if (weatherType == WeatherType.thunder)
              WeatherThunderBg(weatherType: weatherType),
            // 构建晴晚背景效果
            // if (weatherType == WeatherType.sunnyNight)
            //   WeatherNightStarBg(weatherType: weatherType),
          ],
        ),
      ),
    );
  }
}

class SizeInherited extends InheritedWidget {
  final Size size;

  const SizeInherited({
    Key key,
    @required Widget child,
    @required this.size,
  })  : assert(child != null),
        super(key: key, child: child);

  static SizeInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SizeInherited>();
  }

  @override
  bool updateShouldNotify(SizeInherited old) {
    return old.size != size;
  }
}
