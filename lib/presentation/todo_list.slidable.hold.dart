// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notice/fas_copy/flutter_architecture_samples.dart';
import 'package:notice/containers/app_loading.dart';
// import 'package:notice/containers/todo_details.dart';
import 'package:notice/models/models.dart';
import 'package:notice/presentation/todo_item.dart';
import 'package:notice/presentation/todo_item_pre_payment.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoList extends StatefulWidget {
  final String viewType;
  final List<Todo> todos;
  final List<Todo> todosActive;
  final Function(Todo, bool) onCheckboxChanged;
  final Function(Todo) onRemove;
  final Function(Todo) onUndoRemove;
  final Function(Todo) incrementItem;
  final Function(Todo) decrementItem;
  final Function(Todo) zeroItem;

  TodoList({
    Key key,
    @required this.viewType,
    @required this.todos,
    @required this.todosActive,
    @required this.onCheckboxChanged,
    @required this.onRemove,
    @required this.onUndoRemove,
    @required this.incrementItem,
    @required this.decrementItem,
    @required this.zeroItem,
  }) : super(key: key);

  @override
  TodoListState createState() {
    return new TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  final SlidableController slidableController = new SlidableController();

  @override
  Widget build(BuildContext context) {
    return AppLoading(builder: (context, vm) {
      if (vm.isSearchLoading || vm.isLoading) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 68.0),
            child: CircularProgressIndicator(key: ArchSampleKeys.todosLoading),
          ),
        );
      } else {
        if (widget.viewType == "prepayment") {
          return _buildListViewPrePayment();
        } else {
          return _buildListView();
        }
      }
    });
  }

  ListView _buildListViewPrePayment() {
    if (widget.todosActive.isNotEmpty) {
      //   todosActive.add(todosActive.last);
      return ListView.builder(
        padding: EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0),
        itemCount: widget.todosActive.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = widget.todosActive[index];
          return TodoItemPrePayment(
            todo: todo,
            onDismissed: (direction) {
              _removeTodo(context, todo);
            },
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.incrementItem(todo);
            },
            onMinusTap: () {
              widget.decrementItem(todo);
            },
            onZeroTap: () {
              widget.zeroItem(todo);
            },
            onCheckboxChanged: (complete) {
              widget.onCheckboxChanged(todo, complete);
            },
          );
        },
      );
    } else {
      return ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 68.0),
              child: Text(
                "Produk tidak ditemukan",
                style: TextStyle(color: Colors.black26),
              ),
            ),
          ),
        ],
      );
    }
  }

  ListView _buildListView() {
    if (widget.todos.isNotEmpty) {
      //   todos.add(todos.last);
      return ListView.builder(
        padding: EdgeInsets.only(right: 4.0, left: 4.0, bottom: 140.0),
        // key: ArchSampleKeys.todoList,
        itemCount: widget.todos.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = widget.todos[index];
          print("todo");
          print(todo);
          return Slidable(
            controller: slidableController,
            delegate: SlidableDrawerDelegate(),
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  print("ASDA");
                },
              ),
            ],
            child: TodoItem(
              //   key: Key("Todo${todo.id}"),
              todo: todo,
              onDismissed: (direction) {
                _removeTodo(context, todo);
              },
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                widget.incrementItem(todo);
              },
              onMinusTap: () {
                widget.decrementItem(todo);
              },
              onCheckboxChanged: (complete) {
                widget.onCheckboxChanged(todo, complete);
              },
              onZeroTap: () {
                widget.zeroItem(todo);
              },
            ),
          );
        },
      );
    } else {
      return ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 68.0),
              child: Text(
                "Produk tidak ditemukan",
                style: TextStyle(color: Colors.black26),
              ),
            ),
          ),
        ],
      );
    }
  }

  void _removeTodo(BuildContext context, Todo todo) {
    widget.onRemove(todo);

    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).backgroundColor,
        content: Text(
          ArchSampleLocalizations.of(context).todoDeleted(todo.task),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () => widget.onUndoRemove(todo),
        )));
  }
}
