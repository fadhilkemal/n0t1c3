import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
// import 'package:intl/intl.dart';

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
  final double totalKembalian;

  SummaryScreen({
    Key key,
    @required this.totalBill,
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
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("Summary"),
        // title: Text("> ${_totalPayment} : ${_kembalian}"),
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
                        Icons.check_circle,
                        size: 150.0,
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
                              "Rp 3.400.000",
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
                              "Rp 600.000",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 30.0),
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text("Check Button"),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: TextField(),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.email,
                          size: 35.0,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(40.0),
                    child: Form(
                      autovalidate: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Enter Email",
                                fillColor: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Enter Password",
                            ),
                            obscureText: true,
                            keyboardType: TextInputType.text,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                          ),
                          MaterialButton(
                            height: 50.0,
                            minWidth: 150.0,
                            color: Colors.green,
                            splashColor: Colors.teal,
                            textColor: Colors.white,
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                                'Through the night, we have one shot to live anot her day'),
                            Text('We cannot let a stray gunshot give us away'),
                            Text(
                                'We will fight up close, seize the moment and stay in it'),
                            Text(
                                'It’s either that or meet the business end of a bayonet'),
                            Text('The code word is ‘Rochambeau,’ dig me?'),
                            Text('Rochambeau!',
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 0.2)),
                          ],
                        ),
                      )
                      //   TextField(
                      //     textAlign: TextAlign.left,
                      //     decoration: InputDecoration(
                      //         hintText: "Enter Something",
                      //         contentPadding: const EdgeInsets.all(20.0)),
                      //   ),
                      //   Text("SMS Receipt"),
                      //   Flexible(
                      //     child: TextField(),
                      //   ),
                      //   InkWell(
                      //     onTap: () {
                      //     },
                      //     child: Icon(
                      //       Icons.smartphone,
                      //       size: 35.0,
                      //     ),
                      //   )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {},
                        child: Text("Button"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
