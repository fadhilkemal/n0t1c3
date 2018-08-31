// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notice/fas_copy/flutter_architecture_samples.dart';
import 'package:notice/models/models.dart';
import 'package:intl/intl.dart';

class TodoItemPrePayment extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final GestureTapCallback onMinusTap;
  final GestureTapCallback onZeroTap;
  final ValueChanged<bool> onCheckboxChanged;
  final Todo todo;

  TodoItemPrePayment({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onMinusTap,
    @required this.onZeroTap,
    @required this.onCheckboxChanged,
    @required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("###,###.###", "pt-br");
    String priceFormatted = formatter.format(todo.price * todo.quantity);

    final _buildProductQty = Container(
      child: CircleAvatar(
        // backgroundColor: Color(0xFF5023FE),
        // backgroundColor: Color(0xFF1F94E5),
        backgroundColor: Color(0x0FF8fe0fe),
        radius: 15.0,
        child: Text(
          "${todo.quantity}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xFF1F94E5),
          ),
        ),
      ),
    );

    final _buildProductDetail = new Expanded(
      child: Container(
        padding: new EdgeInsets.only(
            left: 4.0, right: 10.0, bottom: 10.0, top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text(
              "${todo.task}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                color: Color(0xff144e76), //!GANTI
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            new Text(
              "Rp $priceFormatted",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                // color: Color(0xff2F72FC), //!GANTI
                color: Color(0x0af144e76), //!GANTI
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );

    return Dismissible(
      key: ArchSampleKeys.todoItem(todo.id),
      onDismissed: onDismissed,
      child: Column(
        children: <Widget>[
          Divider(
            height: 0.0,
            indent: 1.0,
          ),
          ListTile(
            // onTap: onTap,
            // leading: Checkbox(
            //   key: ArchSampleKeys.todoItemCheckbox(todo.id),
            //   value: todo.complete,
            //   onChanged: onCheckboxChanged,
            // ),
            title: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                key: ArchSampleKeys.todoItemTask(todo.id),
                children: <Widget>[
                  _buildProductDetail,
                  _buildProductQty,
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      onMinusTap();
                    },
                    iconSize: 12.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      onTap();
                    },
                    iconSize: 12.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      onZeroTap();
                    },
                    iconSize: 12.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
