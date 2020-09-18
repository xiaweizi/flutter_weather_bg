import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';

class GridViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GridView"),
        ),
        body: Container(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1 / 2,
            children: WeatherType.values
                .map((e) => GridItemWidget(
                      weatherType: e,
                    ))
                .toList(),
          ),
        ));
  }
}

class GridItemWidget extends StatelessWidget {
  final WeatherType weatherType;

  GridItemWidget({Key key, this.weatherType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    weatherPrint("grid item size: ${MediaQuery.of(context).size}");
    return Stack(
      children: [
        WeatherBg(
          weatherType: weatherType,
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width * 2,
        ),
        Center(
          child: Text(
            WeatherUtil.getWeatherDesc(weatherType),
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
