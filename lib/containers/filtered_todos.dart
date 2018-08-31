// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/actions/actions.dart';
import 'package:notice/models/models.dart';
import 'package:notice/presentation/todo_list.dart';
import 'package:notice/selectors/selectors.dart';

class FilteredTodos extends StatelessWidget {
  final String viewType;

  FilteredTodos({
    Key key,
    this.viewType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return TodoList(
          viewType: viewType,
          todos: vm.todos,
          todosActive: vm.todosActive,
          onCheckboxChanged: vm.onCheckboxChanged,
          onRemove: vm.onRemove,
          onUndoRemove: vm.onUndoRemove,
          incrementItem: vm.incrementItem,
          decrementItem: vm.decrementItem,
          zeroItem: vm.zeroItem,
        );
      },
    );
  }
}

class _ViewModel {
  final List<Todo> todos;
  final List<Todo> todosActive;
  final bool loading;
  final Function(Todo, bool) onCheckboxChanged;
  final Function(Todo) onRemove;
  final Function(Todo) onUndoRemove;
  final Function(Todo) incrementItem;
  final Function(Todo) decrementItem;
  final Function(Todo) zeroItem;

  _ViewModel({
    @required this.todos,
    @required this.todosActive,
    @required this.loading,
    @required this.onCheckboxChanged,
    @required this.onRemove,
    @required this.onUndoRemove,
    @required this.incrementItem,
    @required this.decrementItem,
    @required this.zeroItem,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      todos: filteredTodosSelector(
        todosSelector(store.state),
        activeFilterSelector(store.state),
        store.state.categoryPicker,
        store.state.queryFilter,
      ),
      todosActive: filteredTodosSelectorActive(
        todosSelector(store.state),
      ),
      loading: store.state.isLoading,
      onCheckboxChanged: (todo, complete) {
        store.dispatch(UpdateTodoAction(
          todo.id,
          todo.copyWith(complete: !todo.complete, quantity: todo.quantity + 1),
        ));
      },
      incrementItem: (todo) {
        store.dispatch(UpdateTodoAction(
          todo.id,
          todo.copyWith(quantity: todo.quantity + 1),
        ));
      },
      decrementItem: (todo) {
        if (todo.quantity > 0) {
          store.dispatch(UpdateTodoAction(
            todo.id,
            todo.copyWith(quantity: todo.quantity - 1),
          ));
        }
      },
      zeroItem: (todo) {
        if (todo.quantity > 0) {
          store.dispatch(UpdateTodoAction(
            todo.id,
            todo.copyWith(quantity: 0),
          ));
        }
      },
      onRemove: (todo) {
        store.dispatch(DeleteTodoAction(todo.id));
      },
      onUndoRemove: (todo) {
        store.dispatch(AddTodoAction(todo));
      },
    );
  }
}
