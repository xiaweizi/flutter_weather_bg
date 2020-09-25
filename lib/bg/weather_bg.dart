import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_cloud_bg.dart';
import 'package:flutter_weather_bg/bg/weather_color_bg.dart';
import 'package:flutter_weather_bg/bg/weather_night_star_bg.dart';
import 'package:flutter_weather_bg/bg/weather_rain_snow_bg.dart';
import 'package:flutter_weather_bg/bg/weather_thunder_bg.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

// 全局的高度
double globalHeight = 0.0;
// 全局的宽度
double globalWidth = 0.0;
// 根据宽高比，控制图片的缩放比例
double globalWidthRatio = 0.0;

/// 最核心的类，集合背景&雷&雨雪&晴晚&流星效果
/// 1. 支持动态切换大小
/// 2. 支持渐变过度
class WeatherBg extends StatefulWidget {
  final WeatherType weatherType;

  WeatherBg(
      {Key key,
      this.weatherType,
      @required double width,
      @required double height})
      : super(key: key) {
    globalWidth = width;
    globalHeight = height;
    globalWidthRatio = globalWidth / 392.0;
  }

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
    weatherPrint(
        "width: $globalWidth, height: $globalHeight, globalWidthRatio: $globalWidthRatio");
    var oldBgWidget;
    if (_oldWeatherType != null) {
      oldBgWidget = WeatherItemBg(
        weatherType: _oldWeatherType,
      );
    }
    var currentBgWidget = WeatherItemBg(
      weatherType: widget.weatherType,
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
    return AnimatedCrossFade(
      firstChild: firstWidget,
      secondChild: secondWidget,
      duration: Duration(milliseconds: 300),
      crossFadeState: state,
    );
  }
}

class WeatherItemBg extends StatelessWidget {
  final WeatherType weatherType;

  WeatherItemBg({Key key, this.weatherType}) : super(key: key);

  /// 构建晴晚背景效果
  Widget _buildNightStarBg() {
    if (weatherType == WeatherType.sunnyNight) {
      return WeatherNightStarBg(
        weatherType: weatherType,
      );
    }
    return Container();
  }

  /// 构建雷暴效果
  Widget _buildThunderBg() {
    if (weatherType == WeatherType.thunder) {
      return WeatherThunderBg(
        weatherType: weatherType,
      );
    }
    return Container();
  }

  /// 构建雨雪背景效果
  Widget _buildRainSnowBg() {
    if (WeatherUtil.isSnowRain(weatherType)) {
      return WeatherRainSnowBg(
        weatherType: weatherType,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: globalWidth,
      height: globalHeight,
      child: ClipRect(
        child: Stack(
          children: [
            WeatherColorBg(weatherType: weatherType),
            WeatherCloudBg(
              weatherType: weatherType,
            ),
            _buildRainSnowBg(),
            _buildThunderBg(),
            _buildNightStarBg(),
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
