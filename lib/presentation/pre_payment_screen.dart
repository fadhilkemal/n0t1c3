// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:notice/containers/filtered_todos.dart';
import 'package:notice/containers/discount.dart';

class PrePaymentScreen extends StatefulWidget {
  final Function openDrawer;

  PrePaymentScreen({
    Key key,
    this.openDrawer,
  }) : super(key: key);

  @override
  PrePaymentScreenState createState() {
    return new PrePaymentScreenState();
  }
}

class PrePaymentScreenState extends State<PrePaymentScreen> {
  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 266.0,
                // color: Colors.blue[300],
                child: Scrollbar(
                  child: FilteredTodos(viewType: "prepayment"),
                ),
              ),
            ),
            Positioned(
              bottom: 20.0,
              child: RaisedButton(
                child: Text(
                  "%",
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DiscountPage(),
                    ),
                  );
                  //   Navigator.push<Null>(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => PaymentPage(
                  //             totalBill: 400.0,
                  //           ),
                  //     ),
                  //   );
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
    return Scaffold(
      //   key: homeScreenScaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "",
                style: TextStyle(
                  //   color: Color(0x771e53e5),
                  color: Color(0xffffffff),
                ),
              ),
              const Text(
                '',
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
      body: _buildBody(),
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/paymentScreen');

            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(
            //     builder: (_) => PrePaymentScreen(),
            //   ),
            // );
          },
          child: Material(
            color: Color(0xff08FEA6), //!GANTI
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.done, size: 40.0, color: Color(0xff9197ff)),
                ]),
          ),
        ),
      ),
    );
  }
}
