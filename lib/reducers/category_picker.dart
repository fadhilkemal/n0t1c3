// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:notice/actions/actions.dart';

final categoryReducer = combineReducers<String>([
  TypedReducer<String, UpdateCategoryAction>(_activeCategory),
]);

String _activeCategory(String categoryName, UpdateCategoryAction action) {
  return action.name;
}
