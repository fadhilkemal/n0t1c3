import 'package:flutter/material.dart';

import 'package:notice/models/customer.dart';
import 'dart:async';
import 'package:notice/database/dbhelper.dart';
import 'package:flutter/services.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/models/models.dart';
import 'package:notice/actions/actions.dart';

class CustomerDialog extends StatelessWidget {
  final Function() onTap;
  CustomerDialog({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      //   content: AddNewCustomer(),
      content: DefaultTabController(
        length: 2,
        child: Container(
          width: 260.0,
          //   height: 230.0,
          //   padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  child: TabBar(
                    tabs: [
                      Tab(text: "Baru"),
                      Tab(text: "Member"),
                    ],
                  ),
                ),
                Container(
                  width: 260.0,
                  height: 230.0,
                  child: TabBarView(
                    children: [
                      AddNewCustomer(callbackDialog: onTap),
                      ExistingCustomer(callbackDialog: onTap),
                    ],
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

Future<int> addNewCustomerToDb(Customer customer) async {
  var dbHelper = DBHelper();
  int customerId = await dbHelper.saveCustomer(customer);
  return customerId;
}

class AddNewCustomer extends StatefulWidget {
  final Function() callbackDialog;
  AddNewCustomer({
    this.callbackDialog,
  });

  @override
  AddNewCustomerState createState() {
    return new AddNewCustomerState();
  }
}

class AddNewCustomerState extends State<AddNewCustomer> {
  final formKey = GlobalKey<FormState>();
  final _IndoNumberTextInputFormatter _phoneNumberFormatter =
      new _IndoNumberTextInputFormatter();

  String _customerName;
  String _customerPhone;

  Widget _buildButtonButtom(Function dispatchCustomer) {
    void _tambahCustomer() async {
      if (this.formKey.currentState.validate()) {
        formKey.currentState.save();
      } else {
        return null;
      }
      Customer newCustomer =
          Customer(name: _customerName, phone: _customerPhone);
      int customerId = await addNewCustomerToDb(newCustomer);
      dispatchCustomer(Customer(
        name: _customerName,
        id: customerId,
      ));
      widget.callbackDialog();
    }

    return InkWell(
      splashColor: Colors.red,
      onTap: _tambahCustomer,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF33b17c),
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Tambah Customer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontFamily: 'helvetica_neue_light',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.0,
      padding: EdgeInsets.all(0.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: 'helvetica_neue_light',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      //   controller: controller,
                      onSaved: (val) => this._customerName = val,

                      validator: (val) => val.length == 0 ? "Enter Name" : null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      'No HP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: 'helvetica_neue_light',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      onSaved: (val) => this._customerPhone = val,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        _phoneNumberFormatter,
                      ],
                      validator: (val) =>
                          val.length == 0 ? "Enter Phone" : null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                        hintText: '0812-xxx-xxx',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Button Buttom
            StoreConnector<AppState, Function>(
              converter: (Store<AppState> store) {
                return (Customer customer) {
                  store.dispatch(UpdateCustomer(customer));
                };
              },
              builder: (BuildContext context, Function dispatchCustomer) {
                return _buildButtonButtom(dispatchCustomer);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Customer>> fetchEmployeesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<Customer>> employees = dbHelper.getCustomer();
  return employees;
}

class CustomerItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final customer;

  CustomerItem({
    @required this.onTap,
    @required this.customer,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(customer.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            Text("${customer.phone}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
            Divider()
          ]),
    );
  }
}

class ExistingCustomer extends StatelessWidget {
  final Function() callbackDialog;
  ExistingCustomer({
    this.callbackDialog,
  });
  Widget _buildListCustomer(Function dispatchCustomer) {
    void _pilihCustomer(customer) {
      dispatchCustomer(customer);
      this.callbackDialog();
    }

    return Container(
      //   padding: EdgeInsets.all(16.0),
      child: FutureBuilder<List<Customer>>(
        future: fetchEmployeesFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final customer = snapshot.data[index];
                return CustomerItem(
                  onTap: () {
                    _pilihCustomer(customer);
                  },
                  customer: customer,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Container(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function>(
      converter: (Store<AppState> store) {
        return (Customer customer) {
          store.dispatch(UpdateCustomer(customer));
        };
      },
      builder: (BuildContext context, Function dispatchCustomer) {
        return _buildListCustomer(dispatchCustomer);
      },
    );
  }
}

class _IndoNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 4) + '-');
      if (newValue.selection.end >= 4) selectionIndex++;
    }
    if (newTextLength >= 9) {
      newText.write(newValue.text.substring(4, usedSubstringIndex = 8) + '-');
      if (newValue.selection.end >= 8) selectionIndex++;
    }
    if (newTextLength >= 13) {
      newText.write(newValue.text.substring(8, usedSubstringIndex = 12) + ' ');
      if (newValue.selection.end >= 12) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
