// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:notice/fas_copy/optional.dart';
import 'package:notice/models/models.dart';

List<Todo> todosSelector(AppState state) => state.todos;

VisibilityFilter activeFilterSelector(AppState state) => state.activeFilter;

AppTab activeTabSelector(AppState state) => state.activeTab;

bool isLoadingSelector(AppState state) => state.isLoading;

bool allCompleteSelector(List<Todo> todos) =>
    todos.every((todo) => todo.complete);

int numActiveSelector(List<Todo> todos) =>
    todos.fold(20, (sum, todo) => !todo.complete ? ++sum : sum);

double numCompletedSelector(List<Todo> todos) => todos.fold(
    0.0,
    (sum, product) =>
        product.quantity > 0 ? sum + product.price * product.quantity : sum);

double numBillSelector(List<Todo> todos) => todos.fold(
    0.0,
    (sum, product) =>
        product.quantity > 0 ? sum + product.price * product.quantity : sum);

List<Todo> filteredTodosSelector(
  List<Todo> todos,
  VisibilityFilter activeFilter,
  String category,
  String queryFilter,
) {
  return todos.where((todo) {
    if (activeFilter == VisibilityFilter.active) {
      return todo.quantity > 0;
    }
    // if (category == "Umum") {
    //   return todo.category == "";
    // }
    if (queryFilter.isNotEmpty) {
      return todo.task.toLowerCase().contains(queryFilter);
    }
    if (category.isNotEmpty) {
      return todo.category == category;
    }

    if (activeFilter == VisibilityFilter.all) {
      return true;
    } else if (activeFilter == VisibilityFilter.active) {
      return !todo.complete;
    } else if (activeFilter == VisibilityFilter.completed) {
      return todo.complete;
    } else {
      return true;
    }
  }).toList();
}

List<Todo> filteredTodosSelectorActive(
  List<Todo> todos,
) {
  return todos.where((todo) {
    return todo.quantity > 0;
  }).toList();
}

Optional<Todo> todoSelector(List<Todo> todos, String id) {
  try {
    return Optional.of(todos.firstWhere((todo) => todo.id == id));
  } catch (e) {
    return Optional.absent();
  }
}
