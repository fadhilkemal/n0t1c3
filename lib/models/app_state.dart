// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:notice/models/models.dart';

@immutable
class AppState {
  final bool isLoading;
  final bool isSearchLoading;
  final List<Todo> todos;
  final List<Category> categories;
  final AppTab activeTab;
  final VisibilityFilter activeFilter;
  final String categoryPicker;
  final String queryFilter;
  final Customer customer;

  AppState({
    this.isLoading = false,
    this.isSearchLoading = false,
    this.todos = const [],
    this.categories = const [],
    this.categoryPicker = "",
    this.queryFilter = "",
    this.customer = null,
    this.activeTab = AppTab.todos,
    this.activeFilter = VisibilityFilter.all,
  });

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    bool isSearchLoading,
    List<Todo> todos,
    List<Category> categories,
    AppTab activeTab,
    VisibilityFilter activeFilter,
    String categoryPicker,
    String queryFilter,
    Customer customer,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      todos: todos ?? this.todos,
      categories: categories ?? this.categories,
      activeTab: activeTab ?? this.activeTab,
      activeFilter: activeFilter ?? this.activeFilter,
      categoryPicker: categoryPicker ?? this.categoryPicker,
      queryFilter: queryFilter ?? this.queryFilter,
      customer: customer ?? this.customer,
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      isSearchLoading.hashCode ^
      todos.hashCode ^
      categories.hashCode ^
      activeTab.hashCode ^
      activeFilter.hashCode ^
      categoryPicker.hashCode ^
      customer.hashCode ^
      queryFilter.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          isSearchLoading == other.isSearchLoading &&
          todos == other.todos &&
          categories == other.categories &&
          activeTab == other.activeTab &&
          categoryPicker == other.categoryPicker &&
          queryFilter == other.queryFilter &&
          customer == other.customer &&
          activeFilter == other.activeFilter;

  @override
  String toString() {
    return 'AppState{isSearchLoading: $isSearchLoading, todos: $todos, activeTab: $activeTab, queryFilter: $queryFilter}';
  }
}
