import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_cloud_bg.dart';
import 'package:flutter_weather_bg/bg/weather_color_bg.dart';
import 'package:flutter_weather_bg/bg/weather_night_star_bg.dart';
import 'package:flutter_weather_bg/bg/weather_rain_snow_bg.dart';
import 'package:flutter_weather_bg/bg/weather_thunder_bg.dart';
import 'package:flutter_weather_bg/weather_type.dart';

class WeatherBg extends StatefulWidget {
  final WeatherType weatherType;
  static double sHeight;
  static double sWidth;

  WeatherBg({Key key, this.weatherType, var height, var width})
      : super(key: key) {
    sHeight = height;
    sWidth = width;
  }

  @override
  _WeatherBgState createState() => _WeatherBgState();
}

class _WeatherBgState extends State<WeatherBg> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          WeatherColorBg(weatherType: widget.weatherType),
          WeatherCloudBg(
            weatherType: widget.weatherType,
          ),
          WeatherRainSnowBg(
            weatherType: widget.weatherType,
          ),
          WeatherThunderBg(
            weatherType: widget.weatherType,
          ),
          WeatherNightStarBg(
            weatherType: widget.weatherType,
          ),
        ],
      ),
    );
  }
}
