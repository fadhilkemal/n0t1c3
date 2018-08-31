// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:notice/actions/actions.dart';
import 'package:notice/models/models.dart';

final visibilityReducer = combineReducers<VisibilityFilter>([
  TypedReducer<VisibilityFilter, UpdateFilterAction>(_activeFilterReducer),
  TypedReducer<VisibilityFilter, AddTodoAction>(_xItemAdded),
  TypedReducer<VisibilityFilter, ClearCompletedAction>(_transactionDone),
]);

VisibilityFilter _activeFilterReducer(
    VisibilityFilter activeFilter, UpdateFilterAction action) {
  return action.newFilter;
}

VisibilityFilter _xItemAdded(
    VisibilityFilter activeFilter, AddTodoAction action) {
  return VisibilityFilter.active;
}

VisibilityFilter _transactionDone(
    VisibilityFilter activeFilter, ClearCompletedAction action) {
  return VisibilityFilter.all;
}
