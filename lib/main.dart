// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:notice/fas_copy/flutter_architecture_samples.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/actions/actions.dart';
import 'package:notice/containers/payment.dart';
import 'package:notice/localization.dart';
import 'package:notice/middleware/store_todos_middleware.dart';
import 'package:notice/models/models.dart';
import 'package:notice/presentation/home_screen.dart';
import 'package:notice/presentation/main_drawer.dart';
import 'package:notice/reducers/app_state_reducer.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/services.dart';

changeStatusColor(Color color) async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(color);
  } on PlatformException catch (e) {
    print(e);
  }
}

void main() {
  // ignore: deprecated_member_use
//   MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(ReduxApp());
}

class ReduxApp extends StatefulWidget {
  @override
  ReduxAppState createState() {
    return new ReduxAppState();
  }
}

class ReduxAppState extends State<ReduxApp> {
  bool _performanceOverlay;

  changeStatusColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _performanceOverlay = false;
    changeStatusColor(Colors.transparent);
  }

  void togglePerformanceOverlay() {
    // changeStatusColor(Colors.transparent);
    setState(() {
      _performanceOverlay = !_performanceOverlay;
    });
  }

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.loading(),
    middleware: createStoreTodosMiddleware(),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        showPerformanceOverlay: _performanceOverlay,
        title: "v38",
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          ReduxLocalizationsDelegate(),
        ],
        routes: {
          '/': (context) {
            return StoreBuilder<AppState>(
              onInit: (store) {
                store.dispatch(LoadCategAction());
                store.dispatch(LoadTodosAction());
              },
              builder: (context, store) {
                return MainDrawer(
                  togglePerformanceOverlay: togglePerformanceOverlay,
                );
              },
            );
          },
          '/oldHome': (context) {
            return StoreBuilder<AppState>(
              onInit: (store) {
                store.dispatch(LoadCategAction());
                store.dispatch(LoadTodosAction());
              },
              builder: (context, store) {
                return HomeScreen();
              },
            );
          },
          //   ArchSampleRoutes.addTodo: (context) {
          //     return AddTodo();
          //   },
          '/paymentScreen': (context) {
            return PaymentPage();
          },
          //   '/masterProduct': (context) {
          //     return MasterProduct();
          //   },
        },
      ),
    );
  }
}
