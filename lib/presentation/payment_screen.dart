// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'money_masked.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'summary_screen.dart';
import 'payment_suggest.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/models/app_state.dart';
import 'package:notice/actions/actions.dart';
import 'package:notice/selectors/selectors.dart';

import 'dart:convert';
import 'package:notice/models/models.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class RupiahFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final double totalBill;
  final double discountValue;
  final double discountAmount;
  final double potonganHarga;

  PaymentScreen({
    Key key,
    @required this.totalBill,
    this.discountValue = 0.0,
    this.discountAmount = 0.0,
    this.potonganHarga = 0.0,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double _totalBill;
  double _totalPayment;
  double _kembalian;
  Widget _paymentSuggest;
  var controller = MoneyMaskedTextController(
    // leftSymbol: 'Rp ',
    initialValue: 0.0,
  );

  String _kodeStruk;

  @override
  void initState() {
    super.initState();
    _totalBill = widget.totalBill;
    _totalPayment = 0.0;
    _kembalian = 0.0;
    _paymentSuggest = PaymentSuggest(
      key: Key("paymentSuggestionWidget"),
      totalBill: _totalBill,
      calculateKembalian: _calculateKembalianKarenaSuggest,
    );
    // _kodeStruk = Uuid().generateV4().substring(0, 8);
    _kodeStruk = DateTime.now().hashCode.toString();
  }

  void _calcKembalianKarenaInput(input) {
    double val = controller.numberValue;
    if (val == null) {
      debugPrint("NULL");
    } else {
      setState(() {
        _kembalian = val - _totalBill;
        _totalPayment = val;
      });
    }
  }

  void _calculateKembalianKarenaSuggest(input) {
    setState(() {
      if (input is String) {
        _totalPayment = double.parse(input);
      } else {
        _totalPayment = input;
      }
      _kembalian = _totalPayment - _totalBill;
      controller.updateValue(_totalPayment);
    });
  }

  void _onConfirmTap(SaleOrder newTransaction) {
    if ((_kembalian >= 0.0) && (_totalPayment > 0.0)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SummaryScreen(
                totalBill: _totalBill,
                totalPayment: _totalPayment,
                totalKembalian: _kembalian,
                discountAmount: widget.discountAmount,
                discountValue: widget.discountValue,
                potonganHarga: widget.potonganHarga,
                kodeStruk: _kodeStruk,
                customerName: newTransaction.customer,
              ),
        ),
      );
    }
  }

  Widget _buildButtomBar(bool isOkay, String _kembalianFormatted) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return PaymentButton(
          callback: vm.onSaveTransaction,
          todos: vm.todos,
          customer: vm.customer,
          onConfirmTap: _onConfirmTap,
          isOkay: isOkay,
          kembalian: _kembalian,
          kembalianFormatted: _kembalianFormatted,
          totalBill: _totalBill,
          kodeStruk: _kodeStruk,
          discountAmount: widget.discountAmount,
          discountValue: widget.discountValue,
          potonganHarga: widget.potonganHarga,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("###,###.###", "pt-br");
    String _totalBillFormatted = formatter.format(_totalBill);
    String _kembalianFormatted = formatter.format(_kembalian);
    bool isOkay = (_kembalian >= 0.0) && (_totalPayment > 0.0);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Payment"),
        centerTitle: true,
      ),
      bottomNavigationBar: _buildButtomBar(isOkay, _kembalianFormatted),
      //   bottomNavigationBar: SizedBox(
      //     width: MediaQuery.of(context).size.width,
      //     height: 100.0,
      //     child: InkWell(
      //       onTap: _onConfirmTap,
      //       child: Material(
      //         color: isOkay ? Color(0xff08FEA6) : Color(0xffFC6548), //!GANTI
      //         child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: <Widget>[
      //               _kembalian < 0
      //                   ? Text('Rp $_kembalianFormatted')
      //                   : Container(),
      //               Icon(
      //                 Icons.done,
      //                 size: 40.0,
      //                 color:
      //                     isOkay ? Color(0xff9197ff) : Color(0xff000000), //!GANTI
      //               ),
      //             ]),
      //       ),
      //     ),
      //   ),
      body: Container(
        color: Color(0xFFfffbfd),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    "Jumlah Pembayaran",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color(0x23000000),
                          offset: Offset(0.0, 1.0),
                          blurRadius: 0.2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: Text('Rp $_totalBillFormatted',
                            style: TextStyle(
                              fontSize: 35.0,
                              color: Color(0xFF1F94E5), //!GANTI
                            )),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 38.0, left: 8.0),
                  child: Text(
                    "Tunai",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color(0x23000000),
                          offset: Offset(0.0, 1.0),
                          blurRadius: 0.2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: _paymentSuggest,
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 38.0, left: 8.0),
                //   child: Text(
                //     "Tunai",
                //     style: TextStyle(
                //       color: Colors.grey,
                //       fontSize: 11.0,
                //       fontWeight: FontWeight.w900,
                //     ),
                //   ),
                // ),
                Padding(
                  //   padding: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color(0x23000000),
                          offset: Offset(0.0, 1.0),
                          blurRadius: 0.2,
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin:
                              const EdgeInsets.only(left: 19.0, right: 19.0),
                          height: 57.0,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Cash",
                                style: TextStyle(
                                  fontSize: 13.0,
                                  letterSpacing: 0.92,
                                  color: const Color(0x99000000),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextField(
                                    autofocus: false,
                                    controller: controller,
                                    onChanged: _calcKembalianKarenaInput,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      letterSpacing: 0.92,
                                      color: const Color(0xFF000000),
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Masukkan jumlah pembayaran",
                                        prefixText: 'Rp\t',
                                        border: InputBorder.none),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  final Function callback;
  final Function onConfirmTap;
  final bool isOkay;
  final double kembalian;
  final String kembalianFormatted;
  final List<Todo> todos;
  final Customer customer;
  final double totalBill;
  final String kodeStruk;

  final double discountValue;
  final double discountAmount;
  final double potonganHarga;

  PaymentButton({
    Key key,
    @required this.callback,
    @required this.onConfirmTap,
    @required this.isOkay,
    @required this.kembalian,
    @required this.kembalianFormatted,
    @required this.todos,
    @required this.customer,
    @required this.totalBill,
    @required this.kodeStruk,
    this.discountValue = 0.0,
    this.discountAmount = 0.0,
    this.potonganHarga = 0.0,
  }) : super(key: key);

  void _onTap() {
    //Siapin Struktur transaksi dari Screen ini
    String payload = JsonEncoder().convert({
      'order_line': todos.map((todo) => todo.toEntity().toJson()).toList(),
    });
    DateTime datetimeNow = DateTime.now();
    // DateTime datetimeNow = DateTime.now().subtract(Duration(days: 11));
    SaleOrder newTransaction = SaleOrder(
      detail: payload,
      customer: customer != null ? customer.name : "",
      order_datetime: datetimeNow.toString().substring(0, 19),
      order_date: datetimeNow.toString().substring(0, 10),
      price_discount: discountAmount,
      pay_method: "Tunai",
      name: kodeStruk,
      // kembalian: 0.0,
      //   pay_amount: 0.0,
      price_total: totalBill,
    );

    onConfirmTap(newTransaction);
    callback(newTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      child: InkWell(
        onTap: _onTap,
        child: Material(
          color: isOkay ? Color(0xff08FEA6) : Color(0xffFC6548), //!GANTI
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                kembalian < 0 ? Text('Rp $kembalianFormatted') : Container(),
                Icon(
                  Icons.done,
                  size: 40.0,
                  color:
                      isOkay ? Color(0xff9197ff) : Color(0xff000000), //!GANTI
                ),
              ]),
        ),
      ),
    );
  }
}

class _ViewModel {
  final todos;
  final Customer customer;
  final Function onSaveTransaction;

  _ViewModel({
    @required this.todos,
    @required this.onSaveTransaction,
    @required this.customer,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      //   todos: store.state.todos,
      todos: filteredTodosSelectorActive(
        todosSelector(store.state),
      ),
      customer: store.state.customer,
      onSaveTransaction: (SaleOrder payload) {
        store.dispatch(SaveTransaction(payload));
      },
    );
  }
}
