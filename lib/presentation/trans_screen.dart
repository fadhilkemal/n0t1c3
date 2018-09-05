import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notice/database/dbhelper.dart';
import 'package:notice/models/models.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'trans_detail.dart';

Future<Map> fetchTransactionFromDB() async {
  var dbHelper = DBHelper();
  Future transactions = dbHelper.getSaleOrders();
  return transactions;
}

final rpFormatter = NumberFormat("###,###.###", "pt-br");

class TransScreen extends StatefulWidget {
  final Function openDrawer;

  TransScreen({
    this.openDrawer,
  });
  @override
  TransScreenState createState() => TransScreenState();
}

class TransScreenState extends State<TransScreen> {
  List<Widget> _buildSlivers(
    BuildContext context,
    List headers,
    List<SaleOrder> order_data,
  ) {
    List<Widget> slivers = List<Widget>();
    int i = 0;
    // for (final header in headers) {
    //   List<SaleOrder> filtered_order = order_data
    //       .where((order) => order.order_date == header['order_date'])
    //       .toList();
    //   slivers
    //       .addAll(_buildLists(context, i, i += 1, 3, header, filtered_order));
    // }

    for (int index = 0; index < headers.length; index++) {
      var header = headers[index];
      List<SaleOrder> filtered_order = order_data
          .where((order) => order.order_date == header['order_date'])
          .toList();
      slivers.addAll(_buildLists(context, i, 1, 3, header, filtered_order));
    }
    // slivers.addAll(_buildLists(context, i, i += 2, 4));
    return slivers;
  }

  List<Widget> _buildLists(BuildContext context, int firstIndex, int count,
      int children_count, header, order_data) {
    return List.generate(count, (sliverIndex) {
      sliverIndex += firstIndex;
      return SliverStickyHeader(
        header: _buildHeader(sliverIndex, header),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildList(order_data[index]);
            },
            childCount: order_data.length,
          ),
        ),
      );
    });
  }

  Widget _buildList(SaleOrder order) {
    String _priceTotalFormatted = rpFormatter.format(order.price_total);

    final leftSection = CircleAvatar(
      child: Icon(Icons.attach_money),
    );
    final middleSection = new Expanded(
      child: Container(
        padding: new EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text(
              "${order.name}",
              style: new TextStyle(
                color: Color(0xff144e76), //!GANTI
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
            new Text(
              //   "Rp ${order.price_total}",
              "Rp ${_priceTotalFormatted}",
              style: new TextStyle(
                // color: Color(0xff2F72FC), //!GANTI
                color: Color(0x0af144e76), //!GANTI
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            // new Text(
            //   "${todo.category}",
            //   style: new TextStyle(
            //     color: Color(0x00000000),
            //     fontSize: 10.0,
            //   ),
            // ),
          ],
        ),
      ),
    );

    final rightSection = Container(
      child: Padding(
        padding: new EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text(
              "${order.pay_method}",
              style: new TextStyle(
                color: Color(0xff144e76), //!GANTI
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
            new Text(
              "${order.order_datetime.substring(11, 16)}",
              style: new TextStyle(
                // color: Color(0xff2F72FC), //!GANTI
                color: Color(0x0af144e76), //!GANTI
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            // new Text(
            //   "${todo.category}",
            //   style: new TextStyle(
            //     color: Color(0x00000000),
            //     fontSize: 10.0,
            //   ),
            // ),
          ],
        ),
      ),
    );

    return ListTile(
      leading: leftSection,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TransDetailScreen(orderId: order.id),
            fullscreenDialog: true,
          ),
        );
      },
      //   title: Text('${order.name}'),
      title: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        height: 70.0,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            // leftSection,
            middleSection,
            rightSection,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int index, header) {
    String _priceTotalFormatted = rpFormatter.format(header['price_total']);

    return Row(
      children: <Widget>[
        Container(
          height: 60.0,
          color: Colors.lightBlue,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            header['order_date'],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: Container(
            height: 60.0,
            color: Colors.lightBlue,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerRight,
            child: Text(
              "Rp ${_priceTotalFormatted}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
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
        ],
      ),
      //   drawer: Drawer(
      //     child: DrawerList(),
      //   ),
      body: FutureBuilder<Map>(
          future: fetchTransactionFromDB(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List header_data = snapshot.data['header'];
              List<SaleOrder> order_data = snapshot.data['order'];
              return CustomScrollView(
                slivers: _buildSlivers(context, header_data, order_data),
              );
            } else {
              return Container();
            }
          }),
      //   body: Container(
      //     padding: EdgeInsets.all(16.0),
      //     child: FutureBuilder<List<SaleOrder>>(
      //       future: fetchTransactionFromDB(),
      //       builder: (context, snapshot) {
      //         if (snapshot.hasData) {
      //           return ListView.builder(
      //               itemCount: snapshot.data.length,
      //               itemBuilder: (context, index) {
      //                 return Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: <Widget>[
      //                       Text(snapshot.data[index].name,
      //                           style: TextStyle(
      //                               fontWeight: FontWeight.bold, fontSize: 18.0)),
      //                       Text(snapshot.data[index].customer,
      //                           style: TextStyle(
      //                               fontWeight: FontWeight.bold, fontSize: 14.0)),
      //                       Text("${snapshot.data[index].price_total}",
      //                           style: TextStyle(
      //                               fontWeight: FontWeight.bold, fontSize: 14.0)),
      //                       Divider()
      //                     ]);
      //               });
      //         } else if (snapshot.hasError) {
      //           return Text("${snapshot.error}");
      //         }
      //         return Container(
      //           alignment: AlignmentDirectional.center,
      //           child: CircularProgressIndicator(),
      //         );
      //       },
      //     ),
      //   ),
    );
  }
}
