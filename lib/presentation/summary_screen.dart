import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:notice/actions/actions.dart';
import 'package:notice/models/models.dart';

// class SummaryScreen extends StatelessWidget {
//   final double totalBill;
//   final double totalKembalian;

//   SummaryScreen({
//     Key key,
//     @required this.totalBill,
//     @required this.totalKembalian,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Summary"),
//         // title: Text("> ${_totalPayment} : ${_kembalian}"),
//       ),
//       body: Container(
//         child: Text("${totalBill}, $totalKembalian"),
//       ),
//     );
//   }
// }

class SummaryScreen extends StatefulWidget {
  final double totalBill;
  final double totalPayment;
  final double totalKembalian;

  SummaryScreen({
    Key key,
    @required this.totalBill,
    @required this.totalPayment,
    @required this.totalKembalian,
  }) : super(key: key);
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Color gradientStart = Colors.deepPurple[700];
  Color gradientEnd = Colors.purple[500];
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("###,###.###", "pt-br");
    String _totalPaymentFormatted = formatter.format(widget.totalPayment);
    String _kembalianFormatted = formatter.format(widget.totalKembalian);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("Summary"),
        leading: StoreConnector<AppState, Function>(
          converter: (Store<AppState> store) {
            return () {
              store.dispatch(ClearCompletedAction());
              // store.dispatch(LoadTodosAction());
            };
          },
          builder: (BuildContext context, Function onSave) {
            return IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                onSave();

                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
            );
          },
        ),
      ),
      body: Container(
          //   width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [gradientStart, gradientEnd],
          //       begin: const FractionalOffset(0.5, 0.0),
          //       end: const FractionalOffset(0.0, 0.5),
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
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 90.0,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("23424 082120018 0003"),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //   mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text("Total Paid"),
                            Text(
                              "Rp $_totalPaymentFormatted",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text("Total Change"),
                            Text(
                              "Rp $_kembalianFormatted",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    child: Container(
                      child: Material(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(114.0),
                          right: Radius.circular(114.0),
                        ),
                        child: MaterialButton(
                          height: 50.0,
                          color: Colors.yellow[800],
                          textColor: Colors.white,
                          onPressed: () {},
                          child: Text("Send to Kitchen"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Form(
                      autovalidate: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Enter Email",
                                      fillColor: Colors.white),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(100.0),
                                color: Colors.blue,
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.email,
                                      size: 25.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Enter Phone Number",
                                      fillColor: Colors.white),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(100.0),
                                color: Colors.blue,
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.smartphone,
                                      size: 25.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(114.0),
                                      right: Radius.circular(114.0),
                                    ),
                                    child: MaterialButton(
                                      height: 50.0,
                                      minWidth: 150.0,
                                      color: Colors.blue,
                                      splashColor: Colors.blueAccent,
                                      textColor: Colors.white,
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.print),
                                          Text("Print Receipt"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Material(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(114.0),
                                    right: Radius.circular(114.0),
                                  ),
                                  child: StoreConnector<AppState, Function>(
                                    converter: (Store<AppState> store) {
                                      return () {
                                        store.dispatch(ClearCompletedAction());
                                        // store.dispatch(LoadTodosAction());
                                      };
                                    },
                                    builder: (BuildContext context,
                                        Function onSave) {
                                      return MaterialButton(
                                        height: 50.0,
                                        minWidth: 100.0,
                                        color: Colors.green,
                                        splashColor: Colors.teal,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          onSave();

                                          Navigator.of(context).popUntil(
                                              ModalRoute.withName('/'));
                                        },
                                        child: Row(children: <Widget>[
                                          Icon(Icons.add),
                                          Text("New"),
                                        ]),
                                      );
                                    },
                                  ),
                                  //   child: MaterialButton(
                                  //     height: 50.0,
                                  //     minWidth: 100.0,
                                  //     color: Colors.green,
                                  //     splashColor: Colors.teal,
                                  //     textColor: Colors.white,
                                  //     onPressed: () {
                                  //       Navigator.pop(context);
                                  //     },
                                  //     child: Row(children: <Widget>[
                                  //       Icon(Icons.add),
                                  //       Text("New"),
                                  //     ]),
                                  //   ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
