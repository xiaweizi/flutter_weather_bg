import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/utils/image_utils.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

/// 雷暴动画层
class WeatherThunderBg extends StatefulWidget {
  final WeatherType weatherType;

  const WeatherThunderBg({super.key, required this.weatherType});

  @override
  State<WeatherThunderBg> createState() => _WeatherThunderBgState();
}

class _WeatherThunderBgState extends State<WeatherThunderBg>
    with SingleTickerProviderStateMixin {
  final List<ui.Image> _images = [];
  late AnimationController _controller;
  final List<ThunderParams> _thunderParams = [];
  WeatherDataState _state = WeatherDataState.init;

  /// 异步获取雷暴图片资源
  Future<void> fetchImages() async {
    weatherPrint("开始获取雷暴图片");
    final image1 = await ImageUtils.getImage('images/lightning0.webp');
    final image2 = await ImageUtils.getImage('images/lightning1.webp');
    final image3 = await ImageUtils.getImage('images/lightning2.webp');
    final image4 = await ImageUtils.getImage('images/lightning3.webp');
    final image5 = await ImageUtils.getImage('images/lightning4.webp');
    _images.add(image1);
    _images.add(image2);
    _images.add(image3);
    _images.add(image4);
    _images.add(image5);
    weatherPrint("获取雷暴图片成功： ${_images.length}");
    _state = WeatherDataState.init;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initAnim();
    fetchImages();
  }

  // 这里用于初始化动画相关，将闪电三个作为一组循环播放展示
  void initAnim() {
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        Future.delayed(const Duration(milliseconds: 50)).then((value) {
          initThunderParams();
          _controller.forward();
        });
      }
    });

    // 构造第一个闪电的动画数据
    final animation = TweenSequence<double>([
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
      curve: const Interval(
        0.0,
        0.3,
        curve: Curves.ease,
      ),
    ));

    // 构造第二个闪电的动画数据
    final animation1 = TweenSequence<double>([
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
      curve: const Interval(
        0.2,
        0.5,
        curve: Curves.ease,
      ),
    ));

    // 构造第三个闪电的动画数据
    final animation2 = TweenSequence<double>([
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
      curve: const Interval(
        0.6,
        0.9,
        curve: Curves.ease,
      ),
    ));

    animation.addListener(() {
      if (_thunderParams.isNotEmpty) {
        _thunderParams[0].alpha = animation.value;
      }
      if (mounted) setState(() {});
    });

    animation1.addListener(() {
      if (_thunderParams.length > 1) {
        _thunderParams[1].alpha = animation1.value;
      }
      if (mounted) setState(() {});
    });

    animation2.addListener(() {
      if (_thunderParams.length > 2) {
        _thunderParams[2].alpha = animation2.value;
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 构建雷暴 widget
  Widget _buildWidget() {
    // 这里需要判断天气类别信息，防止不需要绘制的时候绘制，影响性能
    if (_thunderParams.isNotEmpty &&
        widget.weatherType == WeatherType.thunder) {
      return CustomPaint(
        painter: ThunderPainter(_thunderParams),
      );
    } else {
      return Container();
    }
  }

  /// 初始化雷暴参数
  void initThunderParams() {
    _state = WeatherDataState.loading;
    _thunderParams.clear();
    final size = SizeInherited.of(context)!.size;
    final width = size.width;
    final height = size.height;
    final widthRatio = size.width / 392.0;
    // 配置三个闪电信息
    for (var i = 0; i < 3; i++) {
      final param = ThunderParams(
          _images[Random().nextInt(5)], width, height, widthRatio);
      param.reset();
      _thunderParams.add(param);
    }
    _controller.forward();
    _state = WeatherDataState.finish;
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init && _images.isNotEmpty) {
      initThunderParams();
    }
    if (_state == WeatherDataState.finish) {
      return _buildWidget();
    }
    return Container();
  }
}

class ThunderPainter extends CustomPainter {
  final Paint _paint = Paint();
  final List<ThunderParams> thunderParams;

  ThunderPainter(this.thunderParams);

  @override
  void paint(Canvas canvas, Size size) {
    if (thunderParams.isNotEmpty) {
      for (final param in thunderParams) {
        drawThunder(param, canvas, size);
      }
    }
  }

  /// 这里主要负责绘制雷电
  void drawThunder(ThunderParams params, Canvas canvas, Size size) {
    canvas.save();
    final identity = ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0, //
      0, 1, 0, 0, 0, //
      0, 0, 1, 0, 0, //
      0, 0, 0, params.alpha, 0, //
    ]);
    _paint.colorFilter = identity;
    canvas.scale(params.widthRatio * 1.2);
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
  double x = 0; // 图片展示的 x 坐标
  double y = 0; // 图片展示的 y 坐标
  double alpha = 0; // 闪电的 alpha 属性
  int get imgWidth => image.width; // 雷电图片的宽度
  int get imgHeight => image.height; // 雷电图片的高度
  final double width, height, widthRatio;

  ThunderParams(this.image, this.width, this.height, this.widthRatio);

  // 重置图片的位置信息
  void reset() {
    x = Random().nextDouble() * 0.5 * widthRatio - 1 / 3 * imgWidth;
    y = Random().nextDouble() * -0.05 * height;
    alpha = 0;
  }
}
