// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/actions/actions.dart';
import 'package:notice/models/models.dart';
import 'package:notice/presentation/discount_screen.dart';
import 'package:notice/selectors/selectors.dart';

class DiscountPage extends StatelessWidget {
  DiscountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return DiscountScreen(
          totalBill: vm.numCompleted,
          onSave: vm.onRemove,
          isEditing: true,
        );
      },
    );
  }
}

class _ViewModel {
  final double numCompleted;
  final Function(Todo) onRemove;

  _ViewModel({
    @required this.onRemove,
    @required this.numCompleted,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      numCompleted: numCompletedSelector(todosSelector(store.state)),
      onRemove: (todo) {
        store.dispatch(DeleteTodoAction(todo.id));
      },
    );
  }
}
