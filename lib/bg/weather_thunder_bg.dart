import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/utils/constants.dart';
import 'package:flutter_weather_bg/utils/image_utils.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

/// 雷暴动画层。
///
/// 三条闪电在同一个 3 秒循环中依次闪烁。
class WeatherThunderBg extends StatefulWidget {
  final WeatherType weatherType;

  const WeatherThunderBg({super.key, required this.weatherType});

  @override
  State<WeatherThunderBg> createState() => _WeatherThunderBgState();
}

class _WeatherThunderBgState extends State<WeatherThunderBg>
    with SingleTickerProviderStateMixin {
  static const int _imageCount = 5;
  static const int _boltCount = 3;

  final List<ui.Image> _images = [];
  late final AnimationController _controller;
  final List<ThunderParams> _thunderParams = [];
  WeatherDataState _state = WeatherDataState.init;

  /// 异步加载 5 张闪电图。
  Future<void> _fetchImages() async {
    weatherPrint("开始获取雷暴图片");
    final futures = List.generate(
      _imageCount,
      (i) => ImageUtils.getImage('images/lightning$i.webp'),
    );
    final images = await Future.wait(futures);
    if (!mounted) {
      for (final i in images) {
        i.dispose();
      }
      return;
    }
    _images
      ..clear()
      ..addAll(images);
    _state = WeatherDataState.init;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchImages();
  }

  /// 构建控制器 + 三段 alpha 动画。
  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addStatusListener((status) {
        if (status != AnimationStatus.completed) return;
        _controller.reset();
        Future.delayed(const Duration(milliseconds: 50), () {
          if (!mounted) return;
          _resetThunderParams();
          _controller.forward();
        });
      });

    // 三段闪电在不同 interval 内各自 0 → 1 → 0。
    for (int i = 0; i < _boltCount; i++) {
      final interval = _intervals[i];
      final animation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(interval.$1, interval.$2, curve: Curves.ease),
        ),
      );
      animation.addListener(() {
        if (_thunderParams.length > i) {
          _thunderParams[i].alpha = animation.value;
        }
        // 不需要 setState —— CustomPaint.repaint 已经挂在 _controller 上
      });
    }
  }

  static const List<(double, double)> _intervals = [
    (0.0, 0.3),
    (0.2, 0.5),
    (0.6, 0.9),
  ];

  @override
  void dispose() {
    _controller.dispose();
    for (final image in _images) {
      image.dispose();
    }
    super.dispose();
  }

  /// 为 3 条闪电分配（或复用）参数对象。
  void _resetThunderParams() {
    if (_images.isEmpty) return;
    _state = WeatherDataState.loading;
    final size = SizeInherited.of(context)!.size;
    final width = size.width;
    final height = size.height;
    final widthRatio = width / kDesignWidth;

    if (_thunderParams.isEmpty) {
      for (var i = 0; i < _boltCount; i++) {
        _thunderParams.add(ThunderParams(
          _images[kRandom.nextInt(_imageCount)],
          width,
          height,
          widthRatio,
        ));
      }
    } else {
      for (final p in _thunderParams) {
        p.image = _images[kRandom.nextInt(_imageCount)];
      }
    }
    for (final p in _thunderParams) {
      p.reset();
    }
    _controller.forward();
    _state = WeatherDataState.finish;
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init && _images.isNotEmpty) {
      _resetThunderParams();
    }
    if (_state != WeatherDataState.finish ||
        _thunderParams.isEmpty ||
        widget.weatherType != WeatherType.thunder) {
      return const SizedBox.shrink();
    }
    return CustomPaint(
      painter: ThunderPainter(_thunderParams, _controller),
    );
  }
}

/// 绘制雷电图片，alpha 通过共享参数驱动。
class ThunderPainter extends CustomPainter {
  final Paint _paint = Paint();
  final List<ThunderParams> thunderParams;

  ThunderPainter(this.thunderParams, Listenable repaint)
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in thunderParams) {
      _drawThunder(p, canvas);
    }
  }

  void _drawThunder(ThunderParams p, Canvas canvas) {
    canvas.save();
    _paint.colorFilter = ColorFilter.mode(
      Color.fromRGBO(255, 255, 255, p.alpha),
      BlendMode.modulate,
    );
    canvas.scale(p.widthRatio * 1.2);
    canvas.drawImage(p.image, Offset(p.x, p.y), _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ThunderPainter old) => true;
}

class ThunderParams {
  ui.Image image;
  double x = 0;
  double y = 0;
  double alpha = 0;

  int get imgWidth => image.width;
  int get imgHeight => image.height;

  final double width, height, widthRatio;

  ThunderParams(this.image, this.width, this.height, this.widthRatio);

  void reset() {
    x = kRandom.nextDouble() * 0.5 * widthRatio - 1 / 3 * imgWidth;
    y = kRandom.nextDouble() * -0.05 * height;
    alpha = 0;
  }
}
