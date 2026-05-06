import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg_example/anim_view.dart';
import 'package:flutter_weather_bg_example/grid_view.dart';
import 'package:flutter_weather_bg_example/list_view.dart';
import 'package:flutter_weather_bg_example/page_view.dart';

void main() {
  runApp(const MyApp());
}

const routePage = "page";
const routeList = "list";
const routeGrid = "grid";
const routeAnim = "anim";

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_weather_bg demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routes: {
        routePage: (BuildContext context) => const PageViewWidget(),
        routeList: (BuildContext context) => const ListViewWidget(),
        routeGrid: (BuildContext context) => const GridViewWidget(),
        routeAnim: (BuildContext context) => const AnimViewWidget(),
      },
      home: const HomePage(),
    );
  }
}

/// demo 首页布局
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// 创建首页 item 布局
  Widget _buildItem(BuildContext context, String routeName, String desc,
      WeatherType weatherType) {
    final width = MediaQuery.of(context).size.width;
    const marginLeft = 10.0;
    const marginTop = 8.0;
    final itemWidth = (width - marginLeft * 4) / 2;
    final itemHeight = itemWidth * 1.5;
    const radius = 10.0;
    return SizedBox(
      width: itemWidth,
      height: itemHeight,
      child: Card(
        elevation: 7,
        margin: const EdgeInsets.symmetric(
            horizontal: marginLeft, vertical: marginTop),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius)),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius))),
          child: Stack(
            children: [
              WeatherBg(
                weatherType: weatherType,
                width: itemWidth,
                height: itemHeight,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: InkWell(
                  onTap: () {
                    weatherPrint("name: $routeName");
                    Navigator.of(context).pushNamed(routeName);
                  },
                  child: Center(
                    child: Text(
                      desc,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Wrap(
            children: [
              _buildItem(context, routePage, "翻页效果", WeatherType.thunder),
              _buildItem(context, routeGrid, "宫格效果", WeatherType.sunnyNight),
              _buildItem(context, routeList, "列表效果", WeatherType.lightSnow),
              _buildItem(context, routeAnim, "切换效果", WeatherType.sunny),
            ],
          ),
        ),
      ),
    );
  }
}
