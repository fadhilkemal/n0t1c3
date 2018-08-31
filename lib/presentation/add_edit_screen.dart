// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notice/fas_copy/flutter_architecture_samples.dart';
import 'package:notice/models/models.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

typedef OnSaveCallback = Function(dynamic);

class AddEditScreen extends StatefulWidget {
  final Function(Todo) onSave;

  AddEditScreen({
    Key key,
    @required this.onSave,
  }) : super(key: key ?? ArchSampleKeys.addTodoScreen);

  @override
  AddEditScreenState createState() {
    return AddEditScreenState();
  }
}

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
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class AddEditScreenState extends State<AddEditScreen> {
  final formKey = GlobalKey<FormState>();

  String name;

  String description;

  String category;

  double price;
  int quantity = 1;

  CurrencyInputFormatter rpFormatter = CurrencyInputFormatter();

  void _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
      Todo eja = Todo(
        this.name,
        price: this.price,
        quantity: this.quantity,
        category: "Xitem",
        complete: true, //x item
      );
      widget.onSave(eja);
    } else {
      return null;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add X Item"),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _submit,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  hintText: "misal : Biaya Kirim",
                ),
                validator: (val) =>
                    val.length == 0 ? "Enter Product Name" : null,
                onSaved: (val) => this.name = val,
                autofocus: true,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity'),
                onSaved: (val) =>
                    this.quantity = val.isNotEmpty ? int.parse(val) : 0,
                validator: (val) => val.length == 0 ? "Quantity min. 1" : null,
                initialValue: "1",
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  rpFormatter
                ],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                initialValue: "0",
                onSaved: (val) {
                  this.price =
                      val.isNotEmpty ? rpFormatter.formatter.parse(val) : 0.0;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
