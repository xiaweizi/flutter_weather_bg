## 3.1.0

性能优化 + 内部重构，非破坏性。公开 API 未变，只用到 `WeatherBg` 的代码无需改动即可升级。

- **性能**：雨雪 / 雷电 / 晴晚三个动画层改用 `CustomPainter` 的 `repaint:` 机制驱动重绘，不再每帧 `setState` 重建整棵子树。雨雪等粒子场景 CPU 占用显著下降。
- **性能**：粒子 alpha 动画不再每帧构建 `ColorFilter.matrix([20 个 double])`，改用 `ColorFilter.mode(..., modulate)`；200+ 粒子时 GC 压力大幅降低。
- **性能**：雷电参数对象改为复用，不再每 3 秒循环重新分配。
- **重构**：`BgPainter` 原本 12 个模板化的 `drawXxx` 方法（共 330 行），改成数据驱动的 `_CloudLayer` 规格表。新增一种天气只要加一条 map entry，不必再写新方法。
- **重构**：`WeatherBg` 手写的 `AnimatedCrossFade` state swap 逻辑替换成 `AnimatedSwitcher` + `ValueKey(weatherType)`，去掉 40 行样板代码，淡入淡出效果保持 300ms 不变。
- **清理**：`ui.Image` 实例在 `State.dispose` 时正确释放（Flutter 3.1+ API）。
- **清理**：删除一条遗留的死代码 `CurvedAnimation(...)`（会泄漏一个 listener）。
- **清理**：粒子系统内的 `Random()` 调用改为共享一个顶层实例。
- **清理**：硬编码的设计基准尺寸（392、817）抽成 `utils/constants.dart` 常量。

## 3.0.0

**破坏性更新：** 本版本启用 sound null-safety，2.8.2 尚未启用。
从 2.x 升级的用户需要相应调整调用处的空值处理（公共 API 未改名，仅类型在合适处变为 non-nullable）。

- 迁移到 Flutter 3.x / Dart 3 空安全（最低 Flutter `>=3.0.0`、Dart `>=3.0.0 <4.0.0`）
- 弃用 `@required`，全部构造器改为 `required` + `super.key`
- 给长期持有的 State 字段加上 `late` / nullable 声明，删掉冗余的 null 判断
- 异步 `setState` 回调前加 `mounted` 判断，避免已销毁组件继续刷新
- 修正 `WeatherPrint` typedef 签名（`wrapWidth` / `tag` 变为 nullable）
- 重建 `example/` 的原生外壳（AGP 8 / Gradle 8、Kotlin DSL，iOS 新模板，新增 Web 支持）
- 升级 `flutter_lints` 至 `^5.0.0`；`example` 默认启用 Material 3
- 修正 MIT LICENSE 的版权归属

## 2.8.0

- 优化雨滴的远近效果
- 优化不同宽高下的展示效果
- 优化绘制逻辑

## 2.7.0

- 美化首页入口展示 UI

## 2.6.0

- 限制晴晚的最小高度

## 2.5.0

- 更新 ReadMe

## 2.3.0

- 添加注释信息

## 2.2.0

- 调整云图位置
- 去除不必要打印
- 新增列表展示例子

## 2.1.0

- 去除不必要的三方依赖
- 支持多平台

## 2.0.0

- 添加更加详细的注释和说明
- 支持切换天气类型时的过度动画
- 支持动态更改宽高后，图片的展示效果
- 优化绘制算法，更加流畅

## 1.3.0

- 添加注释；更改代码结构

## 1.2.0

- 更新 readme

## 1.2.0

- 更新 readme

## 1.1.0

- 支持动态修改背景尺寸，并且优化云图效果

## 1.0.0

- 基础功能完成，支持15中天气背景类型

## 0.0.3

- 更新 readme

## 0.0.2

- 添加测试 widget，测试插件

## 0.0.1

* 初始项目
