import 'package:flutter/material.dart';
import 'package:notice/models/product.dart';
import 'dart:async';
import 'package:notice/database/dbhelper.dart';
import 'package:notice/presentation/master_product_add.dart';
import 'package:notice/containers/load_product.dart';
import 'package:notice/models/models.dart';

Future<List<SaleOrder>> fetchTransactionFromDB() async {
  var dbHelper = DBHelper();
  Future transactions = dbHelper.getSaleOrders();
  return transactions;
}

class TransScreen extends StatefulWidget {
  final Function openDrawer;

  TransScreen({
    this.openDrawer,
  });
  @override
  TransScreenState createState() => new TransScreenState();
}

class TransScreenState extends State<TransScreen> {
  final masterProductScaffoldKey = new GlobalKey<ScaffoldState>();

//   void _showSnackBar(String text) {
//     masterProductScaffoldKey.currentState
//         .showSnackBar(new SnackBar(content: new Text(text)));
//   }

  void _onConfirmTap2() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => TransScreenAdd(),
    //     fullscreenDialog: true,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: masterProductScaffoldKey,
      appBar: new AppBar(
        title: new Text('Transaction List'),
        leading: new IconButton(
          icon: new Icon(Icons.menu),
          onPressed: () {
            widget.openDrawer();
            // context.widget.menuController.toggle();
          },
        ),
        actions: [
          //   FilterSelector(visible: activeTab == AppTab.todos),
          //   ExtraActionsContainer(),
        ],
      ),
      //   drawer: Drawer(
      //     child: DrawerList(),
      //   ),
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new FutureBuilder<List<SaleOrder>>(
          future: fetchTransactionFromDB(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(snapshot.data[index].name,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                          new Text(snapshot.data[index].customer,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          new Text("${snapshot.data[index].price_total}",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          new Divider()
                        ]);
                  });
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
