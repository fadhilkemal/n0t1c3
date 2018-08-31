// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

class ArchSampleTheme {
  static get theme {
    // final originalTextTheme = ThemeData.light().textTheme;
    // final originalBody1 = originalTextTheme.body1;
    // final originalBody2 = originalTextTheme.body2;

    return ThemeData.light().copyWith(
      primaryColor: Color(0xff2f72fc), // menu bar di atas
      //   selectedRowColor: Colors.red[300],\

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
