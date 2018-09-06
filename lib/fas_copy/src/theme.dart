import 'package:flutter/material.dart';

class TestInkSplash extends InkSplash {
  TestInkSplash({
    MaterialInkController controller,
    RenderBox referenceBox,
    Offset position,
    Color color,
    bool containedInkWell = false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    VoidCallback onRemoved,
  }) : super(
          controller: controller,
          referenceBox: referenceBox,
          position: position,
          color: color,
          containedInkWell: containedInkWell,
          rectCallback: rectCallback,
          borderRadius: borderRadius,
          customBorder: customBorder,
          radius: radius,
          onRemoved: onRemoved,
        );
}

class TestInkSplashFactory extends InteractiveInkFeatureFactory {
  const TestInkSplashFactory();

  @override
  InteractiveInkFeature create({
    MaterialInkController controller,
    RenderBox referenceBox,
    Offset position,
    Color color,
    bool containedInkWell = false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    VoidCallback onRemoved,
  }) {
    return new TestInkSplash(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: Colors.green,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: 65.0,
      onRemoved: onRemoved,
    );
  }
}

class ArchSampleTheme {
  static get theme {
    // final originalTextTheme = ThemeData.light().textTheme;
    // final originalBody1 = originalTextTheme.body1;
    // final originalBody2 = originalTextTheme.body2;

    return ThemeData.light().copyWith(
      primaryColor: Color(0xff2f72fc), // menu bar di atas
      //   splashColor: Colors.red,
      //   selectedRowColor: Colors.red[300],

      //   primaryTextTheme: originalTextTheme.copyWith(
      //     title: originalBody1.copyWith(color: Colors.white), //tab bar title
      //   ),
      //   primaryTextTheme: TextTheme(
      //     body1: TextStyle(
      //       decorationColor: Colors.red,
      //     ),
      //   ),
      //   accentTextTheme: TextTheme(title: TextStyle(decorationColor: Colors.red)),
      //   buttonColor: Colors.grey[800],
      //   textSelectionColor: Colors.cyan[100],
      //   backgroundColor: Colors.red[800],
      //   textTheme: originalTextTheme.copyWith(
      //       body1: originalBody1.copyWith(decorationColor: Colors.transparent)),
    );
  }
}
