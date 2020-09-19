import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'dart:ui' as ui;

import 'package:flutter_weather_bg/utils/image_utils.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

/// 雷暴动画层
class WeatherThunderBg extends StatefulWidget {
  final WeatherType weatherType;

  WeatherThunderBg({Key key, this.weatherType}) : super(key: key);

  @override
  _WeatherCloudBgState createState() => _WeatherCloudBgState();
}

class _WeatherCloudBgState extends State<WeatherThunderBg>
    with SingleTickerProviderStateMixin {
  List<ui.Image> _images = [];
  AnimationController _controller;
  List<ThunderParams> _thunderParams = [];

  Future<void> fetchImages() async {
    weatherPrint("开始获取雷暴图片");
    var image1 = await ImageUtils.getImage('images/lightning0.webp');
    var image2 = await ImageUtils.getImage('images/lightning1.webp');
    var image3 = await ImageUtils.getImage('images/lightning2.webp');
    var image4 = await ImageUtils.getImage('images/lightning3.webp');
    var image5 = await ImageUtils.getImage('images/lightning4.webp');
    _images.add(image1);
    _images.add(image2);
    _images.add(image3);
    _images.add(image4);
    _images.add(image5);
    weatherPrint("获取雷暴图片成功： ${_images?.length}");
    initThunderParams();
    setState(() {
      _controller.forward();
    });
  }

  @override
  void initState() {
    fetchImages();
    initAnim();
    super.initState();
  }

  // 这里用于初始化动画相关，将闪电三个作为一组循环播放展示
  void initAnim() {
    _controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        Future.delayed(Duration(milliseconds: 50)).then((value) {
          initThunderParams();
          _controller.forward();
        });
      }
    });

    // 构造第一个闪电的动画数据
    var _animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.0,
        0.3,
        curve: Curves.ease,
      ),
    ));

    // 构造第二个闪电的动画数据
    var _animation1 = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.2,
        0.5,
        curve: Curves.ease,
      ),
    ));

    // 构造第三个闪电的动画数据
    var _animation2 = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.6,
        0.9,
        curve: Curves.ease,
      ),
    ));

    _animation.addListener(() {
      if (_thunderParams != null && _thunderParams.isNotEmpty) {
        _thunderParams[0].alpha = _animation.value;
      }
      setState(() {});
    });

    _animation1.addListener(() {
      if (_thunderParams != null && _thunderParams.isNotEmpty) {
        _thunderParams[1].alpha = _animation1.value;
      }
      setState(() {});
    });

    _animation2.addListener(() {
      if (_thunderParams != null && _thunderParams.isNotEmpty) {
        _thunderParams[2].alpha = _animation2.value;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWidget() {
    // 这里需要判断天气类别信息，防止不需要绘制的时候绘制，影响性能
    if (_thunderParams != null &&
        _thunderParams.isNotEmpty &&
        widget.weatherType == WeatherType.thunder) {
      return CustomPaint(
        painter: ThunderPainter(_thunderParams),
      );
    } else {
      return Container();
    }
  }

  // 初始化雷暴参数
  void initThunderParams() {
    _thunderParams.clear();
    // 配置三个闪电信息
    var param1 = ThunderParams(_images[Random().nextInt(5)]);
    param1.reset();
    var param2 = ThunderParams(_images[Random().nextInt(5)]);
    param2.reset();
    var param3 = ThunderParams(_images[Random().nextInt(5)]);
    param3.reset();
    _thunderParams.add(param1);
    _thunderParams.add(param2);
    _thunderParams.add(param3);
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }
}

class ThunderPainter extends CustomPainter {
  var _paint = Paint();
  final List<ThunderParams> thunderParams;

  ThunderPainter(this.thunderParams);

  @override
  void paint(Canvas canvas, Size size) {
    if (thunderParams != null && thunderParams.isNotEmpty) {
      for (var param in thunderParams) {
        drawThunder(param, canvas, size);
      }
    }
  }

  /// 这里主要负责绘制雷电
  void drawThunder(ThunderParams params, Canvas canvas, Size size) {
    if (params == null || params.image == null) {
      return;
    }
    canvas.save();
    var identity = ColorFilter.matrix(<double>[
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
      params.alpha,
      0,
    ]);
    _paint.colorFilter = identity;
    canvas.scale(globalWidthRatio);
    canvas.drawImage(params.image, Offset(params.x, params.y), _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ThunderParams {
  ui.Image image; // 配置闪电的图片资源
  double x; // 图片展示的 x 坐标
  double y; // 图片展示的 y 坐标
  double alpha; // 闪电的 alpha 属性
  int get imgWidth => image.width; // 雷电图片的宽度
  int get imgHeight => image.height; // 雷电图片的高度

  ThunderParams(this.image);

  // 重置图片的位置信息
  void reset() {
    x = Random().nextDouble() * 0.5 * globalWidth - 1 / 3 * imgWidth;
    y = Random().nextDouble() * -0.05 * globalHeight;
    alpha = 0;
  }
}
