// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notice/database/dbhelper.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

Future<Map> fetchSaleOrderDetailFromDB(int orderId) async {
  var dbHelper = DBHelper();
  Future<Map> employees = dbHelper.getSaleOrderDetail(orderId);
  return employees;
}

class TransDetailScreen extends StatefulWidget {
  final int orderId;
  TransDetailScreen({
    Key key,
    this.orderId,
  }) : super(key: key);

  @override
  TransDetailScreenState createState() {
    return TransDetailScreenState();
  }
}

class DetailContainer extends StatelessWidget {
  final Widget leading;
  final Widget body;
  final String title;
  final Widget trailing;
  final TextStyle titleStyle;

  DetailContainer({
    Key key,
    this.leading,
    this.body,
    this.title = "",
    this.trailing,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            // color: Color(0xFFefeff2),
            color: Color(0xFFe9e9eb),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      //   child: child,
      child: Row(
        children: <Widget>[
          leading != null
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: leading,
                )
              : Container(),
          body != null
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  width: MediaQuery.of(context).size.width / 2,
                  alignment: Alignment.centerLeft,
                  child: body,
                )
              : Container(),
          title.isNotEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    title,
                    style: titleStyle != null ? titleStyle : null,
                  ),
                )
              : Container(),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              alignment: Alignment.topRight,
              child: trailing,
            ),
          ),
        ],
      ),
    );
  }
}

class TransDetailScreenState extends State<TransDetailScreen> {
  Widget _topSection(context, snapshot) {
    var name = snapshot.data['name'];
    var customer = snapshot.data['customer'];
    var priceTotal = snapshot.data['price_total'];
    var pay_method = snapshot.data['pay_method'];
    String order_datetime = snapshot.data['order_datetime'];
    DateTime _dateTime = DateTime.parse(order_datetime);

    var formatter = new DateFormat('E, d MMM');
    String formatted = formatter.format(_dateTime);
    String jam = order_datetime.substring(11, 16);
    final rpFormatter = NumberFormat("###,###.###", "pt-br");

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("$customer"),
              Text("$pay_method"),
              Text("${formatted}"),
              Text("${jam}"),
            ],
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Column(
              children: <Widget>[
                Text(
                  "Rp ${rpFormatter.format(priceTotal)}",
                  style: TextStyle(fontSize: 23.0),
                ),
                Text(
                  "Order $name",
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDetailList(context, snapshot) {
    var detail = snapshot.data['detail'];
    Map transactionDetail = JsonDecoder().convert(detail);
    final rpFormatter = NumberFormat("###,###.###", "pt-br");

    List<Widget> childrenWidgets = List<Widget>();

    for (Map order in transactionDetail["order_line"]) {
      var price = order['price'];
      var quantity = order['quantity'];
      var priceSubtotal = price * quantity;

      Widget listTile = DetailContainer(
        leading: Container(
          width: 45.0,
          height: 45.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFf7f7f8),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            border: new Border.all(
              color: Color(0xFFF2f2f4),
              width: 1.0,
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${order["task"]}",
              style: TextStyle(
                color: Color(0xff17397e), // !GANTI
                fontSize: 14.0,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "x ${order["quantity"]}",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 11.0,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "${rpFormatter.format(priceSubtotal)}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${rpFormatter.format(order['price'])}",
              //   "${order['quantity']}",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 11.0,
              ),
            ),
          ],
        ),
      );

      childrenWidgets.add(listTile);
    }
    return childrenWidgets;
  }

  Widget _productSection(context, snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _buildDetailList(context, snapshot),
    );
  }

  Widget _buildScreen(context, snapshot) {
    var priceDiscount = snapshot.data['price_discount'];
    var priceTotal = snapshot.data['price_total'];

    final rpFormatter = NumberFormat("###,###.###", "pt-br");

    return ListView(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(25.0)),
        _topSection(context, snapshot),
        Padding(padding: EdgeInsets.all(15.0)),
        _productSection(context, snapshot),
        DetailContainer(
          title: "Subtotal",
          trailing: Text(
            "${rpFormatter.format(priceDiscount + priceTotal)}",
          ),
        ),
        DetailContainer(
          title: "Discount",
          trailing: Text(
            "${rpFormatter.format(priceDiscount)}",
          ),
        ),
        DetailContainer(
          title: "Total",
          titleStyle: TextStyle(
            color: Color(0xff2e72f9), // !GANTI
          ),
          trailing: Text(
            "${rpFormatter.format(priceTotal)}",
            style: TextStyle(
              color: Color(0xff2e72f9), // !GANTI
            ),
          ),
        ),
        Padding(padding: EdgeInsets.all(30.0)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Detail"),
        actions: [
          //   IconButton(
          // icon: Icon(Icons.done),
          // onPressed: _submit,
          //   )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<Map>(
          future: fetchSaleOrderDetailFromDB(widget.orderId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildScreen(context, snapshot);
            }
            //   return ListView.builder(
            //       itemCount: snapshot.data.length,
            //       itemBuilder: (context, index) {
            //         return Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: <Widget>[
            //               Text(snapshot.data[index].name,
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.bold, fontSize: 18.0)),
            //               Text(snapshot.data[index].description,
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.bold, fontSize: 14.0)),
            //               Text("${snapshot.data[index].price}",
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.bold, fontSize: 14.0)),
            //               Divider()
            //             ]);
            //       });
            // } else if (snapshot.hasError) {
            //   return Text("${snapshot.error}");
            // }
            return Container(
              alignment: AlignmentDirectional.center,
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
