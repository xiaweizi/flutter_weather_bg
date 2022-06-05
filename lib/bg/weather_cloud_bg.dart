import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/utils/image_utils.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

//// 专门负责绘制背景云层
//// 会根据不同的天气类型，选择需要绘制的图片类型，并控制缩放、渐变、位移以及染色，最终显示在屏幕上
class WeatherCloudBg extends StatefulWidget {
  final WeatherType weatherType;

  WeatherCloudBg({Key key, this.weatherType}) : super(key: key);

  @override
  _WeatherCloudBgState createState() => _WeatherCloudBgState();
}

class _WeatherCloudBgState extends State<WeatherCloudBg> {
  List<ui.Image> _images = [];

  Future<void> fetchImages() async {
    weatherPrint("开始获取云层图片");
    var image1 = await ImageUtils.getImage('images/cloud.webp');
    var image2 = await ImageUtils.getImage('images/sun.webp');
    _images.add(image1);
    _images.add(image2);
    weatherPrint("获取云层图片成功： ${_images?.length}");
    setState(() {});
  }

  @override
  void initState() {
    fetchImages();
    super.initState();
  }

  Widget _buildWidget() {
    if (_images != null && _images.isNotEmpty) {
      return CustomPaint(
        painter: BgPainter(
            _images,
            widget.weatherType,
            SizeInherited.of(context).size.width / 392.0,
            SizeInherited.of(context).size.width),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }
}

class BgPainter extends CustomPainter {
  final _paint = Paint();
  final List<ui.Image> images;
  final WeatherType weatherType;
  final widthRatio;
  final width;

  BgPainter(this.images, this.weatherType, this.widthRatio, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    if (images != null && images.isNotEmpty) {
      switch (weatherType) {
        case WeatherType.sunny:
          drawSunny(canvas, size);
          break;
        case WeatherType.cloudy:
          drawCloudy(canvas, size);
          break;
        case WeatherType.cloudyNight:
          drawCloudyNight(canvas, size);
          break;
        case WeatherType.overcast:
          drawOvercast(canvas, size);
          break;
        case WeatherType.lightRainy:
          drawLightRainy(canvas, size);
          break;
        case WeatherType.middleRainy:
          drawMiddleRainy(canvas, size);
          break;
        case WeatherType.heavyRainy:
        case WeatherType.thunder:
          drawHeavyRainy(canvas, size);
          break;
        case WeatherType.hazy:
          drawHazy(canvas, size);
          break;
        case WeatherType.foggy:
          drawFoggy(canvas, size);
          break;
        case WeatherType.lightSnow:
          drawLightSnow(canvas, size);
          break;
        case WeatherType.middleSnow:
          drawMiddleSnow(canvas, size);
          break;
        case WeatherType.heavySnow:
          drawHeavySnow(canvas, size);
          break;
        case WeatherType.dusty:
          drawDusty(canvas, size);
          break;
        default:
          break;
      }
    }
  }

  /// 绘制阳光
  void drawSunny(Canvas canvas, Size size) {
    ui.Image image = images[0];
    ui.Image image1 = images[1];
    _paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 40);
    canvas.save();
    final sunScale = 1.2 * widthRatio;
    canvas.scale(sunScale, sunScale);
    var offset = Offset(width.toDouble() - image1.width.toDouble() * sunScale,
        -image1.width.toDouble() / 2);
    canvas.drawImage(image1, offset, _paint);
    canvas.restore();

    canvas.save();
    final scale = 0.40 * widthRatio;
    ui.Offset offset1 = ui.Offset(-100, -100);
    canvas.scale(scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.restore();
  }

  void drawCloudy(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0.9,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.40 * widthRatio;
    ui.Offset offset1 = ui.Offset(0, -200);
    ui.Offset offset2 = ui.Offset(-image.width / 2, -130);
    canvas.scale(scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  /// 绘制多云的夜晚效果
  void drawCloudyNight(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.32,
      0,
      0,
      0,
      0,
      0,
      0.39,
      0,
      0,
      0,
      0,
      0,
      0.52,
      0,
      0,
      0,
      0,
      0,
      0.9,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.40 * widthRatio;
    ui.Offset offset1 = ui.Offset(0, -200);
    ui.Offset offset2 = ui.Offset(-image.width / 2, -130);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  /// 绘制阴天
  void drawOvercast(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0.7,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.40 * widthRatio;
    ui.Offset offset1 = ui.Offset(0, -200);
    ui.Offset offset2 = ui.Offset(-image.width / 2, -130);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  /// 绘制小雨效果
  void drawLightRainy(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.45,
      0,
      0,
      0,
      0,
      0,
      0.52,
      0,
      0,
      0,
      0,
      0,
      0.6,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.40 * widthRatio;
    ui.Offset offset1 = ui.Offset(-380, -150);
    ui.Offset offset2 = ui.Offset(0, -60);
    canvas.scale(scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  /// 绘制霾逻辑
  void drawHazy(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.67,
      0,
      0,
      0,
      0,
      0,
      0.67,
      0,
      0,
      0,
      0,
      0,
      0.67,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 2.0 * widthRatio;
    ui.Offset offset1 = ui.Offset(-image.width.toDouble() * 0.5, -200);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.restore();
  }

  /// 绘制雾
  void drawFoggy(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.75,
      0,
      0,
      0,
      0,
      0,
      0.77,
      0,
      0,
      0,
      0,
      0,
      0.82,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 2.0 * widthRatio;
    ui.Offset offset1 = ui.Offset(-image.width.toDouble() * 0.5, -200);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.restore();
  }

  /// 绘制浮尘
  void drawDusty(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.62,
      0,
      0,
      0,
      0,
      0,
      0.55,
      0,
      0,
      0,
      0,
      0,
      0.45,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 2.0 * widthRatio;
    ui.Offset offset1 = ui.Offset(-image.width.toDouble() * 0.5, -200);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.restore();
  }

  /// 绘制大雨
  void drawHeavyRainy(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.19,
      0,
      0,
      0,
      0,
      0,
      0.2,
      0,
      0,
      0,
      0,
      0,
      0.22,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.40 * widthRatio;
    ui.Offset offset1 = ui.Offset(-380, -150);
    ui.Offset offset2 = ui.Offset(0, -60);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  /// 绘制中雨
  void drawMiddleRainy(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.16,
      0,
      0,
      0,
      0,
      0,
      0.22,
      0,
      0,
      0,
      0,
      0,
      0.31,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.40 * widthRatio;
    ui.Offset offset1 = ui.Offset(-380, -150);
    ui.Offset offset2 = ui.Offset(0, -60);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  /// 绘制小雪
  void drawLightSnow(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.67,
      0,
      0,
      0,
      0,
      0,
      0.75,
      0,
      0,
      0,
      0,
      0,
      0.87,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.40 * widthRatio;
    ui.Offset offset1 = ui.Offset(-380, -100);
    ui.Offset offset2 = ui.Offset(0, -170);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  /// 绘制中雪
  void drawMiddleSnow(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.7,
      0,
      0,
      0,
      0,
      0,
      0.77,
      0,
      0,
      0,
      0,
      0,
      0.87,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.40 * widthRatio;
    ui.Offset offset1 = ui.Offset(-380, -100);
    ui.Offset offset2 = ui.Offset(0, -170);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  /// 绘制大雪
  void drawHeavySnow(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.74,
      0,
      0,
      0,
      0,
      0,
      0.74,
      0,
      0,
      0,
      0,
      0,
      0.81,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.40 * widthRatio;
    ui.Offset offset1 = ui.Offset(-380, -100);
    ui.Offset offset2 = ui.Offset(0, -170);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
