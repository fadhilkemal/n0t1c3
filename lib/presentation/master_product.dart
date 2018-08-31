import 'package:flutter/material.dart';
import 'package:notice/models/product.dart';
import 'dart:async';
import 'package:notice/database/dbhelper.dart';
import 'package:notice/presentation/master_product_add.dart';
import 'package:notice/containers/load_product.dart';
import 'package:notice/models/models.dart';

Future<List<Product>> fetchEmployeesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<Product>> employees = dbHelper.getProducts();
  return employees;
}

class MasterProduct extends StatefulWidget {
  final Function openDrawer;

  MasterProduct({
    this.openDrawer,
  });
  @override
  MasterProductState createState() => new MasterProductState();
}

class MasterProductState extends State<MasterProduct> {
  final masterProductScaffoldKey = new GlobalKey<ScaffoldState>();

//   void _showSnackBar(String text) {
//     masterProductScaffoldKey.currentState
//         .showSnackBar(new SnackBar(content: new Text(text)));
//   }

  void _onConfirmTap2() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MasterProductAdd(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: masterProductScaffoldKey,
      appBar: new AppBar(
        title: new Text('Product List'),
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
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: LoadProduct(),
            // child: new RaisedButton(
            //   //   onPressed: _submit,
            //   onPressed: _loadToCart,
            //   child: new Text('^'),
            // ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: new RaisedButton(
              //   onPressed: _submit,
              onPressed: _onConfirmTap2,
              child: new Text('+'),
            ),
          ),
        ],
      ),
      //   drawer: Drawer(
      //     child: DrawerList(),
      //   ),
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new FutureBuilder<List<Product>>(
          future: fetchEmployeesFromDatabase(),
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
                          new Text(snapshot.data[index].description,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          new Text("${snapshot.data[index].price}",
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
