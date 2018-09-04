import 'package:flutter/material.dart';
import 'hidden/menu_screen.dart';
import 'hidden/zoom_scaffold.dart';

class MainDrawer extends StatefulWidget {
  final Function togglePerformanceOverlay;

  MainDrawer({
    Key key,
    this.togglePerformanceOverlay,
  }) : super(key: key);
  @override
  _MainDrawerState createState() => _MainDrawerState();
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

  final menu = Menu(
    items: [
      MenuItem(
        id: '1',
        title: 'Product List',
      ),
      MenuItem(
        id: '2',
        title: 'Transaction',
      ),
      MenuItem(
        id: '3',
        title: 'History',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ZoomScaffold(
      selectedItemId: _selectedMenuItemId,
      contentScreen: Screen(),
      menuScreen: MenuScreen(
        togglePerformanceOverlay: widget.togglePerformanceOverlay,
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
