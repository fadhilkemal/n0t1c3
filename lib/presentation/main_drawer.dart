import 'package:flutter/material.dart';
import 'hidden/menu_screen.dart';
import 'hidden/restaurant_screen.dart';
import 'hidden/zoom_scaffold.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => new _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _selectedMenuItemId;
  @override
  void initState() {
    super.initState();
    // myTabs = List.generate(widget.categories.length, (index) {
    //   return Tab(text: widget.categories[index].toUpperCase());
    // });
    _selectedMenuItemId = '2';
  }

  final menu = new Menu(
    items: [
      new MenuItem(
        id: '1',
        title: 'Product List',
      ),
      new MenuItem(
        id: '2',
        title: 'Transaction',
      ),
    ],
  );

//   var selectedMenuItemId = '1';
  var activeScreen = restaurantScreen;

  @override
  Widget build(BuildContext context) {
    return new ZoomScaffold(
      selectedItemId: _selectedMenuItemId,
      contentScreen: activeScreen,
      menuScreen: new MenuScreen(
        menu: menu,
        selectedItemId: _selectedMenuItemId,
        onMenuItemSelected: (String itemId) {
          //   _selectedMenuItemId = itemId;
          setState(() => _selectedMenuItemId = itemId);
        },
      ),
    );
  }
}
