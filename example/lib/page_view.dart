import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg/weather_type.dart';

class PageViewWidget extends StatefulWidget {
  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {

  WeatherType _weatherType = WeatherType.sunny;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_weatherType"),
      ),
      body: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            _weatherType = WeatherType.values[index];
          });
        },
        itemBuilder: (BuildContext context, int index) {
          weatherPrint("pageView: ${MediaQuery.of(context).size}");
          return WeatherBg(
            weatherType: WeatherType.values[index],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          );
        },
        itemCount: WeatherType.values.length,
      ),
    );
  }
}
