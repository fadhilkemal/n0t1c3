// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:notice/fas_copy/flutter_architecture_samples.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/actions/actions.dart';
import 'package:notice/containers/add_todo.dart';
import 'package:notice/containers/payment.dart';
import 'package:notice/localization.dart';
import 'package:notice/middleware/store_todos_middleware.dart';
import 'package:notice/models/models.dart';
import 'package:notice/presentation/home_screen.dart';
import 'package:notice/presentation/master_product.dart';
import 'package:notice/presentation/main_drawer.dart';
import 'package:notice/reducers/app_state_reducer.dart';

void main() {
  // ignore: deprecated_member_use
  MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(ReduxApp());
}

class ReduxApp extends StatelessWidget {
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
        showPerformanceOverlay: true,
        title: ReduxLocalizations().appTitle,
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
                return MainDrawer();
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
          //   '/paymentScreen': (context) {
          //     return PaymentPage();
          //   },
          //   '/masterProduct': (context) {
          //     return MasterProduct();
          //   },
        },
      ),
    );
  }
}
