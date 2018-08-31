// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:notice/models/models.dart';

class ClearCompletedAction {}

class ToggleAllAction {}

class LoadTodosAction {}

class LoadCategAction {}

class TodosNotLoadedAction {}

class SearchLoading {}

class SearchFinished {}

class TodosLoadedAction {
  final List<Todo> todos;

  TodosLoadedAction(this.todos);

  @override
  String toString() {
    return 'TodosLoadedAction{todos: $todos}';
  }
}

class CategoriesLoadedAction {
  final List<Category> category;

  CategoriesLoadedAction(this.category);

  @override
  String toString() {
    return 'CategoriesLoadedAction{category: $category}';
  }
}

class UpdateQueryFilter {
  final String query;

  UpdateQueryFilter(this.query);

  @override
  String toString() {
    return 'Query{query: $query}';
  }
}

class UpdateTodoAction {
  final String id;
  final Todo updatedTodo;

  UpdateTodoAction(this.id, this.updatedTodo);

  @override
  String toString() {
    return 'UpdateTodoAction{id: $id, updatedTodo: $updatedTodo}';
  }
}

class DeleteTodoAction {
  final String id;

  DeleteTodoAction(this.id);

  @override
  String toString() {
    return 'DeleteTodoAction{id: $id}';
  }
}

class AddTodoAction {
  final Todo todo;

  AddTodoAction(this.todo);

  @override
  String toString() {
    return 'AddTodoAction{todo: $todo}';
  }
}

class UpdateFilterAction {
  final VisibilityFilter newFilter;

  UpdateFilterAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateFilterAction{newFilter: $newFilter}';
  }
}

class UpdateTabAction {
  final AppTab newTab;

  UpdateTabAction(this.newTab);

  @override
  String toString() {
    return 'UpdateTabAction{newTab: $newTab}';
  }
}

class UpdateCategoryAction {
  final String name;

  UpdateCategoryAction(this.name);

  @override
  String toString() {
    return 'UpdateCategoryAction{category: $name}';
  }
}
