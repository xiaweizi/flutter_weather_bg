import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_cloud_bg.dart';
import 'package:flutter_weather_bg/bg/weather_color_bg.dart';
import 'package:flutter_weather_bg/bg/weather_night_star_bg.dart';
import 'package:flutter_weather_bg/bg/weather_rain_snow_bg.dart';
import 'package:flutter_weather_bg/bg/weather_thunder_bg.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

double globalHeight = 0.0;
double globalWidth = 0.0;
double globalWidthRatio = 0.0;

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
  double _value = 1;
  AnimationController _controller;

  @override
  void didUpdateWidget(WeatherBg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weatherType != oldWidget.weatherType) {
      _oldWeatherType = oldWidget.weatherType;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.addListener(() {
      setState(() {
        _value = _controller.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    weatherPrint("xiaweizi::old: $_oldWeatherType, new: ${widget.weatherType}");
    weatherPrint(
        "width: $globalWidth, height: $globalHeight, globalWidthRatio: $globalWidthRatio");
    if (_oldWeatherType != null && _oldWeatherType != widget.weatherType) {
      List<Widget> widgets = [];
        widgets.add(Opacity(
          opacity: 1 - _value,
          child: WeatherItemBg(
            weatherType: _oldWeatherType,
          ),
        ));
        widgets.add(Opacity(
          opacity: _value,
          child: WeatherItemBg(
            weatherType: widget.weatherType,
          ),
        ));
      return Container(
        width: globalWidth,
        height: globalHeight,
        child: Stack(
          children: widgets,
        ),
      );
    } else {
      return WeatherItemBg(
        weatherType: widget.weatherType,
      );
    }
  }
}

class WeatherItemBg extends StatelessWidget {
  final WeatherType weatherType;

  WeatherItemBg({Key key, this.weatherType}) : super(key: key);

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
            WeatherRainSnowBg(
              weatherType: weatherType,
            ),
            WeatherThunderBg(
              weatherType: weatherType,
            ),
            WeatherNightStarBg(
              weatherType: weatherType,
            ),
          ],
        ),
      ),
    );
  }
}
