// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:notice/models/models.dart';
import 'package:notice/reducers/loading_reducer.dart';
import 'package:notice/reducers/tabs_reducer.dart';
import 'package:notice/reducers/todos_reducer.dart';
import 'package:notice/reducers/visibility_reducer.dart';
import 'package:notice/reducers/category_picker.dart';
import 'package:notice/reducers/categories_reducer.dart';
import 'package:notice/reducers/search_query.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return AppState(
    isLoading: loadingReducer(state.isLoading, action),
    isSearchLoading: searchLoadingReducer(state.isSearchLoading, action),
    todos: todosReducer(state.todos, action),
    categories: categoriesReducer(state.categories, action),
    categoryPicker: categoryReducer(state.categoryPicker, action),
    activeFilter: visibilityReducer(state.activeFilter, action),
    activeTab: tabsReducer(state.activeTab, action),
    queryFilter: queryReducer(state.queryFilter, action),
  );
}
