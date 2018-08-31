// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:notice/actions/actions.dart';

final queryReducer = combineReducers<String>([
  TypedReducer<String, UpdateQueryFilter>(_queryFilter),
  TypedReducer<String, SearchFinished>(_queryFilterFinish),
]);

String _queryFilter(String _queryFilter, UpdateQueryFilter action) {
  return action.query;
}

String _queryFilterFinish(String _queryFilter, SearchFinished action) {
  return "";
}
