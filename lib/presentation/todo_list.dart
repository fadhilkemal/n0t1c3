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

class TodoList extends StatelessWidget {
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
        if (viewType == "prepayment") {
          return _buildListViewPrePayment();
        } else {
          return _buildListView();
        }
      }
    });
  }

  ListView _buildListViewPrePayment() {
    if (todosActive.isNotEmpty) {
      //   todosActive.add(todosActive.last);
      return ListView.builder(
        padding: EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0),
        key: ArchSampleKeys.todoList,
        itemCount: todosActive.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = todosActive[index];
          return TodoItemPrePayment(
            todo: todo,
            onDismissed: (direction) {
              _removeTodo(context, todo);
            },

            //   onTap: () => _onTodoTap(context, todo),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              incrementItem(todo);
            },
            onMinusTap: () {
              decrementItem(todo);
            },
            onZeroTap: () {
              zeroItem(todo);
            },
            onCheckboxChanged: (complete) {
              onCheckboxChanged(todo, complete);
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
    if (todos.isNotEmpty) {
      //   todos.add(todos.last);
      return ListView.builder(
        padding: EdgeInsets.only(right: 4.0, left: 4.0, bottom: 140.0),
        key: ArchSampleKeys.todoList,
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = todos[index];
          return TodoItem(
            todo: todo,
            onDismissed: (direction) {
              _removeTodo(context, todo);
            },
            //   onTap: () => _onTodoTap(context, todo),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              incrementItem(todo);
            },
            onMinusTap: () {
              decrementItem(todo);
            },
            onCheckboxChanged: (complete) {
              onCheckboxChanged(todo, complete);
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

  void _removeTodo(BuildContext context, Todo todo) {
    onRemove(todo);

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
          onPressed: () => onUndoRemove(todo),
        )));
  }

//   void _onTodoTap(BuildContext context, Todo todo) {
//     Navigator.of(context)
//         .push(MaterialPageRoute(
//       builder: (_) => TodoDetails(id: todo.id),
//     ))
//         .then((removedTodo) {
//       if (removedTodo != null) {
//         Scaffold.of(context).showSnackBar(SnackBar(
//             key: ArchSampleKeys.snackbar,
//             duration: Duration(seconds: 2),
//             backgroundColor: Theme.of(context).backgroundColor,
//             content: Text(
//               ArchSampleLocalizations.of(context).todoDeleted(todo.task),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             action: SnackBarAction(
//               label: ArchSampleLocalizations.of(context).undo,
//               onPressed: () {
//                 onUndoRemove(todo);
//               },
//             )));
//       }
//     });
//   }
}
