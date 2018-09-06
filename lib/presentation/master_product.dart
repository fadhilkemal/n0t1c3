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
  MasterProductState createState() => MasterProductState();
}

class MasterProductState extends State<MasterProduct> {
  final masterProductScaffoldKey = GlobalKey<ScaffoldState>();

//   void _showSnackBar(String text) {
//     masterProductScaffoldKey.currentState
//         .showSnackBar(SnackBar(content: Text(text)));
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
    return Scaffold(
      key: masterProductScaffoldKey,
      appBar: AppBar(
        title: Text('Product List'),
        leading: IconButton(
          icon: Icon(Icons.menu),
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
            // child: RaisedButton(
            //   //   onPressed: _submit,
            //   onPressed: _loadToCart,
            //   child: Text('^'),
            // ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: RaisedButton(
              //   onPressed: _submit,
              onPressed: _onConfirmTap2,
              child: Text('+'),
            ),
          ),
        ],
      ),
      //   drawer: Drawer(
      //     child: DrawerList(),
      //   ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Product>>(
          future: fetchEmployeesFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(snapshot.data[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                          Text(snapshot.data[index].description,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          Text("${snapshot.data[index].price}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          Divider()
                        ]);
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
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
