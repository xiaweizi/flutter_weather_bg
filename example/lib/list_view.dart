import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({super.key});

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("listView"),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ListItemWidget(
            weatherType: WeatherType.values[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 5);
        },
        itemCount: WeatherType.values.length,
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  final WeatherType weatherType;

  const ListItemWidget({super.key, required this.weatherType});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        child: Stack(
          children: [
            WeatherBg(
              weatherType: weatherType,
              width: MediaQuery.of(context).size.width,
              height: 100,
            ),
            Container(
              alignment: const Alignment(-0.8, 0),
              height: 100,
              child: const Text(
                "北京",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: const Alignment(0.8, 0),
              height: 100,
              child: Text(
                WeatherUtil.getWeatherDesc(weatherType),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
