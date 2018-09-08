// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  final SlidableController slidableController = SlidableController();

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
          "${widget.todo.quantity}",
          style: TextStyle(color: Color(0xFF1F94E5)),
        ),
      ),
    );

    final middleSection = Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 18.0, bottom: 10.0, top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "${widget.todo.task}",
              style: TextStyle(
                color: Color(0xff144e76), //!GANTI
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
            Text(
              "Rp $priceFormatted",
              style: TextStyle(
                // color: Color(0xff2F72FC), //!GANTI
                color: Color(0x0af144e76), //!GANTI
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            // Text(
            //   "${todo.category}",
            //   style: TextStyle(
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
                child: Text(
                  "-",
                  style: TextStyle(
                    // color: Colors.white, //!GANTI
                    color: Color(0xff8e9da7),
                    fontSize: 25.0,
                  ),
                ),
              ))
        ],
      ),
    );

    Widget _buildTodoContent(BuildContext context) {
      return Column(
        children: <Widget>[
          Divider(
            height: 0.0,
            indent: 1.0,
          ),
          ListTile(
            onTap: () {
              if (slidableController.activeState == null) {
                widget.onTap();
              } else {
                if (slidableController
                        .activeState.actionsMoveAnimation.status ==
                    AnimationStatus.dismissed) {
                  widget.onTap();
                }
                if (slidableController
                        .activeState.actionsMoveAnimation.status ==
                    AnimationStatus.completed) {
                  slidableController.activeState.close();
                }
              }
            },
            title: Container(
              height: 70.0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                // key: ArchSampleKeys.todoItemTask(todo.id),
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
      );
    }

    return Slidable.builder(
      key: Key(widget.todo.id),
      controller: slidableController,
      secondaryActionDelegate: SlideActionBuilderDelegate(
        actionCount: 1,
        builder: (context, index, animation, renderingMode) {
          return IconSlideAction(
            caption: 'Delete',
            color: renderingMode == SlidableRenderingMode.slide
                ? Colors.red.withOpacity(animation.value)
                : Colors.red,
            icon: Icons.delete,
            onTap: widget.onZeroTap,
          );
        },
      ),
      delegate: SlidableDrawerDelegate(),
      child: _buildTodoContent(context),
    );
  }
}
