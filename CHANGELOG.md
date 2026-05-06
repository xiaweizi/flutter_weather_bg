## 3.0.0

**Breaking:** This release opts into sound null-safety; 2.8.2 did not.
Users upgrading from 2.x must migrate their call sites accordingly (nothing
in the public API was renamed — only types are now non-nullable where
appropriate).

- Migrate to Flutter 3.x / Dart 3 null-safety (min SDK: Flutter `>=3.0.0`, Dart `>=3.0.0 <4.0.0`)
- Replace deprecated `@required` with the `required` keyword and adopt `super.key` in all constructors
- Annotate long-lived state fields with `late` / nullable types; drop redundant null-check branches
- Add `mounted` guards around async `setState` callbacks to avoid "setState() called after dispose"
- Fix `WeatherPrint` typedef signature (`wrapWidth`/`tag` now nullable)
- Rebuild `example/` native shells (AGP 8 / Gradle 8, Kotlin DSL, new iOS template, Web platform added)
- Bump `flutter_lints` to `^5.0.0`; `example` uses Material 3 by default
- Fix MIT LICENSE copyright holder

## 2.8.0

- Optimize the distance effect of raindrops
- Optimize the display effect under different width and height
- Optimize rendering logic

## 2.7.0

- Beautify the home page entrance display UI

## 2.6.0

- Minimum height of restricted sunny night

## 2.5.0

- Update ReadMe

## 2.3.0

- Add comment information

## 2.2.0

- Adjust cloud image position
- Remove unnecessary printing
- New list display example

## 2.1.0

- Remove unnecessary tripartite dependence
- Support multi platform

## 2.0.0

- Add more detailed comments and instructions
- Supports over animation when switching weather types
- Support the display effect of pictures after dynamically changing the width and height
- Optimized rendering algorithm, more fluent

## 1.3.0

- Add comments; change code structure

## 1.2.0

- Update Readme

## 1.1.0

- Support dynamic modification of background size, and optimize cloud image effect

## 1.0.0

- The basic functions are completed and 15 weather background types are supported

## 0.0.3

- Update Readme

## 0.0.2

- Add test widget and test plug-in

## 0.0.1

* Init project


