import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentSuggest extends StatefulWidget {
  final double totalBill;
  final Function calculateKembalian;

  PaymentSuggest({
    Key key,
    @required this.totalBill,
    @required this.calculateKembalian,
  }) : super(key: key);

//   @override
//   PaymentSuggestState createState() {
//     return new PaymentSuggestState();
//   }
  @override
  PaymentSuggestState createState() => new PaymentSuggestState();
}

class PaymentSuggestState extends State<PaymentSuggest> {
  List collections;
  List collectionsToRender;
  double chosenValue;
  @override
  void initState() {
    super.initState();
    chosenValue = 0.0;
    collections = _generatePaymentSuggest(widget.totalBill);
    // List collections = [];

    collectionsToRender = [];
    for (var i = 0; i < collections.length; i += 3) {
      List pairSuggest = collections.skip(i).take(3).toList();
      collectionsToRender.add(pairSuggest);
    }
  }

  void _suggestionsClick(double elm) {
    widget.calculateKembalian(elm);
    setState(() {
      chosenValue = elm;
    });
  }

  Widget _buildRow(List pair) {
    while (pair.length < 3) {
      pair.add(0.0);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: pair.map(
              (elm) {
                if (elm == 0.0) {
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width / 3) - 20.0,
                    height: 40.0,
                    child: Container(),
                  );
                }
                final formatter = NumberFormat("###,###.###", "pt-br");
                String elmFormatted = formatter.format(elm);

                return InkWell(
                  onTap: () {
                    _suggestionsClick(elm);
                  },
                  child: SizedBox(
                      width: (MediaQuery.of(context).size.width / 3) - 20.0,
                      height: 45.0,
                      child: elm == chosenValue
                          ? Container(
                              alignment: Alignment.center,
                              // height: 124.0,
                              child: Text('$elmFormatted ',
                                  style: TextStyle(color: Colors.blue)
                                  //   overflow: TextOverflow.ellipsis,
                                  ),
                              margin: new EdgeInsets.all(6.0),
                              decoration: new BoxDecoration(
                                color: new Color(0xFFffffff),
                                shape: BoxShape.rectangle,
                                borderRadius: new BorderRadius.circular(41.0),
                                border: Border.all(color: Colors.blueAccent),
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              // height: 124.0,
                              child: Text(
                                ' $elmFormatted',
                                //   overflow: TextOverflow.ellipsis,
                              ),
                              margin: new EdgeInsets.all(6.0),
                              decoration: new BoxDecoration(
                                color: new Color(0xFFffffff),
                                shape: BoxShape.rectangle,
                                borderRadius: new BorderRadius.circular(41.0),
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 1.0,
                                    offset: new Offset(0.0, 1.0),
                                  ),
                                ],
                              ),
                            )),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRows(List collections) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: collections
          .map(
            (pair) => _buildRow(pair),
          )
          .toList(),
    );
  }

  List<double> _generatePaymentSuggest(double _totalBill) {
    List<int> paymentSuggestions = [];

    //Hitung kelipatan 1000
    var sisa1000 = _totalBill / 1000;
    if (sisa1000 % 1 > 0) {
      var sug1 = sisa1000.floor();
      paymentSuggestions.add(sug1 * 1000 + 1000);
      if ((sisa1000.floor() + 1) % 10 != 0) {
        paymentSuggestions.add(sug1 * 1000 + 2000);
      }
    } else {
      var sug1 = sisa1000.floor();
      paymentSuggestions.add(sug1 * 1000);
    }

    // Hitung kelipatan 5000
    var sisa5000 = _totalBill / 5000;
    if (sisa5000 % 1 > 0) {
      var sug1 = sisa5000.floor();
      paymentSuggestions.add(sug1 * 5000 + 5000);
    }

    //Hitung kelipatan 10000
    var sisa10000 = _totalBill / 10000;
    var sug10000 = sisa10000.floor();
    if (sisa10000 % 1 > 0) {
      paymentSuggestions.add(sug10000 * 10000 + 10000);
      if (sisa10000 % 5 < 1) {
        //jika dibawah 10.000, tambahin 20.000 jg
        //jika dibawah 20.000, tambahin 50.000 jg
        paymentSuggestions.add(sug10000 * 10000 + 20000);
      }
    } else {
      paymentSuggestions.add(sug10000 * 10000);
    }

    // //Tambahan 20.000 kalau kelipatan 150 ribu
    // if ((sug10000 % 5) == 0) {
    //     paymentSuggestions.add(sug10000 * 10000 + 20000);
    // }

    //Jika masih dibawah 20.000, tambahin 20.000
    if (sug10000 * 10000 < 20000) {
      paymentSuggestions.add(20000);
    }

    if ((sug10000 * 10000 + 10000) < 50000) {
      paymentSuggestions.add(50000);
      paymentSuggestions.add(100000);
    } else if ((sug10000 * 10000 + 10000) < 100000) {
      paymentSuggestions.add(100000);
    }

    // Hitung kelipatan 50000
    var sisa50000 = _totalBill / 50000;
    if (sisa50000 % 1 > 0) {
      var sug1 = sisa50000.floor();
      paymentSuggestions.add(sug1 * 50000 + 50000);
    }

    //Hitung kelipatan 100000
    var sisa100000 = _totalBill / 100000;
    if (sisa100000 % 1 > 0) {
      var sug1 = sisa100000.floor();
      paymentSuggestions.add(sug1 * 100000 + 100000);
    } else {
      var sug1 = sisa100000.floor();
      paymentSuggestions.add(sug1 * 100000);
    }

    return paymentSuggestions.toSet().map((x) => x * 1.0).toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    // collections = _generatePaymentSuggest(widget.totalBill);
    // // List collections = [];

    // collectionsToRender = [];
    // for (var i = 0; i < collections.length; i += 3) {
    //   List pairSuggest = collections.skip(i).take(3).toList();
    //   collectionsToRender.add(pairSuggest);
    // }
    return Container(child: _buildRows(collectionsToRender));
  }
}
