import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

/// 主要提供两个实例
/// 1. 切换天气类型时，会有过度动画
/// 2. 动态改变宽高，绘制的相关逻辑同步发生改变
class AnimViewWidget extends StatefulWidget {
  @override
  _AnimViewWidgetState createState() => _AnimViewWidgetState();
}

class _AnimViewWidgetState extends State<AnimViewWidget> {
  WeatherType _weatherType = WeatherType.sunny;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AnimView"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: WeatherBg(
                weatherType: _weatherType,
                width: 250,
                height: 500,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            PopupMenuButton<WeatherType>(
              itemBuilder: (context) {
                return <PopupMenuEntry<WeatherType>>[
                  ...WeatherType.values
                      .map((e) => PopupMenuItem<WeatherType>(
                            value: e,
                            child: Text("${WeatherUtil.getWeatherDesc(e)}"),
                          ))
                      .toList(),
                ];
              },
              initialValue: _weatherType,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${WeatherUtil.getWeatherDesc(_weatherType)}"),
                  Icon(Icons.more_vert)
                ],
              ),
              onSelected: (count) {
                setState(() {
                  _weatherType = count;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
