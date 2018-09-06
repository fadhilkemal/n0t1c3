// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:notice/actions/actions.dart';
import 'package:notice/models/models.dart';

final customerReducer = combineReducers<Customer>([
  TypedReducer<Customer, UpdateCustomer>(_updateCustomer),
  TypedReducer<Customer, ClearCompletedAction>(_clearCustomer),
]);

Customer _updateCustomer(Customer customer, UpdateCustomer action) {
  return action.customer;
}

Customer _clearCustomer(Customer customer, ClearCompletedAction action) {
  return null;
}
