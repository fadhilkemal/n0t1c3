// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:notice/fas_copy/flutter_architecture_samples.dart';
import 'package:notice/containers/active_tab.dart';
import 'package:notice/containers/filtered_todos.dart';

import 'package:notice/containers/stats.dart';
import 'package:notice/containers/category.dart';
import 'package:notice/models/models.dart';
import 'package:notice/presentation/buttom_bar.dart';
import 'package:notice/presentation/pre_payment_screen.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/selectors/selectors.dart';

class HomeScreen extends StatelessWidget {
  final Function openDrawer;

  HomeScreen({
    this.openDrawer,
  }) : super(key: ArchSampleKeys.homeScreen);
//   final homeScreenScaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _buildBody(activeTab) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (activeTab == AppTab.stats) {
          return Stats();
        }
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 20.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 83.0,
                // color: Colors.blue[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Stats(),
                    // Text(
                    //   "Tes",
                    //   // "Rp ${store.cartItems.map((item) => item.price).isEmpty ? 0 : store.cartItems.map((item) => item.price).reduce((curr, next) => curr + next)}",
                    //   style: TextStyle(
                    //     fontSize: 53.0,
                    //     color: Colors.black12,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 166.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 166.0,
                // color: Colors.blue[300],
                child: Scrollbar(
                  child: FilteredTodos(viewType: "default"),
                ),
              ),
            ),
            Positioned(
              top: 116.0,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: const Color(0x23000000),
                      offset: new Offset(0.0, 1.0),
                      blurRadius: 0.2,
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                // color: Colors.blue[300],
                child: CategoryWidget(),
              ),
            ),
            Positioned(
              bottom: 0.0,
              //   child: BottomBarCustom(
              //     constraints: constraints,
              //     // onPaymentPressed: () {
              //     //   Navigator.pushNamed(context, '/paymentScreen');
              //     // },
              //     onPaymentPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(
              //           builder: (context) => PrePaymentScreen(),
              //         ),
              //       );
              //     },
              //   ),
              child: StoreConnector<AppState, double>(
                converter: (Store<AppState> store) {
                  return numCompletedSelector(store.state.todos);
                  // store.dispatch(ClearCompletedAction());
                  // store.dispatch(LoadTodosAction());
                },
                builder: (BuildContext context, double store) {
                  return BottomBarCustom(
                    constraints: constraints,
                    onPaymentPressed: () {
                      if (store > 0.0) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PrePaymentScreen(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActiveTab(
      builder: (BuildContext context, AppTab activeTab) {
        return Scaffold(
          //   key: homeScreenScaffoldKey,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                openDrawer();
              },
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "v33",
                    style: TextStyle(
                      //   color: Color(0x771e53e5),
                      color: Color(0xffffffff),
                    ),
                  ),
                  const Text(
                    'Transaction History on SQLite \nPerformance Overlay', // v33 !ACTION : Change ReleaseName
                    style: TextStyle(
                      //   color: Color(0xFF1F94E5),
                      color: Color(0xffffffff),
                      //   color: Color(0xFF1e53e5),
                    ),
                    textScaleFactor: 0.6,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            actions: [
              //   FilterSelector(visible: activeTab == AppTab.todos),
              //   ExtraActionsContainer(),
            ],
          ),
          //   drawer: Drawer(
          //     child: DrawerList(),
          //   ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: _buildBody(activeTab),
          ),
        );
      },
    );
  }
}
