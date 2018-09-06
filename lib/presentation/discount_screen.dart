// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'money_masked.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:notice/presentation/payment_screen.dart';

class PercentInputFormatter extends TextInputFormatter {
//   final formatter = NumberFormat("###.0#", "en_US");
  final formatter = NumberFormat();
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    double value;
    var blackList = RegExp(r'([\,-\s])');
    bool blackListValue = blackList.hasMatch(newValue.text);
    if (blackListValue) {
      //jika terdapat karakter yg tidak diinginkan, langsung return
      return oldValue;
    }
    //jika terdapat karakter . sebanyak dua kali , langsung return
    try {
      value = double.parse(newValue.text);
      if (value >= 100.0) {
        return newValue.copyWith(
          text: "100",
          selection: new TextSelection.collapsed(offset: 3),
        );
      }
      var eja = newValue.text.split(".");
      if (eja.last.length > 2) {
        return oldValue;
      }
      return newValue;
    } catch (e) {
      return oldValue;
    }
  }
}

TextInputFormatter percentFormatter = PercentInputFormatter();

class DiscountScreen extends StatefulWidget {
  final bool isEditing;
  final double totalBill;
  final Function onSave;

  DiscountScreen({
    Key key,
    @required this.totalBill,
    @required this.onSave,
    @required this.isEditing,
  }) : super(key: key);

  @override
  _DiscountScreenState createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  double _totalBill;
  double _newTotalBill;
  double _discountValue;
  double _discountAmount;
  var controller = MoneyMaskedTextController(
    // leftSymbol: 'Rp ',
    initialValue: 0.0,
  );

  TextEditingController discountInput = TextEditingController();

  void onChangeDiscountInput() {
    String text = discountInput.text;
    double discountValue;
    if (text.length > 0) {
      discountValue = double.parse(text);
    } else {
      discountValue = 0.0;
    }

    setState(() {
      _discountAmount = (discountValue * _totalBill / 100);
      _newTotalBill = _totalBill - (discountValue * _totalBill / 100);
      _discountValue = discountValue;
      controller.clear();
    });
  }

  void onChangePotonganInput(input) {
    double potonganInput = controller.numberValue;
    if (potonganInput == null) {
      debugPrint("NULL");
    } else {
      setState(() {
        _discountAmount = potonganInput;
        _newTotalBill = _totalBill - potonganInput;
        _discountValue = 0.0;

        discountInput.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _totalBill = widget.totalBill;
    _newTotalBill = widget.totalBill;
    _discountValue = 0.0;
    _discountAmount = 0.0;
    discountInput.addListener(onChangeDiscountInput);
  }

  void _onConfirmTap() {
    if (_discountAmount > _totalBill) {
      //Jumlah discount tidak boleh lebih dari totalBill
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
              totalBill: _newTotalBill,
              discountAmount: _discountAmount,
              discountValue: _discountValue,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rpFormatter = NumberFormat("###,###.###", "pt-br");
    String _totalBillFormatted = rpFormatter.format(_totalBill);
    String _newTotalBillFormatted = rpFormatter.format(_newTotalBill);
    String _discountAmountFormatted = rpFormatter.format(_discountAmount);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Discount"),
        centerTitle: true,
      ),
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: InkWell(
          onTap: _onConfirmTap,
          child: Material(
            color: Color(0xff08FEA6), //!GANTI
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.done,
                    size: 40.0,
                    color: Color(0xff9197ff), //!GANTI
                  ),
                ]),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFfffbfd),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                    height: 58.0,
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
                                "Discount",
                                style: TextStyle(
                                  fontSize: 13.0,
                                  letterSpacing: 0.92,
                                  color: const Color(0x99000000),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextFormField(
                                    autofocus: false,
                                    controller: discountInput,
                                    inputFormatters: [
                                      percentFormatter,
                                    ],
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      letterSpacing: 0.92,
                                      color: const Color(0xFF000000),
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: "0.00",
                                      prefixText: '(%)\t',
                                      border: InputBorder.none,
                                    ),
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
                    height: 58.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.only(left: 19.0, right: 19.0),
                          height: 57.0,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Potongan Harga",
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
                                    onChanged: onChangePotonganInput,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      letterSpacing: 0.92,
                                      color: const Color(0xFF000000),
                                    ),
                                    decoration: InputDecoration(
                                        filled: true,
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
                // Expanded(
                //   child: Container(),
                // ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    "Tagihan",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
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
                    // height: 58.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  width: 0.0, color: Color(0x00FFDFDFDF)),
                              bottom: BorderSide(
                                  width: 0.0, color: Color(0x00FFDFDFDF)),
                            ),
                          ),
                          padding:
                              const EdgeInsets.only(left: 19.0, right: 19.0),
                          height: 57.0,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Subtotal",
                                style: TextStyle(
                                  fontSize: 13.0,
                                  letterSpacing: 0.92,
                                  color: const Color(0x99000000),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    "Rp $_totalBillFormatted",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      letterSpacing: 0.92,
                                      color: const Color(0xFF000000),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  width: 0.0, color: Color(0x00FFDFDFDF)),
                              bottom: BorderSide(
                                  width: 0.0, color: Color(0x00FFDFDFDF)),
                            ),
                          ),
                          padding:
                              const EdgeInsets.only(left: 19.0, right: 19.0),
                          height: 57.0,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Discount",
                                style: TextStyle(
                                  fontSize: 13.0,
                                  letterSpacing: 0.92,
                                  color: const Color(0xff1F94E5),
                                  //   color: const Color(0x99000000),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    "- Rp $_discountAmountFormatted",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      letterSpacing: 0.92,
                                      color: const Color(0xFF000000),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  width: 0.0, color: Color(0x00FFDFDFDF)),
                              bottom: BorderSide(
                                  width: 0.0, color: Color(0x00FFDFDFDF)),
                            ),
                          ),
                          padding:
                              const EdgeInsets.only(left: 19.0, right: 19.0),
                          height: 57.0,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 13.0,
                                  letterSpacing: 0.92,
                                  color: const Color(0x99000000),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    "Rp $_newTotalBillFormatted",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      letterSpacing: 0.92,
                                      color: const Color(0xFF000000),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
