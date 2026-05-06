import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

/// 主要提供两个实例
/// 1. 切换天气类型时，会有过度动画
/// 2. 动态改变宽高，绘制的相关逻辑同步发生改变
class AnimViewWidget extends StatefulWidget {
  const AnimViewWidget({super.key});

  @override
  State<AnimViewWidget> createState() => _AnimViewWidgetState();
}

class _AnimViewWidgetState extends State<AnimViewWidget> {
  WeatherType _weatherType = WeatherType.sunny;
  double _width = 100;
  double _height = 200;

  @override
  Widget build(BuildContext context) {
    final radius = 5 + (_width - 100) / 200 * 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text("AnimView"),
        actions: [
          PopupMenuButton<WeatherType>(
            itemBuilder: (context) {
              return WeatherType.values
                  .map(
                    (e) => PopupMenuItem<WeatherType>(
                      value: e,
                      child: Text(WeatherUtil.getWeatherDesc(e)),
                    ),
                  )
                  .toList();
            },
            initialValue: _weatherType,
            onSelected: (value) {
              setState(() {
                _weatherType = value;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(WeatherUtil.getWeatherDesc(_weatherType)),
                const Icon(Icons.more_vert),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 7,
            margin: const EdgeInsets.only(top: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)),
            child: ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius))),
              child: WeatherBg(
                weatherType: _weatherType,
                width: _width,
                height: _height,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Slider(
            min: 100,
            max: 300,
            label: "$_width",
            divisions: 200,
            value: _width,
            onChanged: (value) {
              setState(() {
                _width = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Slider(
            min: 200,
            max: 600,
            label: "$_height",
            divisions: 400,
            value: _height,
            onChanged: (value) {
              setState(() {
                _height = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
