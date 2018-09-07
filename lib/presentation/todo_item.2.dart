// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notice/fas_copy/flutter_architecture_samples.dart';
import 'package:notice/models/models.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoItem extends StatefulWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final GestureTapCallback onMinusTap;
  final GestureTapCallback onZeroTap;
  final ValueChanged<bool> onCheckboxChanged;
  final Todo todo;

  TodoItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onMinusTap,
    @required this.onZeroTap,
    @required this.onCheckboxChanged,
    @required this.todo,
  });

  @override
  TodoItemState createState() {
    return new TodoItemState();
  }
}

class TodoItemState extends State<TodoItem> {
  int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = 0;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("###,###.###", "pt-br");
    String priceFormatted = formatter.format(widget.todo.price);

    final leftSection = Container(
      child: CircleAvatar(
        // backgroundImage: NetworkImage('assets/images/employee.png'),0xFFffa749
        // backgroundColor: Color(0xFF5023FE),
        // backgroundColor: Color(0xFF1F94E5),
        backgroundColor: Color(0x0FF8fe0fe),
        radius: 24.0,
        child: Text(
          //   "${widget.todo.quantity}",
          "${_quantity}",
          style: TextStyle(color: Color(0xFF1F94E5)),
        ),
      ),
    );

    final middleSection = new Expanded(
      child: Container(
        padding: new EdgeInsets.only(left: 18.0, bottom: 10.0, top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text(
              "${widget.todo.task}",
              style: new TextStyle(
                color: Color(0xff144e76), //!GANTI
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
            new Text(
              "Rp $priceFormatted",
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
              onTap: widget.onMinusTap,
              child: CircleAvatar(
                // backgroundColor: Color(0x0FFDFDFDF),//!GANTI
                backgroundColor: Color(0x0FFdbdedd),
                radius: 24.0,
                child: new Text(
                  "-",
                  style: new TextStyle(
                    // color: Colors.white, //!GANTI
                    color: Color(0xff8e9da7),
                    fontSize: 25.0,
                  ),
                ),
              ))
        ],
      ),
    );

    return Slidable(
      key: ArchSampleKeys.todoItem(widget.todo.id),

      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: widget.onZeroTap,
        ),
      ],
      //   onDismissed: onDismissed,
      delegate: new SlidableDrawerDelegate(),
      child: Column(
        children: <Widget>[
          Divider(
            height: 0.0,
            indent: 1.0,
          ),
          ListTile(
            // onTap: onTap,
            onTap: () {
              setState(() {
                _quantity++;
              });
            },
            title: Container(
              height: 70.0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                key: ArchSampleKeys.todoItemTask(widget.todo.id),
                children: <Widget>[
                  leftSection,
                  middleSection,
                  rightSection,
                ],
              ),
            ),
            // subtitle: Text(
            //   "${todo.note} - Qty ${todo.quantity} - Price ${priceFormatted} - ${todo.category}",
            //   key: ArchSampleKeys.todoItemNote(todo.id),
            //   maxLines: 3,
            //   overflow: TextOverflow.ellipsis,
            //   style: Theme.of(context).textTheme.subhead,
            // ),
          ),
        ],
      ),
    );
  }
}
