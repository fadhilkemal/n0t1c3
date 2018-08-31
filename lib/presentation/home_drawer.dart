import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  DrawerList();

//   final Widget header;
//   final VoidCallback onTheaterTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          color: Colors.red,
          child: ListTile(
            onTap: () {
              //   Navigator.popAndPushNamed(context, '/masterProduct');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/masterProduct', (Route<dynamic> route) => false);
            },
            // selected: isSelected,
            title: Text("Product"),
          ),
        ),
        Material(
          color: Colors.red,
          child: ListTile(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
              //   Navigator.popAndPushNamed(context, '/');
            },
            title: Text("Transaction"),
          ),
        ),
      ],
    );
  }
}
