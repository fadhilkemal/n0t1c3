// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:notice/models/models.dart';
import 'package:notice/actions/actions.dart';
import 'package:notice/database/dbhelper.dart';
import 'package:notice/tr_copy/todos_repository.dart';

class LoadProduct extends StatelessWidget {
  LoadProduct({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return PatchProduct(
          onLoadNewProductList: vm.onLoadNewProductList,
          onLoadNewCategoryList: vm.onLoadNewCategoryList,
        );
      },
    );
  }
}

class PatchProduct extends StatelessWidget {
  final Function onLoadNewProductList;
  final Function onLoadNewCategoryList;

  PatchProduct({
    Key key,
    this.onLoadNewProductList,
    this.onLoadNewCategoryList,
  }) : super(key: key);

  void _loadToCart() {
    var dbHelper = DBHelper();
    dbHelper.getProducts().then(
      (todos) {
        todos.sort((a, b) => a.name.compareTo(b.name));

        List<Todo> eja = todos.map((x) {
          return Todo.fromEntity(TodoEntity(
              x.name, x.name, x.name, false, 0, x.price, x.category));
        }).toList();
        onLoadNewProductList(eja); //dispatch, dia maunya Todo. bukan TodoEntity
      },
    );
    dbHelper.getCategories().then(
      (categories) {
        onLoadNewCategoryList(
            categories); //dispatch, dia maunya Todo. bukan TodoEntity
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _loadToCart,
      child: new Text('2^'),
    );
  }
}

class _ViewModel {
  final Function onLoadNewProductList;
  final Function onLoadNewCategoryList;

  _ViewModel({
    @required this.onLoadNewProductList,
    @required this.onLoadNewCategoryList,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onLoadNewProductList: (todos) {
        store.dispatch(
          TodosLoadedAction(todos),
        );
      },
      onLoadNewCategoryList: (categories) {
        store.dispatch(
          CategoriesLoadedAction(categories),
        );
        if (categories.isNotEmpty) {
          store.dispatch(UpdateCategoryAction(categories.first.name));
        }
      },
    );
  }
}
