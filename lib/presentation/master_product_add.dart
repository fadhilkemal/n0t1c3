import 'package:flutter/material.dart';
import 'package:notice/models/product.dart';
import 'package:notice/database/dbhelper.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final formatter = NumberFormat.currency(
    symbol: "Rp ",
    locale: "id",
    decimalDigits: 0,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class MasterProductAdd extends StatefulWidget {
  @override
  MasterProductAddState createState() => new MasterProductAddState();
}

class MasterProductAddState extends State<MasterProductAdd> {
  final masterProductScaffoldAddKey = new GlobalKey<ScaffoldState>();
  CurrencyInputFormatter rpFormatter = CurrencyInputFormatter();

  String name;
  String description;
  String category;
  double price;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  void _showSnackBar(String text) {
    masterProductScaffoldAddKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      return null;
    }
    var product = Product(
      name: name,
      description: description,
      category: category,
      price: price,
    );
    var dbHelper = DBHelper();
    dbHelper.saveProduct(product);
    Navigator.pop(context);
    _showSnackBar("New Product saved successfully");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: masterProductScaffoldAddKey,
      appBar: new AppBar(
        title: new Text('Add New Product'),
      ),
      body: Container(
//   width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
//       stops: [0.0, 1.0],
//       tileMode: TileMode.clamp,
//     ),
//   ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.laptop_windows,
                      color: Colors.green,
                      size: 90.0,
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: formKey,
                    autovalidate: false,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(labelText: 'Product Name'),
                          validator: (val) =>
                              val.length == 0 ? "Enter Product Name" : null,
                          onSaved: (val) => this.name = val,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(labelText: 'Product Description'),
                          onSaved: (val) => this.description = val,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(labelText: 'Product Category'),
                          onSaved: (val) => this.category = val,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Price'),
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            rpFormatter
                          ],
                          onSaved: (val) {
                            this.price = val.isNotEmpty
                                ? rpFormatter.formatter.parse(val)
                                : 0.0;
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: Colors.blueAccent,
                            onPressed: _submit,
                            child: Text('Add'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
