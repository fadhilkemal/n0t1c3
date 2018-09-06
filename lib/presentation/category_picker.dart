import 'package:flutter/material.dart';
import 'dart:async';

import 'package:notice/containers/filter_selector.dart';
import 'package:notice/containers/add_todo.dart';

class CategoryPicker extends StatelessWidget {
  final Function onCategorySelected;
  final String categoryPicker;

  CategoryPicker({
    Key key,
    this.onCategorySelected,
    this.categoryPicker,
  }) : super(key: key);

  Widget _buildButton(categoryName) {
    return RaisedButton(
      child: Text(
        "$categoryName",
        style: categoryName == categoryPicker
            ? TextStyle(color: Color(0xff1abc9c))
            : TextStyle(color: Color(0xff3498db)),
      ),
      onPressed: () {
        onCategorySelected(categoryName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = ["Umum", "Paket", "Jantung", "Alkes", "Diabetes"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            category.map((categoryName) => _buildButton(categoryName)).toList(),
      ),
    );
  }
}

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({
    Key key,
    this.onCategorySelected,
    this.onSearchClosed,
    this.onQueryFilter,
    this.categories,
  }) : super(key: key);

  final Function onCategorySelected;
  final Function onSearchClosed;
  final Function onQueryFilter;
  final List categories;

  @override
  _MyTabbedPageState createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage>
    with SingleTickerProviderStateMixin {
  final tabBarKey = new GlobalKey<_MyTabbedPageState>();

//   final List<Tab> myTabs2 = <Tab>[
//     Tab(text: 'LEFT'),
//     Tab(text: 'RIGHT'),
//   ];
  Function _onCategorySelected;
  Function _onQueryFilter;
  final searchInput = TextEditingController();

  TabController _tabController;
//   final List categories = ["Umum", "Paket", "Jantung", "Alkes", "Diabetes"];

  List<Tab> myTabs;
  int _screen = 0;
  int _screenFilter = 0;
  Timer _timeDilationTimer;
  @override
  void initState() {
    super.initState();
    // myTabs = List.generate(widget.categories.length, (index) {
    //   return Tab(text: widget.categories[index].toUpperCase());
    // });
    _onCategorySelected = widget.onCategorySelected;
    _onQueryFilter = widget.onQueryFilter;
    _tabController = TabController(
      vsync: this,
      //   length: myTabs.length,
      length: 30,
    );
    VoidCallback onChanged = () {
      _onCategorySelected(widget.categories[this._tabController.index]);
    };

    _tabController.addListener(onChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchInput.dispose();
    // _timeDilationTimer?.cancel();
    widget.onSearchClosed();

    super.dispose();
  }

  List<Widget> _buildTabs() {
    return List.generate(widget.categories.length, (index) {
      return Tab(
        text: widget.categories[index].toUpperCase(),
        // child: Text(
        //   widget.categories[index].toUpperCase(),
        //   style: TextStyle(
        //     color: Color(0xff2F72FC), //!GANTI
        //     // fontSize: 11.0,
        //   ),
        // ),
      );
    });
  }

  Widget _buildFirstChild() {
    if (widget.categories.isNotEmpty) {
      return TabBar(
        key: tabBarKey,
        isScrollable: true,
        controller: _tabController,
        tabs: _buildTabs(),
        labelColor: Color(0xff1F94E5),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color(0xff1F94E5),
        // indicatorColor: Colors.red,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2.0,
        indicatorPadding: EdgeInsets.symmetric(horizontal: 11.0, vertical: 7.0),
      );
    } else {
      return Container();
    }
  }

  void searchInputChanged(String input2) {
    main() {
      const jeda = const Duration(milliseconds: 1200);
      _timeDilationTimer?.cancel();
      _timeDilationTimer = null;

      _timeDilationTimer = new Timer(jeda, () {
        _onQueryFilter(input2);
      });
      //harus dibawah timeDilation Timer. langsung ke dispatch soalnya
      _onQueryFilter("");
    }

    main();
  }

  Widget _buildPesanan() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 7.0),
            child: Text(
              "PESANAN",
              style: TextStyle(
                color: Color(0xff1F94E5),
                fontWeight: FontWeight.w500,
              ),
            ),
            decoration: UnderlineTabIndicator(
              insets: EdgeInsets.symmetric(
                horizontal: 11.0,
              ),
              borderSide: new BorderSide(
                width: 2.0,
                color: Color(0xff1F94E5),
              ),
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddTodo(),
                  ),
                );
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSecondChild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Container(
            child: TextField(
              controller: searchInput,
              onChanged: searchInputChanged,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff1F94E5), width: 2.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: BorderSide(color: Colors.grey, width: 0.0),
                ),
                hintText: 'Search',
                // hintStyle: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
        Container(
          child: IconButton(
            onPressed: () {
              widget.onSearchClosed();
              //supaya kalau udah keketik, di cancel timer searchingnya
              _timeDilationTimer?.cancel();

              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                _screen = 0;
                searchInput.clear();
              });
            },
            icon: new Icon(Icons.close),
          ),
        ),
      ],
    );
  }

  Widget _buildAll() {
    return _screenFilter == 0
        ? Row(
            children: <Widget>[
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: _screen == 1 ? Color(0xff1F94E5) : null,
                  ),
                  onPressed: () {
                    setState(() {
                      _screen = 1;
                    });
                  },
                ),
              ),
              Expanded(
                child: AnimatedCrossFade(
                  key: Key("value"),
                  firstChild: _buildFirstChild(),
                  secondChild: _buildSecondChild(),
                  crossFadeState: _screen == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _buildWrapper() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          child: FilterSelector(
            // key: Key("value27"),
            visible: true,
            allFilter: (filter) {
              setState(() {
                _screenFilter = filter;
              });
            },
          ),
        ),
        Expanded(
          child: AnimatedCrossFade(
            key: Key("value2"),
            firstChild: _buildAll(),
            secondChild: _buildPesanan(),
            crossFadeState: _screenFilter == 0
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWrapper();
  }
}

class TabBaruNew extends StatefulWidget {
  @override
  _TabBaruNewState createState() => _TabBaruNewState();
}

class _TabBaruNewState extends State<TabBaruNew> {
  @override
  void initState() {
    super.initState();
    // myTabs = List.generate(widget.categories.length, (index) {
    //   return Tab(text: widget.categories[index].toUpperCase());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("asa"));
  }
}
